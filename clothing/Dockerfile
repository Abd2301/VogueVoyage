# Use an official base image
FROM ubuntu:20.04

# Set environment variables
ENV FLUTTER_VERSION=3.16.5
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH=$FLUTTER_HOME/bin:$PATH

# Install necessary tools and dependencies
RUN apt-get update \
    && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    openjdk-11-jdk \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Download and extract Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME

# Add Flutter to path
RUN flutter doctor

# Set the working directory
WORKDIR /app

# Copy project files into the container
COPY . .

# Fetch dependencies
RUN flutter pub get

# Build the Flutter project for Android (or use 'build apk' or 'build appbundle' depending on your needs)
RUN flutter build apk

# Command to run the app, you might adjust this depending on your needs
CMD ["flutter", "run", "--release"]
