{ ... }:
{
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 7;
      Hour = 3;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };

  system.defaults.screencapture.target = "clipboard";

  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.Dragging = true;
  system.defaults.trackpad.TrackpadRightClick = true;

  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.dock.autohide = true;
  system.defaults.dock.wvous-tr-corner = 13; # Lock Screen

  system.defaults.menuExtraClock.ShowDate = 0; # 0 = when space allows
  system.defaults.menuExtraClock.ShowDayOfWeek = true;
  system.defaults.menuExtraClock.ShowAMPM = true;

  system.defaults.controlcenter.BatteryShowPercentage = true;
}
