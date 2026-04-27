{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
    }:
    rec {
      images = rec {
        rp4 = self.nixosConfigurations.rp4.config.system.build.image;
        rp4_2 = nixpkgs.legacyPackages.aarch64-linux.runCommand "rp4-image-hydra" { } ''
          mkdir -p $out/nix-support
          cp ${rp4}/image.raw $out/rp4-image.raw
          echo "file raw $out/rp4-image.raw" > $out/nix-support/hydra-build-products
        '';
      };
      nixosConfigurations.rp4 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          nixos-hardware.nixosModules.raspberry-pi-4
          "${nixpkgs}/nixos/modules/profiles/minimal.nix"
          ./configuration.nix
        ];
      };
      packages.x86_64-linux.default = images.rp4;
      packages.aarch64-linux.default = images.rp4;
      hydraJobs = {
        rp4-image = images.rp4_2;
      };
    };
}
