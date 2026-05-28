{
  pkgs ? import <nixpkgs> { },
}:
let
  python = pkgs.python313;
  pythonEnv = python.withPackages (
    pythonPkgs: with pythonPkgs; [
      uv
      pip
      pytest
      ruff
    ]
  );
in
pkgs.mkShell {
  packages = [ pythonEnv ];
  env = {
    UV_PYTHON = pythonEnv.python.interpreter;
    UV_PYTHON_DOWNLOADS = "never";
  };
  shellHook = ''
    export PATH=.venv/bin/:$PATH
  '';
}
