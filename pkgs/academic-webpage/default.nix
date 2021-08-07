{ pkgs, stdenv, ... }:

stdenv.mkDerivation rec {
  pname = "academic-webpage";
  version = "2021-08-07";

  buildInputs = with pkgs; [ hugo ];

  src = pkgs.fetchFromGitHub {
    owner = "qaristote";
    repo = "academic-webpage";
    rev = "${version}";
    sha256 = sha256:12f1ybxq6m9n5pr3cfx1d8svjw0f750pdy6b7rmv83i3gymsw1i0;
    fetchSubmodules = true;
  };

  phases = [ "unpackPhase" "buildPhase" ];

  buildPhase = ''
    hugo --destination $out
  '';
}
