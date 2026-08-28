<p align="center">
 <img width="250" height="140" alt="EmoterLogo4" src="https://github.com/user-attachments/assets/310058f6-c9ed-4321-84ed-853f696ba468" />
</p>

- [FAQ](https://github.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/blob/main/Documentations%20%26%20Changelogs/FAQ.md)
- [Wiki](https://github.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/wiki)
- [SGA Wiki](https://github.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/wiki/SpecificGameAnimations-and-how-to-make-your-own-SGA)
- [List of games with SpecificGameAnimations](https://github.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/blob/main/SpecificGameAnimations/Games%20list.md)
- [Emoter Changelog](https://github.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/blob/main/Documentations%20%26%20Changelogs/Emoter%20Changelog.md)
- [AnimIdDetector Changelog](https://github.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/blob/main/Documentations%20%26%20Changelogs/AnimId%20Detector%20Changelog.md)
<br>

**Emoter** is a FE GUI with a lot of animations you can play while moving, sitting or other things. This GUI doesn't give you any Advantages and made to have fun.<br>
Dance without any problems and restrictions!<br>
<br>

- Script:
```lua
 loadstring(game:HttpGet("https://raw.githubusercontent.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/refs/heads/main/MainScript.lua",true))()
```
<br>
<img width="548" height="354" alt="image" src="https://github.com/user-attachments/assets/485b95cf-0898-487a-aa8b-b3205c4f5fa0" /><br>
<br>

### What this Gui can do?
- Play FE animations (**43** R6 animations AND more than **100** R15 animations)
- Highly configurable Button and animation functions
- Abibily to change animation speed
- All anmations have Action3 or Action4 priority so it wont be replaced or conflicting with default animations
- You can loop unlooped anims by clicking RMB on them
- Preview animation by hovering on it's anim button
- Cool options: Pausing all animations, stopping all default animations, pausing default "Animate" script, falling and reversing animations
- Other color themes
- Ability to use animation by entering its ID
- Added SGA - SpecificGameAnimations: file with Animations for specific games. It will be places with emotes available in these places specifically.<br/>
I will add it manually and type available ones in README. Also you can add files for yourself in your files folder. More information [here](https://github.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/wiki/SpecificGameAnimations-and-how-to-make-your-own-SGA). <br/>
(You can add your SGA in [Discussions](https://github.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/discussions/categories/your-sga-specific-game-animations) so i can add it to Github)<br/>
- "Running" and "Idle" types for animations. "Running" type will change AnimationSpeed depending on the character's speed and stop when character isn't moving (staying). "Idle" type will play whed you're staying. It has a lot of configurations, so check more info on how to use it in my Wiki
- Emote wheel (Activate by <kbd>,</kbd> button. You can't edit emotes for it in Gui itself (at least for now), You'll need to edit files in EmoterData folder.

### To do:
- Double Hotkey
- Make size changing setting
- More R15 animations
- More Options (maybe)
- More<br/>
<br/>
   This script was based on Energize by illremember. Original: https://github.com/IlikeyocutgHAH12/FEEGGEG/blob/main/%5BFE%5D%20Energize%20Animation%20Gui.txt<br/>
<br/>

# AnimId Detector
  Animation Id detector made to look and add Animations for games and other things.<br/>
<br>

- Script:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/refs/heads/main/AnimationIdDetector.lua",true))()
```

<img width="488" height="294" alt="image" src="https://github.com/user-attachments/assets/707e7d25-17d2-4ebe-9172-6c36988fab24" /> <img width="487" height="294" alt="image" src="https://github.com/user-attachments/assets/0c2901da-9b65-4c95-a884-cef52aaa7af5" />

### What this Gui can do?
- Detect animation Character currently playing or Animation object (Name, Id and Priority if detecting from Character)
- Choose Character do detect anims from By entering it's Name or write a path to it (game.workspace.Rig)
- Chose a path to search for Anim Objects in
- Preview detected anims
- Name and Id are copyable so you dont need to write it yourself
- Save and EXPORT anims to file as KeyframeSequences (KeyframeSequence will have it's Animation Id as Attribute)
- Easily add animations to Emoter files
<br/>
<br/>
I made those scripts for myself, so it may be not fully suitable for you. You can change it if you want, but it would be cool if you will credit me and original author!<br/>
<br/>

**Hope you like it!**
