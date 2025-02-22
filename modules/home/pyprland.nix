{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [pyprland];

  xdg.configFile."hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = [
      "scratchpads",
      "expose",
    ]

    [scratchpads.term]
    animation = "fromTop"
    command = "kitty --class kitty-dropterm"
    class = "kitty-dropterm"
    size = "75% 60%"
    max_size = "1920px 100%"

    [scratchpads.volume]
    animation = "fromRight"
    command = "pavucontrol"
    class = "pavucontrol"
    lazy = true
    size = "40% 90%"
    max_size = "1080px 100%"
    unfocus = "hide"


    [expose]
    include_special = false

  '';
}
