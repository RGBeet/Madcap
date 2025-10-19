local mod_path = "" .. SMODS.current_mod.path       -- save the mod path for future usage!

-- LOADING JOKERS
Madcap.object_buffer = {
	['Jokers'] = {}
}

Madcap.Directories = {
	['poker_hands'] = {
		pass = function()
			return true
		end
	},
	['jokers'] = {
		['madcap'] = {
			pass = function()
				return true
			end,
			func = function(d) -- add joker id to joker ids
				--tell('Adding '..(d and d.key or '?!?')..' to Joker List.')
				d.pools = { ['MadcapJoker'] = true }
				d.blueprint_compat  = d.blueprint_compat or true
				d.eternal_compat    = d.eternal_compat or true
				d.perishable_compat = d.perishable_compat or true
				d.unlocked          = d.unlocked or true
				d.discovered        = d.discovered or true
			end
		},
		['cryptid'] = {
			pass = function()
				return next(SMODS.find_mod("Cryptid")) -- cryptid jokers are not loaded here
			end,
			func = function(d)
				d.pools = { ['MadcapJoker'] = true }
				d.blueprint_compat  = d.blueprint_compat or true
				d.eternal_compat    = d.eternal_compat or true
				d.perishable_compat = d.perishable_compat or true
				d.unlocked          = d.unlocked or true
				d.discovered        = d.discovered or true
			end
		},
		['morefluff'] = {
			pass = function()
				return next(SMODS.find_mod("MoreFluff")) -- cryptid jokers are not loaded here
			end,
			func = function(d)
				d.pools = { ['MadcapJoker'] = true }
				d.blueprint_compat  = d.blueprint_compat or true
				d.eternal_compat    = d.eternal_compat or true
				d.perishable_compat = d.perishable_compat or true
				d.unlocked          = d.unlocked or true
				d.discovered        = d.discovered or true
			end
		},
		['toga'] = {
			pass = function()
				return MadLib.mod_loaded('TOGAPack') -- cryptid jokers are not loaded here
			end,
			func = function(d)
				d.pools = { ['MadcapJoker'] = true }
				d.blueprint_compat  = d.blueprint_compat or true
				d.eternal_compat    = d.eternal_compat or true
				d.perishable_compat = d.perishable_compat or true
				d.unlocked          = d.unlocked or true
				d.discovered        = d.discovered or true
			end
		},
	},
	['consumables'] = {
		['madcap'] = {
			['tarot'] = {
				pass = function()
					return true
				end
			},
			['spectral'] = {
				pass = function()
					return true
				end
			},
			['cosma'] = {
				pass = function()
					return true
				end
			},
			['spatia'] = {
				pass = function()
					return true
				end
			},
			['potentia'] = {
				pass = function()
					return true
				end
			},
			['planets'] = {
				pass = function()
					return true
				end
			}
		},
		['morefluff'] = {
			['colour'] = {
				pass = function()
					return next(SMODS.find_mod("MoreFluff"))
				end
			},
			['rotarot'] = {
				pass = function()
					return next(SMODS.find_mod("MoreFluff"))
				end
			},
		}
	},
	['boosters']	= {
		pass = function()
			return true
		end
	},
	['challenges']	= {
		pass = function()
			return true
		end
	},
	['stakes'] = {
		['madcap'] = {
			pass = function()
				return true
			end
		},
		['pacdam'] = {
			pass = function()
				return next(SMODS.find_mod("Pacdam"))
			end
		}
	},
	['vouchers']	= {
		['madcap'] = {
			pass = function()
				return true
			end
		}
	},
	['enhancements'] = {
		['madcap'] = {
			pass = function()
				return true
			end
		},
		['morefluff'] = {
			pass = function()
				return next(SMODS.find_mod("MoreFluff"))
			end
		},
		['akyrs'] = {
			pass = function()
				return next(SMODS.find_mod("aikoyorisshenanigans"))
			end
		},
	},
	['editions'] = {
		pass = function()
			return true
		end
	},
	['seals']		= {
		pass = function()
			return true
		end
	},
	['sleeves']		= {
		pass = function()
			return next(SMODS.find_mod("CardSleeves"))
		end
	},
	['stickers']	= {
		pass = function()
			return true
		end
	},
	['tags']		= {
		['madcap'] = {
			['regular'] = {
				pass = function()
					return true
				end
			},
			['antags'] = {
				pass = function()
					return true
				end,
				func = function(d)
					table.insert(Madcap.Lists.AnTags, d.key)
				end
			},
			['special'] = {
				pass = function()
					return true
				end
			}
		}
	},
	['blinds'] = {
		['boss'] = {
			pass = function()
				return true
			end,
			func = function(d)
				d.boss 		= d.boss or { min = 1, max = 10}
			end
		},
		['showdown'] = {
			pass = function()
				return true
			end,
			func = function(d)
				d.boss 		= d.boss or { showdown = true, min = 1, max = 10}
			end
		},
		--TODO: add DX blinds?
	},
	['decks'] = {
		pass = function()
			return true
		end
	},
	['challenges'] 	= {
		pass = function()
			return true
		end
	},
}

local function load_folder(folder)
	local files = NFS.getDirectoryItems(mod_path .. folder)
	for _, file in ipairs(files) do
		local f, err = SMODS.load_file(folder .. "/" .. file)
		if err then
			errors[file] = err
		else
			local curr_obj = f()
			local namey = curr_obj.name
			if curr_obj.name == "HTTPS Module" and Madcap[curr_obj.name] == nil then
				MadcapConfig[curr_obj.name] = false
			end
			if MadcapConfig[curr_obj.name] == nil then
				MadcapConfig[curr_obj.name] = true
				Madcap.enabled[curr_obj.name] = true
				tell("Loading current object "..namey)
			end
			if MadcapConfig[curr_obj.name] then
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
							if not Madcap.object_buffer[item.object_type] then
								Madcap.object_buffer[item.object_type] = {}
							end
							--tell("Added item to obj_buffer of "..namey)
							Madcap.object_buffer[item.object_type][#Madcap.object_buffer[item.object_type] + 1] = item
						else
							tell("Error loading item "..namey .." :(")
						end
					end
				end
			end
		end
	end
end

load_folder('items/misc') -- load the items folder
load_folder('compat') -- load the items folder

for set, objs in pairs(Madcap.object_buffer) do
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

local function load_items(path,func)
	local files = NFS.getDirectoryItems(mod_path..path)
	tell('File path is '.. path)
	MadLib.loop_func(files, function(file)
		tell('File is '..file)
		local f, err = SMODS.load_file(path..file)
		if err then
			tell_error(err)
			--errors[file] = err
			return false
		end

		local item = f()

		if not (item and item.data) then
			tell('Item could not load - improper data structure.')
			return false
		elseif item.devmode and item.devmode ~= Madcap.Data.devmode then
			tell('Item could not load - devmode only!')
			return false
		end

		if item.categories and MadLib.list_matches_one(item.categories, function(c)
			return MadcapConfig[v] ~= nil and MadcapConfig[v] == false
		end) then
			tell('Item '..(item.data and item.data.key or 'UNKNOWN')..' could not load - configs turned off.')
			return false
		end

		local data = item.data
		if data.object_type then
			if func then func(item.data) end
			tell('Attempting to load item '..(item.data and item.data.key or 'UNKNOWN')..'.')
			SMODS[data.object_type](data)
		end
	end)
end

local function loop_directories(tbl, path)
    path = path or {}
    tell('Loading Directories')
	print(path)
	MadLib.loop_table(tbl, function(key,value)
        if type(value) ~= "table" then return false end
		local pass = value.pass and value.pass() or nil
		if (pass ~= nil and pass ~= false) then
			tell("Loading folder at: " .. table.concat(path, ".") .. (next(path) and "." or "") .. key)
			local final_path = 'items/'
			MadLib.loop_func(path, function(v,i)
				final_path = final_path .. v .. '/'
			end)
			load_items(final_path..key..'/',value.func)
		else
			table.insert(path, key)
			loop_directories(value, path)
			table.remove(path)
		end
	end)
end

loop_directories(Madcap.Directories)
-- File loading based on Cryptid mod lmao
local errors = {}
Madcap.object_buffer = {}

-- File loading ended!
print(errors)
for f, e in ipairs(errors) do
    tell_stat("Error loading file",e)
end

