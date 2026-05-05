{ pkgs, ... }:

{
  system.stateVersion = 5;
  system.primaryUser = "kei-p";
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.defaults.dock.orientation = "left";

  system.activationScripts.postActivation.text = ''
    /usr/bin/killall Dock || true
  '';
}
