# Initialize base image
FROM osrf/ros:noetic-desktop-full
ARG ROSDISTRO=noetic
ENV ROSDISTRO=$ROSDISTRO

# Set working directory
WORKDIR /root/workdir

# Entrypoint
COPY docker/entrypoint.sh /

# Zsh theme, and make entrypoint executable
COPY docker/.p10k.zsh /root/
ENV TERM=xterm-256color
RUN apt-get update && apt-get install -y zsh bash wget &&\
  PATH="$PATH:/usr/bin/zsh" &&\
  chmod +x /entrypoint.sh

# Default zsh powerline10k theme, no plugins installed
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)"

# Initialize zsh theme
RUN echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc

# Install any other system packages, including for ROS
RUN apt-get install -y\
  libgl1-mesa-glx\
  vim\
  tmux\
  figlet\
  iputils-ping\
  ssh-client

# Make entry
ENTRYPOINT ["/entrypoint.sh"]
CMD ["zsh"]