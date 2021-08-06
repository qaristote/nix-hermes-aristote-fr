{ pkgs }:

{
  academic-webpage = pkgs.callPackage ./academic-webpage { };
  filtron = pkgs.callPackage ./filtron {}; 
}
