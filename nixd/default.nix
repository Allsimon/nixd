{
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  nixComponents,
  nixf,
  nixt,
  llvmPackages,
  gtest,
  boost,
  libxml2,
  zlib,
}:

let
  pname = "nixd";
in
stdenv.mkDerivation {
  inherit pname;
  version = "nightly";

  src = ../.;

  outputs = [
    "out"
    "dev"
  ];

  mesonBuildType = "release";

  # Link only LLVM's "support" component statically instead of the
  # monolithic libLLVM dylib; this keeps ~550 MiB of LLVM out of the
  # runtime closure. Static LLVMSupport needs zlib/libxml2 at link time.
  mesonFlags = [ (lib.mesonBool "llvm_static" true) ];

  preConfigure = ''
    cd ${pname}
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    nixComponents.nix-expr
    nixComponents.nix-main
    nixComponents.nix-cmd
    nixf
    nixt
    llvmPackages.llvm
    gtest
    boost
    libxml2
    zlib
  ];

  meta = {
    mainProgram = "nixd";
    description = "Nix language server";
    homepage = "https://github.com/nix-community/nixd";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ inclyc ];
    platforms = lib.platforms.unix;
  };
}
