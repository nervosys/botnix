#! /usr/bin/env nix-shell
#! nix-shell -I botpkgs=. -i bash -p delta jq perl

set -euo pipefail
shopt -s inherit_errexit

cat <<'EOF'
This script attempts to automatically convert option descriptions from
DocBook syntax to markdown. Naturally this process is incomplete and
imperfect, so any changes generated by this script MUST be reviewed.

Possible problems include: incorrectly replaced tags, badly formatted
markdown, DocBook tags this script doesn't recognize remaining in the
output and crashing the docs build, incorrect escaping of markdown
metacharacters, incorrect unescaping of XML entities—and the list goes on.

Always review the generated changes!

Some known limitations:
  - Does not transform literalDocBook items
  - Replacements can occur in non-option code, such as string literals


EOF



build-options-json() {
    nix-build --no-out-link --expr '
        let
            sys = import ./botnix/default.nix {
                configuration = {};
            };
        in
        [
            sys.config.system.build.manual.optionsJSON
        ]
    '
}



git diff --quiet || {
    echo "Worktree is dirty. Please stash or commit first."
    exit 1
}

echo "Building options.json ..."
old_options=$(build-options-json)

echo "Applying replacements ..."
perl -pi -e '
    BEGIN {
        undef $/;
    }

    s,<literal>([^`]*?)</literal>,`$1`,smg;
    s,<replaceable>([^»]*?)</replaceable>,«$1»,smg;
    s,<filename>([^`]*?)</filename>,{file}`$1`,smg;
    s,<option>([^`]*?)</option>,{option}`$1`,smg;
    s,<code>([^`]*?)</code>,`$1`,smg;
    s,<command>([^`]*?)</command>,{command}`$1`,smg;
    s,<link xlink:href="(.+?)" ?/>,<$1>,smg;
    s,<link xlink:href="(.+?)">(.*?)</link>,[$2]($1),smg;
    s,<package>([^`]*?)</package>,`$1`,smg;
    s,<emphasis>([^*]*?)</emphasis>,*$1*,smg;
    s,<citerefentry>\s*
        <refentrytitle>\s*(.*?)\s*</refentrytitle>\s*
        <manvolnum>\s*(.*?)\s*</manvolnum>\s*
      </citerefentry>,{manpage}`$1($2)`,smgx;
    s,^( +description =),\1 lib.mdDoc,smg;
' "$@"

echo "Building options.json again ..."
new_options=$(build-options-json)


! cmp -s {$old_options,$new_options}/share/doc/botnix/options.json && {
    diff -U10 \
        <(jq . <$old_options/share/doc/botnix/options.json) \
        <(jq . <$new_options/share/doc/botnix/options.json) \
        | delta
}
