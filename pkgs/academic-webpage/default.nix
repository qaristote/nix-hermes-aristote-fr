{ pkgs, stdenv, ... }:

stdenv.mkDerivation {
  name = "academic-webpage";

  buildInputs = with pkgs; [ hugo ];

  src = pkgs.fetchFromGitHub {
    owner = "qaristote";
    repo = "academic-webpage";
    rev = "18e00fdd22643831376e012793574d9293243f6f";
    sha256 = "148gknjlwr71q5gkp4q7bnza64222izhn949ki14k7b9y7j486c6";
    fetchSubmodules = true;
  };

  phases = [ "unpackPhase" "buildPhase" ];

  buildPhase = ''
    hugo --destination $out
  '';
}
