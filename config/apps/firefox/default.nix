# https://raw.githubusercontent.com/TLATER/dotfiles/b39af91fbd13d338559a05d69f56c5a97f8c905d/home-config/config/graphical-applications/firefox.nix

{ config, lib, pkgs, flake-inputs, ... }:
let
  inherit (pkgs) runCommandNoCC writeText;
  inherit (pkgs.lib.strings) concatStrings;
  inherit (pkgs.lib.attrsets) mapAttrsToList;

  tlaterpkgs = flake-inputs.self.packages.${pkgs.system};
  inherit (flake-inputs.self.packages.${pkgs.system}) firefox-ui-fix;

  settings = writeText "user.js" (concatStrings (mapAttrsToList (name: value: ''
    user_pref("${name}", ${builtins.toJSON value});
  '') config.programs.firefox.profiles.mikel.settings));

  settings-file = runCommandNoCC "firefox-settings" { } ''
    cat '${firefox-ui-fix}/user.js' '${settings}' > $out
  '';
in {
  home = {
    file.".mozilla/firefox/mikel/chrome/icons" = {
      source = "${firefox-ui-fix}/icons";
    };

    file.".mozilla/firefox/${config.programs.firefox.profiles.mikel.path}/user.js" =
      {
        source = settings-file;
      };
  };

  programs = {
    firefox = {
      enable = true;

      profiles = {
        mikel = {
          search = {
            default = "DuckDuckGo";
            force = true;
          };

          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            auto-tab-discard
            clearurls
            darkreader
            decentraleyes
            duckduckgo-privacy-essentials
            enhanced-github
            tampermonkey
            stylus
            ublock-origin
            user-agent-switcher
          ];
        };
      };

      userChrome = builtins.readFile "${firefox-ui-fix}/css/leptonChrome.css";
      userContent = builtins.readFile "${firefox-ui-fix}/css/leptonContent.css";

      settings = {
        gfx = { webrender = { all = true; }; };

        media = { ffmpeg = { vaapi = { enabled = true; }; }; };

        widget = { dmabuf = { force-enabled = true; }; };

        privacy = {
          webrtc = { legacyGlobalIndicator = true; };

          trackingprotection = {
            enabled = true;
            socialtracking = { enabled = true; };
          };
        };

        app = {
          shield = { optoutstudies = { enabled = false; }; };

          update = { auto = false; };
        };

        browser = {
          bookmarks = { restore_default_bookmarks = false; };

          contentblocking = { category = "strict"; };

          ctrlTab = { recentlyUsedOrder = false; };

          discovery = { enabled = false; };

          laterrun = { enabled = false; };

          newtabpage = {
            activity-stream = {
              asrouter = {
                userprefs = {
                  cfr = {
                    addons = false;
                    features = false;
                  };
                };
              };

              feeds = { snippets = false; };

              improvesearch = {
                topSiteSearchShortcuts = {
                  havePinned = "";
                  searcEngines = "";
                };
              };

              section = { highlights = { includePocket = false; }; };

              showSponsored = false;
              showSponsoredTopSites = false;
            };

            pinned = false;
          };

          protections_panel = { infoMessage = { seen = true; }; };

          quitShortcut = { disabled = true; };

          shell = { checkDefaultBrowser = false; };

          ssb = { enabled = true; };

          toolbars = {
            bookmarks = { visibility = "never"; };

            urlbar = {
              placeHolderName = "DuckDuckGo";
              suggest = { openpage = false; };
            };
          };
        };

        datareporting = {
          policy = {
            dataSubmissionEnable = false;
            dataSubmissionPolicyAcceptedVersion = 2;
          };
        };

        dom = {
          security = {
            https_only_mode = true;
            dom.securityhttps_only_mode_ever_enabled = true;
          };
        };

        extensions = {
          getAddons = { showPane = false; };

          htmlaboutaddons = { recommendations = { enabled = false; }; };

          pocket = { enabled = false; };
        };

        identity = { fxaccouts = { enabled = false; }; };
      };
    };
  };

  xdg = {
    mimeApps = {
      enable = true;

      associations.added = {
        "application/pdf" = [ "firefox.desktop" ];
        "video/mp4" = [ "mpv.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "text/html" = [ "firefox.desktop" ];
      };

      defaultApplications = {
        "application/pdf" = [ "firefox.desktop" ];
        "application/x-extension-htm" = [ "firefox.desktop" ];
        "application/x-extension-html" = [ "firefox.desktop" ];
        "application/x-extension-shtml" = [ "firefox.desktop" ];
        "application/x-extension-xht" = [ "firefox.desktop" ];
        "application/x-extension-xhtml" = [ "firefox.desktop" ];
        "application/x-www-browser" = [ "firefox.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/chrome" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/ftp" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "x-scheme-handler/webcal" = [ "firefox.desktop" ];
        "x-www-browser" = [ "firefox.desktop" ];
        "video/mp4" = [ "mpv.desktop" ];
      };
    };
  };
}
