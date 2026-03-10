> [!IMPORTANT] DO NOT SYMLINK `~/.config/pam/pam_env.conf` to `/etc/security/pam_env.conf`

Do the following instead:

```fish
sudo cp ~/.config/pam_env.conf /etc/security/pam_env.conf
sudo chown root:root /etc/security/pam_env.conf
sudo chmod 644 /etc/security/pam_env.conf
```
