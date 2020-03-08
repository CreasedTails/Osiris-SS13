// "Useful" items - I'm guessing things that might be used at work?
/datum/gear/utility
	display_name = "briefcase"
	path = /obj/item/weapon/storage/briefcase
	sort_category = "Прочее"
	cost = 199

/datum/gear/utility/clipboard
	display_name = "clipboard"
	path = /obj/item/weapon/clipboard
	cost = 9

/datum/gear/utility/folder_colorable
	display_name = "folder, colorable"
	flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/weapon/folder
	cost = 19

/datum/gear/utility/folder_presets
	display_name = "folder"
	path = /obj/item/weapon/folder
	cost = 19

/datum/gear/utility/folder_presets/New()
	..()
	var/folder = list(
		"Grey"			=	/obj/item/weapon/folder,
		"Cyan"			=	/obj/item/weapon/folder/cyan,
		"Red"			=	/obj/item/weapon/folder/red,
		"Yellow"		=	/obj/item/weapon/folder/yellow,
		"Blue"			=	/obj/item/weapon/folder/blue,
	)
	gear_tweaks += new /datum/gear_tweak/path(folder)

/datum/gear/utility/paicard
	display_name = "personal AI device"
	path = /obj/item/device/paicard
	cost = 249

/datum/gear/utility/cheaptablet
	display_name = "cheap tablet computer"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/cheap
	cost = 199

/datum/gear/utility/normaltablet
	display_name = "advanced tablet computer"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/advanced
	cost = 449

/datum/gear/utility/cheaplaptop
	display_name = "military laptop"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/cheap/elbrus4kk
	cost = 499

/datum/gear/utility/normallaptop
	display_name = "consumer laptop"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/standard/xenoware
	cost = 849

/datum/gear/utility/advancedlaptop
	display_name = "high-tech laptop"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/advanced/golden
	cost = 1499


