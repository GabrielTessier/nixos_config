{ config, pkgs, lib, ... }:

let
  # --- Bibliothèque partagée ---
  ribbonLib = ''
    STATE_FILE="/tmp/hypr_ribbon_state"

    current_ws() {
      ${pkgs.hyprland}/bin/hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq '.id'
    }

    ws_to_ribbon() {
      echo $(( ($1 - 1) / 10 ))
    }

    ws_to_local() {
      echo $(( ($1 - 1) % 10 + 1 ))
    }

    save_position() {
      local ribbon=$1 local_ws=$2
      touch "$STATE_FILE"
      if grep -q "^''${ribbon}=" "$STATE_FILE" 2>/dev/null; then
        ${pkgs.gnused}/bin/sed -i "s/^''${ribbon}=.*/''${ribbon}=''${local_ws}/" "$STATE_FILE"
      else
        echo "''${ribbon}=''${local_ws}" >> "$STATE_FILE"
      fi
    }

    saved_position() {
      local ribbon=$1
      local val
      val=$(grep "^''${ribbon}=" "$STATE_FILE" 2>/dev/null | cut -d= -f2)
      echo "''${val:-1}"
    }
  '';

  # --- Script : changer de workspace dans le ruban courant ---
  workspaceRibbon = pkgs.writeShellApplication {
    name = "workspace-ribbon";
    runtimeInputs = [ pkgs.jq pkgs.gnused pkgs.hyprland ];
    text = ''
      ${ribbonLib}

      LOCAL=$1
      MODE=''${2:-switch}   # "switch" par défaut, ou "move"

      if [ "$LOCAL" -gt 9 ] || [ "$LOCAL" -lt 1 ]; then
        echo "workspace 1-9"
        exit 1
      fi

      CUR_WS=$(current_ws)
      RIBBON=$(ws_to_ribbon "$CUR_WS")
      TARGET=$(( RIBBON * 10 + LOCAL ))

      case "$MODE" in
           move)   ${pkgs.hyprland}/bin/hyprctl dispatch movetoworkspace "$TARGET" ;;
           switch) ${pkgs.hyprland}/bin/hyprctl dispatch workspace "$TARGET"       ;;
           *)      echo "invalide param"; exit 1 ;;
      esac

      save_position "$RIBBON" "$LOCAL"
    '';
  };

  # --- Script : changer de ruban ---
  switchRibbon = pkgs.writeShellApplication {
    name = "switch-ribbon";
    runtimeInputs = [ pkgs.jq pkgs.gnused pkgs.hyprland ];
    text = ''
      ${ribbonLib}

      CUR_WS=$(current_ws)
      CUR_RIBBON=$(ws_to_ribbon "$CUR_WS")
      CUR_LOCAL=$(ws_to_local "$CUR_WS")

      save_position "$CUR_RIBBON" "$CUR_LOCAL"

      case "$1" in
        next) NEW_RIBBON=$(( CUR_RIBBON + 1 )) ;;
        prev) NEW_RIBBON=$(( CUR_RIBBON > 0 ? CUR_RIBBON - 1 : 0 )) ;;
        *)    NEW_RIBBON=$1 ;;
      esac

      SAVED=$(saved_position "$NEW_RIBBON")
      TARGET=$(( NEW_RIBBON * 10 + SAVED ))

      ${pkgs.hyprland}/bin/hyprctl dispatch workspace "$TARGET"
    '';
  };

  # --- Script : daemon qui sauvegarde la position à chaque changement de workspace ---
  saveWsListener = pkgs.writeShellApplication {
    name = "save-ws-listener";
    runtimeInputs = [ pkgs.socat pkgs.gnused pkgs.hyprland ];
    text = ''
      ${ribbonLib}

      SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

      ${pkgs.socat}/bin/socat -u "UNIX-CONNECT:$SOCK" - | while IFS= read -r line; do
        if [[ "$line" == "workspace>>"* ]]; then
          WS_ID="''${line#workspace>>}"
          RIBBON=$(ws_to_ribbon "$WS_ID")
          LOCAL=$(ws_to_local "$WS_ID")
          save_position "$RIBBON" "$LOCAL"
        fi
      done
    '';
  };

in {
  config = lib.mkIf config.userSettings.hyprland.enable {
    # Rend les scripts disponibles dans le PATH
    home.packages = [ workspaceRibbon switchRibbon saveWsListener ];

    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [ "save-ws-listener" ];
        bind =
          # Super + 1..9 -> workspace dans le ruban courant
          builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mainMod, code:1${toString i}, exec, workspace-ribbon ${toString ws}"
              "$mainMod SHIFT, code:1${toString i}, exec, workspace-ribbon ${toString ws} move"
              "$mainMod, F${toString ws}, exec, switch-ribbon ${toString i}"
            ]
          ) 9)
          ++
          [
            # Switch workspace
	          #"$mainMod, Tab, workspace, m+1"
	          #"$mainMod SHIFT, Tab, workspace, m-1"

            # Navigation entre rubans
            "$mainMod ALT, right, exec, switch-ribbon next"
            "$mainMod ALT, left,  exec, switch-ribbon prev"
          ];
      };
    };
  };
}
