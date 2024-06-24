# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [  "quiet"
    "splash"
    "pcie_aspm=force"
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  networking.wireguard.enable =
    true; # Enable wireguard
  # Set your time zone.
  time.timeZone = "Asia/Bahrain";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "uk";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    videoDrivers = [ "amdgpu" ];

    deviceSection = ''
      Option "DRI" "3"
      Option "TearFree" "true"
    '';

    desktopManager = { xterm.enable = false; };

    displayManager = {
      startx.enable = true;

    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ dmenu i3status i3lock i3blocks ];

    };

    xkbOptions = "ctrl:nocaps";
    layout = "gb";

  };

   services.tlp = {
    enable = true;

    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 50;
    };
  };

  services.fwupd.enable = true;

  services.ananicy = { 
	enable = true;
	package = pkgs.ananicy-cpp;
  };

  hardware.brillo.enable = true;
  hardware.cpu.amd.updateMicrocode = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];

  fonts.fontconfig = {
  	antialias = true;
	subpixel.lcdfilter = "default";
	subpixel.rgba = "rgb";
	hinting.enable = true;
	hinting.style = "full";

	# default fonts
	defaultFonts = {
		serif = ["IBM Plex Serif"];
		sansSerif = ["IBM Plex Sans"];
		monospace = ["Iosevka Nerd Font Mono"];
	};
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mazin = {
    isNormalUser = true;
    extraGroups = [ "wheel"
    "video"
    "networkmanager"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [ home-manager firefox tree ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    lf
    feh
    wget
    git
    nfs-utils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  services.irqbalance.enable = true;
  
  services.fstrim.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}

