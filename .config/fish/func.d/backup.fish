function backup -d "Backup file to ~/.backup (can mannually define with \$BACKUP_DIR)"
    set backup_dir ~/.backup/
    set -q BACKUP_DIR; and set backup_dir $BACKUP_DIR
    set backup_dir (realpath $backup_dir)

    for file in $argv
        set uuid (uuidgen --time)
        set file (string replace -r '/+$' '' $file)
        command cp -vr $file $backup_dir/$file'__'$uuid.bak
    end
end
