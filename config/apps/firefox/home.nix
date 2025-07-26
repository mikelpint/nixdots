# https://raw.githubusercontent.com/TLATER/dotfiles/b39af91fbd13d338559a05d69f56c5a97f8c905d/home-config/config/graphical-applications/firefox.nix
# https://github.com/yokoffing/Betterfox

{
  lib,
  pkgs,
  inputs,
  osConfig,
  config,
  user,
  home-manager,
  ...
}:

let
  package = pkgs.wrapFirefox (pkgs."firefox-unwrapped".override {
    # pipewireSupport = true;
  }) { };

  kagiPrivateTokenPlaceholder = "kagi-private-token-placeholder";
  stylusId = "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}";
in
{
  home = {
    file = lib.mkIf false {
      ".mozilla/firefox/${user}/user.js" = {
        force = true;
      };
      ".mozilla/firefox/static-${user}/user.js" = {
        force = true;
      };

      ".mozilla/firefox/static-${user}/search.json.mozlz4" = {
        force = true;
      };
      ".mozilla/firefox/${user}/search.json.mozlz4" = {
        force = true;
      };

      ".mozilla/firefox/default/user.js" = {
        force = true;
      };
      ".mozilla/firefox/static-default/user.js" = {
        force = true;
      };

      ".mozilla/firefox/static-default/search.json.mozlz4" = {
        force = true;
      };
      ".mozilla/firefox/default/search.json.mozlz4" = {
        force = true;
      };
    };

    activation =
      { }
      // (lib.mkIf false {
        "firefox-replaceKagiPrivateToken" =
          home-manager.lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" "firefox" ]
            ''
              TOKEN=$(printf '%s' "$(< ${osConfig.age.secrets.kagi-private-token.path})" | sed -e 's/[\/&]/\\&/g')
              TARGET=$([ -f "/home/${user}/.mozilla/firefox/${user}/user.js" ] && \
                echo -n "/home/${user}/.mozilla/firefox/${user}/user.js" || \
                [ -f "/home/${user}/.mozilla/firefox/static-${user}/user.js" ] && \
                echo -n "/home/${user}/.mozilla/firefox/static-${user}/user.js" || \
                [ -f "/home/${user}/.mozilla/firefox/default/user.js" ] && \
                echo -n "/home/${user}/.mozilla/firefox/default/user.js" || \
                echo -n "/home/${user}/.mozilla/firefox/static-default/user.js"
              )

              [ -n TOKEN ] && ${pkgs.gnused}/bin/sed -i "s/${kagiPrivateTokenPlaceholder}/$TOKEN/g" $TARGET || ${pkgs.gnused}/bin/sed -i "s/token=${kagiPrivateTokenPlaceholder}&//g" $TARGET
            '';
      })
      // (lib.mkIf (false && (osConfig.catppuccin.enable or false)) {
        "stylus-catppuccin" = ''
          INTERNAL_UUID=$(\
            echo "{$(\
                cat prefs.js | \
                ${pkgs.gnused}/bin/sed '/^\/\//d' | \
                ${pkgs.gnused}/bin/sed '/^[[:space:]]*$/d' | \
                ${pkgs.gnused}/bin/sed -r 's/^user_pref\(\"(.+)\", (.+)\);$/"\1": \2,/g' | \
                ${pkgs.gnused}/bin/sed '$s/,$//' \
            )}" | \
            ${pkgs.jq}/bin/jq -r '."extensions.webextensions.uuids"' | \
            ${pkgs.jq}/bin/jq -r '."${stylusId}"' \
          )
        '';
      });
  };

  programs = {
    firefox = {
      enable = true;
      inherit package;

      nativeMessagingHosts = with pkgs; [ web-eid-app ];

      languagePacks = [
        "en-US"
        "es"
      ];

      policies = {
        AppAutoUpdate = false;
        Authentication = { };
        DisableFirefoxStudies = true;
        DisableMasterPasswordCreation = true;
        DisablePocket = true;
        DisableProfileImport = true;
        DisableProfileRefresh = true;
        DisableSecurityBypass = {
          InvalidCertificate = false;
          SafeBrowsing = false;
        };
        DisableSetDesktopBackground = true;
        DisableTelemetry = true;
        DNSOverHTTPS = {
          Enabled =
            (
              (osConfig.services.resolved.enable or false)
              && (toString (osConfig.services.resolved.dnsovertls or false) == "true")
            )
            || (osConfig.services.dnscrypt-proxy2.enable or false);
        };
        DontCheckDefaultBrowser = true;
        DownloadDirectory = config.home.sessionVariables.XDG_DOWNLOAD_DIR or "\${HOME}/Downloads";
        EnableTrackingProtection = {
          Value = true;
        };
        EncryptedMediaExtensions = {
          Enabled = true;
        };
        ExtensionSettings = {
          "*" = {
            installation_mode = "blocked";
          };
        };
        SearchEngines = {
          Default = "kagi";
        };
        SSLVersionMax = "tls1.3";
        SSLVersionMin = "tls.12";
      };

      profiles = {
        default = {
          isDefault = true;

          search = {
            force = true;
            default = config.programs.firefox.policies.SearchEngines.Default or "kagi";
            privateDefault =
              config.programs.firefox.profiles."${user}".search.default
                or config.programs.firefox.profiles.default.search.default;
            engines = {
              "kagi" = {
                name = "Kagi";
                urls = [
                  {
                    template = "https://kagi.com/search";
                    params = [
                      {
                        name = "token";
                        value = kagiPrivateTokenPlaceholder;
                      }

                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "https://assets.kagi.com/v2/favicon-32x32.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = [
                  "@kagi"
                  "@kg"
                ];
              };

              "nixos-packages" = {
                name = "NixOS Packages";
                description = "Search in NixOS Packages";
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "from";
                        value = "0";
                      }

                      {
                        name = "size";
                        value = "relevance";
                      }

                      {
                        name = "type";
                        value = "packages";
                      }

                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [
                  "@np"
                  "@nixpkgs"
                ];
              };

              "nixos-options" = {
                name = "NixOS Options";
                description = "Search in NixOS Options";
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "from";
                        value = "0";
                      }

                      {
                        name = "size";
                        value = "relevance";
                      }

                      {
                        name = "type";
                        value = "packages";
                      }

                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [
                  "@no"
                  "@nixopts"
                  "@nixoptions"
                ];
              };

              "nixos-wiki" = {
                name = "NixOS Wiki";
                description = "Search in the NixOS Wiki";
                urls = [
                  {
                    template = "https://wiki.nixos.org/w/index.php";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "https://wiki.nixos.org/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = [
                  "@nw"
                  "@nixwiki"
                ];
              };
            };
          };

          extensions = {
            packages =
              with (import inputs.nur {
                inherit pkgs;
                nurpkgs = pkgs;
              }).repos.rycee.firefox-addons;
              [
                anchors-reveal
                auto-tab-discard
                clearurls
                cookie-autodelete
                decentraleyes
                enhanced-github
                enhancer-for-youtube
                firefox-color
                libredirect
                link-cleaner
                linkhints
                reddit-enhancement-suite
                skip-redirect
                stylus
                tampermonkey
                ublock-origin
                user-agent-string-switcher
              ]
              ++ (lib.optionals (
                let
                  any = builtins.any (
                    let
                      p = pkgs.nodePackages.nodejs;
                    in
                    x: (if lib.attrsets.isDerivation x then lib.getName x else null) == p
                  );
                in
                any config.home.packages || any osConfig.environment.systemPackages
              ) [ react-devtools ])
              ++ (lib.optionals (osConfig.programs.steam.enable or false) [ protondb-for-steam ])
              ++ (lib.optionals (
                let
                  any = builtins.any (
                    let
                      cli = pkgs.protonvpn-cli;
                      gui = pkgs.protonvpn-gui;
                    in
                    x:
                    let
                      name = if lib.attrsets.isDerivation x then lib.getName x else null;
                    in
                    name != null && (name == cli || name == gui)
                  );
                in
                any config.home.packages || any osConfig.environment.systemPackages
              ) [ proton-vpn ])
              ++ (lib.optionals (
                let
                  any = builtins.any (
                    let
                      p = pkgs.proton-pass;
                    in
                    x: (if lib.attrsets.isDerivation x then lib.getName x else null) == p
                  );
                in
                any config.home.packages || any osConfig.environment.systemPackages
              ) [ proton-pass ])
              ++ (lib.optionals
                (
                  (config.programs.firefox.profiles."${user}".search.default
                    or config.programs.firefox.profiles.default.search.default
                  ) == "ddg"
                )
                [
                  duckduckgo-privacy-essentials
                ]
              )
              ++ (lib.optionals
                (
                  (config.programs.firefox.profiles."${user}".search.default
                    or config.programs.firefox.profiles.default.search.default
                  ) == "kagi"
                )
                [
                  kagi-privacy-pass
                  kagi-search
                ]
              );

            settings = {
              "${stylusId}" = {
                # Stylus
              };
            };

            force = true;
          };

          userChrome =
            let
              cascade = pkgs.fetchFromGitHub {
                owner = "andreasgrafen";
                repo = "cascade";
                rev = "f8c6bb5a36f24aba61995204ff5497c865e78e50";
                sha256 = "aylkbsKLuCJqao8oeEZvSMaZUvjIxhlT/kGJ1DDsEt0=";
              };
            in
            lib.strings.concatLines (
              builtins.map (
                line:
                if (builtins.match "^@import \"includes/(.*)\";" line) != null then
                  (builtins.readFile "${cascade}/chrome/includes/${
                    builtins.substring ((builtins.stringLength "import \"includes/") + 1) (
                      (builtins.stringLength line)
                      - (builtins.stringLength "\";")
                      - ((builtins.stringLength "import \"includes/") + 1)
                    ) line
                  }")
                else
                  line
              ) (lib.strings.splitString "\n" (builtins.readFile "${cascade}/chrome/userChrome.css"))
            );

          settings = {
            "content.notify.interval" = 10000;

            "keyword.url.kagi" = "https://kagi.com/search?token=${kagiPrivateTokenPlaceholder}&q=%s";
            "keyword.url.ddg" = "https://duckduckgo.com/?q=%s";

            "full-screen-api.transition-duration.enter" = "0 0";
            "full-screen-api.transition-duration.leave" = "0 0";
            "full-screen-api.delay" = -1;
            "full-screen-api.warning.timeout" = 0;

            "layout.css.dpi" = 0;
            "layout.wordselect.eat_space_to_next_word" = false;

            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.server" = "data:,";
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.coverage.opt-out" = true;
            "toolkit.coverage.opt-out" = true;
            "toolkit.coverage.endpoint.base" = "";

            "gfx.canvas.accelerated.cache-items" = 4096;
            "gfx.canvas.accelerated.cache-size" = 512;
            "gfx.content.ski-font-cache-size" = 20;
            "gfx.webrender.all" = true;
            "gfx.webrender.software" = true;

            "media.memory_cache_max_size" = 65536;
            "media.cache_readahead_limit" = 7200;
            "media.cache_resume_threshold" = 3600;
            "media.ffmpeg.vaapi.enabled" = true;
            "media.hardware-video-decoding.enabled" = true;
            "media.hardware-video-decoding.force-enabled" = true;
            "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
            "media.peerconnection.ice.default_address_only" = true;

            "image.mem.decode_bytes_at_a_time" = 32768;

            "widget.dmabuf.force-enabled" = true;
            "widget.wayland.opaque-region.enabled" = false;

            "privacy.userContext.ui.enabled" = true;
            "privacy.globalprivacycontrol.enabled" = true;
            "privacy.webrtc.legacyGlobalIndicator" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.socialtracking.enabled" = true;

            "app.shield.optoutstudies.enabled" = false;
            "app.normandy.enabled" = false;
            "app.normandy.api_url" = "";
            "app.update.auto" = false;

            "cookiebanners.service.mode" = 1;
            "cookiebanners.service.mode.privateBrowsing" = 1;

            "network.protocol-handler.expose.magnet" = false;
            "network.http.max-connections" = 1800;
            "network.http.max-persistent-connections-per-server" = 10;
            "network.http.max-urgent-start-excessive-connections-per-host" = 5;
            "network.http.referer.XOriginTrimmingPolicy" = 2;
            "network.cookie.sameSite.noneRequiresSecure" = true;
            "network.dnsCacheExpiration" = 3600;
            "network.dns.disablePrefetch" = true;
            "network.dns.disablePrefetchFromHTTPS" = true;
            "network.prefetch-next" = false;
            "network.predictor.enabled" = false;
            "network.predictor.enable-prefetch" = false;
            "network.ssl_tokens_cache_capacity" = 10240;
            "network.IDN_show_punycode" = true;
            "network.auth.subresource-http-auth-allow" = 1;
            "network.captive-portal-service.enabled" = false;

            "permissions.default.desktop-notification" = 2;
            "permissions.default.geo" = 2;
            "permissions.manager.defaultsUrl" = "";
            "permissions.allowObject.urlWhitelist" = "";

            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
            "datareporting.healthreport.uploadEnabled" = true;

            "security.ssl.treat_unsafe_negotiation_as_broken" = true;
            "security.tls.enable_0rtt_data" = false;
            "security.sandbox.content.read_path_whitelist" = [ "/sys/" ];
            "security.OCSP.enabled" = 0;
            "security.remote_settings.crlite_filters.enabled" = true;
            "security.pki.crlite_mode" = 2;
            "security.insecure_connection_text.enabled" = true;
            "security.insecure_connection_text.pbmode.enabled" = true;
            "security.mixed_content.block_display_content" = true;

            "pdfjs.enableScripting" = false;

            "captivedetect.canonicalURL" = "";

            "findBar.highlightAll" = true;

            "browser.aboutConfig.showWarning" = false;

            "browser.aboutwelcome.enabled" = false;

            "browser.bookmarks.openInTabClosesMenu" = false;
            "browser.bookmarks.restore_default_bookmarks" = false;

            "browser.cache.disk.enable" = lib.mkDefault false;
            "browser.cache.disk.parent_directory" = lib.mkDefault "/run/user/${
              builtins.toString osConfig.users.users.${user}.uid
            }/firefox";
            "browser.cache.memory.enable" = lib.mkDefault false;
            "browser.cache.memory.capacity" = lib.mkDefault (-1);

            "browser.contentblocking.category" = "strict";
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

            "browser.ctrlTab.recentlyUsedOrder" = false;

            "browser.discovery.enabled" = false;

            "browser.display.os-zoom-behavior" = lib.mkDefault 0;

            "browser.download.start_downloads_in_tmp_dir" = true;
            "browser.download.always_ask_before_handling_new_types" = false;
            "browser.download.addToRecentDocs" = false;
            "browser.download.open_pdf_attachments_inline" = true;

            "browser.formfill.enable" = false;

            "browser.helperApps.deleteTempFileOnExit" = true;

            "browser.laterrun.enabled" = false;

            "browser.menu.showViewImageInfo" = true;

            "browser.newtab.url" =
              if
                (
                  (config.programs.firefox.profiles."${user}".search.default
                    or config.programs.firefox.profiles.default.search.default
                  ) == "kagi"
                )
              then
                "https://kagi.com"
              else
                "about:newtab";
            "browser.newtabpage.activity-stream.telemetry" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.feeds.snippets" = false;
            "browser.newtabpage.activity-stream.feeds.topstories" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
            "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
            "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.pinned" = false;

            "browser.preferences.moreFromMozilla" = false;

            "browser.privatebrowsing.forceMediaMemoryCache" = true;
            "browser.privatebrowsing.vpnpromourl" = "";

            "browser.protections_panel.infoMessage.seen" = true;

            "browser.quitShortcut.disabled" = true;

            "browser.safebrowsing.downloads.remote.enabled" = false;

            "browser.sessionstore.interval" = 60000;
            "browser.sessionstore.resume_from_crash" = lib.mkDefault false;

            "browser.shell.checkDefaultBrowser" = false;

            "browser.ssb.enabled" = true;

            "browser.tabs.crashReporting.sendReport" = false;
            "browser.tabs.remote.autostart.enabled" = true;
            "browser.tabs.remote.autostart.2" = true;
            "browser.tabs.remote.force-enable" = false;
            "browser.tabs.tabmanager.enabled" = false;

            "browser.toolbars.bookmarks.visibility" = "never";
            "browser.toolbars.urlbar.placeHolderName" =
              if
                (
                  (config.programs.firefox.profiles."${user}".search.default
                    or config.programs.firefox.profiles.default.search.default
                  ) == "kagi"
                )
              then
                "Kagi"
              else
                "DuckDuckGo";
            "browser.toolbars.urlbar.suggest.openpage" = false;

            "browser.uitour.enabled" = false;

            "browser.urlbar.update2.engineAliasRefresh" = true;

            "browser.urlbar.quicksuggest.enabled" = false;
            "browser.urlbar.suggest.calculator" = false;
            "browser.urlbar.suggest.unitConversion.enabled" = false;
            "browser.urlbar.suggest.trending.featureGate" = false;
            "browser.urlbar.suggest.quicksuggest.sponsored" = false;
            "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;

            "browser.xul.error_pages.expert_bad_cert" = true;

            "browser.translations.neverTranslateLanguages" = "en,es,eu";

            "breakpad.reportURL" = "";

            "dom.enable_web_task_scheduling" = true;
            "dom.private-attribution.submission.enabled" = false;
            "dom.security.sanitizer.enabled" = true;
            "dom.security.https_only_mode" = true;
            "dom.security.https_first" = true;
            "dom.security.https_first_schemeless" = true;
            "dom.security.dom.securityhttps_only_mode_ever_enabled" = true;

            "editor.truncate_user_pastes" = false;

            "signon.formlessCapture.enabled" = false;
            "signon.privateBrowsingCapture.enabled" = false;

            "extensions.autoDisableScopes" = 0;
            "extensions.enabledScopes" = 15;
            "extensions.postDownloadThirdPartyPrompt" = false;
            "extensions.getAddons.showPane.false" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "extensions.pocket.enabled" = false;

            "identity.fxaccounts.enabled" = false;

            "urlclassifier.trackingSkipURLs" = "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com";
            "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com, *.twitter.com, *.twimg.com";
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
          "application/pdf" = [ "firefox.desktop" ];
          "x-scheme-handler/http" = [ "firefox.desktop" ];
          "x-scheme-handler/https" = [ "firefox.desktop" ];
          "text/html" = [ "firefox.desktop" ];
        };
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
      };
    };
  };
}
