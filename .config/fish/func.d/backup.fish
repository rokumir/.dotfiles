function backup --argument file
    set uuid (uuidgen)
    set backup_dir ~/.backup/
    cp $file $file.bak
end
