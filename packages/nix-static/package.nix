{ pkgs }:
let
  staticLibraryStdenv =
    pkgs.stdenvAdapters.withCFlags
      [
        "-flto=auto"
        "-ffat-lto-objects"
      ]
      (
        pkgs.stdenvAdapters.propagateBuildInputs (
          pkgs.stdenvAdapters.overrideMkDerivationArgs (
            args:
            {
              dontDisableStatic = true;
            }
            // pkgs.lib.optionalAttrs ((args.dontAddStaticConfigureFlags or false) != true) {
              configureFlags = (args.configureFlags or [ ]) ++ [
                "--enable-static"
                "--disable-shared"
              ];
              cmakeFlags = (args.cmakeFlags or [ ]) ++ [ "-DBUILD_SHARED_LIBS:BOOL=OFF" ];
              mesonFlags = (args.mesonFlags or [ ]) ++ [
                "-Ddefault_library=static"
                "-Ddefault_both_libraries=static"
              ];
            }
          ) pkgs.stdenv
        )
      );

  staticZlib = pkgs.zlib.override {
    stdenv = staticLibraryStdenv;
    shared = false;
    splitStaticOutput = false;
  };
  staticBzip2 = pkgs.bzip2.override {
    stdenv = staticLibraryStdenv;
    enableStatic = true;
    enableShared = false;
  };
  staticXz = pkgs.xz.override {
    stdenv = staticLibraryStdenv;
    enableStatic = true;
  };
  staticZstd = pkgs.zstd.override {
    stdenv = staticLibraryStdenv;
    static = true;
    enableStatic = true;
    buildContrib = false;
    doCheck = false;
  };
  staticLzo = pkgs.lzo.override {
    stdenv = staticLibraryStdenv;
  };
  staticAttr = pkgs.attr.override {
    stdenv = staticLibraryStdenv;
  };
  staticAcl = pkgs.acl.override {
    stdenv = staticLibraryStdenv;
    attr = staticAttr;
  };
  staticOpenSSL =
    (pkgs.openssl.override {
      stdenv = staticLibraryStdenv;
      static = true;
    }).overrideAttrs
      (_: {
        doCheck = false;
        separateDebugInfo = false;
      });

  staticLibarchive =
    (pkgs.libarchive.override {
      stdenv = staticLibraryStdenv;
      acl = staticAcl;
      attr = staticAttr;
      bzip2 = staticBzip2;
      lzo = staticLzo;
      openssl = staticOpenSSL;
      xz = staticXz;
      zlib = staticZlib;
      zstd = staticZstd;
      xarSupport = false;
      libxml2 = null;
    }).overrideAttrs
      (_: {
        doCheck = false;
      });
  staticLibblake3 = pkgs.libblake3.override {
    stdenv = staticLibraryStdenv;
    useTBB = false;
  };
  staticLibsodium = pkgs.libsodium.override {
    stdenv = staticLibraryStdenv;
  };
  staticOpenlibm =
    (pkgs.openlibm.override {
      stdenv = staticLibraryStdenv;
    }).overrideAttrs
      (prevAttrs: {
        postInstall = (prevAttrs.postInstall or "") + ''
          rm -f "$out"/lib/libopenlibm.so*
        '';
      });
  staticBrotli = pkgs.brotli.override {
    stdenv = staticLibraryStdenv;
    staticOnly = true;
  };
  staticLibcpuid = pkgs.libcpuid.override {
    stdenv = staticLibraryStdenv;
  };
  staticBoost =
    (pkgs.boost.override {
      stdenv = staticLibraryStdenv;
      enableShared = false;
      enableStatic = true;
      enableIcu = false;
      extraB2Args = [
        "--with-container"
        "--with-context"
        "--with-coroutine"
        "--with-iostreams"
        "--with-url"
      ];
      zlib = staticZlib;
      bzip2 = staticBzip2;
      zstd = staticZstd;
      xz = staticXz;
    }).overrideAttrs
      (prevAttrs: {
        buildPhase = builtins.replaceStrings [ "--without-python" ] [ "" ] prevAttrs.buildPhase;
        installPhase = builtins.replaceStrings [ "--without-python" ] [ "" ] prevAttrs.installPhase;
      });

  staticCurl =
    (pkgs.curlMinimal.override {
      stdenv = staticLibraryStdenv;
      brotliSupport = false;
      c-aresSupport = false;
      gnutlsSupport = false;
      gsaslSupport = false;
      gssSupport = false;
      http2Support = false;
      http3Support = false;
      websocketSupport = false;
      idnSupport = false;
      ldapSupport = false;
      opensslSupport = true;
      pslSupport = false;
      rtmpSupport = false;
      scpSupport = false;
      rustlsSupport = false;
      zlibSupport = true;
      zstdSupport = false;
      openssl = staticOpenSSL;
      zlib = staticZlib;
    }).overrideAttrs
      (_: {
        separateDebugInfo = false;
      });
  staticLibseccomp =
    (pkgs.libseccomp.override {
      stdenv = staticLibraryStdenv;
    }).overrideAttrs
      (_: {
        doCheck = false;
      });
  staticSqlite =
    (pkgs.sqlite.override {
      stdenv = staticLibraryStdenv;
      zlib = staticZlib;
    }).overrideAttrs
      (prevAttrs: {
        configureFlags = (prevAttrs.configureFlags or [ ]) ++ [
          "--disable-math"
          "--disable-tcl"
        ];
        doCheck = false;
        env = (prevAttrs.env or { }) // {
          NIX_CFLAGS_COMPILE =
            builtins.replaceStrings
              [
                "-DSQLITE_ENABLE_FTS5"
                "-DSQLITE_ENABLE_MATH_FUNCTIONS"
              ]
              [ "" "" ]
              (prevAttrs.env.NIX_CFLAGS_COMPILE or "");
        };
        separateDebugInfo = false;
      });

  staticLibssh2 =
    (pkgs.libssh2.override {
      stdenv = staticLibraryStdenv;
      openssl = staticOpenSSL;
      zlib = staticZlib;
    }).overrideAttrs
      (prevAttrs: {
        configureFlags = (prevAttrs.configureFlags or [ ]) ++ [ "--disable-examples-build" ];
      });
  staticPcre2 = pkgs.pcre2.override {
    stdenv = staticLibraryStdenv;
  };
  staticLlhttp =
    (pkgs.llhttp.override {
      stdenv = staticLibraryStdenv;
    }).overrideAttrs
      (prevAttrs: {
        cmakeFlags = (prevAttrs.cmakeFlags or [ ]) ++ [
          "-DLLHTTP_BUILD_SHARED_LIBS=OFF"
          "-DLLHTTP_BUILD_STATIC_LIBS=ON"
        ];
      });
  staticLibgit2 =
    (pkgs.libgit2.override {
      stdenv = staticLibraryStdenv;
      staticBuild = true;
      zlib = staticZlib;
      libssh2 = staticLibssh2;
      openssl = staticOpenSSL;
      pcre2 = staticPcre2;
      llhttp = staticLlhttp;
    }).overrideAttrs
      (prevAttrs: {
        cmakeFlags = (prevAttrs.cmakeFlags or [ ]) ++ [
          "-DBUILD_CLI=OFF"
          "-DBUILD_TESTS=OFF"
        ];
        doCheck = false;
      });

  staticBoehmgc = pkgs.nixDependencies.boehmgc.override {
    stdenv = staticLibraryStdenv;
    enableStatic = true;
  };
  staticEditline = pkgs.editline.override {
    stdenv = staticLibraryStdenv;
  };
  staticLowdown = pkgs.lowdown.override {
    stdenv = staticLibraryStdenv;
    enableShared = false;
    enableStatic = true;
  };
  staticMimalloc =
    (pkgs.mimalloc.override {
      stdenv = staticLibraryStdenv;
    }).overrideAttrs
      (prevAttrs: {
        cmakeFlags = (prevAttrs.cmakeFlags or [ ]) ++ [
          "-DMI_BUILD_SHARED=OFF"
          "-DMI_BUILD_STATIC=ON"
          "-DMI_BUILD_TESTS=OFF"
        ];
        doCheck = false;
        postFixup = (prevAttrs.postFixup or "") + ''
          substituteInPlace "$dev/lib/pkgconfig/mimalloc.pc" \
            --replace-fail "-latomic" "${staticLibraryStdenv.cc.cc}/lib/libatomic.a"
        '';
      });

  staticNix =
    (pkgs.nixVersions.latest.overrideScope (
      _: prev: {
        stdenv = staticLibraryStdenv;
        acl = staticAcl;
        attr = staticAttr;
        boehmgc = staticBoehmgc;
        boost = staticBoost;
        brotli = staticBrotli;
        bzip2 = staticBzip2;
        curl = staticCurl;
        editline = staticEditline;
        libarchive = staticLibarchive;
        libblake3 = staticLibblake3;
        libcpuid = staticLibcpuid;
        libgit2 = staticLibgit2;
        libseccomp = staticLibseccomp;
        libsodium = staticLibsodium;
        libssh2 = staticLibssh2;
        llhttp = staticLlhttp;
        lowdown = staticLowdown;
        lzo = staticLzo;
        mimalloc = staticMimalloc;
        openssl = staticOpenSSL;
        pcre2 = staticPcre2;
        sqlite = staticSqlite;
        xz = staticXz;
        zlib = staticZlib;
        zstd = staticZstd;

        nix-store = prev.nix-store.override {
          embeddedSandboxShell = true;
          withAWS = false;
        };
      }
    )).overrideAllMesonComponents
      (
        finalAttrs: prevAttrs:
        {
          mesonFlags = (prevAttrs.mesonFlags or [ ]) ++ [
            "-Dprefer_static=true"
            "-Db_lto=true"
            "-Dc_link_args=-Wl,--as-needed"
            "-Dcpp_link_args=${
              if finalAttrs.pname == "nix" then
                "-Wl,--as-needed,-u,pow,-u,log2,${staticOpenlibm}/lib/libopenlibm.a"
              else
                "-Wl,--as-needed"
            }"
          ];
          separateDebugInfo = false;
          env = (prevAttrs.env or { }) // {
            NIX_CFLAGS_COMPILE = toString (prevAttrs.env.NIX_CFLAGS_COMPILE or "") + " -fno-ipa-modref";
            NIX_CFLAGS_LINK =
              toString (prevAttrs.env.NIX_CFLAGS_LINK or "")
              + " -fno-ipa-modref -static-libgcc -static-libstdc++";
          };
          postFixup =
            (prevAttrs.postFixup or "")
            + pkgs.lib.optionalString (finalAttrs.pname == "nix") ''
              dynamicLoader=${pkgs.lib.escapeShellArg (baseNameOf pkgs.stdenv.cc.bintools.dynamicLinker)}
              if ${pkgs.patchelf}/bin/patchelf --print-needed "$out/bin/nix" \
                | grep -Fxq "$dynamicLoader"; then
                ${pkgs.patchelf}/bin/patchelf --remove-needed "$dynamicLoader" "$out/bin/nix"
              fi
              needed=$(${pkgs.patchelf}/bin/patchelf --print-needed "$out/bin/nix")
              if [ "$needed" != "libc.so.6" ]; then
                echo "unexpected dynamic dependencies in $out/bin/nix:" >&2
                printf '%s\n' "$needed" >&2
                exit 1
              fi

              rm -f "$out/nix-support/propagated-build-inputs"
              if find "${staticOpenSSL.out}/lib/ossl-modules" \
                -mindepth 1 -print -quit | grep -q .; then
                echo "refusing to prune an OpenSSL output that contains runtime modules" >&2
                exit 1
              fi
              ${pkgs.removeReferencesTo}/bin/remove-references-to \
                -t ${staticOpenSSL.out} "$out/bin/nix"

              strip --strip-all "$out/bin/nix"
            '';
        }
        // pkgs.lib.optionalAttrs (prevAttrs.pname == "nix") {
          disallowedReferences =
            (prevAttrs.disallowedReferences or [ ])
            ++ [ staticOpenSSL.out ]
            ++ (prevAttrs.propagatedBuildInputs or [ ]);
        }
      );
in
pkgs.lib.meta.addMetaAttrs {
  description = "Nix with every library except libc linked statically";
  platforms = pkgs.lib.platforms.linux;
} staticNix.nix-cli
