#!/bin/zsh
set -e

# Source ros with every new shell
echo 'source /opt/ros/$ROS_DISTRO/setup.zsh' >> /root/.zshrc
echo 'source /opt/ros/$ROS_DISTRO/setup.bash' >> /root/.bashrc

# Welcome message
echo "figlet -f slant 'Welcome!'" >> ~/.zshrc

# Start the VNC server
x11vnc -forever -create

exec "$@"