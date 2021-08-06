{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "filtron";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "filtron";
    rev = "v${version}";
    sha256 = "18d3h0i2sfqbc0bjx26jm2n9f37zwp8z9z4wd17sw7nvkfa72a26";
  };

  doCheck = false;
  vendorSha256 = "05q2g591xl08h387mm6njabvki19yih63dfsafgpc9hyk5ydf2n9";
}
