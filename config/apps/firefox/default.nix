# https://raw.githubusercontent.com/TLATER/dotfiles/b39af91fbd13d338559a05d69f56c5a97f8c905d/home-config/config/graphical-applications/firefox.nix

{ config, lib, pkgs, inputs, ... }:

let firefox = "floorp";
in {
  home = {
    activation = {
      "chrome" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        rm -rf /home/mikel/.mozilla/firefox/mikel/chrome
        cp -r /etc/nixos/config/apps/firefox/chrome /home/mikel/.mozilla/firefox/mikel
      '';
    };
  };

  programs = {
    firefox = {
      enable = true;
      package = (pkgs.wrapFirefox
        (pkgs.${firefox} - unwrapped.override { pipewireSupport = true; }) { });

      profiles = {
        mikel = {
          isDefault = true;

          search = {
            default = "DuckDuckGo";
            force = true;
          };

          extensions = with (import inputs.nur {
            inherit pkgs;
            nurpkgs = pkgs;
          }).repos.rycee.firefox-addons; [
            anchors-reveal
            auto-tab-discard
            clearurls
            cookie-autodelete
            darkreader
            decentraleyes
            duckduckgo-privacy-essentials
            enhanced-github
            libredirect
            link-cleaner
            linkhints
            protondb-for-steam
            reddit-enhancement-suite
            skip-redirect
            stylus
            tampermonkey
            ublock-origin
            user-agent-string-switcher
          ];

          userChrome = ''
            @import 'includes/cascade-config.css';
            @import 'includes/cascade-colours.css';

            @import 'includes/cascade-layout.css';
            @import 'includes/cascade-responsive.css';
            @import 'includes/cascade-floating-panel.css';

            @import 'includes/cascade-nav-bar.css';
            @import 'includes/cascade-tabs.css';
          '';

          settings = {
            toolkit = {
              legacyUserProfileCustomizations = { stylesheets = true; };
            };

            gfx = { webrender = { all = true; }; };

            media = {
              ffmpeg = { vaapi = { enabled = true; }; };

              hardware-video-decoding = { force-enabled = true; };
            };

            widget = {
              dmabuf = { force-enabled = true; };

              wayland = { opaque-region = { enabled = false; }; };
            };

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
              autoDisableScopes = 0;

              getAddons = { showPane = false; };

              htmlaboutaddons = { recommendations = { enabled = false; }; };

              pocket = { enabled = false; };
            };

            identity = { fxaccouts = { enabled = false; }; };
          };
        };
      };
    };
  };

  xdg = {
    mimeApps = {
      enable = true;

      associations = {
        added = {
          "application/pdf" = [ "${firefox}.desktop" ];
          "x-scheme-handler/http" = [ "${firefox}.desktop" ];
          "x-scheme-handler/https" = [ "${firefox}.desktop" ];
          "text/html" = [ "${firefox}.desktop" ];
        };
      };

      defaultApplications = {
        "application/pdf" = [ "${firefox}.desktop" ];
        "application/x-extension-htm" = [ "${firefox}.desktop" ];
        "application/x-extension-html" = [ "${firefox}.desktop" ];
        "application/x-extension-shtml" = [ "${firefox}.desktop" ];
        "application/x-extension-xht" = [ "${firefox}.desktop" ];
        "application/x-extension-xhtml" = [ "${firefox}.desktop" ];
        "application/x-www-browser" = [ "${firefox}.desktop" ];
        "application/xhtml+xml" = [ "${firefox}.desktop" ];
        "text/html" = [ "${firefox}.desktop" ];
        "x-scheme-handler/chrome" = [ "${firefox}.desktop" ];
        "x-scheme-handler/http" = [ "${firefox}.desktop" ];
        "x-scheme-handler/https" = [ "${firefox}.desktop" ];
        "x-scheme-handler/ftp" = [ "${firefox}.desktop" ];
        "x-scheme-handler/about" = [ "${firefox}.desktop" ];
        "x-scheme-handler/unknown" = [ "${firefox}.desktop" ];
        "x-scheme-handler/webcal" = [ "${firefox}.desktop" ];
        "x-www-browser" = [ "${firefox}.desktop" ];
      };
    };
  };
}
