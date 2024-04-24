# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "snd_usb_audio" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zagreb";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hr_HR.UTF-8";
    LC_IDENTIFICATION = "hr_HR.UTF-8";
    LC_MEASUREMENT = "hr_HR.UTF-8";
    LC_MONETARY = "hr_HR.UTF-8";
    LC_NAME = "hr_HR.UTF-8";
    LC_NUMERIC = "hr_HR.UTF-8";
    LC_PAPER = "hr_HR.UTF-8";
    LC_TELEPHONE = "hr_HR.UTF-8";
    LC_TIME = "hr_HR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "workman";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stablejoy = {
    isNormalUser = true;
    description = "stablejoy";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      kate
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  git vim wget direnv zoom-us yt-dlp htop btop zellij element-desktop nix-output-monitor 
  marksman  moreutils vscode ripgrep ranger obs-studio cabal-install lsd npins haskell-language-server
  dhall-lsp-server nls nil rust-analyzer unzip libsForQt5.polonium 
  ghc hpack nix-tree lf shellcheck jq cmatrix nerdfonts vlc cowsay fortune asciiquarium
  slides eza bat dust fd procs tealdeer zoxide tokei hexo-cli 
  alacritty figlet hugo easyeffects pavucontrol alsa-scarlett-gui
  ];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  home-manager.users.stablejoy = { pkgs, ... }: {
    home.packages = with pkgs; [ ];

  programs.direnv.enable = true;
  
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = false;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      lightline-vim
      fzf-vim
    ];
    extraConfig = ''
      set shiftwidth=2
      set tabstop=2
      set expandtab
      set relativenumber
      '';
  };

  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      marksman
    ];
    defaultEditor = true;
    settings = {
      theme = "kanagawa";
      editor = {
        true-color = true;
        mouse = false;
        bufferline = "always";
        line-number = "relative";
        lsp.display-messages = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };     
    };
    languages = {
      language = [{
        name = "nix";
      }];  
    };
  };
  
  programs.git = {
    enable = true;
    userName = "stablejoy";
    userEmail = "dooygoy@gmail.com";
  };

  home.stateVersion = "23.11";
  };
    
  programs.zsh = {
    enable = true;
    histSize = 100000;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true; 
    enableBashCompletion = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "Iosevka"
          "FiraMono"
          "FantasqueSansMono"
          "NerdFontsSymbolsOnly"
        ];
     })
     roboto
     roboto-mono
   ];
  };

  system.stateVersion = "23.11"; # Did you read the comment?

}
