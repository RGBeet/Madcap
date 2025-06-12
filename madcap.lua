--RGUTILS = NFS.load(SMODS.current_mod.path .. "/rgutils.lua")()

local colors = {
	chaos = '32CD32',
	unusual = '9c87f6',
}

--[[

	pikari 		(goblet)
	suojata 	(shield)
	kukinta		(bloom)
	veitsi		(knife)
	tyhjä		(void)
]]

RGMC = {
	seed 				= 'rgmc',	-- when the seed is SUS
	devmode 			= false, 	-- if enabled expect to see a LOT of debug text
	funcs 				= {}, 		-- ALL THE FUNCTIONS!
	custom_suits 		= {}, 		-- handles custom suit shenanigans
	C = {
		goblets 	= HEX('D66FA3'),		-- Goblets suit color
		towers 		= HEX('593559'),		-- Towers suit color
		blooms 		= HEX('A7EE5F'),		-- Blooms suit color
		daggers 	= HEX('591235'),		-- Daggers suit color
		voids		= HEX('382242'),		-- Voids suit color

		goblets_hc 	= HEX('591235'),		-- Goblets suit color
		towers_hc 	= HEX('7d2a89'),		-- Towers suit color
		blooms_hc 	= HEX('82ba49'),		-- Blooms suit color
		daggers_hc 	= HEX('712025'),		-- Daggers suit color

		patina		= HEX('49ab9a'),		-- Patina Seal color
		bronze		= HEX('754d42'),		-- Bronze Seal color
		jade		= HEX('226f4c'),		-- Jade Seal color
		cream		= HEX('ebe8bd'),		-- Cream Seal color
		umber		= HEX('b56622'),		-- Umber Seal color

		cosma_teal	= HEX('01D883'),		-- Cosma card color

		hot_pink 	= HEX('FF0080'),		-- Madcap hot pink
		pale_pink 	= HEX('F6879B'),		-- Unusual pink
		purple		= HEX('9C87F6'),		-- Unusual purple
		orange		= HEX('FF7E00'),		-- Gimmick orange
		chaotic		= HEX('32CD32'),		-- Chaotic lime

		stone 		= HEX('7A8087'),		-- Stone cards
		ferrous 	= HEX('F5EAEA'),		-- Ferrous cards
		wolfram 	= HEX('5C5C73'),		-- Wolfram cards
		lustrous 	= HEX('7DD75A'),		-- Lustrous cards


		gradients = {
			CHAOS 		= {HEX('75188F'), HEX('3A188F')},
			UNUSUAL 	= {HEX('9C87F6'), HEX('F6879B')},
			CHAOTIC 	= {HEX('32CD32'), HEX('CD32CD')},
			ALTERED 	= {HEX('5c0e59'), HEX('b5821d')},
			ECHIPS	 	= {HEX('000994'), HEX('9a00ff')}, 	-- i like this color :)
			EMULT 		= {HEX('a41818'), HEX('9a00ff')},
		},
	},
	config = {
	},
	--[[


	]]--
	rarity_keys = { -- used to simplify looking up rarities
		['Common'] 		= 1,
		['Uncommon'] 	= 2,
		['Rare'] 		= 3,
		['Legendary'] 	= 4,
		['Unusual'] 	= 'rgmc_unsuual',
		['Gimmick'] 	= 'rgmc_gimmick',
	},
	rarities = { -- rarities have special info
		['Common'] = {
			name = 'Common',
			value = 1,
			special = false,
		},
		['Uncommon'] = {
			name = 'Uncommon',
			value = 2,
			special = false,
		},
		['rgmc_gimmick'] = {
			name = 'Gimmick',
			value = 2.5,
			special = true,
		},
		['Rare'] = {
			name = 'Rare',
			value = 3,
			special = false,
		},
		['rgmc_unusual'] = {
			name = 'Unusual',
			value = 3.5,
			special = true,
		},
		['Legendary'] = {
			name = 'Legendary',
			value = 4,
			special = true,
		},
	},
	-- Used for organizing enhancements for stuff like Big Bonus (Voucher)
	enhancement_lists = {
		bonus = {
			'bonus',
			'stone',
			'rgmc_wolfram'
		},
		mult = {
			'mult',
			'lucky',
			'rgmc_wolfram'
		},
		x_mult = {
			'glass',
			'steel',
			'rgmc_lustrous'
		},
		money = {
			'gold',
			'lucky'
		},
	},
}

function print_debug_text(text,prefix)
	if not RGMC.devmode then return false end
	local finished_text
	if type(text) == 'string' then
		finished_text = "[MADCAP] - "..(prefix and prefix..' ' or '')..(text or '???')
	else
		print(text)
		finished_text = "[MADCAP] - TEXT TYPE IS "..type(text)
	end
	print(finished_text)
end

-- Prints out a MADCAP message!
function tell(text)
   print_debug_text(text)
end

-- Prints out a MADCAP error.
function tell_error(text)
	print_debug_text(text..' - ERROR!')
	return false
end

-- Prints out a MADCAP stat. Foo: Bar
function tell_stat(text,stat)
    print_debug_text(text..": "..tostring(stat))
end

-- Prints out a MADCAP list.
function tell_list(text,list)
    print_debug_text(text..":")
    print(list)
end

-- more flexible key path function
function key_path(k, p)
	return { key = k, path = p }
end

-- simple key path function
function key_path_simple(k,e)
	local path = k..'.'..e
	return key_path(k, path)
end

-- compare two numbers
local function cmp(a, b)
   a = tostring(a.N)
   b = tostring(b.N)
   local patt = '^(.-)%s*(%d+)$'
   local _,_, col1, num1 = a:find(patt)
   local _,_, col2, num2 = b:find(patt)
   if (col1 and col2) and col1 == col2 then
      return tonumber(num1) < tonumber(num2)
   end
   return a < b
end

SMODS.load_file('lib/main.lua')()     		-- main functions
SMODS.load_file('lib/misc.lua')()			-- misc functions
SMODS.load_file('lib/unsorted.lua')()		-- unsorted right now
SMODS.load_file('lib/overrides.lua')()     	-- overrides

-- suits
G.C.RGMC_GOBLETS  	= RGMC.C.goblets
G.C.RGMC_TOWERS 	= RGMC.C.towers
G.C.RGMC_BLOOMS		= RGMC.C.blooms
G.C.RGMC_DAGGERS	= RGMC.C.daggers
G.C.RGMC_VOIDS 		= RGMC.C.voids

-- cards / enhancements
G.C.RGMC_COSMA 		= RGMC.C.cosma_teal
G.C.RGMC_STONE 		= RGMC.C.stone
G.C.RGMC_FERROUS 	= RGMC.C.ferrous
G.C.RGMC_WOLFRAM 	= RGMC.C.wolfram
G.C.RGMC_LUSTROUS 	= RGMC.C.lustrous

-- seals
G.C.RGMC_PATINA 	= RGMC.C.patina
G.C.RGMC_BRONZE 	= RGMC.C.bronze

-- rarities
G.C.RGMC_GIMMICK 	= RGMC.C.orange
G.C.RGMC_UNUSUAL 	= { 0, 0, 0, 0 }

-- chips/mult stuff
G.C.RGMC_EMULT 		= { 0, 0, 0, 0 }
G.C.RGMC_ECHIPS 	= { 0, 0, 0, 0 }

-- enabled type stuff
local mod_path = "" .. SMODS.current_mod.path       -- save the mod path for future usage!
rgmc_config = SMODS.current_mod.config          	-- loading configuration
RGMC.enabled = copy_table(rgmc_config)      		-- what is enabled?


-- rarities are handled here because why not
SMODS.Rarity{ -- Unusual: not quite Epic Jokers, but not quite Legendary.
    key = "unusual",
    loc_txt = { name = RGMC.rarities['rgmc_unusual'].name },
    badge_colour = G.C.RGMC_UNUSUAL,
}

SMODS.Rarity{ -- Gimmick: used for Jokers not normally obtainable in regular decks.
    key = "gimmick",
    loc_txt = { name = RGMC.rarities['rgmc_gimmick'].name },
    badge_colour = G.C.RGMC_GIMMICK,
}

if Cryptid then -- load cryptid compat
	SMODS.load_file('compat/cryptid.lua')()
end

if FinisherBossBlindStringMap then -- load finity compat
	SMODS.load_file('compat/finity.lua')()
end

if SMODS and Talisman then -- load talisman compat (you should rly have this)
	tell('Good!')
else
	tell("Why aren't you using Talisman?!")
end

-- File loading based on Cryptid mod lmao
local files = NFS.getDirectoryItems(mod_path .. "items")
local errors = {}
RGMC.obj_buffer = {}

for _, file in ipairs(files) do
	tell("Loading file "..file)
	local f, err = SMODS.load_file("items/" .. file)
	if err then
        errors[file] = err
	else
		local curr_obj = f()
        local namey = curr_obj.name
		if curr_obj.name == "HTTPS Module" and RGMC[curr_obj.name] == nil then
			rgmc_config[curr_obj.name] = false
		end
		if rgmc_config[curr_obj.name] == nil then
			rgmc_config[curr_obj.name] = true
			RGMC.enabled[curr_obj.name] = true
            tell("Loading current object "..namey)
		end
		if rgmc_config[curr_obj.name] then
            tell("Succesfully loaded " .. namey)
			if curr_obj.init then
				curr_obj:init()
			end
			if not curr_obj.items then
				tell("Warning: " .. namey .. " has no items")
			else
				for _, item in ipairs(curr_obj.items) do
					if not item.order then
						item.order = 0
					end
					if curr_obj.order then
						item.order = item.order + curr_obj.order
					end
					if SMODS[item.object_type] then
						if not RGMC.obj_buffer[item.object_type] then
							RGMC.obj_buffer[item.object_type] = {}
						end
                        --tell("Added item to obj_buffer of "..namey)
						RGMC.obj_buffer[item.object_type][#RGMC.obj_buffer[item.object_type] + 1] = item
					else
						tell("Error loading item "..namey .." :(")
					end
				end
			end
		end
	end
end
for set, objs in pairs(RGMC.obj_buffer) do
	table.sort(objs, function(a, b)
		return a.order < b.order
	end)
	for i = 1, #objs do
		if objs[i].post_process and type(objs[i].post_process) == "function" then
			objs[i]:post_process()
		end
		SMODS[set](objs[i])
	end
end
-- File loading ended!


print(errors)
for f, e in ipairs(errors) do
    tell_stat("Error loading file",e)
end


----------------------------------------------
------------MOD CODE END----------------------
