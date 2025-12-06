{
  description = "Inception Devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          # Networking
          inetutils
          openssl
          nmap
          socat
          curl

          # Utilities
          jq
        ];

        shellHook = ''
          export SHELL=${lib.getExe pkgs.bash};
        '';
      };
    };
}
