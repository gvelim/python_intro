{
  description = "Python pandas devenv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system} = {
        default = pkgs.mkShellNoCC {
          name = "Python3 virtual environment";
          packages = with pkgs; [
            python3Packages.python
            # https://nixos.org/manual/nixpkgs/stable/#setup-hooks
            python3Packages.venvShellHook
            nil
            nixd
          ];
          venvDir = "./.venv";
          shellHook = ''
            venvShellHook
          '';
          postVenvCreation = ''
            source .venv/bin/activate
            # Install project dependencies using pip
            pip install -r requirements.txt
          '';
        };
      };
    };
}
