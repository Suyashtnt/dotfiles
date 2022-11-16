{...}: ''
  /* Linux & macOS specific styles */
  @media (-moz-gtk-csd-available), (-moz-mac-big-sur-theme: 0), (-moz-mac-big-sur-theme: 1) {
      #TabsToolbar:not([customizing="true"]) {
            visibility: collapse !important;
        }

      #toolbar-menubar {
            padding-top: 0px !important;
        }

      #TabsToolbar:not([customizing="true"]) {
            visibility: collapse !important;
        }

      #toolbar-menubar {
            padding-top: 0px !important;
        }

      #nav-bar {
            padding-left: 80px;
        }

      #TabsToolbar .titlebar-buttonbox-container {
            visibility: visible !important;
            position: absolute;
            top: 12px;
            left: 0px;
        }

      .titlebar-buttonbox-container {
            display: block;
        }

      .titlebar-button > .toolbarbutton-icon {
            height: 13x !important;
            min-height: 13px !important;
            width: 13px !important;
            min-width: 13px !important;
        }

      .titlebar-button {
            padding-left: 6px !important;
            padding-right: 6px !important;
            padding-top: 6px !important;
        }

      .titlebar-placeholder[type="pre-tabs"] {
            width: 120px !important;
        }

      .titlebar-buttonbox-container {
            -moz-box-ordinal-group: 0;
        }
  }


  /* Windows specific styles */
  @media (-moz-platform: windows-win10) {
      /* Hide main tabs toolbar */
      :root[tabsintitlebar]{
            --uc-window-control-width: 138px; /* Space at the right of nav-bar for window controls */
            /* --uc-window-drag-space-width: 24px; */  /* To add extra window drag space in nav-bar */
        }

      #nav-bar{
            border-inline: var(--uc-window-drag-space-width,0px) solid var(--toolbar-bgcolor) ;
            border-inline-style: solid !important;
            border-right-width: calc(var(--uc-window-control-width,0px) + var(--uc-window-drag-space-width,0px));

            padding-top: 0px !important;
            margin-left: -80px; /* Removes the space left when hiding .titlebar-buttonbox-container */
        }

      :root {
            --uc-toolbar-height: 32px;
            --chrome-content-separator-color: none !important;
        }

      :root:not([uidensity="compact"]) {
            --uc-toolbar-height: 38px;
        }

      #TabsToolbar {
            visibility: collapse !important;
        }
      /* Hide the Windows controls on the left side. */
      #TabsToolbar .titlebar-buttonbox-container {
            visibility: hidden !important;
        }
      /* Line up the Windows controls with the rest of the icons in the toolbar. */
      .titlebar-buttonbox-container {
            margin-top: 7px;
        }
      :root:not([inFullscreen]) #nav-bar {
            margin-top: calc(0px - var(--uc-toolbar-height));
        }

      #toolbar-menubar {
            min-height: unset !important;
            height: var(--uc-toolbar-height) !important;
            position: relative;
        }

      #main-menubar {
            -moz-box-flex: 1;
            background-color: var(--toolbar-bgcolor,--toolbar-non-lwt-bgcolor);
            background-clip: padding-box;
            border-right: 30px solid transparent;
            border-image: linear-gradient(to left, transparent, var(--toolbar-bgcolor,--toolbar-non-lwt-bgcolor) 30px) 20 / 30px;
        }

      #toolbar-menubar:not([inactive]) {
            z-index: 2;
        }

      #toolbar-menubar[inactive] > #menubar-items {
            opacity: 0;
            pointer-events: none;
            margin-left: var(--uc-window-drag-space-width,0px);
        }

      :root[inFullscreen] #nav-bar {
            border-inline: none !important;
        }
  }


  /* General styles */
  #browser {
      position: relative;
  }

  #sidebar-box[sidebarcommand*="tabcenter"] {
      z-index: 1;
  }

  #sidebar-box[sidebarcommand*="tabcenter"] #sidebar-header {
      visibility: collapse;
      display: none;
  }

  #sidebar-box[sidebarcommand*="tabcenter"]:not([hidden]) {
      display: block;
      position: absolute;
      min-width: 48px;
      max-width: 48px;
      overflow: hidden;
      transition: all 0.2s ease;
      border-right: 1px solid var(--sidebar-border-color);
      z-index: 1;
      top: 0;
      bottom: 0;
  }

  [sidebarcommand*="tabcenter"] #sidebar,
  #sidebar-box[sidebarcommand*="tabcenter"]:hover {
      min-width: 10vw !important;
      width: 30vw !important;
      max-width: 200px !important;
      z-index: 10 !important;
  }

  @media (width >= 1200px) {
      [sidebarcommand*="tabcenter"] #sidebar,
      #sidebar-box[sidebarcommand*="tabcenter"]:hover {
          max-width: 250px !important;
      }
  }

  [sidebarcommand*="tabcenter"] ~ #sidebar-splitter {
      display: none;
  }

  [sidebarcommand*="tabcenter"] #sidebar {
      max-height: 100%;
      height: 100%;
  }

  #sidebar-box[sidebarcommand*="tabcenter"]:not([hidden]) ~ #appcontent {
      margin-left: 48px;
  }

  #main-window[inFullscreen][inDOMFullscreen] #appcontent {
      margin-left: 0;
  }

  #main-window[inFullscreen] #sidebar {
      height: 100vh;
  }

  [sidebarcommand*="tabcenter"] #sidebar-header {
      background: #0C0C0D;
      border-bottom: none !important;
  }

  [sidebarcommand*="tabcenter"] ~ #sidebar-splitter {
      border-right-color: #0C0C0D !important;
      border-left-color: #0C0C0D !important;
  }

  [sidebarcommand*="tabcenter"] #sidebar-switcher-target,
  [sidebarcommand*="tabcenter"] #sidebar-close {
      filter: invert(100%);
  }

  @media (max-width: 630px) {
      #urlbar-container {
          min-width: 100% !important;
      }
      #menubar-items {
          display: none !important;
      }
  }

  :root, window, page, dialog, wizard, toolbar, .cui-widget-panel, #widget-overflow {
  	font-family: "Inter";
  	letter-spacing: .01rem;
  }

  :root, vbox, scrollbox {
  	scrollbar-color: hsla(0, 0%, 100%, 0.1) transparent !important;
  	scrollbar-width: thin !important;
  }

  :root {
  	--acrylic-backdrop-filter: blur(10px);
  	--acrylic-background-blend-mode: exclusion;
  	--acrylic-background-image: url("chrome://global/skin/media/imagedoc-lightnoise.png");
  }


  .panel-arrowbox[part=arrowbox] {
  	z-index: 999;
  }

  scrollbox {
  	scroll-behavior: smooth;
  	overflow-y: auto;
  }

  .scrollbutton-up[orient=vertical],
  .scrollbutton-down[orient=vertical] {
  	visibility: collapse !important;
  }

  scrollbar {
  	scrollbar-color: hsla(0, 0%, 33%, 0.5) hsla(0, 0%, 0%, 0) !important;
  	scrollbar-width: thin !important;
  	background-color: hsla(0, 0%, 0%, 0.1);
  	backdrop-filter: var(--acrylic-backdrop-filter) !important;
  }

  /*
  			TREE STYLE TABS - START
  */

  /* Reduce minimum width of the sidebar */
  #sidebar {
    min-width: 100px !important;
  }

  /* Hide sidebar header when using Tree Style Tab. */
  #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
  	visibility: collapse;
  }

  /*
  			TREE STYLE TABS - END
  */



  /*
  			REMOVE TAB BAR - START
  */

  #navigator-toolbox {
  	position: relative !important;
  }

  :root[sizemode="maximized"][tabsintitlebar="true"] #navigator-toolbox {
  	margin-top: 8px;
  }

  #toolbar-menubar,
  #TabsToolbar > :not(.titlebar-buttonbox-container):not(.private-browsing-indicator) {
  	visibility: collapse !important;
  }

  .private-browsing-indicator {
  	background-size: 69%;
  	margin-inline-end: 6px;
  	opacity: 0.7;
  }

  /* Workaround v2 (Since #nav-bar is bad at laying out children (it doesnt respect ::after's width on small window widths), just make it get out of the way)*/


  #titlebar {
  	-moz-appearance: none !important;
  	position: absolute !important;
  	inset: 2px;
  	display: flex !important;
  	align-items: center;
  	justify-content: end;
  	padding: 0 !important;

  	pointer-events: none;
  }

  #titlebar > * {
  	pointer-events: auto;
  }

  .titlebar-button {
      padding: 8px 13px !important;
  }


  /*
  			REMOVE TAB BAR - END
  */

  #navigator-toolbox:-moz-lwtheme {
  	--tabs-border-color: rgba(0,0,0,.1) !important;
  }

  #nav-bar {
  	padding: 2px !important;
  	font-size: 16px !important;
  }
  #nav-bar-customization-target {
  	padding-left: 5px !important;
  }

  #back-button,
  #forward-button {
  	padding: 0 !important;
  }
  #back-button > .toolbarbutton-icon {
  	list-style-image: url("img/back.svg") !important;
  }
  #forward-button > .toolbarbutton-icon {
  	list-style-image: url("img/forward.svg") !important;
  }
  #reload-button > .toolbarbutton-icon {
  	list-style-image: url("img/reload.svg") !important;
  }
  #history-panelmenu {
  	list-style-image: url("img/history.svg") !important;
  }
  #downloads-indicator-icon {
  	list-style-image: url("img/downloads.svg") !important;
  }
  #bookmarks-menu-button > .toolbarbutton-icon {
  	list-style-image: url("img/bookmarks.svg") !important;
  }
  #nav-bar-overflow-button > .toolbarbutton-icon {
  	list-style-image: url("img/overflow.svg") !important;
  }
  #PanelUI-menu-button {
  	list-style-image: url("img/menu.svg") !important;
  }

  #urlbar,
  /* #searchbar {
  	--urlbar-background: #272735;
  } */
  /* :root[lwthemetextcolor="bright"] #urlbar,
  :root[lwthemetextcolor="bright"] #searchbar {
  	--urlbar-background: hsla(0, 0%, 12%, 0.9);
  } */
  #urlbar,
  #searchbar {
  	--urlbar-height: var(--urlbar-height, 30px); /* The browser should take care of this, but just incase, this is the default */
  	--urlbar-toolbar-height: var(--urlbar-container-height) !important;
      color: #ECCECE !important;
  }

  #searchbar {
  	background: none !important;
  	border: none !important;
  	position: relative;
  	box-shadow: none !important;
      border-radius: 8px !important;
  }

  #searchbar > * {
      position: relative !important;
  }

  #searchbar::before {
      content: "";
  	position: absolute !important;
      display: block;
      inset: 0;
      border-radius: 3px;
  }

  #urlbar > #urlbar-background,
  #searchbar::before {
  	/* background: var(--urlbar-background) !important; */
  	box-shadow: 0 0 0 transparent, 0 0 0 var(--shadow-color) !important;
  	--shadow-color: hsla(0, 0%, 0%, 0);
  	--toolbarbutton-border-radius: 3px;
  	transition: border-color .15s ease, box-shadow .15s ease;
  	animation-duration: 150ms !important;
      border-radius: 8px !important;

  }

  #urlbar[open] > #urlbar-background {
  	box-shadow: 0 3px 5px var(--shadow-color), 0 10px 19px 4px var(--shadow-color) !important;
  	backdrop-filter: var(--acrylic-backdrop-filter) !important;
  	--shadow-color: hsla(0, 0%, 0%, .1);
      border-radius: 8px !important;

  }

  #urlbar-input-container,
  #searchbar {
  	--padding-inline: 14px;
  	padding-inline: var(--padding-inline) !important;
  }

  #urlbar[breakout][breakout-extend] > #urlbar-input-container {
  	padding-inline: calc(var(--padding-inline) + 5px) !important;
  }

  :root {
  	--urlbar-icon-size: 14px !important;
  	--urlbar-icon-padding: 4px !important;
  	--identity-box-margin-inline: 8px !important;
  }

  .sharing-icon,
  #identity-icon,
  #permissions-granted-icon,
  #tracking-protection-icon,
  .notification-anchor-icon,
  #blocked-permissions-container > .blocked-permission-icon,
  #tracking-protection-icon-box,
  .searchbar-search-icon {
  	width: var(--urlbar-icon-size) !important;
  	height: unset !important;
  	aspect-ratio: 1;
  }

  .searchbar-search-button[addengines="true"] > .searchbar-search-icon-overlay {
  	width: 9px !important;
  	height: unset !important;
  	aspect-ratio: 1;
  	margin: -4px 0 0 -13px !important;
  }

  .urlbar-icon {
      width: calc(14px + 2 * var(--urlbar-icon-padding)) !important;
      height: 100% !important;
  }

  #urlbar #star-button {
      list-style-image: url("chrome://browser/skin/bookmark-hollow.svg") !important;
  }
  .urlbarView-row-inner {
      padding-inline-start: calc(var(--urlbar-icon-size) + 2 * var(--urlbar-icon-padding) + var(--identity-box-margin-inline) - 15px) !important;
      border-radius: 4px !important;
  }

  .searchbar-search-button {
  	margin-inline-end: var(--identity-box-margin-inline);
  }

  .searchbar-search-icon {
  	margin: 0 !important;
  }

  #PopupSearchAutoComplete {
  	margin-top: 6px !important;
  	padding: 10px !important;
  	box-shadow: inset 0 12px 11px -5px #00000030 !important;
  }
  .search-panel-current-engine {
  	padding-bottom: 10px !important;
  }
  .search-panel-tree {
  	display: grid !important;
  	gap: 10px !important;
  	padding: 10px 0 !important;
  }
  .search-one-offs {
  	padding-top: 5px !important;
  }
  .search-panel-header {
  	padding-bottom: 5px !important;
  }
  .search-panel-container {
  	padding-bottom: 8px !important;
  }

  .bookmark-item > .menu-text,
  .bookmark-item > .menu-iconic-text {
  	margin-inline-start: 10px !important;
  }
  .titlebar-min {display:none!important;}
  .titlebar-max {display:none!important;}
  .titlebar-restore {display:none!important;}
  .titlebar-close {display:none!important;}
  #bookmarksPanel{
      background-color: #00000020;
  }
  #sidebar-header{
      padding: 6px !important;
      margin: 6px !important;
      background-color: #00000010 !important;
      font-family: Inter !important;
      border-radius: 5px !important;
  	box-shadow: 0 3px 5px var(--shadow-color) !important;
  }
  #sidebar>*{
      background-color: #00000010 !important;
  }
  #urlbar,
  #urlbar * {

      outline: none !important;
      box-shadow: none !important;

  }
  @media (prefers-color-scheme: dark) { :root {

      --window-colour:                     #1E2021;
      --secondary-colour:                  #191B1C;
      --inverted-colour:                   #FAFAFC;

      /* Containter Tab Colours */
      --uc-identity-colour-blue:            #7ED6DF;
      --uc-identity-colour-turquoise:       #55E6C1;
      --uc-identity-colour-green:           #B8E994;
      --uc-identity-colour-yellow:          #F7D794;
      --uc-identity-colour-orange:          #F19066;
      --uc-identity-colour-red:             #FC5C65;
      --uc-identity-colour-pink:            #F78FB3;
      --uc-identity-colour-purple:          #786FA6;

      --uc-identity-colour-blue-muted:      #7ED6DF99;
      --uc-identity-colour-turquoise-muted: #55E6C199;
      --uc-identity-colour-green-muted:     #B8E99499;
      --uc-identity-colour-yellow-muted:    #F7D794CC;
      --uc-identity-colour-orange-muted:    #F19066FF;
      --uc-identity-colour-red-muted:       #FC5C65FF;
      --uc-identity-colour-pink-muted:      #F78FB399;
      --uc-identity-colour-purple-muted:    #786FA6FF;

  }}

  :root {

      /* URL colour in URL bar suggestions */
      --urlbar-popup-url-color: var(--uc-identity-colour-blue) !important;


      /*---+---+---+---+---+---+---+
       | V | I | S | U | A | L | S |
       +---+---+---+---+---+---+---*/

      /* global border radius */
      --uc-border-radius: 0;

      /* dynamic url bar width settings */
      --uc-urlbar-width: clamp(200px, 40vw, 500px);

      /* dynamic tab width settings */
      --uc-active-tab-width:   clamp(100px, 20vw, 300px);
      --uc-inactive-tab-width: clamp( 50px, 15vw, 200px);

      /* if active always shows the tab close button */
      --show-tab-close-button: none; /* DEFAULT: -moz-inline-box; */

      /* if active only shows the tab close button on hover*/
      --show-tab-close-button-hover: none; /* DEFAULT: -moz-inline-box; */

      /* adds left and right margin to the container-tabs indicator */
      --container-tabs-indicator-margin: 10px;

  }
  :root {

      --uc-theme-colour:                          var(--window-colour,    var(--toolbar-bgcolor));
      --uc-hover-colour:                          var(--secondary-colour, rgba(0, 0, 0, 0.2));
      --uc-inverted-colour:                       var(--inverted-colour,  var(--toolbar-color));

      --button-bgcolor:                           var(--uc-theme-colour)    !important;
      --button-hover-bgcolor:                     var(--uc-hover-colour)    !important;
      --button-active-bgcolor:                    var(--uc-hover-colour)    !important;

      --toolbarbutton-border-radius:              var(--uc-border-radius)   !important;

      --tab-border-radius:                        var(--uc-border-radius)   !important;
      --lwt-text-color:                           var(--uc-inverted-colour) !important;
      --lwt-tab-text:                             var(--uc-inverted-colour) !important;

      --arrowpanel-border-radius:                 var(--uc-border-radius)   !important;

      --tab-block-margin: 2px !important;

  }

  /* container tabs indicator */
  .tabbrowser-tab[usercontextid]
      > .tab-stack
      > .tab-background
      > .tab-context-line {

          margin: -1px var(--container-tabs-indicator-margin) 0 var(--container-tabs-indicator-margin) !important;
          height: 1px !important;
          border-radius: var(--tab-border-radius) !important;
          box-shadow: 0 1px 10px 1px var(--uc-identity-gradient-colour) !important;

  }
  /* style and position speaker icon */
  .tab-icon-overlay:not([sharing], [crashed]):is([soundplaying], [muted], [activemedia-blocked]) {

      stroke: transparent !important;
      background: transparent !important;
      opacity: 1 !important; fill-opacity: 0.8 !important;

      color: currentColor !important;

      stroke: var(--uc-theme-colour) !important;
      background-color: var(--uc-theme-colour) !important;

    }


    /* change the colours of the speaker icon on active tab to match tab colours */
    .tabbrowser-tab[selected] .tab-icon-overlay:not([sharing], [crashed]):is([soundplaying], [muted], [activemedia-blocked]) {

      stroke: var(--uc-hover-colour) !important;
      background-color: var(--uc-hover-colour) !important;

    }

  #urlbar{
      min-width: none !important;
      border: none !important;
      outline: none !important;
  }

  /* nav-bar-customization-target */
''
