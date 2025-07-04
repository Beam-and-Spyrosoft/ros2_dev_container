ARG DOCKER_REPO
ARG ROS_DISTRO
ARG IMAGE_SUFFIX
FROM $DOCKER_REPO:$ROS_DISTRO$IMAGE_SUFFIX
ARG USERNAME

# Remove the default `ubuntu` user if exists
RUN if id -u ubuntu > /dev/null 2>&1; then userdel -r ubuntu; fi && \
    if getent group ubuntu > /dev/null 2>&1; then groupdel ubuntu; fi

# Create the user
RUN useradd -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Install additonal packages - add any that you need
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y sudo python3-pip python-is-python3 ssh neovim git libboost-all-dev libgmock-dev \
    zsh curl wget fonts-powerline locales less gdb ros-dev-tools ros-$ROS_DISTRO-ament-* cmake ninja-build \
    python3-bloom python3-vcstool fakeroot python3-sphinx sphinx-rtd-theme-common python3-sphinx-rtd-theme \
    doxygen doxygen-gui graphviz python3-myst-parser python3-breathe python3-exhale python3-linkify-it lcov \
    libfoonathan-memory-dev

USER $USERNAME
WORKDIR /home/$USERNAME

# Install oh-my-zsh and plugins for the user
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Copy zshrc configuration
COPY --chown=$USERNAME:$USERNAME zshrc /home/$USERNAME/.zshrc

# Make zsh the default shell for user
RUN sudo chsh -s /bin/zsh $USERNAME

# Set the default user
ENV SHELL /bin/zsh
CMD ["/bin/zsh"]