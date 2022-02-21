# Initialize base image
FROM ros:melodic as ros_base

# Zsh theme, and make entrypoint executable
COPY docker/.p10k.zsh /root/
ENV TERM=xterm-256color
RUN apt-get update && apt-get install -y zsh bash wget &&\
  PATH="$PATH:/usr/bin/zsh"

# Default zsh powerline10k theme, no plugins installed
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)"

# Initialize zsh theme
RUN echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc

# Install system packages "starter pack"
RUN apt-get update && apt-get install -y \
  figlet \
  libgl1-mesa-glx \
  vim \
  tmux \
  iputils-ping \
  tree

# ------- VNC GUI Configuration -------
# Install vnc, xvfb for VNC configuration, fluxbox for window managment
RUN apt-get update && apt-get install -y \
  x11vnc \
  xvfb \
  fluxbox
RUN mkdir ~/.vnc

# Start the VNC server
RUN echo "export DISPLAY=:20" >> ~/.zshrc \
  && echo "export DISPLAY=:20" >> ~/.bashrc

# Always try to start windows management in background to be ready for VNC
RUN echo "( fluxbox > /dev/null 2>&1 & )" >> ~/.zshrc \
  && echo "( fluxbox > /dev/null 2>&1 & )" >> ~/.bashrc

# Clean up unnecessary output files
RUN echo "rm -f /root/workdir/nohup.out" >> ~/.zshrc \
  && echo "rm -f /root/workdir/nohup.out" >> ~/.bashrc
# ---------------------------------

# Install any other system packages, including for ROS
# RUN apt-get update && apt-get install -y \


# Setup entrypoint
COPY docker/entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Make entry
WORKDIR /root/workdir
ENTRYPOINT ["/entrypoint.sh"]
CMD ["zsh"]
