#!/bin/zsh
set -e

# Source ros with every new shell
echo 'source /opt/ros/$ROSDISTRO/setup.zsh' >> /root/.zshrc
echo 'source /opt/ros/$ROSDISTRO/setup.bash' >> /root/.bashrc

# Welcome message
echo "figlet -f slant 'Welcome!'" >> ~/.zshrc

exec "$@"