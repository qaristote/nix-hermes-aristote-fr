{ pkgs, stdenv, ... }:

stdenv.mkDerivation rec {
  pname = "academic-webpage";
  version = "2021-08-14";

  buildInputs = with pkgs; [ hugo ];

  src = pkgs.fetchFromGitHub {
    owner = "qaristote";
    repo = "academic-webpage";
    rev = "51211cc9521fc7ff32e9d0e0315a45904f909f15";
    sha256 = "1874v3x7ks8lqiivvacdfqznlpnqizdk559h8kc5swlrh1pc7bzx";
    fetchSubmodules = true;
  } 

  phases = [ "unpackPhase" "buildPhase" ];

  buildPhase = ''
    hugo --destination $out
  '';
}
