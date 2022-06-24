{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    ble-thermometer-scan.url = "github:kaiju/ble-thermometer-scan";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: (
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        packages.wallpaper = import ./wallpaper { inherit pkgs; };
      }
    )
  ) // {

    overlays = {
      wallpaper = (final: prev: { wallpaper = self.packages.${prev.system}.wallpaper; });
      ble-thermometer-scan = inputs.ble-thermometer-scan.overlay;

      kustomize = (final: prev: {
        kustomize = prev.buildGoModule {
          inherit (prev.kustomize.drvAttrs)
            pname modRoot doCheck nativeBuildInputs buildInputs buildPhase installPhase;
          inherit (prev.kustomize) meta;
          version = "4.5.5";
          ldflags = let t = "sigs.k8s.io/kustomize/api/provenance"; in
            [
              "-s"
              "-X ${t}.version=${final.kustomize.version}"
              "-X {$t}.gitCommit=${final.kustomize.src.rev}"
            ];
          vendorSha256 = "sha256-itOOeOuWXjwTXwJ6XI0noJEFYH9aeefo17q7qdF+9ck=";
          src = prev.fetchFromGitHub {
            owner = "kubernetes-sigs";
            repo = final.kustomize.pname;
            rev = "kustomize/v${final.kustomize.version}";
            sha256 = "sha256-VLl7a0qPmTaVCof2By88X5Z7ymb0H6+G4qUSwzpKQEI=";
          };
        };
      });

      kubebuilder = (final: prev: {
        kubebuilder = prev.buildGoModule {
          inherit (prev.kubebuilder.drvAttrs)
            pname subPackages doCheck postInstall allowGoReference nativeBuildInputs;
          inherit (prev.kubebuilder) meta;
          version = "3.4.1";
          ldflags = [
            "-X main.kubeBuilderVersion=v${final.kubebuilder.version}"
            "-X main.goos=${final.kubebuilder.go.GOOS}"
            "-X main.goarch=${final.kubebuilder.go.GOARCH}"
            "-X main.gitCommit=v${final.kubebuilder.version}"
            "-X main.buildDate=v${final.kubebuilder.version}"
          ];
          vendorSha256 = "sha256-jpA/tQREyLW1MeKZd9tKI/8I0aCk5alM/BKlSh12Rvs=";
          src = prev.fetchFromGitHub {
            owner = "kubernetes-sigs";
            repo = "kubebuilder";
            rev = "v${final.kubebuilder.version}";
            sha256 = "sha256-h+eis4Tj9LhEzCO1Tg9eFxAUUzFuc4r41pBkcQIuUmo=";
          };
        };
      });

      # override pinentry so we don't build a bunch of xorg garbage
      # https://github.com/NixOS/nixpkgs/issues/124753
      pinentry = (final: prev: {
        pinentry = prev.pinentry.override {
          enabledFlavors = [ "curses" ];
        };
      });

    };



  };
}
