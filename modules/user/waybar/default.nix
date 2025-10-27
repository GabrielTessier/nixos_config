{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.userSettings.waybar;
in
{
  options = {
    userSettings.waybar = {
      enable = lib.mkEnableOption "Enable waybar";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      style = ./style.css;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          margin = "9 5 0 10";
          
          modules-left = ["hyprland/workspaces" "hyprland/language" "keyboard-state" "hyprland/submap" ];
          modules-center = ["clock" ];
          modules-right = [ "pulseaudio" "bluetooth" "custom/mem" "cpu" "backlight" "battery" "tray" "custom/notification"];

          "hyprland/workspaces" = {
            disable-scroll = true;
          };

          "hyprland/language" = {
            format-en = "US";
	          format-fr = "FR";
            format-ru = "RU";
	          min-length = 5;
	          tooltip = false;
          };

          "keyboard-state" = {
            #numlock = true;
            capslock = true;
            format = "{icon} ";
            format-icons = {
              locked = " ";
              unlocked = "";
            };
          };

          "clock" = {
	          format = "{:L%H:%M - %a}  ";
	          format-alt = "{:L%A, %d %B %Y (%R)}  ";
            timezone = "Europe/Paris";
	          locale = "fr_FR.UTF-8";
	          tooltip-format = "<tt><big>{calendar}</big></tt>";
	          calendar = {
		          mode           = "year";
		          mode-mon-col   = 3;
		          weeks-pos      = "right";
		          on-scroll      = 1;
		          on-click-right = "mode";
		          format = {
			          months   = "<span color='#ffead3'><b>{}</b></span>";
			          days     = "<span color='#ecc6d9'><b>{}</b></span>";
			          weeks    = "<span color='#99ffdd'><b>S{}</b></span>";
			          weekdays = "<span color='#ffcc66'><b>{}</b></span>";
			          today    = "<span color='#ff6699'><b><u>{}</u></b></span>";
		          };
	          };
	          actions = {
		          on-click-right = "mode";
		          #//"on-click-forward": "tz_up",
		          #//"on-click-backward": "tz_down",
		          on-scroll-up   = "shift_up";
		          on-scroll-down = "shift_down";
	          };
          };

	        # SwayNC
	        "custom/notification" = {
	          tooltip-format = "Left: Notifications\nRight: Do not disturb";
		        format = "{icon}";
		        format-icons = {
		          notification = "<span foreground='red'><sup></sup></span>";
			        none = "";
			        dnd-notification = "<span foreground='red'><sup></sup></span>";
			        dnd-none = "";
			        inhibited-notification = "<span foreground='red'><sup></sup></span>";
			        inhibited-none = "";
			        dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
			        dnd-inhibited-none = "";
		        };
		        return-type = "json";
		        exec-if = "which swaync-client";
		        exec = "swaync-client -swb";
		        on-click = "swaync-client -t -sw";
		        on-click-right = "swaync-client -d -sw";
		        escape = true;
	        };

          "custom/weather" = {
            format = "{}";
            tooltip = true;
            interval = 1800;
            exec = "curl -s 'wttr.in/Grenoble?format=%c%t'";
            #return-type = "json";
          };

          "pulseaudio" = {
            # scroll-step = 1; # %, can be a float
            reverse-scrolling = 1;
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon}  {format_source}";
            format-bluetooth-muted = " {icon}  {format_source}";
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            on-click = "pavucontrol";
            min-length = 13;
          };

          "custom/mem" = {
            format = "{} ";
            interval = 3;
            exec = "free -h | awk '/Mem:/{printf $3}'";
            tooltip = false;
          };

          "cpu" = {
            interval = 2;
            format = "{usage}% ";
            min-length = 6;
          };

          "temperature" = {
            # thermal-zone = 2;
            # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
            critical-threshold = 80;
            # format-critical = "{temperatureC}°C {icon}";
            format = "{temperatureC}°C {icon}";
            format-icons = ["" "" "" "" ""];
            tooltip = false;
          };

          "backlight" = {
            device = "intel_backlight";
            format = "{percent}% {icon}";
            format-icons = [""];
            min-length = 7;
          };

          "battery" = {
            states = {
	            good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = " {capacity}%";
            format-alt = "{time} {icon}";
            format-icons = ["" "" "" "" ""];
          };

	        "bluetooth" = {
	          format = " {status}";
	          format-disabled = "";
	          format-off = "";
	          interval = 30;
	          on-click = "blueman-manager";
	          format-no-controller = "";
	        };

          tray = {
            icon-size = 16;
            spacing = 10;
          };
        };
      };
    };
  };
}
