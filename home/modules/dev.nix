{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional

    # scala
    scala
    sbt
    coursier
    jdk17
    metals

    # Create a wrapper script for IntelliJ
    (writeShellScriptBin "idea" ''
      export _JAVA_AWT_WM_NONREPARENTING=1
      export IDEA_JDK=${pkgs.jdk17.home}
      export JETBRAINS_JRE=${pkgs.jetbrains.jdk}
      export JAVA_HOME=${pkgs.jdk17.home}
      export JDK_JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dsun.java2d.uiScale=1.0"
      exec ${pkgs.jetbrains.idea-ultimate}/bin/idea "$@"
    '')
  ];
  
  # Set JAVA_HOME to JDK 17 path
  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk17}/lib/openjdk";
  };

  # Create IntelliJ IDEA configuration
  home.file.".config/JetBrains/IntelliJIdea2023.3/idea.properties" = {
    text = ''
      # Custom IntelliJ properties
      editor.scale.fonts.in.editor=true
      ide.ui.scale=1.0
      ide.ui.hidpi=true
    '';
  };

  # Create JVM options file for IntelliJ
  home.file.".config/JetBrains/IntelliJIdea2023.3/idea64.vmoptions" = {
    text = ''
      -Xms512m
      -Xmx2048m
      -XX:ReservedCodeCacheSize=512m
      -Dsun.java2d.uiScale=1.0
      -Dsun.java2d.opengl=true
      -Dawt.useSystemAAFontSettings=lcd
      -Dswing.aatext=true
      -Dide.ui.scale=1.0
    '';
  };
}

