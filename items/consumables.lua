local get_pos = function(_y,_x)
    return {
        x = _x,
        y = _y
    }
end

local girder = {
	object_type = "Consumable",
	set = "Tarot",
	name = "rgmc_girder",
	key = "girder",
	pos = get_pos(0,0),
	config = { max_highlighted = 2, mod_conv = 'm_rgmc_ferrous' },
	cost = 4,
	atlas = "consumables",
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_rgmc_ferrous
		return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted } }
	end,
    can_use = function(self, card)
      return #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.max_highlighted
    end,
}

local filament = {
	object_type = "Consumable",
	set = "Tarot",
	name = "rgmc_filament",
	key = "filament",
	pos = get_pos(0,1),
	config = { max_highlighted = 1, mod_conv = 'm_rgmc_wolfram' },
	cost = 4,
	atlas = "consumables",
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_rgmc_ferrous
		return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted } }
	end,
    can_use = function(self, card)
      return #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.max_highlighted
    end,
}

local polish = {
	object_type = "Consumable",
	set = "Tarot",
	name = "rgmc_polish",
	key = "polish",
	pos = get_pos(0,2),
	config = { max_highlighted = 1, mod_conv = 'm_rgmc_lustrous' },
	cost = 4,
	atlas = "consumables",
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_rgmc_lustrous
		return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted } }
	end,
    can_use = function(self, card)
      return #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.max_highlighted
    end,
}

local providence = {
	object_type = "Consumable",
	set = "Tarot",
	name = "rgmc_providence",
	key = "providence",
	pos = get_pos(0,3),
	config = { extra = { odds = 3, max_highlighted = 2} },
	loc_vars = function(self, info_queue, card)
		return {vars = { (G.GAME.probabilities.normal or 1), self.config.extra.odds, self.config.extra.max_highlighted }}
	end,
    can_use = function(self, card)
		return #G.hand.cards > 0 -- is there a hand of cards available?
    end,
	cost = 4,
	atlas = "consumables",
	use = function(self, card, area, copier)

		local seed = 'rgmc_providence'
		if pseudorandom(seed) < G.GAME.probabilities.normal / self.config.extra.odds then
			tell('Providence activated!')

			local list = RGMC.funcs.deep_copy(G.hand.cards)

			pseudoshuffle(list, pseudoseed('rgmc_providence'))

			local i,j = 1,0
			while i < #list and j < self.config.extra.max_highlighted do
				if not list[i].edition then
					j = j+1
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.08,
						func = function()
							--play_sound('holo1', 0.76, 0.4)
							list[i]:set_edition("e_rgmc_disco",true)
							list[i]:juice_up(0.3, 0.5)
							return true
						end
					}))
				end
			end
		end
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function() G.hand:unhighlight_all(); return true end }))
	end,
}

local oxidize = {
	object_type = "Consumable",
	set = "Spectral",
	name = "rgmc_patina_seal",
	key = "oxidize",
	pos = get_pos(0,5),
	config = {
		extra = "rgmc_patina",
		max_highlighted = 1
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_SEALS[(card.ability or self.config).extra]
		return {vars = {to_big((card.ability or self.config).max_highlighted)}}
	end,
	cost = 4,
	atlas = "consumables",
	use = function(self, card, area, copier) --Good enough
		local used_consumable = copier or card
		for i = 1, #G.hand.highlighted do
			local highlighted = G.hand.highlighted[i]
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					highlighted:juice_up(0.3, 0.5)
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					if highlighted then
						highlighted:set_seal(card.ability.extra)
					end
					return true
				end,
			}))
			delay(0.5)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
}

local reduct = {
	object_type = "Consumable",
	set = "Spectral",
	key = "reduct",
	pos = get_pos(0,4),
	config = {
		extra = "rgmc_bronze",
		max_highlighted = 2
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_SEALS[(card.ability or self.config).extra]
		return {vars = {to_big((card.ability or self.config).max_highlighted)}}
	end,
	cost = 4,
	atlas = "consumables",
	use = function(self, card, area, copier) --Good enough
		local used_consumable = copier or card
		for i = 1, #G.hand.highlighted do
			local highlighted = G.hand.highlighted[i]
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					highlighted:juice_up(0.3, 0.5)
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					if highlighted then
						highlighted:set_seal(card.ability.extra)
					end
					return true
				end,
			}))
			delay(0.5)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
}

local madcrap = {
	object_type = "Consumable",
	set = "Spectral",
	name = "rgmc_madcrap",
	key = "madcrap",
	pos = get_pos(0,6),
	config = {
		extra = {
			odds = 4
		}
	},
	cost = 4,
	atlas = "consumables",
	can_use = function(self, card)
		return G.hand and #G.hand.cards > 0
	end,
    use = function(self, card, area, copier)
		local list = {'2','3','4','5'}
		local temp_list = {}

		for i = 1, #G.hand.cards do
			if pseudorandom('oh_crap') < G.GAME.probabilities.normal / self.config.extra.odds then
				temp_list[#temp_list+1] = G.hand.cards[i]
			end
		end

		for i=1, #temp_list do
			local percent = 1.15 - (i-0.999) / (#G.hand.cards-0.998)*0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.08,
				func = function()
					temp_list[i]:flip()
					play_sound('card1', percent)
					return true
				end,
			}))
		end

		for i=1, #temp_list do
			local percent = 1.15 - (i-0.999) / (#G.hand.cards-0.998)*0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.08,
				func = function()
					play_sound('tarot2', percent, 0.6);
					temp_list[i]:juice_up(0.3, 0.3)

					local _rank, _suit = nil, nil
					_rank = pseudorandom_element(list, pseudoseed("rgmc_madcrap"))
					_suit = SMODS.Suits[G.hand.cards[i].base.suit].value

					SMODS.change_base(temp_list[i], _suit, _rank) -- change da rank
					return true
				end,
			}))
		end

		for i=1, #temp_list do
			local percent = 1.15 - (i-0.999) / (#G.hand.cards-0.998)*0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.08,
				func = function()
					play_sound('card1', percent)
					temp_list[i]:flip()
					return true
				end,
			}))
		end
    end,
}

local chalice = {
	object_type = "Consumable",
	set = "Spectral",
	name = "rgmc_chalice",
	key = "chalice",
	pos = get_pos(0,7),
	config = {
		suit_conv = 'rgmc_goblets'
	},
	cost = 4,
	atlas = "consumables",
	can_use = function(self, card)
		return #G.hand.cards > 0
	end,
	use = function(self, card, area, copier)
		RGMC.funcs.set_special_suits(true)
		local temp_list = {}
		-- light suits
		if not G.hand then return false end

		for i = 1, #G.hand.cards do
			if
				RGMC.funcs.card_suit_in_list(G.hand.cards[i],light_suits)
				and G.hand.cards[i].base.suit ~= self.config.suit_conv
			then
				temp_list[#temp_list+1] = G.hand.cards[i]
			end
		end

		for i=1, #temp_list do
			local percent = 1.15 - (i-0.999) / (#G.hand.cards-0.998)*0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.08,
				func = function()
					temp_list[i]:flip()
					play_sound('card1', percent)
					return true
				end,
			}))
		end

		for i=1, #temp_list do
			local percent = 1.15 - (i-0.999) / (#G.hand.cards-0.998)*0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.08,
				func = function()
					play_sound('tarot2', percent, 0.6);
					temp_list[i]:juice_up(0.3, 0.3)
					temp_list[i]:change_suit(self.config.suit_conv);
					return true
				end,
			}))
		end

		for i=1, #temp_list do
			local percent = 1.15 - (i-0.999) / (#G.hand.cards-0.998)*0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.08,
				func = function()
					temp_list[i]:flip()
					play_sound('card1', percent)
					return true
				end,
			}))
		end
	end,
}

local armoire = {
	object_type = "Consumable",
	set = "Spectral",
	name = "rgmc_armoire",
	key = "armoire",
	pos = get_pos(0,8),
	config = {
		suit_conv = 'rgmc_towers'
	},
	cost = 4,
	atlas = "consumables",
	can_use = function(self, card)
		return #G.hand.cards > 0
	end,
	use = function(self, card, area, copier)
		RGMC.funcs.set_special_suits(true)
		local temp_list = {}
		-- light suits
		if not G.hand then return false end

		for i = 1, #G.hand.cards do
			if
				RGMC.funcs.card_suit_in_list(G.hand.cards[i],dark_suits)
				and G.hand.cards[i].base.suit ~= self.config.suit_conv
			then
				temp_list[#temp_list+1] = G.hand.cards[i]
			end
		end

		for i=1, #temp_list do
			local percent = 1.15 - (i-0.999) / (#G.hand.cards-0.998)*0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.08,
				func = function()
					temp_list[i]:flip()
					play_sound('card1', percent)
					return true
				end,
			}))
		end

		for i=1, #temp_list do
			local percent = 1.15 - (i-0.999) / (#G.hand.cards-0.998)*0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.08,
				func = function()
					play_sound('tarot2', percent, 0.6);
					temp_list[i]:juice_up(0.3, 0.3)
					temp_list[i]:change_suit(self.config.suit_conv);
					return true
				end,
			}))
		end

		for i=1, #temp_list do
			local percent = 1.15 - (i-0.999) / (#G.hand.cards-0.998)*0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.08,
				func = function()
					temp_list[i]:flip()
					play_sound('card1', percent)
					return true
				end,
			}))
		end
	end,
}

-- adds two temporary hands (max: 8)
local bluebell = {
	object_type = "Consumable",
	set = "Spectral",
	name = "rgmc_bluebell",
	key = "bluebell",
	pos = get_pos(0,9),
	config = {extra = {add = 2}},
	cost = 4,
	atlas = "consumables",
	can_use = function(self, card)
		return G.GAME.MADCAP.temporary_hands < 8
	end,
	use = function(self, card, area, copier)
		local words = localize("rgmc_temp_hand_plus")
		attention_text({
			scale = 0.7,
			text = words,
			maxw = 12,
			hold = RGMC.funcs.get_default_attention_hold(words),
			align = 'cm',
			offset = {x = 0, y = -1},
			major = G.play
		})
		G.GAME.MADCAP.temporary_hands = G.GAME.MADCAP.temporary_hands + 1
	end,
}

-- adds two temporary discards (max: 8)
--
local amaryllis = {
	object_type = "Consumable",
	set = "Spectral",
	name = "rgmc_amaryllis",
	key = "amaryllis",
	pos = get_pos(1,0),
	config = {extra = {add = 3}},
	cost = 4,
	atlas = "consumables",
	can_use = function(self, card)
		return G.GAME.MADCAP.temporary_discards < 8
	end,
	use = function(self, card, area, copier)
		local words = localize("rgmc_temp_discard_plus")
		attention_text({
			scale = 0.7,
			text = words,
			maxw = 12,
			hold = RGMC.funcs.get_default_attention_hold(words),
			align = 'cm',
			offset = {x = 0, y = -1},
			major = G.play
		})
		G.GAME.MADCAP.temporary_discards = G.GAME.MADCAP.temporary_discards + 1
	end,
}

local list = {
	girder,
	filament,
	polish,
	--providence, doesnt work and i am too lazy to fix it right now
	reduct,
	oxidize,
	madcrap,
	chalice,
	armoire,
	bluebell,
	amaryllis,
}

for i=1, #list do
    if list[i] then list[i].order = i-1 end
end

return {
    name = "Consumables",
    init = function() print("Consumables!") end,
    items = list
}
