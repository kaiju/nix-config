{ config, pkgs, lib, ... }:
{
  xsession = {
    enable = true;
    initExtra = ''
      setxkbmap -option 'ctrl:nocaps'
    '';
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        colors.focused = {
          background = "#8c9440";
          indicator = "#b5bd68";
          text = "#ffffff";
          border = "#b5bd68";
          childBorder = "#8c9440";
        };
        modifier = "Mod4";

        menu = "${pkgs.rofi}/bin/rofi -show combi";

        terminal = "${pkgs.alacritty}/bin/alacritty";
        gaps = {
          smartBorders = "on";
          smartGaps = true;
          inner = 7;
        };
        keybindings = lib.mkOptionDefault {
          "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '-5%'";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '+5%'";
          "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86MonBrightnessUp" = "exec ${pkgs.brillo}/bin/brillo -A 5";
          "XF86MonBrightnessDown" = "exec ${pkgs.brillo}/bin/brillo -U 5";
        };
      };
    };
  };

  services = {
    picom = {
      enable = true;
      vSync = true;
    };
  };

}
