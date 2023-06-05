if [ -d "$HOME/.aliases" ]; then
    for f in $HOME/.aliases/*; do
        . "$f" || echo "ERROR: failed to include alias file '${f}'"
    done
fi
