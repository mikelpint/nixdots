# https://raw.githubusercontent.com/TLATER/dotfiles/b39af91fbd13d338559a05d69f56c5a97f8c905d/home-config/config/graphical-applications/firefox.nix

{ config, lib, pkgs, ... }: {
  programs = {
    firefox = {
      enable = true;

      profiles = {
        mikel = {
          search = {
            default = "DuckDuckGo";
            force = true;
          };

          # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          #   auto-tab-discard
          #   clearurls
          #   darkreader
          #   decentraleyes
          #   duckduckgo-privacy-essentials
          #   enhanced-github
          #   tampermonkey
          #   stylus
          #   ublock-origin
          #   user-agent-switcher
          # ];

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
