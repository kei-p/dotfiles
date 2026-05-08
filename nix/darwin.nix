{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.kei-p = {
    name = "kei-p";
    home = "/Users/kei-p";
  };

  homebrew = {
    enable = true;
    brews = [
      "puma-dev"
    ];
    casks = [
      "ghostty"
    ];
  };

  system = {
    stateVersion = 5;
    primaryUser = "kei-p";

    defaults = {
      dock.orientation = "left";

      NSGlobalDomain = {
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        "com.apple.mouse.tapBehavior" = 1;
      };

      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };

      controlcenter = {
        BatteryShowPercentage = true;
      };
    };

    activationScripts.postActivation.text = ''
      /usr/bin/killall Dock || true
    '';
  };
}
