# https://raw.githubusercontent.com/TLATER/dotfiles/b39af91fbd13d338559a05d69f56c5a97f8c905d/home-config/config/graphical-applications/firefox.nix
# https://github.com/yokoffing/Betterfox

{ config, lib, pkgs, inputs, osConfig, ... }:

let firefox = "firefox-unwrapped";
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
        (pkgs."${firefox}".override { pipewireSupport = true; }) { });

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
            content = { notify = { interval = 100000; }; };

            keyword = { url = { "ddg" = "https://duckduckgo.com/?q=%s"; }; };

            full-screen-api = {
              transition-duration = {
                enter = "0 0";
                leave = "0 0";
              };
              delay = -1;
              warning = { timeout = 0; };
            };

            layout = {
              css = { dpi = 0; };
              wordselect = { eat_space_to_next_word = false; };
            };

            toolkit = {
              legacyUserProfileCustomizations = { stylesheets = true; };

              telemetry = {
                enabled = false;
                unified = false;

                server = "data:,";

                archive = { enabled = false; };

                newProfilePing = { enabled = false; };
                shutdownPingSender = { enabled = false; };
                updatePing = { enabled = false; };
                bhrPing = { enabled = false; };
                firstShutdownPing = { enabled = false; };

                coverage = { opt-out = true; };
              };

              coverage = {
                opt-out = true;

                endpoint = { base = ""; };
              };
            };

            gfx = {
              canvas = {
                accelerated = {
                  cache-items = 4096;
                  cache-size = 512;
                };
              };

              content = { skia-font-cache-size = 20; };

              webrender = {
                all = true;
                software = true;
              };
            };

            media = {
              memory_cache_max_size = 65536;
              cache_readahead_limit = 7200;
              cache_resume_threshold = 3600;

              ffmpeg = { vaapi = { enabled = true; }; };

              hardware-video-decoding = {
                enabled = true;
                force-enabled = true;
              };

              peerconnection = {
                ice = {
                  proxy_only_if_behind_proxy = true;
                  default_address_only = true;
                };
              };
            };

            image = { mem = { decode_bytes_at_a_time = 32768; }; };

            widget = {
              dmabuf = { force-enabled = true; };

              wayland = { opaque-region = { enabled = false; }; };
            };

            privacy = {
              userContext = { ui = { enabled = true; }; };

              globalprivacycontrol = { enabled = true; };

              webrtc = { legacyGlobalIndicator = true; };

              trackingprotection = {
                enabled = true;
                socialtracking = { enabled = true; };
              };
            };

            app = {
              shield = { optoutstudies = { enabled = false; }; };

              normandy = {
                enabled = false;
                api_url = "";
              };

              update = { auto = false; };
            };

            cookiebanners = {
              service = {
                mode = 1;
                "mode.privateBrowsing" = 1;
              };
            };

            network = {
              protocol-handler = { expose = { magnet = false; }; };

              http = {
                max-connections = 1800;
                max-persistent-connections-per-server = 10;
                max-urgent-start-excessive-connections-per-host = 5;

                referer = { XOriginTrimmingPolicy = 2; };
              };

              cookie = { sameSite = { noneRequiresSecure = true; }; };

              dnsCacheExpiration = 3600;
              dns = {
                disablePrefetch = true;
                disablePrefetchFromHTTPS = true;
              };

              prefetch-next = false;

              predictor = {
                enabled = false;
                enable-prefetch = false;
              };

              ssl_tokens_cache_capacity = 10240;

              IDN_show_punycode = true;

              auth = { subresource-http-auth-allow = 1; };

              captive-portal-service = { enabled = false; };
            };

            permissions = {
              default = {
                desktop-notification = 2;
                geo = 2;
              };

              manager = { defaultsUrl = ""; };

              allowObject = { urlWhitelist = ""; };
            };

            datareporting = {
              policy = { dataSubmissionEnabled = false; };

              healthreport = { uploadEnabled = false; };
            };

            security = {
              ssl = { treat_unsafe_negotiation_as_broken = true; };

              tls = { enable_0rtt_data = false; };

              sandbox = { content = { read_path_whitelist = [ "/sys/" ]; }; };

              OCSP = { enabled = 0; };

              remote_settings = { crlite_filters = { enabled = true; }; };

              pki = { crlite_mode = 2; };

              insecure_connection_text = {
                enabled = true;

                pbmode = { enabled = true; };
              };

              mixed_content = { block_display_content = true; };
            };

            pdfjs = { enableScripting = false; };

            captivedetect = { canonicalURL = ""; };

            findBar = { highlightAll = true; };

            browser = {
              aboutConfig = { showWarning = false; };

              aboutwelcome = { enabled = false; };

              bookmarks = {
                openInTabClosesMenu = false;
                restore_default_bookmarks = false;
              };

              cache = {
                disk = {
                  enable = lib.mkDefault false;
                  parent_directory = lib.mkDefault
                    "/run/user/${osConfig.users.users.mikel.uid}/firefox";
                };

                memory = {
                  enable = lib.mkDefault false;
                  capacity = lib.mkDefault - 1;
                };
              };

              contentblocking = { category = "strict"; };

              crashReports = { unsubmittedCheck = { autoSubmit2 = false; }; };

              ctrlTab = { recentlyUsedOrder = false; };

              discovery = { enabled = false; };

              display = { os-zoom-behavior = lib.mkDefault 0; };

              download = {
                start_downloads_in_tmp_dir = true;
                always_ask_before_handling_new_types = false;
                addToRecentDocs = false;
                open_pdf_attachments_inline = true;
              };

              formfill = { enable = false; };

              helperApps = { deleteTempFileOnExit = true; };

              laterrun = { enabled = false; };

              menu = { showViewImageInfo = true; };

              newtabpage = {
                activity-stream = {
                  telemetry = false;

                  asrouter = {
                    userprefs = {
                      cfr = {
                        addons = false;
                        features = false;
                      };
                    };
                  };

                  feeds = {
                    telemetry = false;

                    snippets = false;

                    topstories = false;
                    section = { topstories = false; };
                    system = { topstories = false; };
                  };

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

              preferences = { moreFromMozzila = false; };

              privatebrowsing = {
                forceMediaMemoryCache = true;

                vpnpromourl = "";
              };

              protections_panel = { infoMessage = { seen = true; }; };

              quitShortcut = { disabled = true; };

              safebrowsing = {
                downloads = { remote = { enabled = false; }; };
              };

              sessionstore = {
                interval = 60000;

                resume_from_crash = lib.mkDefault false;
              };

              shell = { checkDefaultBrowser = false; };

              ssb = { enabled = true; };

              tabs = {
                crashReporting = { sendReport = false; };

                remote = {
                  autostart = {
                    enabled = true;

                    "2" = true;
                  };

                  force-enable = false;
                };

                tabmanager = { enabled = false; };
              };

              toolbars = {
                bookmarks = { visibility = "never"; };

                urlbar = {
                  placeHolderName = "DuckDuckGo";
                  suggest = { openpage = false; };
                };
              };

              uitour = { enabled = false; };

              urlbar = {
                quicksuggest = { enabled = false; };

                suggest = {
                  calculator = false;
                  unitConversion = { enabled = false; };
                  trending = { featureGate = false; };

                  quicksuggest = {
                    sponsored = false;
                    nonsponsored = false;
                  };
                };
              };

              xul = { error_pages = { expert_bad_cert = true; }; };
            };

            breakpad = { reportURL = ""; };

            datareporting = {
              policy = {
                dataSubmissionEnable = false;
                dataSubmissionPolicyAcceptedVersion = 2;
              };
            };

            dom = {
              enable_web_task_scheduling = true;

              private-attribution = { submission = { enabled = false; }; };

              security = {
                sanitizer = { enabled = true; };

                https_only_mode = true;
                https_first = true;
                https_first_schemeless = true;

                dom = { securityhttps_only_mode_ever_enabled = true; };
              };
            };

            editor = { truncate_user_pastes = false; };

            signon = {
              formlessCapture = { enabled = false; };

              privateBrowsingCapture = { enabled = false; };
            };

            extensions = {
              autoDisableScopes = 0;

              postDownloadThirdPartyPrompt = false;

              getAddons = { showPane = false; };

              htmlaboutaddons = { recommendations = { enabled = false; }; };

              pocket = { enabled = false; };
            };

            identity = { fxaccouts = { enabled = false; }; };

            urlclassifier = {
              trackingSkipURLs =
                "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com";

              features = {
                socialtracking = {
                  skipURLs = "*.instagram.com, *.twitter.com, *.twimg.com";
                };
              };
            };
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
