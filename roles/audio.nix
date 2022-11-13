{ ... }:
{
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipwire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
