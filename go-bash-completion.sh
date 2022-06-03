_go() 
{
    local CMD=${COMP_WORDS[0]}
    local CUR=${COMP_WORDS[COMP_CWORD]}
    local PREV=${COMP_WORDS[COMP_CWORD-1]}
    local IFS=$' \t\n' WORDS
    local HCMD=$( echo "${COMP_LINE% *}" | sed -En 's/\s+-.*$//; s/^\s*'$CMD'\s+(help)?/'$CMD' help /; p' );
    local HCMD2=$( echo "${COMP_LINE% *}" | sed -En 's/'$CMD'\s+tool\s+-n\s+/'$CMD' tool /; s/\s+-.*$//; s/$/ --help/; p' );
    local SED_CMD='sed -En '\''/[Cc]ommands are:$/{ n; :X n; s/^[[:blank:]]*([^[:blank:]]+).*/\1/p; tX }'\'
    local SED_OPT=$( cat <<\@
            sed -En -e '1bZ' -e 's/^[[:blank:]]+(-[[:alnum:]_-]+).*/\1/; TB; p; b' \
                    -e ':B /^The -/!b; :X s/ flag/&/; TY; bZ; :Y N; bX' \
                    -e ':Z s/(.*)([^[:alnum:]]-[[:alnum:]_-]+)(.*)/\2\n\1/; /-[[:alnum:]_-]+\n$/{ s/[^[:alnum:]\n_-]//gp; b}; tZ'
@
)
    if [ "${CUR:0:1}" = "-" ]; then
        if [[ ${COMP_WORDS[1]} = "tool" && $COMP_CWORD -ge 3 ]]; then
            [ ${COMP_WORDS[2]} = "vet" ] && HCMD2=${HCMD2/--help/help}
            WORDS=$( eval "$HCMD2 |& $SED_OPT" )
            [ "${COMP_WORDS[2]}" = "cgo" ] && { WORDS=${WORDS/--/}
                WORDS=${WORDS/-fgo-pkgpath/} WORDS=${WORDS/-fgo-prefix/} ;}
        else
            WORDS=$( eval "$HCMD |& $SED_OPT" )
            case ${COMP_WORDS[1]} in
                clean | get | install | list | run | test | vet)
                WORDS=$WORDS$'\n'$( eval "$CMD help build |& $SED_OPT" ) ;;
            esac
        fi
    else
        if [ "$COMP_CWORD" -eq 1 ]; then
            WORDS=$( eval "$CMD help |& $SED_CMD" )$' help'
        else
            if [ "${COMP_WORDS[1]}" = "tool" ]; then
                if [[ $COMP_CWORD -eq 2 || ( $COMP_CWORD -eq 3 && $PREV = "-n" ) ]]; then
                    WORDS=$( $CMD tool )
                else
                    WORDS=$( eval "$HCMD2 |& $SED_CMD" )
                fi
            else
                WORDS=$( eval "$HCMD |& $SED_CMD" )
            fi
        fi
    fi
    COMPREPLY=( $(compgen -W "$WORDS" -- "$CUR") )
    [ "${COMPREPLY: -1}" = "=" ] && compopt -o nospace
}

complete -o default -o bashdefault -F _go go


