_: ''
  @import "macchiatto.css";

  * {
    font-family: JetBrainsMono Nerd Font;
    font-weight: normal;
    font-size: 14px;
    min-height: 0;
    color: @text;
  }

  button:hover {
    box-shadow: none;
    text-shadow: none;
    background: none;
    transition: none;
  }

  #window,
  #clock,
  #tray,
  #pulseaudio,
  #battery,
  #network,
  #workspaces,
  #window,
  #custom-launcher {
    background-color: @base;
    margin-top: 2px;
    margin-bottom: 0px;
    padding: 3px;
  }

  #tray {
    border: 2px solid @blue;
    padding-left: 5px;
    padding-right: 5px
  }

  #custom-launcher,
  #window {
    border: 2px solid @blue;
    border-radius: 10px 10px 10px 10px;
  }

  #custom-spotify {
    margin-left: 3px ;
    border: 2px solid @blue;
    border-radius: 10px 10px 10px 10px;
  }

  #workspaces {
    border: 2px solid @blue;
    color: @text;
  }

  #clock {
    border-right: 2px solid @blue;
    border-top: 2px solid @blue;
    border-bottom: 2px solid @blue;
  }

  #network {
    border-left: 2px solid @blue;
    border-top: 2px solid @blue;
    border-bottom: 2px solid @blue;
  }

  #battery {
    border-top: 2px solid @blue;
    border-bottom: 2px solid @blue;
  }

  #pulseaudio {
    border-top: 2px solid @blue;
    border-bottom: 2px solid @blue;
  }

  #tray {
    border-radius: 10px 10px 10px 10px;
    margin-right: 3px;
  }

  #network {
    border-radius: 10px 0px 0px 10px;
  }

  #clock {
    border-radius: 0px 10px 10px 0px;
  }

  #custom-launcher {
    font-size: 16px;
    margin-left: 3px;
    margin-right: 3px;
  }

  #clock {
    font-weight: bold;
    margin-right: 3px;
  }

  #window {
    font-weight: bold;
    border-radius: 10px 10px 10px 10px;
    padding-left: 7px;
    padding-right: 7px;
  }

  #workspaces button {
    color: @text;
    padding: 1px;
  }

  #workspaces button.active {
    color: @subtext1 !important;
  }

  #workspaces button.focused {
    color: @subtext1 !important;
  }

  #workspaces {
    border-radius: 10px 10px 10px 10px;
  }

  button {
    min-width: 16px;
  }

  window#waybar {
    background-color: transparent;
    border-radius: 10px 10px 10px 10px;
  }
''
