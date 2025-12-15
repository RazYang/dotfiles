{
  pkgs,
  stdenv,
  writeScriptBin,
  ...
}:
drv:
let
  entry-script = writeScriptBin "${drv.pname}-entry" ''
    #!/bin/sh
    prog_name=$(basename $0)
    prog_path=$(dirname $(realpath $0))
    mountpoint=/tmp/${drv.name}


    ctrl_c() {
        umount $mountpoint
        rmdir $mountpoint
    }
    trap ctrl_c INT




    if [ "$prog_name" = "${drv.pname}-entry" ]
    then
        prog_name=$1
        if [ "$prog_name" = "" ]
        then
            echo "No program name was provided"
            exit 1
        fi
        shift
    fi


    if ! test -d $mountpoint
    then
        mkdir $mountpoint
    else 
        umount $mountpoint
    fi

    $prog_path/.utils/squashfuse $prog_path/../${drv.name}.store $mountpoint
    $prog_path/.utils/bwrap --dev-bind / / --bind $mountpoint/nix /nix ${drv}/bin/$prog_name $@

  '';
in
stdenv.mkDerivation {
  inherit (drv) pname;
  inherit (drv) version;
  closureInfo = pkgs.closureInfo {
    rootPaths = [
      drv
      pkgs.bash
    ];
  };
  bundledDrv = drv;
  buildCommand = ''
    mkdir -p $out/bin/.utils
    cd $out

    cp ${entry-script}/bin/${drv.pname}-entry $out/bin
    cp ${pkgs.pkgsStatic.bubblewrap}/bin/bwrap $out/bin/.utils
    cp ${pkgs.pkgsStatic.squashfuse}/bin/squashfuse $out/bin/.utils
    cp ${pkgs.pkgsStatic.dash}/bin/dash $out/bin/.utils/sh

    tar cf - $(< $closureInfo/store-paths) | ${pkgs.squashfsTools}/bin/mksquashfs - ${drv.name}.store -tar -no-recovery -no-strip -comp lz4 #zstd -Xcompression-level 1 

    cd $out/bin
    for i in $(ls $bundledDrv/bin);do
      ln -s ${drv.pname}-entry $(basename $i)
    done
  '';
}
