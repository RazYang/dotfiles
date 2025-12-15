{ pkgs, ... }:
let
  pythonEnv = pkgs.python312.withPackages (
    py: with py; [
      pwntools
      pycryptodome
      r2pipe
      z3-solver
      ipython
    ]
  );

in
{
  devshell.packages = with pkgs; [
    pythonEnv
    sqlmap
    wget
    curl
    nmap
    stdmanpages
    man-pages
    stdman
    linux-manual
    exegol
    masscan
    radare2
    pwntools
    gdb
    gef
    one_gadget
    ropgadget
    metasploit
    exploitdb
    unzip
    p7zip
    unrar
    gcc
    go
  ];

}
