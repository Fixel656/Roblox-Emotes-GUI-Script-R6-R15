# Documentation & Tutorial

- How does SGA Works?<br>

All data stored in:
- Files in SpecificGameAnimations folder in my Github repository
- Files in (Workspace folder of your executor)/EmoterData/SpecificAnims
- CustomAnims.lua file in (Workspace folder of your executor)/EmoterData<br>

  Each file in these folders made for each game and NECESSARILY need to have an GameId of a game in name of file you need (Except for CustomAnims.lua file, it was made for animations playable on ANY game an dyou need to made this file by yourself)<br>
  and formated as JSON.<br>

  There are 4 categories in file:
  - "CustomEmotes": Category with Animations you can play
  - "DefaultAnims": Category with default anims for each game (like run, walk, fall, etc.) made for options like Stop Default Anims. Kinda useless for now as i didn't make a function to disable custom Animate scripts maded by developers of their game yet<br>
  (By the way "Animate" is a (mostly) local script that handles character's animation on running, jumping and other moves. In some places developers may make their own Animate scripts and call them other names, like Nullscape or Blade Ball).
  - "ToolActionAnims": White list of animations that will be always played even if you playing an emote. Made mostly for animations where you act with tool or attacking with/without it (You can turn it off in settings).
  - "ToolIdleAnims": Another white list of animations that will be always played even if you playing an emote. Made mostly for animations whe you just holding tool (You can turn it off in settings as well).
  - "EmoteWheelEmotes": Category with emotes you want to set for your emote wheel.<br>

All data in files looks like this:
    
```json
{
	"CustomEmotes": [
	["Idle", "Idle", "Spec", 1, 180435571, 0.1, 1, "PriorLow", true],
	["Walk", "Walk", "Spec", 1, 13772468608, 0, 2, "PriorHigh", false]
	],
	"DefaultAnims": 
		["16738351181", "13772468608"],
	"ToolActionAnims": 
		["180435792", "13772468608"],
	"ToolIdleAnims": 
		["13772468608"],
	"EmoteWheelEmotes": 
		["R6Wave", "SpecFrontflip", "SpecRambunctious", "SpecRussianKick", "SpecBunnyHop", "SpecNosferatuRun", "SpecParanormalSwag", "SpecChickenDance"]
}
```

Let's look at each category.<br>

CustomEmotes:<br>

Each Emote in this category looks like this:<br>
<img width="1025" height="99" alt="Безымянный" src="https://github.com/user-attachments/assets/72daf536-23ef-4341-9927-5e047917ddd4" /><br>

1.ButtonName: Name of button in GUI. Needed for EmoteWheel and other things (Highly reccomended to have special name to avoid errors)<br>

2.ButtonText: Text shown on Button in GUI.<br>

3.ScrollingFrameType: Type of ScrollingFrame on which the button will be located: R6, R15, or Spec (Specific). R6 and R15 ScrollingFrames are frames with default emotes or emotes playable on ALL games. Not recommended for SGA, better use it for CustomAnims.lua file. 
Spec is Scrolling frame made specially for SGA <br>

4.LayoutOrder: Layout Order of GUI, Group of Emotes in which animation will be located (1 - Dances, 2 - Actions, 3 - Walk&Run, 4 - Weird, 5 - Poses&Idles, 6 - Attack) <br>

5.AnimationId: Id of animation you want to add. Make sure its not made and added to Roblox by you;<br>

6.FadeTime: Fade time of animation (if set to 0, animation will start playing instantly) <br>

7.AnimationSpeed: Speed of animation<br>

8.AnimationType: Type of animation. It's actually kinda complicated, because words in it works like tags.<br>
 - Priority: "PriorLow" sets priority to Action3, "PriorHigh" sets priority to Action4. If you don't know what that means, go to official Roblox documentation: https://create.roblox.com/docs/reference/engine/classes/AnimationTrack<br>
 - Pause: If you type "Pause" word in string, it will pause animation after 1 second, whick is useful for some animations (Used in DeathRagdoll for R15 and Scared for R6). the problem is that there's a lot of animations that need other time to pause, so maybe i will update it someday<br>

9.AnimationLoop: Loop value of animation. if set to false, you can loop it by right mouse button.<br>

"DefaultAnims", "ToolActionAnims" and "ToolIdleAnims" Categories only need AnimationId<br>

EmoteWheelEmotes:<br>

To set emotes for Emote Wheel you need to type ButtonName and ScrollinFrameType without spaces like this:
