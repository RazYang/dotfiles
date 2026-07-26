#!/bin/sh

command_not_found_handle () {
    if [ -n "${MC_SID-}" ] || ! [ -t 1 ]; then
        >&2 echo "$1: command not found"
        return 127
    fi

    toplevel=nixpkgs
    cmd=$1
    attrs=$(@nix-locate@ --minimal --no-group -t x -t s -w --at-root "/bin/$cmd" | sed 's|\.out$||g')

    len=$(echo -n "$attrs" | grep -c "^")

    case $len in
        0)
            >&2 echo "$cmd: command not found"
            ;;
        1)
            >&2 cat <<EOF
$cmd: command not found
But provided by '$toplevel#$attrs':

Install to user profile:
  nix profile add '$toplevel#$attrs'

Or run once:
  , $cmd ...        # with select cache
  , -d $cmd ...     # without cache
EOF
            ;;
        *)
            >&2 echo "$cmd: command not found"
            >&2 echo "But provided by several packages:"
            >&2 echo ""
            >&2 echo "Install to user profile:"
            printf '%s\n' "$attrs" | while IFS= read -r attr; do
                >&2 echo "  nix profile add '$toplevel#$attr'"
            done
            >&2 echo ""
            >&2 echo "Or run once:"
            >&2 echo "  , $cmd ...        # with select cache"
            >&2 echo "  , -d $cmd ...     # without cache"
            ;;
    esac

    return 127
}

command_not_found_handler () {
    command_not_found_handle "$@"
    return $?
}
