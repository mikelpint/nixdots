_: ''
  * {
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

  #backlight,
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

    margin-bottom: 3px;
    margin-top: 3px;

    padding: 3px;
  }

  #backlight {
    color: @text;

    border-bottom: 2px solid @pink;
    border-top: 2px solid @pink;

    padding-left: 7px;
    padding-right: 7px;
  }

  #battery {
    color: @text;

    border-bottom: 2px solid @pink;
    border-top: 2px solid @pink;

    padding-left: 7px;
    padding-right: 7px;
  }

  #clock {
    color: @text;

    border-radius: 0px 10px 10px 0px;

    border-bottom: 2px solid @pink;
    border-right: 2px solid @pink;
    border-top: 2px solid @pink;

    padding-left: 7px;
    padding-right: 7px;

    margin-right: 3px;
  }

  #cpu {
    color: @text;

    border-radius: 10px 0px 0px 10px;

    border-bottom: 2px solid @pink;
    border-left: 2px solid @pink;
    border-top: 2px solid @pink;

    padding-left: 7px;
    padding-right: 7px;
  }

  #custom-launcher {
    color: @text;

    font-size: 16px;

    padding-left: 7px;
    padding-right: 7px;

    margin-left: 3px;
    margin-right: 3px;
  }

  #custom-launcher,
  #window {
    color: @text;

    border: 2px solid @pink;
    border-radius: 10px 10px 10px 10px;
  }

  #custom-spotify {
    color: @text;

    color: @text;

    border: 2px solid @pink;
    border-radius: 10px 10px 10px 10px;

    margin-left: 3px;
  }

  #disk {
    color: @text;

    border-radius: 0px 10px 10px 0px;

    border-bottom: 2px solid @pink;
    border-right: 2px solid @pink;
    border-top: 2px solid @pink;

    padding-left: 7px;
    padding-right: 7px;
  }

  #memory {
    color: @text;

    border-bottom: 2px solid @pink;
    border-top: 2px solid @pink;

    padding-left: 7px;
    padding-right: 7px;
  }

  #network {
    color: @text;

    border-bottom: 2px solid @pink;
    border-top: 2px solid @pink;


    padding-left: 7px;
    padding-right: 7px;
  }

  #pulseaudio {
    color: @text;

    border-radius: 10px 0px 0px 10px;

    border-bottom: 2px solid @pink;
    border-left: 2px solid @pink;
    border-top: 2px solid @pink;

    padding-left: 7px;
    padding-right: 7px;

    margin-left: 3px;
  }

  #tray {
    color: @text;

    border-radius: 10px 10px 10px 10px;

    border: 2px solid @pink;
    padding-left: 5px;
    padding-right: 5px;

    margin-right: 3px;
  }

  #window {
    color: @text;

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
    color: @text;

    border: 0;
    padding: 1px;
  }

  #workspaces button.active {
    background-color: @pink;
    color: #ffffff;
  }

  #workspaces button:hover {
    background-color: @surface2;
  }
''
