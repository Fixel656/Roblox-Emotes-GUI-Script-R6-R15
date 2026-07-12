Made an FE Animations script with some features

- Script: `loadstring(game:HttpGet("https://raw.githubusercontent.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/refs/heads/main/MainScript.lua",true))()`

<img width="476" height="356" alt="image" src="https://github.com/user-attachments/assets/51f4a0ba-73d8-4b39-8042-b76c7d8f802c" /> <br/>

What this Gui can do:
- Play FE animations, of course (**43** R6 animations AND **88** R15 animations)
- Highly configurable Button and animation functions
- Abibily to change animation speed. The number you write in the window is adding to the default speed, 
if you type negative number, it will make animation slower, but if summary speed will be negative, animation won't work, 
and if summary is 0, animation will stuck on first frames. 
- Gui will reappear on Player.CharacterAdded so it prevents Gui to disappear or stop working on death
- All anmations have Action3 or Action4 priority so it wont be replaced or conflicting with default animations
- You can loop unlooped anims by clicking RMB on them
- You can preview Animation by hovering on anim button
- Search animation you need (no need to follow the symbol case)
- Cool options: Pausing all animations, stopping all default animations, pausing default "Animate" script

To do:
- Add other color themes and make style more modern
- Saveable settings and position
- More R15 animations (there`s no other good FE R6 anims left)
- Section with Animations for some separate games. It will be places with emotes available in these places specifically.
It will be manually, so it will be a few games. I will type available ones in README.
- HotKeys
- Ability to use animation by entering its ID (maybe will make "Saved Anims" Section)
- More Options sections
- Add AnimSmoothFade setting
- Add Tool anims working while playing Anims
- More<br/>
<br/>
   This script was based on Energize by illremember. Original: https://github.com/IlikeyocutgHAH12/FEEGGEG/blob/main/%5BFE%5D%20Energize%20Animation%20Gui.txt<br/>
<br/>
<br/>
<br/>
  CREATED ANIMATION ID DETECTOR (Maded to get Id for Section with Animations for some separate games And other things)<br/>
<br/>
- Script: `loadstring(game:HttpGet("https://raw.githubusercontent.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/refs/heads/main/AnimationIdDetector.lua",true))()`

<img width="488" height="294" alt="image" src="https://github.com/user-attachments/assets/707e7d25-17d2-4ebe-9172-6c36988fab24" /> <img width="487" height="294" alt="image" src="https://github.com/user-attachments/assets/0c2901da-9b65-4c95-a884-cef52aaa7af5" />


What this Gui can do:
- Detect animation Character currently playing or Animation object (Name, Id and Priority if detecting from Character)
- Choose Character do detect anims from By entering it's Name or write a path to it (game.workspace.Rig)
- Chose a path to search for Anim Objects in
- Preview detected anims
- Name and Id are copyable so you dont need to write it yourself
- Save and EXPORT anims to file as KeyframeSequences (KeyframeSequence will have it's Animation Id as Attribute)

I made those scripts for myself, so it may be not fully suitable for you, especially on section with separate places. You can change it if you want, but it would be cool if you will credit me and original author!

Hope you like it! 
