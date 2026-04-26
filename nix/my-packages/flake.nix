{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.aarch64-darwin.my-packages = nixpkgs.legacyPackages.aarch64-darwin.buildEnv {
      name = "my-packages-list";
      paths = with nixpkgs.legacyPackages.aarch64-darwin; [
        git
        curl
      ];
    };

   apps.aarch64-darwin.update = {
     type = "app";
     program = toString (nixpkgs.legacyPackages.aarch64-darwin.writeShellScript "update-script" ''
       set -e
       echo "Updating flake..."
       nix flake update
       echo "Updating profile..."
       nix profile upgrade nix/my-packages
       echo "Update complete!"
     '');
   };
  };
}
