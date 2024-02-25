{ pkgs, ... }:
{

  home.packages = with pkgs; [
    (retroarch.override {
      cores = with libretro; [
        mesen
      ];
    })
  ];

}
