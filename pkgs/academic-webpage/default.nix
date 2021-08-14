{ pkgs, stdenv, ... }:

stdenv.mkDerivation rec {
  pname = "academic-webpage";
  version = "2021-08-14";

  buildInputs = with pkgs; [ hugo ];

  src = pkgs.fetchFromGitHub {
    owner = "qaristote";
    repo = "academic-webpage";
    rev = "${version}";
    sha256 = sha256:1l8gmca95d20yc5fmd44qm3n758pf912y7q0zvr4g73dbf03h9ba;
    fetchSubmodules = true;
  };

  phases = [ "unpackPhase" "buildPhase" ];

  buildPhase = ''
    hugo --destination $out
  '';
}
