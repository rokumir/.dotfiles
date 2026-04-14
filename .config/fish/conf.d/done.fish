set -U __done_min_cmd_duration 10000
set -U __done_notification_duration 1800

set -Ua __done_exclude '^git (?!push|pull|fetch)'
set -Ua __done_exclude '^(vi|vim|nvim)'
set -Ua __done_exclude '^(tarts|drift)'
set -Ua __done_exclude '^(tmux)'
