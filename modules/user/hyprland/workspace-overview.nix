{ config, pkgs, lib, ... }:

let
  shell = ''
  import Quickshell
  import Quickshell.Io
  import Quickshell.Wayland
  import Quickshell.Hyprland
  import QtQuick
  import QtQuick.Layouts

  ShellRoot {
      id: root

      property int maxRibbons:  9
      property int wsPerRibbon: 9
      property int previewW:    180
      property int previewH:    100

      // Lecture du fichier d'état des rubans
      FileView {
          id: ribbonStateFile
          path: "/tmp/hypr_ribbon_state"
          watchChanges: true
      }

      // Retourne le wsId global sauvegardé pour un ruban donné
      // Ex: "0=2" -> ribbonIdx=0 -> wsId=2 ; "1=1" -> ribbonIdx=1 -> wsId=11
      function savedWsForRibbon(ribbonIdx) {
          var lines = (ribbonStateFile.text() ?? "").split("\n")
          for (var i = 0; i < lines.length; i++) {
              var parts = lines[i].split("=")
              if (parts.length === 2 && parseInt(parts[0]) === ribbonIdx) {
                  return ribbonIdx * 10 + parseInt(parts[1])
              }
          }
          //return ribbonIdx * 10 + 1  // fallback : premier workspace du ruban
          return -1;                   // fallback : pas le workspace par default
      }

      IpcHandler {
          target: "overlay"
          function toggle(): void {
              if (overlayLoader.active) {
                  overlayLoader.active = false
              } else {
                  ribbonStateFile.reload()
                  overlayLoader.active = true
              }
          }
      }

      LazyLoader {
          id: overlayLoader
          active: false

          PanelWindow {
              color: "transparent"
              WlrLayershell.layer:          WlrLayer.Overlay
              WlrLayershell.keyboardFocus:  WlrKeyboardFocus.Exclusive
              anchors { top: true; bottom: true; left: true; right: true }

              Item {
                  anchors.fill: parent
                  focus:        true

                  // Rafraichir les données IPC à l'ouverture
                  Component.onCompleted: {
                      forceActiveFocus()
                      Hyprland.refreshToplevels()
                  }

                  Keys.onEscapePressed: overlayLoader.active = false

                  MouseArea {
                      anchors.fill: parent
                      onClicked:    overlayLoader.active = false

                      Rectangle {
                          anchors.centerIn: parent
                          color:   "#EE1e2030"
                          radius:  14
                          implicitWidth:  grid.implicitWidth  + 48
                          implicitHeight: grid.implicitHeight + 48

                          MouseArea { anchors.fill: parent }

                          ColumnLayout {
                              id: grid
                              anchors.centerIn: parent
                              spacing: 12

                              Text {
                                  Layout.alignment: Qt.AlignHCenter
                                  text:            "Workspaces"
                                  color:           "#c0caf5"
                                  font.pixelSize:  16
                                  font.bold:       true
                              }

                              Repeater {
                                  model: root.maxRibbons

                                  RowLayout {
                                      id:   ribbonRow
                                      property int  ribbonIdx:       index
                                      property int  focusedId:       Hyprland.focusedWorkspace?.id ?? 1
                                      property int  activeRibbon:    Math.floor((focusedId - 1) / 10)
                                      property bool isCurrentRibbon: ribbonIdx === activeRibbon
                                      spacing: 8

                                      // Label ruban
                                      Rectangle {
                                          implicitWidth:  28
                                          implicitHeight: root.previewH
                                          radius:         6
                                          color: ribbonRow.isCurrentRibbon ? "#7aa2f7" : "transparent"

                                          Text {
                                              anchors.centerIn: parent
                                              text:      "R" + (ribbonRow.ribbonIdx + 1)
                                              color:     ribbonRow.isCurrentRibbon ? "#1a1b26" : "#565f89"
                                              font.pixelSize: 11
                                              font.bold: ribbonRow.isCurrentRibbon
                                          }
                                      }

                                      Rectangle {
                                          implicitWidth:  1
                                          implicitHeight: root.previewH
                                          color: "#2a2b3d"
                                      }

                                      // Previews des workspaces
                                      Repeater {
                                          model: root.wsPerRibbon

                                          WorkspacePreview {
                                              wsId:           ribbonRow.ribbonIdx * 10 + (index + 1)
                                              isActive:       wsId === ribbonRow.focusedId
                                              isCurrentRibbon: ribbonRow.isCurrentRibbon
                                              isSaved:        wsId === root.savedWsForRibbon(ribbonRow.ribbonIdx)
                                              implicitWidth:  root.previewW
                                              implicitHeight: root.previewH

                                              MouseArea {
                                                  anchors.fill: parent
                                                  onClicked: {
                                                      Hyprland.dispatch("workspace " + parent.wsId)
                                                      overlayLoader.active = false
                                                  }
                                              }
                                          }
                                      }
                                  }
                              }
                          }
                      }
                  }
              }
          }
      }
  }
  '';
  preview = ''
  import Quickshell
  import Quickshell.Wayland
  import Quickshell.Hyprland
  import QtQuick

  Rectangle {
      id: root

      property int  wsId:            0
      property bool isActive:        false
      property bool isCurrentRibbon: false
      property bool isSaved:         false

      property var hyprWorkspace: {
          for (let ws of Hyprland.workspaces.values) {
              if (ws.id === root.wsId) return ws
          }
          return null
      }

      property var wsToplevels: hyprWorkspace?.toplevels?.values ?? []

      property var wsMonitor: hyprWorkspace?.monitor ?? Hyprland.focusedMonitor

      property real monitorX: wsMonitor?.x      ?? 0
      property real monitorY: wsMonitor?.y      ?? 0
      property real monitorW: wsMonitor?.width  ?? 1920
      property real monitorH: wsMonitor?.height ?? 1080
      property real sx: width  / monitorW
      property real sy: height / monitorH

      clip:         true
      radius:       7
      color:        "#0f1017"
      border.color: isActive ? "#7aa2f7" : (isSaved ? "#e0af68" : (isCurrentRibbon ? "#3b3d5c" : "transparent"))
      border.width: (isActive || isSaved) ? 2 : 1

      Repeater {
          model: root.wsToplevels

          Item {
              required property var modelData

              property var ipc: modelData.lastIpcObject

              x:      ((ipc?.at?.[0]   ?? 0) - root.monitorX) * root.sx
              y:      ((ipc?.at?.[1]   ?? 0) - root.monitorY) * root.sy
              width:  (ipc?.size?.[0]  ?? root.width)          * root.sx
              height: (ipc?.size?.[1]  ?? root.height)         * root.sy
              clip:   true

              ScreencopyView {
                  anchors.fill:   parent
                  captureSource:  modelData.wayland
                  live:           false
                  constraintSize: Qt.size(parent.width, parent.height)
              }
          }
      }

      Text {
          anchors.centerIn: parent
          visible:          root.wsToplevels.length === 0
          text:             root.wsId % 10 || 10
          color:            root.isActive ? "#7aa2f7" : "#3b3d5c"
          font.pixelSize:   22
          font.bold:        true
      }

      Rectangle {
          visible: root.wsToplevels.length > 0
          anchors { top: parent.top; left: parent.left; margins: 3 }
          width: 18; height: 18; radius: 4
          color: "#AA000000"

          Text {
              anchors.centerIn: parent
              text:      root.wsId % 10 || 10
              color:     root.isActive ? "#7aa2f7" : "#ffffff"
              font.pixelSize: 10
              font.bold: root.isActive
          }
      }
  }
  '';

  ribbonOverview = pkgs.runCommandLocal "ribbon-overview" {} ''
    mkdir $out
    cp ${pkgs.writeText "shell.qml"            shell}   $out/shell.qml
    cp ${pkgs.writeText "WorkspacePreview.qml" preview} $out/WorkspacePreview.qml
  '';
in {
  # Fichier QML déployé dans la config Quickshell
  # On symlink le dossier parceque sinon qs résous le symlink avant et ne trouve pas WorkspacePreview
  xdg.configFile."quickshell/ribbon-overview".source = ribbonOverview;

  # Service systemd pour lancer l'instance Quickshell au démarrage
  systemd.user.services.ribbon-overview = {
    Unit = {
      Description = "Hyprland Ribbon Overview (Quickshell)";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.quickshell}/bin/qs -c ribbon-overview";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Keybinding dans Hyprland
  wayland.windowManager.hyprland.settings.bind =
    lib.mkAfter [
      "SUPER, W, exec, ${pkgs.quickshell}/bin/qs ipc -c ribbon-overview call overlay toggle"
    ];
}
