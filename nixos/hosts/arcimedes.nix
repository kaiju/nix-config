{
  lib,
  pkgs,
  ...
}:
{
  # hardware

  boot.initrd.availableKernelModules = [
    "vmd"
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  home-manager.users.josh.imports = [
    ../../hm/dev-tools.nix
    ../../hm/neovim.nix
  ];

  # host specific config
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # force use of xe driver instead of i915
  # this breaks jellyfin ffmpeg currently sine it passes i915 in -init_hw_device
  /*
    boot.kernelParams = [
      "i915.force_probe=!56a0"
      "xe.force_probe=56a0"
    ];
  */

  networking.hostName = "arcimedes";

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    vpl-gpu-rt
    intel-media-driver # neccessary for jellyfin
    intel-compute-runtime # needed to make gpu show up in clinfo
    intel-ocl # needed to make cpu show up in clinfo

    # probably don't need to be here
    #vaapiIntel
    #vaapiVdpau
    #libvdpau-va-gl
    #intel-media-sdk
    #intel-gpu-tools

  ];

  environment.systemPackages = with pkgs; [
    clinfo
    #intel-media-sdk
    intel-gpu-tools
    libva-utils
    hwinfo
    #ollama
  ];

  services.openssh.enable = true;

  fileSystems = {
    "/media" = {
      device = "192.168.8.3:/tank/shares/media";
      fsType = "nfs";
    };
  };

  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  users.users.jellyfin.extraGroups = [
    "render"
    "video"
  ];

}
