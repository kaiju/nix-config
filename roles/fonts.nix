{ pkgs, config, ... }:
{
  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      ubuntu_font_family
      iosevka
      ibm-plex
      font-awesome
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [
          "IBM Plex Mono"
        ];
        sansSerif = [
          "DejaVu Sans"
        ];
        serif = [
          "DejaVu Serif"
        ];
      };
    };
  };
} 
