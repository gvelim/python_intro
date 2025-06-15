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
          venvDir = "./.venv"; # required by venvShellHook()
          buildInputs = with pkgs; [
            python3Packages.python
            # https://nixos.org/manual/nixpkgs/stable/#how-to-consume-python-modules-using-pip-in-a-virtual-environment-like-i-am-used-to-on-other-operating-systems
            # https://gist.github.com/bb010g/8a28a7d1fcdb021b42d1da71d2429a4b
            # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/interpreters/python/hooks/venv-shell-hook.sh
            # https://github.com/NixOS/nixpkgs/commit/eba1f794184f6bc08558a6506ed62eada008f37e#diff-7c765cc9768cdae049f8712b4ef719bc94ec8ec2e8df2dd50ddf14c6acd4e580
            python3Packages.venvShellHook
            python3Packages.python-lsp-server
            nil
            nixd
          ];
          shellHook = "venvShellHook";
          postVenvCreation = ''
            # unset SOURCE_DATE_EPOCH
            # source ${venvDir}/bin/activate <-- venvShellHook() already calls this
            # Install project dependencies using pip
            pip install -r requirements.txt
          '';
        };
      };
    };
}
