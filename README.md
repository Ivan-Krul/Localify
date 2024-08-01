Localify
=======

It's a single-page website, what can play music from local device, your computer or from the server, as you opening any media player.

Before entering to `Localify.html`
-----------------

You can set where should you search music in `pathToCheckItOut.txt`, or reducing target music files in `ignore.txt` and run `WritePathsToContent.ps1` for automatic detection and outputing `content.txt`, or you can fill it manually.
Also you has to **TURN OFF CORS IN YOUR BROWSER IN CASE OF USING OR DEVELOPING THIS REPOSITORY**

Interface
-----------------

![screenshot.png](screenshot.png)

What it can?
-----------------

Except listening music, you can create your own playlist and watching satisfying customisable equalizer visualisation, or at least save your GPU. It's based on browser build-in player, so you can manually set, whatever you want. You can watch all music in a single list, or select from your folder music or search your music by search bar. Playlists you made are savable to m3u8 files, so you can enjoy your music not only with browser. For video-makers with music you want to visualize in video, you can record the EQ, but it would fill your download folder and history, only with your insist.

Compatatility
----------------

You can already use Localify if you're in Windows.
It requires .sh script to use it in Linux, MacOS or Server-side computers.
If you dare, you can install Powershell in Unix-like system and launch `WritePathsToContent.ps1`
