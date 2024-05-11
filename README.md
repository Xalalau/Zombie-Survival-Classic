Changelog:

Original 

```
Changes from v1.07 -> v1.1
    I'll release a full update to 1.1 probably tommarrow. I'll include the 'spectate' concommand protection I've been using as well.

    Main features:
    - Redone HUD.
    - Redone Scoreboard.
    - Redone VGUI.
    - F1 - F4 buttons all have individual functions instead of clogging up the scoreboard.
    - F4 now has all the post process options as well as some other stuff on it.
    - You can toggle the beats on/off.
    - You can change the film grain opacity!
    - Anti-overflow / pure virtual function calls for when many, many people blow up at the same time.
    - Wraith.
    - Configurable starting loadouts.
    - Dynamic movement speeds.
    - Everyone is slightly faster.
    - Doors can come off their hinges after taking a lot of damage.
    - So much stuff since 1.07 that I can't take the time to put them all down. Basically, everything is better. 

Changes from v1.05 -> v1.07
    - Added Fast Headcrab class. Faster and less health than the normal one.
    - Added Poison Headcrab class. This class will deal up to 40 or so damage over time if you hit someone. It also comes with a poison spit that will do only do 10 damage but will blind and lesser poison if it hits someone's head!
    - Added 'Ricochete' Magnum. This has the highest damage of all the pistols and has the ability to bounce off walls one time to deal half damage.
    - Changed 'Battleaxe' Handgun to do slightly more damage and less rate of fire.
    - Added 'Peashooter' Handgun.
    - Added 'Shredder' SMG.
    - Added 'Impaler' Crossbow. This has the unique ability of going through multiple enemies and it does plenty damage.
    - All weapons have cute names.
    - Added dynamic movement speed system. Having a weapon out that is heavy will slow you down while having a knife or a pistol out will make you faster.
    - Custom crosshair due to above system.
    - Added dynamic aim-cone system. Crouching and standing still reduce your aim cone while moving will greatly increase it.
    - Added Zombie Horde system and meter. This is exactly like the human's fear meter but for zombies. The more zombies that are packed together, the bigger this bar gets. The bigger it gets, the more damage the zombies do to humans. A full bar means DOUBLE damage. The chem zombie is especially sensitive to this bar. It even has it's own set of beats.
    - Added Zombie Feast system. Gibs are now server-side and zombies can simply walk in to them to eat them and regain 5% of their maximum health per gib.
    - Humans who die will now drop their weapons and can be picked up by other humans. If you run over that weapon again during a reward then you simply receive ammo for it.
    - The melee of zombies have absolutely nothing to do with bullets anymore. They now use pure TakeDamage and TraceHullAttack. Meaning you don't have to be 100% accurate when swinging your melee.
    - Health of every zombie class was increased by about 20% each.
    - Darkened some colors on the HUD.
    - Added commands: zs_enablecolormod 0/1 zs_enablemotionblur 0/1 zs_enablesharpen 0/1 zs_enablefilmgrain 0/1. If you like post processing but don't like a specific feature, you can turn it off with those.
    - First zombie is chosen randomly between the first 4 connected players instead of the 4th person to join.
    - Reduced size of 'Arsenal Upgraded' window since it was taking up half the screen.
    - Custom HUD for the bottom left portion of the HUD.
    - Changed some colormod stuff to make it look more menacing as a human.
    - Fixed reload animations on the Sweeper Shotgun and the Slug Rifle (gun held stupidly).
    - Humans can press USE on other humans to shove them. You can not shove another human if there is no ground for them to be shoved to. Meaning you can't shove them off a roof or out a window.
    - Suiciding will give whoever last hit you the kill, as long as they're not on the same team.
    - Headshots to zombies do 2x damage. Anywhere else does 3/4 damage.
    - Re-added Fast Zombie lunge damage.
    - Fast Zombie base damage reduced from 6 to 5. Maximum of 10 due to Horde meter.
    - Removed movement slow down when swinging as a Fast Zombie.
    - Dying as a human has new effects.
    - Being dead now puts your camera in your ragdoll's eyes.
    - Upgraded blood effects drastically.
    - Changed the way headshots are calculated. Now is distance to joint rather than distance to joint's height (more accurate calculation).
    - Removed clientside ragdoll creation on gibs due to them being spawned infinately when you would change visleafs.
    - Optimized HUD components and code.
    - Fixed Torso Zombies having incorrect starts on their tracelines for melee. Meaning that the attack was starting from way too high above your camera.
    - Fixed error on moving over a name in the scoreboard.
    - Fixed purple checkers on most materials due to the GM update removing gmdm.
    - Fixed black / purple screen on zombies.
    - Fixed exploit where zombies could shoot invisible, instant-kill bullets through glass and some small props like soda cans.
    - Fixed all client-side crashing. This means chem zombie explode overflow and other junk.
    - Fixed all server-side crashing. The last time I checked my server it had an uptime of 5 days with 0 crashes.
    - Fixed Regeneration powerup not working properly.
    - Fixed 2 portions of the end-time scoreboard not showing.
    - Fixed pain sounds not playing for humans.
    - Fixed bug where Humans couldn't switch to weapons that had no ammo for them. 

Changes from v1.04 -> v1.05
    Added Headcrab class.
    - Added powerups system.
    - Added map profile system. Lua files named after the current map (ie: zs_nastyhouse.lua) in the gamemodes/zombiesurvival/maps folder will be ran on map start. This is so you can make some creative things unique to your own server or give out public fixes. (The basement jamming in forestofthedamned?)
    - Added slug rifle.
    - Altered some zombie team melee damages to be a bit more balanced.
    - Added breathe meter. Affects humans only.
    - Added concommand disable_pp 1/0. 1 to turn post processing completely off. 0 to turn it on. (as long as you're above dxlevel 90)
    - Added OPTIONAL (zs_options, ANTI_VENT_CAMP) butt-cramp meter. Basically, if you stay in a cramped space for too long (a minute) then your spine will explode. Comes with a meter and only affects humans.
    - Added SEffect for redemption.
    - You will now see a glowing cross thing in the death messages when a person has redeemed themself.
    - Having less than 30 health on the human team or being underwater on any team will make your screen wobble back and forth a bit.
    - Ammo regeneration system optimized. It uses less code and stuff.
    - Ammo regeneration amounts can be edited in zs_options.
    - 357 ammo regeneration changed from 6 to 12.
    - Shotgun ammo regeneration changed from 20 to 12.
    - Fast zombie charge attack will push people a little harder than before. Objects are the same.
    - Fast zombie charge attack will disorient the zombie's screen less.
    - Fast zombie charge attack will disorient the person who gets hit's screen.
    - Fast zombie melee damage changed from 5 to 6.
    - Fixed a crash fix that happened to a few people when the round ends.
    - Got rid of the flatline sound that you hear whenever a player dies. You should now only hear the correct death sounds according to what I put in.
    - Fixed the help menu displaying blank items for Chance of...
    - All animation code has been severely optimized. You should notice a nice decrease in server-side lag.
    - Zombies now have a 1/3 chance to turn in to a torso zombie if not shot in the head and they survive, wich in it self has a 3/4 chance to happen. So roughly a 24% chance to happen if not headshotted. Also brought in the old 'legs gib' effect from gmod9.
    - Zombies need to have their attack key down in order to respawn.
    - Poison zombies can walk while swinging.
    - Added slam as reward 75.
    - Tons and tons of bug fixes and other little changes.

Changes from v1.03 -> v1.04
    * Zombies who have no teamates will spawn with x2 health.
    * Infliction can not reduce itself due to zombies leaving the server or redeeming. It can increase but never decrease.
    * Infliction is now directly affected by the amount of time remaining in a round. At 10 minutes, for example, infliction will be locked at %50 or more.
    * Fixed chem-zombie not doing damage when in vents and other low places.
    * Made music assigned to a team instead of win/lose. Example, you're a zombie and the humans win - you hear human win music. All the humans die - you hear lose music.
    * Made some adjustments to balance and when weapons are given. Nothing major.
    * Added a popup/sound thing when new zombie classes are unlocked.
    * Changed the end scoreboard around. It's now easier to read things, especially when you win and everything is really bright.
    * Gamemode will now track people's total damage dealt while on the zombie team and total damage while on the human team. It is displayed at the end of the round on the scoreboard.
    * Changed default health for poison zombies to be 280 (up from 250).
    * Increased poison zombie and chem-zombie walking speed by 4%.
    * Added a humanwin song instead of using a crappy hl2 one. Working on replacing the dumb mortal kombat song with something else.
    * Added DESTROY_DOORS option to zs_options file. Destroys all func_door and func_door_rotating's. On by default.
    * Added DESTROY_PROP_DOORS option to zs_options file. Destroys all prop_door_rotating. Off by default.
    * Added FORCE_NORMAL_GAMMA option to zs_options file. Forces people to have their mat_monitorgamma setting locked at 2.2. This means that people can't just adjust their brightness settings. They need to use flashlights. Won't be affected by the smarter people who use graphics card control panels and such. On by default.
    * Fixed problem where people could suicide after being hit by someone and not give that person a kill. Due to a gmod update or something, was working before.
    * Made starting knife actually swing like one. =)
    * A lot of other stuff I don't remember much about.

Changes from v1.02 -> v1.03
    * Reduced glock 3 bullet damage from 13 to 11.
    * Fixed support for older cards (dx89 and lower) seeing weirdness as a human.
    * Made it so that by using kill in the console or killing yourself by similair means will give the person who last hit you a kill. No more suiciding punks.
    * You can see your own gibs. (Not much contrast between the red overlay and the gibs but you can hear the squishy sounds and stuff.)
    * Lots of bug fixes and stuff.
    * Pressing f3 will go to the classes menu.
    * Added options to allow NPC's and scoring for killing NPC's in zs_options.lua. I suggest you up the DIFFICULTY variable to around 2.0 or more if you plan on doing this, otherwise you'll have cannon fodders for NPC's. NOT SUGGESTED FOR BIGGER SERVERS.

Changes from v1.01 -> v1.02
    * Made chem-zombie explosion more powerful.
    * Fixed lua/init.lua crash that was a result of a GMod update changing the behavior of ScriptEnforcer.

Changes from v1.0 -> v1.01
    * Fixed chem-zombies not exploding properly. 
```
