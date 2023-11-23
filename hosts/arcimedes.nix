{ config, lib, pkgs, modulesPath, ... }:
{
  # hardware
  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  home-manager.users.josh.imports = [
    ../home-manager/dev-tools.nix
    ../home-manager/neovim.nix
  ];

  # host specific config
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "arcimedes";

  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
    intel-media-sdk
    intel-compute-runtime
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
  ];

  environment.systemPackages = with pkgs; [
    intel-media-sdk
    intel-gpu-tools
    libva-utils
    hwinfo
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
  users.users.jellyfin.extraGroups = [ "render" "video" ];

}
