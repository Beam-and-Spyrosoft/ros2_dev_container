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
    zsh curl wget fonts-powerline locales less gdb ros-dev-tools ros-jazzy-ament-* cmake ninja-build
ENV SHELL /bin/bash

USER $USERNAME
WORKDIR /home/$USERNAME

# Install oh-my-zsh and plugins for the user
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Copy zshrc configuration
COPY --chown=$USERNAME:$USERNAME zshrc /home/$USERNAME/.zshrc

# Create minimal p10k config if user doesn't have one
RUN [ ! -f /home/$USERNAME/.p10k.zsh ] && \
    echo "# Generated p10k config - run 'p10k configure' to customize\ntypeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet\n" > /home/$USERNAME/.p10k.zsh || true

# Make zsh the default shell for user
RUN sudo chsh -s /bin/zsh $USERNAME

# Source ROS environment automatically
RUN echo "source /opt/ros/$ROS_DISTRO/setup.zsh" >> /home/$USERNAME/.zshrc
RUN echo "source /home/ws/install/setup.zsh" >> /home/$USERNAME/.zshrc

# Set the default user
ENV SHELL /bin/zsh
CMD ["/bin/zsh"]