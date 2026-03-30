set -U __done_min_cmd_duration 10000
set -U __done_notification_duration 1800

set -U __done_exclude '^git (?!push|pull|fetch)'
set -U __done_exclude '^(vi|vim|nvim)'
set -U __done_exclude '^(tarts|drift)'
set -U __done_exclude '^(tmux)'
