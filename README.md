# Nixenv

*Like devcontainers, but with more nix*

Nixenv generates development environments using Incus and Nix.  
Given a nixenv.yml file, specifying the features the container needs, a new fitting Incus container gets created.  

## Features

### x11

Passthrough a x11 socket, allowing for video output

#### xauth

Specify whether the correct xauth file should be passed through as well

#### display

Specify the number of the display to pass through

### wayland

Passthrough a wayland socket, allowing for video output
  
### pipewire

Passthrough a pipewire socket, allowing for audio output

### pulseaudio

Passthrough a pulseaudio socket, allowing for audio output

### user

Passthrough the current user with the gid and uid