# Writing Botnix Documentation {#sec-writing-documentation}

As Botnix grows, so too does the need for a catalogue and explanation of
its extensive functionality. Collecting pertinent information from
disparate sources and presenting it in an accessible style would be a
worthy contribution to the project.

## Building the Manual {#sec-writing-docs-building-the-manual}

The sources of the [](#book-nixos-manual) are in the
[`nixos/doc/manual`](https://github.com/nervosys/Botnix/tree/master/nixos/doc/manual)
subdirectory of the Botpkgs repository.

You can quickly validate your edits with `make`:

```ShellSession
$ cd /path/to/botpkgs/nixos/doc/manual
$ nix-shell
nix-shell$ devmode
```

Once you are done making modifications to the manual, it's important to
build it before committing. You can do that as follows:

```ShellSession
nix-build nixos/release.nix -A manual.x86_64-linux
```

When this command successfully finishes, it will tell you where the
manual got generated. The HTML will be accessible through the `result`
symlink at `./result/share/doc/nixos/index.html`.
