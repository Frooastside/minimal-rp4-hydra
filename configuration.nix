{ pkgs, lib, ... }:

{
  imports = [ ./repart.nix ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  environment.systemPackages = with pkgs; [
    git
    parted
  ];
  services.openssh.enable = true;
  networking.hostName = "rp4-nixos";
  users = {
    users.default = {
      password = "default123456789";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILUlTyMHf9lIjlXuilVWZT0I9BqZUNN2gsy5U+D3SZ+Z simon.benezan@h-net.com"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIO6NPut/WhzhJNQNPlshqVHhsODamuekMPfKit9h5XVvAAAAG3NzaDpzaW1vbi5iZW5lemFuQGgtbmV0LmNvbQ== simon.benezan@h-net.com"
      ];
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
  nix.settings = {
    experimental-features = lib.mkDefault "nix-command flakes";
    trusted-users = [
      "root"
      "@wheel"
    ];
  };
  system.stateVersion = "25.11";
}
