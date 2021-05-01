{
  inputs.pkgs.url = "/home/chivay/repos/nixpkgs";

  outputs = { self, pkgs }: {
     nixosConfigurations.xakep = pkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [ ./configuration.nix ];
     };
  };
}
