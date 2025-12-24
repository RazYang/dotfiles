{
  pkgs,
  inputs,
  users,
  ...
}:
let
  primaryUser = "yang";
in
{
  nix.settings.trusted-users = [ primaryUser ];
  users.users."${primaryUser}".home = "/Users/${primaryUser}";
  home-manager.users.yang.imports = users."${primaryUser}".modules;
  services = {
    yabai.enable = true;
    skhd.enable = true;
  };

  environment.enableAllTerminfo = true;
  environment.systemPackages = with pkgs; [
    xz
    zip
    gnutar
    curl
    wget
    tree
    gawk
    gnused
    gnugrep
    findutils

    ghostty-bin
    dbeaver-bin
    wireshark
    drawio
    imhex
  ];

  fonts.packages = with pkgs; [ nerd-fonts.iosevka ];

  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllFiles = true;
      AppleShowScrollBars = "Automatic";
      NSAutomaticWindowAnimationsEnabled = false;
      NSStatusItemSelectionPadding = 1;
      NSStatusItemSpacing = 1;
      "com.apple.keyboard.fnState" = false;
    };
    controlcenter.BatteryShowPercentage = true;
    dock = {
      autohide = true;
      tilesize = 48;
    };
    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      FXRemoveOldTrashItems = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "Nlsv";
      _FXSortFoldersFirst = true;
    };
  };
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
  system.primaryUser = primaryUser;
  system.stateVersion = 6;
}
