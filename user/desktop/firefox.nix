{config, pkgs, nur, ...}:

{
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-wayland;

      profiles.${config.home.username} = {
        extensions.packages = with nur.repos.rycee.firefox-addons; [
          bitwarden
          clearurls
          darkreader
          facebook-container
          i-dont-care-about-cookies
          multi-account-containers
          react-devtools
          stylus
          ublock-origin
          vimium
        ];

        settings = {
          "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.uidensity" = 1;
          "devtools.theme" = "dark";
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.tabs.opentabfor.middleclick" = false;
          "browser.link.open_newwindow" = 2;
        };

        userChrome = ''
          #TabsToolbar {
            display: none !important;
          }
        '';
      };

    };
}
