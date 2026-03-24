1. Copy the `xdg.sh` file over.

```fish
sudo cp ~/.config/pam/xdg.sh /etc/profile.d/xdg.sh
```

2. Logout and log back in.

3. If still doesn't work, use the `pam_env.conf` file instead.

```fish
sudo cp ~/.config/pam/pam_env.conf /etc/security/pam_env.conf
sudo chown root:root /etc/security/pam_env.conf
sudo chmod 644 /etc/security/pam_env.conf
```
