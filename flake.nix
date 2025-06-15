{
  description = "Python Introduction DevEnv";

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
        default = pkgs.mkShellNoCC rec {
          name = "Python3 virtual environment";
          venvDir = "./.venv";
          buildInputs = with pkgs; [
            python3Packages.python
            # https://nixos.org/manual/nixpkgs/stable/#how-to-consume-python-modules-using-pip-in-a-virtual-environment-like-i-am-used-to-on-other-operating-systems
            python3Packages.venvShellHook
            python3Packages.python-lsp-server
            nil
            nixd
          ];
          shellHook = ''
            venvShellHook
          '';
          postVenvCreation = ''
            unset SOURCE_DATE_EPOCH
            source ${venvDir}/bin/activate
            # Install project dependencies using pip
            pip install -r requirements.txt
          '';
        };
      };
    };
}
