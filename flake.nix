{
  description = "Nix flake C++23 cross development environment";
  nixConfig = {
    extra-substituters = [ "https://cache.garnix.io" ];
    extra-trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # engine.url = "https://github.com/ProjetISIE/SmartPianoEngine/archive/main.tar.gz";
  };
  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      forSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux" # "aarch64-linux"
        "aarch64-darwin"
      ];
    in
    {
      devShells = forSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default =
            pkgs.mkShell.override
              {
                stdenv = pkgs.clangStdenv; # Clang instead of GCC
              }
              {
                packages =
                  with pkgs;
                  [
                    bashInteractive
                    clang-tools # Clang CLIs, including LSP
                    cmake-format # CMake formatter
                    cmake-language-server # Cmake LSP
                    doctest # Testing framework (-DBUILD_TESTING=ON builds)
                    doxygen # Documentation generator
                    lldb # Clang debug adapter
                  ]
                  ++ lib.optionals stdenv.isLinux [
                    alsa-utils # aconnect…
                    clang-uml # UML diagram generator
                    cppcheck # C++ Static analysis
                    fluidsynth # JACK Synthesizer
                    qsynth # FluidSynth GUI
                    socat # Serial terminal for manual testing
                    valgrind # Debugging and profiling
                  ];
                # shellHook = ''
                #   cmake -B build -GNinja -DCMAKE_BUILD_TYPE=Debug \
                #     -DCOVERAGE=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON # -S .
                # '';
              };
        }
      );
    };
}
