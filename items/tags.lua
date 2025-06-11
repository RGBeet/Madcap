local get_pos = function(_y,_x)
    return {
        x = _x,
        y = _y
    }
end

local function show_tag_effect_text(text)
	attention_text({ scale = 1.25, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7}, major = G.play })
end

local tag_boomerang = {
	object_type = "Tag",
	atlas = "tags",
	pos = get_pos(0,0),
	config = {
		type = 'round_start_bonus',
		extra = {
			blind_increase = 0.5
		}
	},
	key = "boomerang",
	discovered = true,
	loc_vars = function(self, info_queue, tag)
		return {
			vars = {
				G.GAME ~= nil and tag.config.extra.blind_increase and tag.config.extra.blind_increase or 50
			}
		}
	end,
	in_pool = function()
        return true -- Always appears!
    end,
	apply = function(self, tag, context)
		if context.type == self.config.type then
			tag:yep('-'..tostring(self.config.extra.blind_increase), G.C.GREEN, function() return true end)

            show_tag_effect_text("Blind Decreased!")
            G.GAME.blind:add_chips(G.GAME.blind.chips * -self.config.extra.blind_increase) --

            -- Add a new Boomerang AnTag,
            add_tag(Tag('tag_rgmc_anti_boomerang'))
            G.GAME.tags[#G.GAME.tags].config.extra.blind_increase = self.config.extra.blind_increase
            tag.triggered = true
            return true
        end
    end
}

local tag_perilous = {
	object_type = "Tag",
	atlas = "tags",
	pos = get_pos(0,1),
	config = {
		type = 'round_start_bonus',
		extra = {
			blind_increase = 0.5,
			dollars = 20
		}
	},
	key = "perilous",
	discovered = true,
	loc_vars = function(self, info_queue, tag)
		return {
			vars = {
				G.GAME and tag.config.extra.blind_increase or 50,
				G.GAME and tag.config.extra.dollars or 20
			}
		}
	end,
	in_pool = function()
        return true -- Always appears!
    end,
	apply = function(self, tag, context)
		if context.type == self.config.type then
			tag:yep('+', G.C.MONEY, function() return true end) -- Money
            show_tag_effect_text("Blind Increased!")
            G.GAME.blind:add_chips(G.GAME.blind.chips * self.config.extra.blind_increase) -- Add blind money
            ease_dollars(self.config.extra.dollars) -- Add money
            tag.triggered = true
            return true
        end
    end
}

local tag_xchips = {
	object_type = "Tag",
	atlas = "tags",
	pos = get_pos(1,2),
	config = {
		type = 'hand_played',
		extra = {
			Xchip_bonus = 2
		}
	},
	key = "xchips",
	discovered = true,
	loc_vars = function(self, info_queue, tag)
		return { vars = { G.GAME ~= nil and self.config.extra.Xchip_bonus or 1 } }
	end,
	in_pool = function()
        return true -- Always appears!
    end,
	apply = function(self, tag, context)
		if context.type == self.config.type and context.after then
			local bonus = self.config.extra.Xchip_bonus or 1

			hand_chips = mod_chips(hand_chips * bonus)
			update_hand_text({delay = 0}, {chips = hand_chips})

			tag:instayep('X'..tostring(bonus), G.C.CHIPS, function()
				return false
			end, 0, "talisman_xchip", false)
			delay(0.5)
            --tag.triggered = true
            return true
        end
	end
}

local tag_xmult = {
	object_type = "Tag",
	atlas = "tags",
	pos = get_pos(1,1),
	config = {
		type = 'hand_played',
		extra = {
			Xmult_bonus = 2.5
		}
	},
	key = "xmult",
	discovered = true,
	loc_vars = function(self, info_queue, tag)
		return { vars = { G.GAME ~= nil and self.config.extra.Xmult_bonus or 1 } }
	end,
	in_pool = function()
        return true -- Always appears!
    end,
	apply = function(self, tag, context)
		if context.type == self.config.type and context.after then
			local bonus = self.config.extra.Xmult_bonus or 1

			mult = mod_mult(mult * bonus)
			update_hand_text({delay = 0}, {mult = mult})

			tag:instayep('X'..tostring(bonus), G.C.MULT, function()
				return true
			end, 0, "polychrome1", false)
			delay(0.5)
            --tag.triggered = true
            return true
        end
	end
}

local tag_royal = {
	object_type = "Tag",
	atlas = "tags",
	pos = get_pos(0,2),
	config = {
		type = 'standard_pack_opened'
	},
	key = "royal",
	discovered = true,
	loc_vars = function(self, info_queue, tag)
	end,
	in_pool = function()
        return G.GAME.round_resets.ante > 1 and G.GAME.Exotic -- appears after ante 1 and Exotics enabled
    end,
	apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:instayep('+', G.C.MADCAP_UNUSUAL, function()
                return true
            end, 0, nil, true)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0,
                blockable = false,
                blocking = false,
                func = function()
                    if
						G.pack_cards
						and G.pack_cards.cards
						and G.pack_cards.VT.y < G.ROOM.T.h -- pack cards
					then
                        --enable_exotics()

                        for _, v in ipairs(G.pack_cards.cards) do
                            if
								not (v:is_suit('rgmc_goblets')
								or v:is_suit('rgmc_towers')
								or v.config.center == G.P_CENTERS.m_wild)
							then
                                local suits = {'rgmc_goblets', 'rgmc_towers'}
                                local suit = pseudorandom_element(suits, pseudoseed('rgmc_royal_'..G.SEED))
                                v:change_suit(suit)
                            end
                        end

                        return true
                    end
                end
            }))
            tag.triggered = true
            return true
        end
    end
}

-- Rerolls next blind into boss blind (or finisher)
local tag_punisher = {
	object_type = "Tag",
	atlas = "tags",
	pos = get_pos(0,5),
	config = {
		type = 'round_start_bonus',
		extra = {
			dollars = 15,
			hands_left = 2
		}
	},
	key = "punisher",
	discovered = true,
	loc_vars = function(self, info_queue, tag)
		return {
			vars = {
				self.config.extra.dollars,
				self.config.extra.hands_left
			}
		}
	end,
	in_pool = function()
		-- appears if ante 3 or greater (gotta give some time because it's a DOOZY!)
        return RGMC.devmode or G.GAME.round_resets.ante > 2
    end,
	apply = function(self, tag, context)
        if
			context.type == self.config.type
			and not G.GAME.MADCAP.punisher_mode
		then
			G.GAME.MADCAP.punisher_mode = true -- find a better variable, just do this for now

			-- Do the add money stuff
			tag:yep('+', G.C.MONEY, function() return true end)
            ease_dollars(self.config.extra.dollars)

            -- Make that shit sudden death

            -- If you have less than X hands... TOO BAD
            local hand_diff = math.min(G.GAME.current_round.hands_left,self.config.extra.hands_left)

            ease_hands_played(-G.GAME.current_round.hands_left + hand_diff)
			ease_discard(-G.GAME.current_round.discards_left) -- bye bye discards

            tag.triggered = true
            return true
        end
	end
}

--[[
	rainbow can add the following editions:

	foil, holographic, polychrome, negative
	iridescent, infernal, chrome, disco
]]

local tag_rainbow = {
	object_type = "Tag",
	atlas = "tags",
	pos = get_pos(0,4),
	config = {
		type = 'store_joker_modify'
	},
	key = "rainbow",
	discovered = true,
	loc_vars = function(self, info_queue, tag)
	end,
	in_pool = function()
        return RGMC.devmode or G.GAME.round_resets.ante > 1
    end,
	apply = function(self, tag, context)
		if context.type == self.config.type then
			local _applied = nil
			if not context.card.edition and not context.card.temp_edition and context.card.ability.set == "Joker" then
				local lock = tag.ID
				G.CONTROLLER.locks[lock] = true
				context.card.temp_edition = true
				tag:yep("+", G.C.DARK_EDITION, function()

					local random_edition = RGMC.funcs.get_weighted_edition()
					context.card:set_edition(random_edition, true) -- TODO: add random edition
					context.card.ability.couponed = true -- free, no cost
					context.card:set_cost()
					context.card.temp_edition = nil
					G.CONTROLLER.locks[lock] = nil
					return true
				end)
				_applied = true
				tag.triggered = true
			end
		end
    end
}

local function booster_opened_rn()
	return (
		G.STATE == G.STATES.TAROT_PACK
		or G.STATE == G.STATES.PLANET_PACK
		or G.STATE == G.STATES.SPECTRAL_PACK
		or G.STATE == G.STATES.STANDARD_PACK
		or G.STATE == G.STATES.BUFFOON_PACK
		or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
	)
end

local function do_the_target_tag(self, tag, params)
	local key = tag.config.extra.booster_type or 'p_arcana_normal'

	tag:yep('+', G.C.BOOSTER, function()
		SMODS.add_booster_to_shop(key,params)
		return true
	end)

	self.triggered = true
end

local tag_target_mk1 = {
	object_type = "Tag",
	atlas = "tags",
	pos = get_pos(2,0),
	config = {
		extra = {
			booster_type = nil
		}
	},
	key = "target_mk1",
	discovered = true,
	loc_vars = function(self, info_queue, tag)
		return {
			vars = {
				self.config.extra.booster_type
			}
		}
	end,
	in_pool = function()
        return false -- special tag for target deck
    end,
	apply = function(self, tag, context)
		if context.type == "voucher_add" then
			G.GAME.MADCAP.open_booster_rn = true
			do_the_target_tag(self, tag, {
				choose_min 	= 1,
				choose_max 	= 2,
				extra_min 	= 3,
				extra_max	= 5,
				cost = 0
			})
			tag.triggered = true
			return true
		end
    end
}

local tag_target_mk2 = {
	object_type = "Tag",
	atlas = "tags",
	pos = get_pos(2,2),
	config = {
		extra = {
			booster_type = nil
		}
	},
	key = "target_mk2",
	discovered = true,
	loc_vars = function(self, info_queue, tag)
		return {
			vars = {
				self.config.extra.booster_type
			}
		}
	end,
	in_pool = function()
        return false -- special tag for target deck
    end,
	apply = function(self, tag, context)
		if context.type == "voucher_add" then
			do_the_target_tag(self, tag, {
				choose_min 	= 2,
				choose_max 	= 3,
				extra_min 	= 5,
				extra_max	= 8,
				cost = 0
			})
		end
    end
}

-- Takes whatever
local anti_boomerang = {
	object_type = "Tag",
	atlas = "tags",
	pos = get_pos(1,0),
	config = {
		type = 'round_start_bonus',
		extra = { -- counts as an AnTag
			blind_increase = 0.5,
			antag = true
		}
	},
	key = "anti_boomerang",
	discovered = true,
	loc_vars = function(self, info_queue, tag)
		return {
			vars = {
				G.GAME ~= nil and tag.config.extra.blind_increase and tag.config.extra.blind_increase or 50
			}
		}
	end,
	in_pool = function()
        return false -- AnTags don't appear normally.
    end,
	apply = function(self, tag, context)
		if context.type == self.config.type then
			tag:yep('+'..tostring(self.config.extra.blind_increase), G.C.RED, function() return true end)
            show_tag_effect_text("Blind Increased!")

            if not self.config.extra.blind_increase then -- no blind increase? add one
				self.config.extra.blind_increase = 1 -- that's all you get, 1. now buzz off!
			end

            G.GAME.blind:add_chips(G.GAME.blind.chips * self.config.extra.blind_increase)
            tag.triggered = true
            return true
        end
    end
}

-- these tags could not be done. they will come later

local list = {
	tag_boomerang,
	tag_perilous,
	--tag_royal,
	tag_punisher,
	tag_rainbow,
	--tag_xchips,
	--tag_xmult,
	tag_target_mk1,
	tag_target_mk2,
	anti_boomerang,
}

for i=1, #list do
	list[i].order = i-1
end

return {
	name = "Tags",
	init = function() print("Tags!") end,
	items = list,
}
