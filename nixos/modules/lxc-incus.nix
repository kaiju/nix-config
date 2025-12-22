{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
{

  imports = [
    (modulesPath + "/virtualisation/lxc-image-metadata.nix")
    (modulesPath + "/virtualisation/lxc-container.nix")
  ];

  config = {

    system.nixos.tags = lib.mkOverride 98 [
      "incus"
      "lxc"
    ];
    system.build.image = lib.mkOverride 98 config.system.build.incus-lxc-tarball;
    system.build.incus-lxc-tarball =
      let
        cfg = config.virtualisation.lxc;

        templates =
          if cfg.templates != { } then
            let
              list = lib.mapAttrsToList (name: value: { inherit name; } // value) (
                lib.filterAttrs (name: value: value.enable) cfg.templates
              );
            in
            {
              files = map (tpl: {
                source = tpl.template;
                target = "/templates/${tpl.name}.tpl";
              }) list;
              properties = lib.listToAttrs (
                map (
                  tpl:
                  lib.nameValuePair tpl.target {
                    when = tpl.when;
                    template = "${tpl.name}.tpl";
                    properties = tpl.properties;
                  }
                ) list
              );
            }
          else
            {
              files = [ ];
              properties = { };
            };

        toYAML = name: data: pkgs.writeText name (lib.generators.toYAML { } data);

        closureInfo = pkgs.closureInfo {
          rootPaths = config.system.build.toplevel;
        };

        metadata = toYAML "metadata.yaml" {
          architecture = builtins.elemAt (builtins.match "^([a-z0-9_]+).+" (toString pkgs.stdenv.hostPlatform.system)) 0;
          creation_date = 1;
          properties = {
            description = "${config.system.nixos.distroName} ${config.system.nixos.codeName} ${config.system.nixos.label} ${pkgs.stdenv.hostPlatform.system}";
            os = "${config.system.nixos.distroId}";
            release = "${config.system.nixos.codeName}";
          };
          templates = templates.properties;
        };
        files = [
          {
            source = metadata;
            target = "/metadata.yaml";
          }
          {
            source = (config.system.build.toplevel + "/init");
            target = "/rootfs/sbin/init";
          }
          {
            source = (config.system.build.toplevel + "/etc/os-release");
            target = "/rootfs/etc/os-release";
          }
          {
            source = (closureInfo + "/registration");
            target = "/rootfs/nix-path-registration";
          }
        ]
        ++ templates.files;
      in
      pkgs.stdenv.mkDerivation {
        name = "lxc-incus-tarball";
        __structuredAttrs = true;
        unsafeDiscardReferences.out = true;

        fileSources = map (x: x.source) files;
        fileTargets = map (x: x.target) files;

        buildCommand = ''
          mkdir -p rootfs/proc rootfs/sys rootfs/dev rootfs/nix/store

          # copy files
          stripSlash() {
            res="$1"
            if test "''${res:0:1}" = /; then res=''${res:1}; fi
          }

          for ((i = 0; i < ''${#fileTargets[@]}; i++)); do
            echo "Copy ''${fileTargets[$i]}"
            stripSlash "''${fileTargets[$i]}"
            mkdir -p "$(dirname "$res")"
            cp -a "''${fileSources[$i]}" "$res"
          done

          # copy rootfs
          echo "Copying rootfs"
          for i in $(< ${closureInfo}/store-paths); do
            cp -a "$i" "rootfs/''${i:1}"
          done

          # tar up our stuff
          echo "Creating tarball"
          rm env-vars
          mkdir -p $out/tarball
          time tar --sort=name --mtime='@1' --owner=0 --group=0 --numeric-owner -c * | ${pkgs.pixz}/bin/pixz -t > $out/tarball/${config.image.baseName}.tar.xz
        '';

      };

  };

}
