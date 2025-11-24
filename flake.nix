{
  description = "NixOS SD card image for Raspberry Pi";
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05"; # NixOS Stable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    # lanzaboote.url = "github:nix-community/lanzaboote"; # Secure Boot
    hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware Configs
    # impermanence.url = "github:nix-community/impermanence"; # Amnesiac root
  };
  outputs =
    {
      self,
      nixpkgs,
      hardware,
    }:
    let
      systems =
        f:
        nixpkgs.lib.genAttrs
          [
            # "riscv64-linux" # 64-bit RISC-V Linux
            "aarch64-linux" # 64-bit ARM Linux
            "x86_64-linux" # 64-bit Intel/AMD Linux
          ]
          (
            system:
            f {
              pkgs = import nixpkgs { inherit system; };
            }
          );
    in
    {
      # NixOS SD card image, build with `nix build` (it’s the defaultPackage)
      nixosConfigurations.sd = nixpkgs.lib.nixosSystem {
        modules = [
          {
            system.stateVersion = "25.11";
            nixpkgs.hostPlatform = "aarch64-linux";
          }
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
          # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./rpi4.nix
          hardware.nixosModules.raspberry-pi."4" # The SBC

        ];
      };
      defaultPackage.aarch64-linux = self.nixosConfigurations.sd; # FIXME
      devShells = systems (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nixd # "Official" Nix LSP
              nil # Nix LSP
              nixfmt # Formatter
              nixfmt-tree # Format a whole directory of nix files
              yaml-language-server # YAML LSP
              taplo # TOML LSP
              bash-language-server # Bash, shell script LSP
              shellcheck # Shell script analysis
              # vscode-langservers-extracted # HTML/CSS/JS(ON)
            ];
          };
        }
      );
    };
}
