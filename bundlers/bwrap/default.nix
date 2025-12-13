{
  pkgs,
  stdenv,
  writeScriptBin,
  ...
}:
drv:
let
  entry-script = writeScriptBin "${drv.name}" ''
    #!/bin/sh
    prog_name=$(basename $0)
    prog_path=$(dirname $(realpath $0))
    bundle_path=$(dirname $prog_path)
    mountpoint=/tmp/${drv.name}

    mkdir -p $mountpoint
    umount $mountpoint > /dev/null 2>&1
    $prog_path/.erofs --offset=4096 $0 $mountpoint > /dev/null 2>&1 

    if [ "$prog_name" = "${drv.name}-env" ]
    then
        prog_name=''${SHELL##*/}
    fi

    $prog_path/.bwrap \
      --dev-bind / / \
      --unsetenv PATH \
      --setenv PATH ${drv}/bin/:$PATH \
      --ro-bind "$mountpoint" /nix \
      $prog_name "$@"
    umount $mountpoint > /dev/null 2>&1
    rmdir $mountpoint > /dev/null 2>&1
    exit $?
  '';
in
stdenv.mkDerivation {
  name = drv.name + ".tar.gz";
  closureInfo = pkgs.closureInfo { rootPaths = [ drv ]; };
  bundledDrv = drv;
  src = ./.;
  buildPhase = ''
    bin_path=${drv.name}
    mkdir -p $bin_path
    script_name=${drv.name}-env

    tar cf - $(< $closureInfo/store-paths) | tar xf -
    ${pkgs.pkgsStatic.erofs-utils}/bin/mkfs.erofs -zlz4hc nix.erofs ./nix
    cp ${entry-script}/bin/${drv.name} $bin_path/$script_name
    chmod +w $bin_path/$script_name
    truncate -s 4096 $bin_path/$script_name
    cat nix.erofs >> $bin_path/$script_name
    chmod +x $bin_path/$script_name
    chmod -w $bin_path/$script_name

    cd $bin_path
    for each in $(ls ${drv}/bin);do
      base=$(basename $each)
      if [ "$script_name" != $base ];then
        ln -s $script_name $each 
      fi
    done
    cd ../

    cp ${pkgs.pkgsStatic.bubblewrap}/bin/bwrap $bin_path/.bwrap
    cp ${pkgs.pkgsStatic.erofs-utils}/bin/erofsfuse $bin_path/.erofs
    chmod +w $bin_path/.bwrap $bin_path/.erofs
    strip -s $bin_path/.bwrap $bin_path/.erofs
    chmod -w $bin_path/.bwrap $bin_path/.erofs
  '';
  installPhase = ''
    tar czf $out ${drv.name}
  '';
}
