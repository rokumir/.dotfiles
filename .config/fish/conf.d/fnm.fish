if type -q fnm
    fnm env --use-on-cd --shell=fish --version-file-strategy=recursive | source
end
