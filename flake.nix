{

  # /*****                                                  /******   /****
  # |*    *|  |*   |  |*       ****     **    *****        |*    |  /*    *
  # |*    *|  |*   |  |*      /*       /* *   |*   |      |*    |  |*
  # |*****/   |*   |  |*       ****   /*   *  |*   /     |*    |   ******
  # |         |*   |  |*           |  ******  *****     |*    |         |
  # |         |*   |  |*       *   |  |*   |  |*  *    |*    |   *     |
  # |          ****    *****    ****  |*   |  |*   *   ******    *****
  #
  #  ==========================================================================

  # This is Arcturus's Pulsar configuration flake for Hydra build servers.
  # It is passed into the PulsarOS configuration flake to build the server.
  # You should include a specific version of this flake as an input
  # in the server configuration flake and pipe its output to the `make`
  # function to build the system.
  description = "Pulsar configuration flake for Atlantic";

  inputs = {
    # PulsarOS uses the latest nixpkgs channel,
    # so new (but somewhat? stable) packages are used by default.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11-small";
  };

  outputs =
    { nixpkgs, ... }:
    rec {
      # Runner configuration
      hostname = "atlantic"; # Identify the system for networking tasks
      user = "arcturus"; # Login username of primary runner
      name = "Arcturus Autonomy"; # Full name of primary user

      # Git configuration
      git = {
        name = "Arcturus Autonomy";
        email = "arcturus-logistics@mit.edu";
      };

      # Meta configuration
      flake = "/home/${user}/gh/arcturus/nixos";

      # Import hardware scan (device-specific)
      hardware = import ./hardware-configuration.nix;
      hyprland.monitors = [ ];

      # Internationalization properties
      locale = "en_US.UTF-8";

      # Power-efficient NVIDIA GPU settings
      graphics = {
        opengl = true;
        nvidia = {
          enabled = true;
          intelBusId = "PCI:00:02:0";
          nvidiaBusId = "PCI:01:00:0";
        };
      };

      # System overrides
      overrides = [ ];
      homeOverrides = [ ];

      # Custom packages
      systemPackages = pkgs: with pkgs; [ hello ];
      homePackages =
        pkgs: with pkgs; [
          hello-wayland
        ];

      # Hydra
      hydra = {
        enabled = true;
        port = "3000";
      };

      # Enforce defaults
      system = "x86_64-linux";
      kernel = "zen";
      secureboot.enabled = false;
      stateVersion = "24.11";
      autoLogin = true;
      ssh.enabled = true;
      hyprland.mod = "SUPER";
      audio.jack = false;
      ollama = false;

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
