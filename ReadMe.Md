This work is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0
International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg

# About
tr-orangefarm is a ***Free*** orange picking resource that uses grape seed farm as the sole place for picking oranges. Once you have collected the oranges then you will need to go to house located near *EAST Sandy Shorces exit 68* Which is located also on the blip with the processing blip. There you will be able to process *Raw Oranges*  into orange juice or you can sell raw oranges here at the processor. If you have processed oranged juices in vinewood you will be able to sell the *Orange Juice* at the dinner.

*Note only made this because I seen this simple thing for 10 dollars on tebex and wanted to make it for free*

Everything can be edited within the config this supports langs/different languanges by editing the text in the config.

the minigame can be edited within the config as well. Everything will have hashed out comments next to them so you will be able to edit everything with the detail needed.

Created By
- TRClassic

# Support Discord
https://discord.gg/vTCUWCnQSD

# Dependencies (ESX):
- [CircleMinigame](https://github.com/trclassic92/CircleMinigame) - Converted from qbcore
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_lib](https://github.com/overextended/ox_lib)
- [ESX_Legacy](https://github.com/esx-framework/esx-legacy)

# Dependencies (QB-Remastered):
- [CircleMinigame](https://github.com/trclassic92/CircleMinigame)
- [qb-inventory](https://github.com/QBCore-Remastered/qb-inventory)
- [ox_target](https://github.com/overextended/ox_target) (Config Option)
- [qb-target](https://github.com/qbcore-framework/qb-target) (Config Option)
- [ox_lib](https://github.com/overextended/ox_lib)
- [qb-core remastered](https://github.com/qbcore-framework/qb-core)

# Dependencies (QB):
- [CircleMinigame](https://github.com/trclassic92/CircleMinigame)
- [qb-inventory](https://github.com/qbcore-framework/qb-inventory)
- [ox_target](https://github.com/overextended/ox_target) (Config Option)
- [qb-target](https://github.com/qbcore-framework/qb-target) (Config Option)
- [ox_lib](https://github.com/overextended/ox_lib)
- [qb-core](https://github.com/qbcore-framework/qb-core)

## Preview's
- [ShowCase Video](https://youtu.be/KFj_WiAhp0s)

![Preview Screenshot](https://i.imgur.com/NOHlypk.jpeg)

![Preview Screenshot](https://i.imgur.com/rZJbpVo.jpeg)

![Preview Screenshot](https://i.imgur.com/6kPzfKv.jpeg)


# Install ESX
#### Items

ox inventory/data/item.lua

Step 1.
```
	['orange'] = {
		label = 'Fresh Orange',
		weight = 25,
		client = {
			status = { hunger = 500 },
			anim = 'eating',
			prop = { model = `ng_proc_food_ornge1a`, pos = vec3(0.02, 0.02, -0.04), rot = vec3(0.0, 0.0, 0.0) },
			usetime = 2500,
			notification = 'You ate a delicious orange'
		},
	},

	['orange_juice'] = {
		label = 'Orange Juice',
		weight = 100,
		client = {
			status = { thirst = 100000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_script_bottle_01`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'You have refreshed your self with a nice cold bottle of orange juice'
		}
	},

```

#### Images

Step 2. Move the images from the tr-orangefarming/Images to \[ox]\ox_inventory\web\images

# Install QBCore
#### Items

qb-core/shared/item.lua

Step 1.
```
--ProjextX Orange Farm
	['orange'] 						 = {['name'] = 'orange', 						['label'] = 'Fresh Orange', 				['weight'] = 25, 		['type'] = 'item', 		['image'] = 'orange.png', 		['unique'] = false, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A fresh orange'},
	['orange_juice'] 			 	 = {['name'] = 'orange_juice', 					['label'] = 'Fresh Orange Juice', 			['weight'] = 75, 		['type'] = 'item', 		['image'] = 'orangejuice.png', 		['unique'] = false, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A fresh bottle of orange juice'},
```
#### Images

Step 2. Move the images from the tr-orangefarming/images to [qb]\qb-inventory\html\images

#### FXManifest

Step 3. Remove `'@es_extended/imports.lua'` from the Fxmanifest.lua
