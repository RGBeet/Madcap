local list = {} -- loads a blank list if mod is not added
local mod_id, mod_name = "RiftRaft", "Rift-Raft"
local loaded = mod_loaded(mod_id)

if loaded then -- load the items

	Madcap.RiftCard = SMODS.Consumable:extend {
		set = 'Rift',
		atlas = 'riftraft_riftcards',
		set_ability = function(self, card, initial, delay_sprites)
			if not card.edition then card:set_edition({negative = true}, true, true) end
		end
	}

	list[#list+1] = MadLib.create_atlas('riftraft_riftcards', 'riftraft_riftcards.png')

    local get_pos = function(_y,_x)
        return {
            x = _x,
            y = _y
        }
    end

	-- I have no idea how to plug these into list.
	-- just do em here ig
	local wavelength = {
		key = "wavelength",
		loc_vars = function(self, info_queue, card)
			return { }
		end,
		config = {
			extra = { },
		},
		pos = get_pos(0,1),
		cost = 1,
		in_pool = function(self, args)
			return false
		end,
		can_use = function(self, card)
			return true
		end,
		use = function(self, card, area)
			-- use
		end,
	}

	local rift_cards = {
		wavelength
	}

	for i = 1,#rift_cards do
		rift_cards[i].set 		= 'Rift'
		rift_cards[i].atlas 	= 'riftraft_riftcards'
		rift_cards[i].order 	= 100+i
		rift_cards[i].set_ability = function(self, card, initial, delay_sprites)
			if not card.edition then
				card:set_edition({negative = true}, true, true)
			end
		end

		Madcap.RiftCard(rift_cards[i])
	end
end

return {
    name = mod_name .. " Compatability",
    init = function() -- does the non item stuff ig?
		if not mod_loaded(mod_id) then
			tell(mod_name .. "is not loaded - skipping!")
			return false
		end

		return true
    end,
    items = list
}
