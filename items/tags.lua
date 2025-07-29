local get_pos = function(_y,_x)
    return {
        x = _x,
        y = _y
    }
end

local function show_tag_effect_text(text)
	attention_text({ scale = 1.25, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7}, major = G.play })
end

function Madcap.Funcs.add_anti_tag(t)
	add_tag(Tag('tag_rgmc_anti_'..t))
	return G.GAME.tags[#G.GAME.tags]
end

-- BOOMERANG: Lowers blind requirements for the current/next blind,
-- but adds a Rebound AnTag.
local boomerang = {
	key = "boomerang",
	pos = get_pos(0,0),
	config = {
		type = 'round_start_bonus',
		blind_increase = 0.5
	},
	loc_vars = function(self, info_queue, tag)
        return MadLib.collect_vars(number_format(G.GAME and self.config.blind_increase or 0.5))
	end,
	in_pool = function()
        return true -- Always appears!
    end,
	apply = function(self, tag, context)
		if context.type == self.config.type then
			tag:yep('-'..tostring(self.config.blind_increase), G.C.GREEN, function() return true end)
            show_tag_effect_text("Blind Decreased!")
			G.GAME.blind:multiply_chips(self.config.blind_increase)
            Madcap.Funcs.add_anti_tag('boomerang').config.blind_increase = self.config.blind_increase
            tag.triggered = true
            return true
        end
    end
}

-- BOOMERANG: Raises blind requirements for the current/next blind,
-- but gain $10 +$2 per Ante?
local perilous = {
	key = "perilous",
	pos = get_pos(0,1),
	config = {
		type = 'round_start_bonus',
		blind_increase = 0.5,
		dollars = 10,
		extra = 2
	},
	loc_vars = function(self, info_queue, tag)
        return MadLib.collect_vars(
			number_format(G.GAME and self.config.blind_increase or 0.5),
			number_format(G.GAME and self.config.dollars or 20))
	end,
	in_pool = function()
        return true -- Always appears. Less likely to appear if you have >$20.
    end,
	apply = function(self, tag, context)
		if context.type == self.config.type then
			tag:yep('+', G.C.MONEY, function() return true end) -- Money
            show_tag_effect_text("Blind Increased!")
			G.GAME.blind:multiply_chips(self.config.blind_increase)
            ease_dollars(self.config.dollars) -- Add money
            tag.triggered = true
            return true
        end
    end
}

local xchips = {
	key = "xchips",
	pos = get_pos(0,6),
	config = {
		type = 'hand_played',
		extra = 2
	},
	loc_vars = function(self, info_queue, tag)
        return MadLib.collect_vars(number_format(G.GAME and self.config.extra or 1))
	end,
	in_pool = function()
        return true -- Always appears!
    end,
	apply = function(self, tag, context)
		if
			context.type == self.config.type
			and context.final_scoring_step
		then
			local bonus = self.config.extra or 1

			hand_chips = mod_chips(hand_chips * bonus)
			update_hand_text({delay = 0}, {chips = hand_chips})

			tag:instayep('X'..tostring(bonus), G.C.CHIPS, function()
				return false
			end, 0, "talisman_xchip", false)

			delay(0.5)
            return true
        end

        if context.end_of_round then
			tag.triggered = true
			return true
		end
	end
}

local xmult = {
	key = "xmult",
	pos = get_pos(0,7),
	config = {
		type = 'hand_played',
		extra = 2.5,
	},
	discovered = true,
	loc_vars = function(self, info_queue, tag)
        return MadLib.collect_vars(number_format(G.GAME and self.config.extra or 1))
	end,
	in_pool = function()
        return true -- Always appears!
    end,
	apply = function(self, tag, context)

		if
			context.type == self.config.type
			and context.final_scoring_step
		then
			local bonus = self.config.extra or 1

			mult = mod_mult(mult * bonus)
			update_hand_text({delay = 0}, {mult = mult})

			tag:instayep('X'..tostring(bonus), G.C.MULT, function()
				return false
			end, 0, "polychrome1", false)

			delay(0.5)
            return true
        end

        if context.end_of_round then
			tag.triggered = true
			return true
		end
	end
}

-- ROYAL: Upon opening a Standard Pack, turn all suits into
-- Goblets/Towers/Blooms/Daggers
Madcap.ModdedSuits = {'goblets','towers','blooms','daggers'}
local royal = {
	key = "royal",
	config = {
		type = 'standard_pack_opened'
	},
	in_pool = function()
        return G.GAME.round_resets.ante > 1 and G.GAME.Exotic -- appears after ante 1 and Exotics enabled
    end,
	apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:instayep('+', G.C.MADCAP_UNUSUAL, function()
                return true
            end, 0, nil, true)

            MadLib.event({
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
						local base_suit_cards = MadLib.get_list_matches(G.pack_cards.cards, function (v)
							for _,k in pairs(Madcap.ModdedSuits) do
								if not v:is_suit('rgmc_'..k) then return true end
							end
							return false
						end)

						-- Change the suits of all
                        for _, v in ipairs(base_suit_cards) do
							local suit = pseudorandom_element(Madcap.ModdedSuits, pseudoseed('rgmc_royal_'..G.SEED))
							v:change_suit('rgmc_'..suit)
                        end

                        return true
                    end
                end
            })

            tag.triggered = true
            return true
        end
    end
}

-- Rerolls next blind into boss blind (or finisher)
local punisher = {
	key = "punisher",
	pos = get_pos(0,5),
	config = {
		type = 'round_start_bonus',
		dollars = 15,
		extra = 2, -- hands left
	},
	loc_vars = function(self, info_queue, tag)
        return MadLib.collect_vars(number_format(self.config.dollars or 15), number_format(self.config.extra))
	end,
	in_pool = function()
		-- appears if ante 3 or greater (gotta give some time because it's a DOOZY!)
        return Madcap.Data.devmode or G.GAME.round_resets.ante > 2
    end,
	apply = function(self, tag, context)
        if
			context.type == self.config.type
			and not G.GAME.MADCAP.punisher_mode
		then
			G.GAME.MADCAP.punisher_mode = true -- find a better variable, just do this for now

			tag:yep('+', G.C.MONEY, function() return true end)
            ease_dollars(self.config.extra.dollars)
            local hand_diff = math.min(G.GAME.current_round.hands_left,self.config.extra.hands_left)


            ease_hands_played(-G.GAME.current_round.hands_left + hand_diff)
			ease_discard(-G.GAME.current_round.discards_left) -- bye bye discards

            tag.triggered = true
            return true
        end
	end
}

function Madcap.Funcs.handle_edition_tag_logic(self,tag,context)
	if not context then
		return false
	elseif context.type == self.config.type then
		local _applied = nil

		if (Cryptid and Cryptid.forced_edition()) then
			tag:nope()
		end

		if
			not context.card.edition
			and not context.card.temp_edition
			and context.card.ability.set == "Joker"
		then
			local lock = tag.ID
			G.CONTROLLER.locks[lock] = true
			context.card.temp_edition = true
			tag:yep("+", G.C.DARK_EDITION, function()
				context.card:set_edition('e_'..card.ability.edition, true)
				context.card.ability.couponed = true
				context.card:set_cost()
				context.card.temp_edition = nil
				G.CONTROLLER.locks[lock] = nil
				return true
			end)
			_applied = true
			tag.triggered = true
			return true
		end
	end
end

Madcap.BlankVar = {vars={}}

local function activate_edition(self, tag, context)
	if context.type == self.config.type then
		local applied = nil
		if
			context.card
			and not context.card.edition
			and not context.card.temp_edition
			and context.card.ability.set == 'Joker'
		then
			local lock = tag.ID
			G.CONTROLLER.locks[lock] = true
			context.card.temp_edition = true
			tag:yep('+', G.C.DARK_EDITION, function()
				context.card:set_edition('e_rgmc_iridescent', true)
				context.card.ability.couponed = true
				context.card:set_cost()
				context.card.temp_edition = nil
				G.CONTROLLER.locks[lock] = nil
				return true
			end)
			applied = true
			tag.triggered = true
		end
		return applied
	end
end

-- RAINBOW: Gives a random tag from Vanilla OR Madcap.
local rainbow = {
	key = "rainbow",
	pos = get_pos(0,4),
	config = {
		type = 'store_joker_modify'
	},
	in_pool = function()
        return Madcap.Data.devmode or G.GAME.round_resets.ante > 1
    end,
	config = { type = "store_joker_modify", edition = "e_rgmc_iridescent" },
	loc_vars = function(self, info_queue, tag)
		info_queue[#info_queue + 1] = G.P_CENTERS[self.config.edition]
		return Madcap.BlankVar
	end,
	set_ability = function(self, tag)
		self.config.edition = MadLib.get_weighted_edition({
			'e_foil',
			'e_holo',
			'e_polychrome',
			'e_negative',
			'e_rgmc_iridescent',
			'e_rgmc_infernal',
			'e_rgmc_chrome',
			'e_rgmc_disco',
			'e_rgmc_galactic',
			'e_rgmc_abyssal',
			'e_rgmc_luxury',
		})
		tell(self.config.edition)
	end,
	apply = function(self, tag, context)
        return activate_edition(self, tag, context)
    end,
}

local function get_simple_edition_locvar(self, info_queue, tag)
	info_queue[#info_queue + 1] = G.P_CENTERS[self.config.edition]
	return Madcap.BlankVar
end

local iridescent = {
	key = "iridescent",
	pos = get_pos(2,2),
	config = {
		type = 'store_joker_modify'
	},
	in_pool = function()
        return Madcap.Data.devmode or G.GAME.round_resets.ante > 1
    end,
	config = { type = "store_joker_modify", edition = "e_rgmc_iridescent" },
	loc_vars = get_simple_edition_locvar,
	apply = function(self, tag, context)
        return activate_edition(self, tag, context)
    end,
}

local infernal = {
	key = "infernal",
	pos = get_pos(2,3),
	config = {
		type = 'store_joker_modify'
	},
	in_pool = function()
        return Madcap.Data.devmode or G.GAME.round_resets.ante > 1
    end,
	config = { type = "store_joker_modify", edition = "e_rgmc_infernal" },
	loc_vars = get_simple_edition_locvar,
	apply = function(self, tag, context)
        return activate_edition(self, tag, context)
    end,
}

local chrome = {
	key = "chrome",
	pos = get_pos(2,4),
	config = {
		type = 'store_joker_modify'
	},
	in_pool = function()
        return Madcap.Data.devmode or G.GAME.round_resets.ante > 1
    end,
	config = { type = "store_joker_modify", edition = "e_rgmc_chrome" },
	loc_vars = get_simple_edition_locvar,
	apply = function(self, tag, context)
        return activate_edition(self, tag, context)
    end,
}
local disco = {
	key = "disco",
	pos = get_pos(2,5),
	config = {
		type = 'store_joker_modify'
	},
	in_pool = function()
        return Madcap.Data.devmode or G.GAME.round_resets.ante > 1
    end,
	config = { type = "store_joker_modify", edition = "e_rgmc_disco " },
	loc_vars = get_simple_edition_locvar,
	apply = function(self, tag, context)
        return activate_edition(self, tag, context)
    end,
}

local infernal = {
	key = "infernal",
	pos = get_pos(2,3),
	config = {
		type = 'store_joker_modify'
	},
	in_pool = function()
        return Madcap.Data.devmode or G.GAME.round_resets.ante > 1
    end,
	config = { type = "store_joker_modify", edition = "e_rgmc_infernal" },
	loc_vars = get_simple_edition_locvar,
	apply = function(self, tag, context)
        return activate_edition(self, tag, context)
    end,
}

local galactic = {
	key = "infernal",
	pos = get_pos(3,3),
	config = {
		type = 'store_joker_modify'
	},
	in_pool = function()
        return Madcap.Data.devmode or G.GAME.round_resets.ante > 1
    end,
	config = { type = "store_joker_modify", edition = "e_rgmc_galactic" },
	loc_vars = get_simple_edition_locvar,
	apply = function(self, tag, context)
        return activate_edition(self, tag, context)
    end,
}

local abyssal = {
	key = "infernal",
	pos = get_pos(3,4),
	config = {
		type = 'store_joker_modify'
	},
	in_pool = function()
        return Madcap.Data.devmode or G.GAME.round_resets.ante > 1
    end,
	config = { type = "store_joker_modify", edition = "e_rgmc_abyssal" },
	loc_vars = get_simple_edition_locvar,
	apply = function(self, tag, context)
        return activate_edition(self, tag, context)
    end,
}

local luxury = {
	key = "luxury",
	pos = get_pos(3,5),
	config = {
		type = 'store_joker_modify'
	},
	in_pool = function()
        return Madcap.Data.devmode or (G.GAME.round_resets.ante > 1 and G.GAME.dollars > 5)
    end,
	config = { type = "store_joker_modify", edition = "e_rgmc_luxury" },
	loc_vars = get_simple_edition_locvar,
	apply = function(self, tag, context)
        return activate_edition(self, tag, context)
    end,
}


function Madcap.Funcs.open_booster_quick(key)
	local card = Card(
		G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
		G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
		G.CARD_W * 1.27,
		G.CARD_H * 1.27,
		G.P_CARDS.empty,
		G.P_CENTERS[key],
		{ bypass_discovery_center = true, bypass_discovery_ui = true }
	)
	card.cost = 0
	card.from_tag = true
	G.FUNCS.use_card({config = { ref_table = card } })
	card:start_materialize()
	G.CONTROLLER.locks[lock] = nil
	return true
end

-- COSMA TAG: Simple Cosma Pack
local cosma = {
	key = "cosma",
	pos = get_pos(1,0),
	config = { type = "new_blind_choice" },
	loc_vars = function(self, info_queue)
		-- make cosma booster
		info_queue[#info_queue + 1] = { set = "Other", key = "p_rgmc_cosma", specific_vars = { 1, 3 } }
		return Madcap.BlankVar
	end,
	apply = function(self, tag, context)
		local lock = tag.ID
		if context.type == "new_blind_choice" then
			G.CONTROLLER.locks[lock] = true
			tag:yep('+', G.C.ORANGE,function()
				Madcap.Funcs.open_booster_quick("rgmc_cosma")
			end)
			tag.triggered = true
			return true
		end
	end,
}

function MadLib.do_level_up(card,poker_hand,amt)
	update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 }, {
		handname = localize(poker_hand, "poker_hands"),
		chips = G.GAME.hands[poker_hand].chips,
		mult = G.GAME.hands[poker_hand].mult,
		level = G.GAME.hands[poker_hand].level,
	})
	level_up_hand(card, poker_hand, nil, amt or 1)
	update_hand_text(
		{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
		{ mult = 0, chips = 0, handname = "", level = "" }
	)
end

local pandora = {
	key = "pandora",
	pos = get_pos(1,1),
	config = {
		type 	= "new_blind_choice",
		extra	= 1
	},
	loc_vars = function(self, info_queue)
        return MadLib.collect_vars(number_format(self.config.extra))
	end,
	in_pool = function()
		-- will easing the mayhem exceed the max mayhem
        return G.GAME.Mayhem + 1 <= G.GAME.max_mayhem
    end,
	apply = function(self, tag, context)
		local lock = tag.ID
		if context.type == self.config.type then
			tag:yep('+', G.C.PURPLE, function() return true end) -- Money
            show_tag_effect_text("Mayhem Increased!")
			Madcap.Funcs.ease_mayhem(mayhem)
            tag.triggered = true
            return true
        end
	end,
}

local decant = {
	key = "decant",
	pos = get_pos(1,2),
	config = {
		type 	= "new_blind_choice",
		extra	= 5
	},
	loc_vars = function(self, info_queue)
		local common_hand = G.GAME.MADCAP and MadLib.get_most_played_hand().key or "High Card"
        return MadLib.collect_vars(common_hand, number_format(self.config.extra))
	end,
	in_pool = function()
		local _levels = 0
		MadLib.loop_func(G.GAME.hands, function(v,i)
			_levels = _levels + (v.level - 1)
		end)

        return _levels > 5
    end,
	apply = function(self, tag, context)
		if context.type == self.config.type then
			local chosen_hands = {}
			tag:instayep('+', G.C.PURPLE, function()

				-- Remove from X random hands
				for i=1,self.config.extra do
					MadLib.simple_event(function()
						local _hands = MadLib.get_loop_func(G.GAME.hands, function(v,i)
							return v.level > 1 and MadLib.get_item_index(v, chosen_hands) == -1
						end)
						local _visible = MadLib.loop_func(G.GAME.hands, function(v,i) return v.visible end)

						if #hands < math.min(_visible, 5) then
							_hands = MadLib.get_loop_func(G.GAME.hands, function(v,i) return v.level > 1 end)
						end

						local poker_hand = pseudorandom_element(_hands, pseudoseed('decant'))
						MadLib.do_level_up(card,poker_hand,-1)
						chosen_hands[#chosen_hands+1] = poker_hand
						return true
					end, 0.4, 'after')
				end

				-- Level up most played hand (that wasn't leveled down) X tiems
				MadLib.simple_event(function()
					local most_played = MadLib.get_highest_match(false,nil,nil,function(k,v)
						return not chosen_hands[k] and v.played or -1
					end)
					MadLib.do_level_up(card,most_played,self.config.extra)
					return true
				end, 1.5, 'after')

				return true
			end, 0.5)
			tag.triggered = true
			return true
		end
	end,
}

local exchange = {
	key = "exchange",
	pos = get_pos(1,3),
	config = {
		type 	= "immediate",
		extra 	= 1
	},
	in_pool = function()
        return G.jokers and #G.jokers.cards > 0
    end,
	apply = function(self, tag, context)
		if context.type == self.config.type then

			-- Pseudo-sorted
			local joker_list = MadLib.get_sorted_list(MadLib.get_list_matches(G.jokers.cards, function(v)
				return not v:is_invulnerable()
			end), function(a,b)
				return MadLib.get_rarity_value(a.config.center.rarity) + math.random()*2 < MadLib.get_rarity_value(b.config.center.rarity)
			end)

			-- Destroy old jokers, make new jokers
			for i=1, #math.min(self.config.extra,joker_list) do
				local target 		= joker_list[i]
				local new_rarity 	= MadLib.get_higher_rarity(target.config.center.rarity)
				target:start_dissolve({ G.C.RED }, nil, 1.6)
				card = create_card("Joker", context.area, nil, "cry_epic", nil, nil, nil, "cry_eta")
				local hittable = {
					set = "Joker",
					rarity = new_rarity
				}
				SMODS.add_card(hittable)
			end
		end
	end,
}

function Madcap.Funcs.do_rarity_tag(self, tag, context, params)
	if not context then
		return false
	elseif context.type == "store_joker_create" then
		local posession = { 0 }
		for k, v in ipairs(G.jokers.cards) do
			if
				v.config.center.rarity == self.config.extra
				and not posession[v.config.center.key]
			then
				posession[1] = rares_in_posession[1] + 1
				posession[v.config.center.key] = true
			end
		end

		local card = nil
		if #G.P_JOKER_RARITY_POOLS[self.config.extra] > posession[1] then
			card = create_card("Joker", context.area, nil, tag.abillity.extra, nil, nil, nil, "rgmc")
			create_shop_card_ui(card, "Joker", context.area)
			card.states.visible = false
			tag:yep("+", G.C.RARITY[self.config.extra], function()
				card:start_materialize()
				card.misprint_cost_fac = (params and params.cost_fac) or 0
				card:set_cost()
				return true
			end)
		else
			tag:nope()
		end

		tag.triggered = true
		return card
	end
end


local unusual = {
	key = "unusual",
	pos = get_pos(1,5),
	config = {
		type 	= "store_joker_create",
		extra 	= 'rgmc_unusual'
	},
	apply = function(self, tag, context)
		Madcap.Funcs.do_rarity_tag(self, tag, context, { cost_fac = 0.5 })
	end
}

local legendary = {
	key = "legendary",
	pos = get_pos(1,4),
	config = {
		type 	= "store_joker_create",
		extra 	= 'Legendary'
	},
	apply = function(self, tag, context)
		Madcap.Funcs.do_rarity_tag(self, tag, context, { cost_fac = 0.5 })
	end
}

local concept = {
	key = "concept",
	pos = get_pos(2,0),
	config = {
		target = nil
	},
	in_pool = function()
        return G.jokers and #G.jokers.cards > 0
    end,
	apply = function(self, tag, context)
		if
			target == nil
			and context.type == "tag_add"
			and context.tag.key ~= self.config.key
		then
			target = context.tag -- mark the tag used
		end

		-- if the target tag is removed, then get the next tag above it
		if
			context.type == "tag_remove"
			and context.tag == self.config.target
		then
			for i=1,#G.GAME.tags-1 do
				if
					G.GAME.tags[i] == self
					and G.GAME.tags[i].key ~= self.config.key
				then
					target = G.GAME.tags[i+1]
					break
				end
			end
		end

		-- copy
		if
			target ~= nil
			and context.type == G.GAME.tags[self.config.extra].config.type
		then
			add_tag(Tag(self.config.key))
		end
	end,
}

local jackpot = {
	key = "jackpot",
	pos = get_pos(2,7),
	config = {
		type = "new_blind_choice",
		odds = 6
	},
	min_ante = 2,
	loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = { set = "Tag", key = "tag_rgmc_cogito" }
		return MadLib.collect_vars(G.GAME.probabilities.normal or 1, self.config.odds)
	end,
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			if
				MadLib.calculate_roll({
					numer 	= G.GAME.probabilities.normal or 1 ,
					denom 	= self.config.odds,
					seed 	= 'rgmc_jackpto'
				})
			then
				local lock = tag.ID
				G.CONTROLLER.locks[lock] = true
				tag:yep("+", G.C.SECONDARY_SET.Spectral, function()
					local cog = Tag("tag_rgmc_cogito")
					if self.config.shiny then cog.ability.shiny = Cryptid.is_shiny() end
					add_tag(cog)
					tag.triggered = true
					cog:apply_to_run({ type = "new_blind_choice" })
					G.CONTROLLER.locks[lock] = nil
					return true
				end)
			else
				tag:nope()
				tag.triggered = true
				for i = 1, #G.GAME.tags do
					if G.GAME.tags[i] ~= tag then
						if G.GAME.tags[i]:apply_to_run({ type = "new_blind_choice" }) then
							break
						end
					end
				end
			end
			tag.triggered = true
			return true
		end
	end
}

local cogito = {
	key = "cogito",
	pos = get_pos(3,2),
	config = { type = "new_blind_choice" },
	loc_vars = function(self, info_queue)
		info_queue[#info_queue+1] = G.P_CENTERS.p_spectral_normal_1
		info_queue[#info_queue+1] = { set = "CosmaTarot", key = "c_rgmc_sleeping_ships" }
		info_queue[#info_queue+1] = { set = "CosmaTarot", key = "c_rgmc_aversion" }
		return Madcap.BlankVar
	end,
	apply = function(self, tag, context)
		local lock = tag.ID
		if context.type == "new_blind_choice" then
			G.CONTROLLER.locks[lock] = true
			tag:yep('+', G.C.ORANGE,function()
				Madcap.Funcs.open_booster_quick("rgmc_cosma")
			end)
			tag.triggered = true
			return true
		end
	end,
	in_pool = function()
		return false -- this is a very special tag
	end,
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
	key = "target_mk1",
	pos = get_pos(3,0),
	config = { type = "new_blind_choice" },
	loc_vars = function(self, info_queue, tag)
		info_queue[#info_queue + 1] = { set = "Other", key = "p_rgmc_reward_jumbo", specific_vars = { 1, 3 } }
		return Madcap.BlankVar
	end,
	in_pool = function()
        return false -- special tag for target deck
    end,
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			Madcap.Funcs.open_booster_quick('rgmc_reward_jumbo')
			tag.triggered = true
			return true
		end
    end
}

local tag_target_mk2 = {
	key = "target_mk2",
	pos = get_pos(3,1),
	config = { type = "new_blind_choice" },
	loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = { set = "Other", key = "p_rgmc_reward_mega", specific_vars = { 2, 5 } }
		return Madcap.BlankVar
	end,
	in_pool = function()
        return false -- special tag for target deck
    end,
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			Madcap.Funcs.open_booster_quick('rgmc_reward_mega')
			tag.triggered = true
			return true
		end
    end
}

local antag_target_mk1 = {
	key = "target_mk1",
	pos = get_pos(3,2),
	config = { type = "new_blind_choice" },
	loc_vars = function(self, info_queue, tag)
		info_queue[#info_queue + 1] = { set = "Other", key = "p_rgmc_ruinous_jumbo", specific_vars = { 1, 3 } }
		return Madcap.BlankVar
	end,
	in_pool = function()
        return false -- special tag for target deck
    end,
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			Madcap.Funcs.open_booster_quick('rgmc_ruinous_jumbo')
			tag.triggered = true
			return true
		end
    end
}

local antag_target_mk2 = {
	key = "target_mk2",
	pos = get_pos(3,3),
	discovered = true,
	config = { type = "new_blind_choice" },
	loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = { set = "Other", key = "p_rgmc_ruinous_mega", specific_vars = { 2, 5 } }
		return Madcap.BlankVar
	end,
	in_pool = function()
        return false -- special tag for target deck
    end,
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			Madcap.Funcs.open_booster_quick('rgmc_ruinous_mega')
			tag.triggered = true
			return true
		end
    end
}


local antag_boomerang = {
	key = "boomerang",
	pos = get_pos(0,1),
	config = {
		type = 'round_start_bonus',
		extra = { -- counts as an AnTag
			blind_increase = 0.5,
			antag = true
		}
	},
	discovered = true,
	loc_vars = function(self, info_queue, tag)
		return MadLib.collect_vars(number_format(self.config.extra.blind_increase))
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

local videos = {
	'trendyhoodie',
	'snoo',
	'bankloan',
	'yum',
	'burp',
	'jokey',
	'honse',
	'fnaf',
	'moviefree'
}

local commercial = {
    key = 'commercial',
	pos = get_pos(1,7),
	config = {
		dollars = 3,
	},
    apply = function(self, tag, context)
        tag:yep('+', G.C.DARK_EDITION, print())
		local video = pseudorandom_element(videos, pseudoseed('rgmc_meme'))
           G.FUNCS.overlay_menu{
                definition = MadLib.create_video_uibox(video, 'rgmadcap', 'GET ME OUTTA HERE!', function()
					ease_dollars(self.config.dollars) -- Add money
				end
				),
                config = {no_esc = true}
            }
        tag.triggered = true
        return true
    end,
}
--create_UIBox_custom_video1
-- these tags could not be done. they will come later

local list = {}

Madcap.Funcs.LoadTags({
	boomerang,
	perilous,
	royal,
	punisher,
	xchips,
	xmult,
	rainbow,
	cosma,
	pandora,
	decant,
	exchange,
	unusual,
	legendary,
	iridescent,
	infernal,
	chrome,
	disco,
	concept,
	commercial,
	target_mk1,
	target_mk2,
	jackpot,
	cogito,
}, list, 'tags')

local antags = {
	antag_boomerang,
	antag_target_mk1,
	antag_target_mk2,
	--antag_punisher,
	--antag_buffoon,
	--antag_ethereal,
	--antag_charm,
	--antag_meteor,
	--antag_juggle,
	--antag_voucher
	--antag_skip,
	--antag_investment,
	--antag_topup,
	--antag_boss,
	--antag_standard,
	--antag_garbage,
}

for i=1, #antags do antags[i].key = 'anti_' .. antags[i].key end

Madcap.Funcs.LoadTags(antags, list, 'antags')



return {
	name = "Tags",
	init = function() print("Tags!") end,
	items = list,
}
