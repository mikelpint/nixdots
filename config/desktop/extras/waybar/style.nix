_: ''
  * {
    color: @text;
    font-family: JetBrainsMono Nerd Font;
    font-size: 14px;
    font-weight: normal;
    min-height: 0;
  }

  *.warning {
    color: @peach;
  }

  *.critical {
    color: @red;
  }

  button {
    min-width: 16px;
  }

  button:hover {
    background: none;
    box-shadow: none;
    text-shadow: none;
    transition: none;
  }

  tooltip {
    border-radius: 10px 10px 10px 10px;
    border: 2px solid @pink;

    background-color: @base;
  }

  tooltip label {
    color: @text;
  }

  window#waybar {
    background-color: transparent;

    border-radius: 10px 10px 10px 10px;
  }

  #battery,
  #clock,
  #cpu,
  #custom-launcher,
  #disk,
  #memory,
  #network,
  #pulseaudio,
  #tray,
  #window,
  #workspaces {
    background-color: @base;
    
    margin-bottom: 0px;
    margin-top: 2px;
    
    padding: 3px;
  }

  #battery {
    border-bottom: 2px solid @pink;
    border-top: 2px solid @pink;
  }

  #clock {
    border-radius: 0px 10px 10px 0px;

    border-bottom: 2px solid @pink;
    border-right: 2px solid @pink;
    border-top: 2px solid @pink;

    margin-right: 3px;
  }

  #cpu {
    border-radius: 10px 0px 0px 10px;

    border-bottom: 2px solid @pink;
    border-left: 2px solid @pink;
    border-top: 2px solid @pink;

    padding-left: 7px;
  }

  #custom-launcher {
    font-size: 16px;

    margin-left: 3px;
    margin-right: 3px;
  }

  #custom-launcher,
  #window {
    border: 2px solid @pink;
    border-radius: 10px 10px 10px 10px;
  }

  #custom-spotify {
    border: 2px solid @pink;
    border-radius: 10px 10px 10px 10px;
    
    margin-left: 3px;
  }

  #disk {
    border-radius: 0px 10px 10px 0px;

    border-bottom: 2px solid @pink;
    border-right: 2px solid @pink;
    border-top: 2px solid @pink;

    padding-right: 7px;
  }

  #memory {
    border-bottom: 2px solid @pink;
    border-top: 2px solid @pink;

    padding-left: 7px;
    padding-right: 7px;
  }

  #network {
    border-bottom: 2px solid @pink;
    border-top: 2px solid @pink;
  }

  #pulseaudio {
    border-radius: 10px 0px 0px 10px;

    border-bottom: 2px solid @pink;
    border-left: 2px solid @pink;
    border-top: 2px solid @pink;
  }

  #tray {
    border-radius: 10px 10px 10px 10px;

    border: 2px solid @pink;
    padding-left: 5px;
    padding-right: 5px;

    margin-right: 3px;
  }

  #window {
    border-radius: 10px 10px 10px 10px;

    font-weight: bold;

    padding-left: 7px;
    padding-right: 7px;
  }

  #workspaces {
    border-radius: 10px 10px 10px 10px;

    border: 2px solid @pink;
    
    margin-right: 3px;
  }

  #workspaces button {
    border: 0;
    padding: 1px;
  }

  #workspaces button.active {
    background-color: @pink;
    color: white;
  }

  #workspaces button:hover {
    background-color: @surface2;
  }
''
