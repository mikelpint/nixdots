{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:

{
  home = lib.mkIf (!(builtins.hasAttr "nixcord" inputs)) {
    packages = with pkgs; [
      legcord

      kdePackages.xwaylandvideobridge
    ];
  };

  programs = lib.mkIf (builtins.hasAttr "nixcord" inputs) {
    nixcord = {
      enable = true;

      discord = {
        package = pkgs.discord;
        branch = "stable";

        vencord = {
          enable = true;
          unstable = false;
        };

        openASAR = {
          enable = true;
        };

        autoscroll = {
          enable = false;
        };
      };

      config = {
        themeLinks = [
          "https://catppuccin.github.io/discord/dist/catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}.theme.css"
        ];

        plugins = {
          accountPanelServerProfile = {
            enable = true;
            prioritizeServerProfile = true;
          };

          alwaysTrust = {
            enable = true;
            file = true;
          };

          anonymiseFileNames = {
            enable = true;
            anonymiseByDefault = true;
            method = "timestamp";
          };

          betterGifAltText = {
            enable = true;
          };

          betterGifPicker = {
            enable = true;
          };

          betterRoleContext = {
            enable = true;
            roleIconFileFormat = "png";
          };

          betterRoleDot = {
            enable = true;
            bothStyles = true;
            copyRoleColorInProfilePopout = true;
          };

          betterSessions = {
            enable = true;
            backgroundCheck = true;
            checkInterval = 30;
          };

          betterSettings = {
            enable = true;
            disableFade = true;
            organizeMenu = true;
            eagerLoad = true;
          };

          betterUploadButton = {
            enable = true;
          };

          biggerStreamPreview = {
            enable = true;
          };

          blurNSFW = {
            enable = true;
            blurAmount = 10;
          };

          callTimer = {
            enable = true;
          };

          clearURLs = {
            enable = true;
          };

          copyEmojiMarkdown = {
            enable = true;
            copyUnicode = true;
          };

          copyFileContents = {
            enable = true;
          };

          copyUserURLs = {
            enable = true;
          };

          crashHandler = {
            enable = true;
            attemptToPreventCrashes = true;
            attemptToNavigateToHome = true;
          };

          dontRoundMyTimestamps = {
            enable = true;
          };

          experiments = {
            enable = true;
          };

          fixCodeblockGap = {
            enable = true;
          };

          fixImagesQuality = {
            enable = true;
          };

          fixSpotifyEmbeds = {
            enable = true;
            volume = 10.0;
          };

          fixYoutubeEmbeds = {
            enable = true;
          };

          forceOwnerCrown = {
            enable = true;
          };

          friendInvites = {
            enable = true;
          };

          friendsSince = {
            enable = true;
          };

          fullSearchContext = {
            enable = true;
          };

          gifPaste = {
            enable = true;
          };

          imageLink = {
            enable = false;
          };

          imageZoom = {
            enable = true;
            saveZoomValues = true;
            nearestNeighbour = true;
            square = false;
            zoom = 2.0;
            size = 100.0;
            zoomSpeed = 0.5;
          };

          memberCount = {
            enable = true;
            toolTip = true;
            memberList = true;
          };

          mentionAvatars = {
            enable = true;
            showAtSymbol = true;
          };

          messageClickActions = {
            enable = true;
            enableDeleteOnClick = false;
            enableDoubleClickToEdit = true;
            enableDoubleClickToReply = true;
            requireModifier = false;
          };

          messageLatency = {
            enable = true;
            latency = 2;
            detectDiscordKotlin = true;
            showMillis = true;
          };

          messageLinkEmbeds = {
            enable = true;
            automodEmbeds = "never";
          };

          messageLogger = {
            enable = true;
            deleteStyle = "text";
            logDeletes = true;
            collapseDeleted = true;
            logEdits = true;
            inlineEdits = true;
            ignoreBots = true;
          };

          messageTags = {
            enable = true;
            clyde = true;
          };

          moreCommands = {
            enable = true;
          };

          moreUserTags = {
            enable = true;
            dontShowForBots = true;
            dontShowBotTag = false;
            tagSettings = {
              webhook = {
                text = "Webhook";
                showInChat = true;
                showInNotChat = true;
              };

              owner = {
                text = "Owner";
                showInChat = true;
                showInNotChat = true;
              };

              administrator = {
                text = "Admin";
                showInChat = true;
                showInNotChat = true;
              };

              moderatorStaff = {
                text = "Staff";
                showInChat = true;
                showInNotChat = true;
              };

              moderator = {
                text = "Mod";
                showInChat = true;
                showInNotChat = true;
              };

              voiceModerator = {
                text = "VC Mod";
                showInChat = true;
                showInNotChat = true;
              };

              chatModerator = {
                text = "Chat Mod";
                showInChat = true;
                showInNotChat = true;
              };
            };
          };

          noDevtoolsWarning = {
            enable = true;
          };

          noF1 = {
            enable = true;
          };

          noTypingAnimation = {
            enable = true;
          };

          noUnblockToJump = {
            enable = true;
          };

          notificationVolume = {
            enable = true;
            notificationVolume = 100.0;
          };

          openInApp = {
            enable = true;
            spotify = true;
            steam = true;
            epic = false;
            tidal = true;
            itunes = false;
          };

          permissionsViewer = {
            enable = true;
            permissionsSortOrder = "highestRole";
            defaultPermissionsDropdownState = true;
          };

          pictureInPicture = {
            enable = true;
            loop = true;
          };

          pinDMs = {
            enable = true;
            pinOrder = "mostRecent";
            dmSectioncollapsed = true;
          };

          platformIndicators = {
            enable = true;
            lists = true;
            badges = true;
            messages = true;
            colorMobileIndicator = true;
          };

          previewMessage = {
            enable = true;
          };

          quickMention = {
            enable = true;
          };

          quickReply = {
            enable = true;
          };

          readAllNotificationsButton = {
            enable = true;
          };

          relationshipNotifier = {
            enable = true;
            notices = false;
            offlineRemovals = true;
            friends = true;
            friendRequestCancels = true;
            servers = true;
            groups = true;
          };

          replaceGoogleSearch = {
            enable = true;
            customEngineName = "kagi";
            customEngineURL = "https://kagi.com/search?q";
          };

          replyTimestamp = {
            enable = true;
          };

          revealAllSpoilers = {
            enable = true;
          };

          sendTimestamps = {
            enable = true;
            replaceMessageContents = true;
          };

          serverInfo = {
            enable = true;
          };

          serverListIndicators = {
            enable = true;
            mode = "both";
          };

          shikiCodeblocks = {
            enable = true;
            tryHljs = "SECONDARY";
            useDevIcon = "GREYSCALE";
            bgOpacity = 100.0;
          };

          showAllMessageButtons = {
            enable = true;
          };

          showConnections = {
            enable = true;
            iconSize = 32;
            iconSpacing = "cozy";
          };

          showMeYourName = {
            enable = true;
            mode = "nick-user";
          };

          showTimeoutDuration = {
            enable = true;
            displayStyle = "ssalggnikool";
          };

          silentTyping = {
            enable = true;
            showIcon = false;
            contextMenu = true;
          };

          sortFriendRequests = {
            enable = true;
            showDates = true;
          };

          spotifyControls = {
            enable = true;
            hoverControls = true;
            useSpotifyUris = false;
          };

          spotifyCrack = {
            enable = true;
            noSpotifyAutoPause = true;
          };

          spotifyShareCommands = {
            enable = true;
          };

          stickerPaste = {
            enable = true;
          };

          streamerModeOnStream = {
            enable = true;
          };

          superReactionTweaks = {
            enable = true;
            superReactByDefault = true;
            superReactionPlayingLimit = 20;
          };

          themeAttributes = {
            enable = true;
          };

          typingIndicator = {
            enable = true;
            includeCurrentChannel = true;
            includeMutedChannels = true;
            includeBlockedUsers = true;
            indicatorMode = "both";
          };

          typingTweaks = {
            enable = true;
            showAvatars = true;
            showRoleColors = true;
            alternativeFormatting = true;
          };

          unindent = {
            enable = true;
          };

          unlockedAvatarZoom = {
            enable = true;
            zoomMultiplier = 4;
          };

          unsuppressEmbeds = {
            enable = true;
          };

          userVoiceShow = {
            enable = true;
            showInUserProfileModal = true;
            showInMemberList = true;
            showInMessages = true;
          };

          USRBG = {
            enable = true;
            nitroFirst = true;
            voiceBackground = true;
          };

          validReply = {
            enable = true;
          };

          validUser = {
            enable = true;
          };

          vencordToolbox = {
            enable = true;
          };

          viewIcons = {
            enable = true;
            format = "png";
            imgSize = 1024;
          };

          viewRaw = {
            enable = true;
            clickMethod = "Left";
          };

          voiceDownload = {
            enable = true;
          };

          voiceMessages = {
            enable = true;
            noiseSuppression = true;
            echoCancellation = true;
          };

          volumeBooster = {
            enable = true;
            multiplier = 2;
          };

          whoReacted = {
            enable = true;
          };

          youtubeAdblock = {
            enable = true;
          };
        };

        frameless = true;
        transparent = true;
        disableMinSize = true;
      };
    };
  };
}
