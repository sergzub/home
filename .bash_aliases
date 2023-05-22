if [ -d "$HOME/.alias" ]; then
    for f in $HOME/.aliases/*; do
        . "$f" || echo "ERROR: failed to include alias file '${f}'"
    done
fi
