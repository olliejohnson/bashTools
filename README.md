# bashTools

# IMPORTANT follow this before running pterodactylpanel.sh

Enabling Swap
On most systems, Docker will be unable to setup swap space by default. You can confirm this by running docker info and looking for the output of WARNING: No swap limit support near the bottom.

Enabling swap is entirely optional, but we recommended doing it if you will be hosting for others and to prevent OOM errors.

To enable swap, open /etc/default/grub as a root user and find the line starting with GRUB_CMDLINE_LINUX_DEFAULT. Make sure the line includes swapaccount=1 somewhere inside the double-quotes.

After that, run sudo update-grub followed by sudo reboot to restart the server and have swap enabled. Below is an example of what the line should look like, do not copy this line verbatim. It often has additional OS-specific parameters.

GRUB_CMDLINE_LINUX_DEFAULT="swapaccount=1"
