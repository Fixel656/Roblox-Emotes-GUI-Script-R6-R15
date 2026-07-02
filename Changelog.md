V1:
- Added abibily to change animation speed. The number you write in the window is adding to the default speed, 
if you type negative number, it will make animation slower, but if summary speed will be negative, animation won't work, 
and if summary is 0,animation will stuck on first frames. 
- Changed how Gui looks
- Gui will reappear on Player.CharacterAdded so it prevents Gui to disappear or stop working on death
- Button to Destroy Gui
- Added, edited and deleted some R6 animations
- changed Frame dragging from Frame.Draggable to using UiDragDetector (Now the Frame won't stop dragging even if you move mouse very quick)

  <img width="476" height="299" alt="image" src="https://github.com/user-attachments/assets/60f24374-a56a-4e04-83f3-54ce7c427b31" />
  
V2:
- Optimized script and made it easier to edit and add new emotes. Now it uses Functions for making anim buttons and playing anims insted of doing code for each button,
  which saved almost 1000 lines of code before i added more animations (Now it saves even more)
- Made various types and functions for animations
- Now some anims can be paused after 1 second by "Pause" option
- Now you can change LayoutOrder for animations to group them (No visual separations for groups though because of UIGridLayout)
- All anmations now have Action3 or Action4 priority (PriorLow/PriorHigh in script) so you can normally use animations playable by /e
- More R6/R15 animations (88 R15 anims and pair of R6 ones), deleted all previous R15 anims because of their awfulness
- Button to delete Gui
- Showing text for some buttons on hover
- Changed colors in some places and some other changes
- Buttons for currently playing animations are more visible
- You can loop unlooped anims by clicking RMB on them now

  <img width="472" height="299" alt="image" src="https://github.com/user-attachments/assets/6b81659d-1763-4d45-8d4f-7aa5f98ef2dc" />

V2.2:
- Fixed Gui Reset when Character reappears (death or something else)
- Fixed colors binding to BgColor

V2.6:
- Fixed "Pause" anim function bug when it pauses wrong if you quick enough to play anim with "Pause" Type again
- Added anim Preview Frame (Unexpected, actually). Disabled by default because can be not useful and you can disable it in Gui

V2.8:
- Added Options

  <img width="234" height="134" alt="image" src="https://github.com/user-attachments/assets/dd2b59fd-7b3d-48fa-9746-8ae2271cbf54" />

V2.9:
- Added Divide Frames to visually separate animation buttons (By changing from UIGridLayout to UIListLayout)
- Fixed some UIPadding things

  <img width="473" height="300" alt="image" src="https://github.com/user-attachments/assets/9297a64e-7428-4c3c-a283-d346d3fa942a" />

V2.9.5:
- Added Search
- Maded some positions to save on restart
