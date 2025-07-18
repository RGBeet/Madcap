local list = {} -- loads a blank list if mod is not added
local mod_id, mod_name = "Finity", "Finity"

if mod_loaded(mod_id) and 3 == 1 then -- load the items

	list[#list+1] = MadLib.create_atlas('jokers_finity', 'jokers_finity.png')
	local mod_colour = SMODS.Rarities['finity_showdown'].badge_colour

	local legend = function(n,front)
		return {x = front and 1 or 0, y = n}
	end

	local finity_blindfold = {
		key = 'finity_blindfold',
		eternal_compat = true,
		perishable_compat = true,
		blueprint_compat = true,
		demicoloncompat = true,
		config =  {
			extra = {
				add_tags = 1,
				incr_add = 1,
			},
			immutable = {
				max_incr = 10
			}
		},
		loc_vars = function(self, info_queue, card)
			return {
				vars = {
					card.ability.extra.add_tags,
					math.min(card.ability.extra.incr_add, card.ability.immutable.max_incr)
				}
			}
		end,
		calculate = function(self, card, context)
		end
	}

	local function get_lowest_suit(area)
		local suits, min_value = {}, #area+1
		local retval = nil

		for _,v in pairs(area) do
			suits[v.base.suit] = suits[v.base.suit] and suits[v.base.suit]+1 or 0
		end

		for _,v in pairs(suits) do
			if v < min_value then
				retval = k
				min_value = v
			end
		end

		return retval
	end

	local finity_hoop = {
		key = 'finity_hoop',
		eternal_compat = true,
		perishable_compat = true,
		blueprint_compat = true,
		demicoloncompat = false,
		config =  {
			extra = {
			}
		},
		loc_vars = function(self, info_queue, card)
			return {
				vars = { G.playing_cards and get_lowest_suit(G.playing_cards) or "Clubs" } -- get least active suit
			}
		end,
		calculate = function(self, card, context)
		end
	}

	local finity_pin = {
		key = 'finity_pin',
		eternal_compat = true,
		perishable_compat = true,
		blueprint_compat = true,
		demicoloncompat = false,
		config =  {
        immutable = {
            min_rarity = 'rgmc_unusual'
			},
			extra = {
				blind_reduce = 0.80
			}
		},
		loc_vars = function(self, info_queue, card)
			local rarity = SMODS.Rarities[self.config.immutable.min_rarity]
			return {
				vars = {
					number_format(self.config.extra.blind_reduce),
					localize(string.lower("k_" .. rarity.key))
				}
			}
		end,
		calculate = function(self, card, context)
		end
	}


	jokers = {
		finity_blindfold,
		finity_hoop,
		finity_pin,
	}


	for i=1, #jokers do
		jokers[i].object_type = 'Joker'
		jokers[i].order 	= 1000+i
		jokers[i].atlas 	= 'jokers_finity'
		jokers[i].rarity 	= 'finity_showdown'
		jokers[i].pos 		= legend(i-1,false)
		jokers[i].soul_pos  = legend(i-1,true)
		jokers[i].unlocked  = true
		jokers[i].discovered = true
		jokers[i].set_card_type_badge = function(self, card, badges)
			badges[#badges+1] = create_badge(localize("rgmc_compat_finity"), mod_colour, nil, 1.2)
		end
		list[#list+1] 	= jokers[i]
	end

end

return {
    name = mod_name .. " Compatability",
    init = function() -- does the non item stuff ig?
		if not mod_loaded(mod_id) then
			tell(mod_name .. "is not loaded - skipping!")
			return false
		end

		-- Add Showdown rarities to table
		MadLib.RarityValues['finity_showdown'] = {
			name = 'Showdown',
			value = 5.5,
			special = true,
		}

		MadLib.RarityValues['Showdown'] = 'finity_showdown'

		return true
    end,
    items = list
}
