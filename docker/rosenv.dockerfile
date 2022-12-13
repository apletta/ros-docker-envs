# Initialize base image
FROM ros:melodic as ros_base

# -------- Base Environment -------
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
# ---------------------------------

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

# ----- ORB-SLAM3 Dependencies ----
# Install OpenCV
WORKDIR /root/
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/4.4.0.zip \
  && apt install unzip \
  && unzip opencv.zip \
  && cd opencv-4.4.0 \
  && mkdir -p build && cd build \
  && cmake .. \
  && make \
  && make install

# apt install qtbase5-dev
# apt install qtdeclarative5-dev
# mkdir Release && cd Release
# cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_GTK=ON -D WITH_OPENGL=ON ..
# 

# Install Pangolin
WORKDIR /root/
RUN git clone --recursive https://github.com/stevenlovegrove/Pangolin.git
WORKDIR /root/Pangolin
RUN yes | ./scripts/install_prerequisites.sh recommended \
  && mkdir -p build && cd build \
  && cmake .. \
  && make \
  && make install
# ---------------------------------

# ------ Project Dependencies -----
# Post-processing pipeline dependencies
RUN yes | apt install python3-pip \
  && pip3 install matplotlib \
  && yes | apt install python3-tk

# Install any other system packages, including for ROS
RUN apt-get update && apt-get install -y \
  ros-$ROS_DISTRO-rviz
# ---------------------------------

# Setup entrypoint
COPY docker/entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Make entry
WORKDIR /root/workdir
ENTRYPOINT ["/entrypoint.sh"]
CMD ["zsh"]
