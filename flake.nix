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
      images = {
        rp4 = self.nixosConfigurations.rp4.config.system.build.image;
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
        rp4-image = images.rp4;
      };
    };
}
