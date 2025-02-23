{
#    https://www.youtube.com/watch?v=qlfm3MEbqYA&ab_channel=Vimjoyer
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
        gamescopeSession.enable = true;
        package = pkgs.steam.override {
            # extraEnv = {
            #   SDL_VIDEODRIVER = "windows";
            #   ENABLE_VKBASALT = 0;
            #   PROTON_HIDE_NVIDIA_GPU = 0;
            #   PROTON_ENABLE_NVAPI = 1;
            #   PROTON_ENABLE_NGX_UPDATER = 1;
            #   PROTON_USE_D9VK = 1;
            #   PROTON_USE_VKD3D = 1;
            #   DXVK_ASYNC = 1;
            #   __GL_VRR_ALLOWED = 1;
            #   PROTON_NO_ESYNC = 1;
            # };
        };
    };
    programs.gamemode.enable = true;

    # open ports for steam stream and some games
    networking.firewall.allowedTCPPorts = with pkgs.lib; [ 27036 27037 ] ++ (range 27015 27030);
    networking.firewall.allowedUDPPorts = with pkgs.lib; [ 4380 27036 ] ++ (range 27000 27031);
    networking.firewall.allowPing = true;

    environment.systemPackages = with pkgs; [
        gamescope
    ];
}