if [ -d "$HOME/.alias" ]; then
    for f in $HOME/.alias/*; do
        . "$f" || echo "ERROR: failed to include alias file '${f}'"
    done
fi
