-- cryptid mod compat
local list = {} -- loads a blank list if mod is not added
local mod_id, mod_name = "MoreFluff", "More Fluff"
local loaded = mod_loaded(mod_id)

if loaded then -- load the items



	local function get_enhancement_tarot_loc_vars(self, info_queue, card)
		if not (self and card) then return  { vars = {} } end
		MadLib.add_to_queue(G.P_CENTERS[self.config.mod_conv])
		return MadLib.collect_vars(card and card.ability.max_highlighted or self.config.max_highlighted,
			localize{type = 'name_text', set = 'Enhanced', key = self.config.mod_conv})
	end

	-- Has at least 1 card selected
	local function consumable_highlight_check(self,card)
		if not (self and card) then return false end
		return #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.max_highlighted
	end

	-- Progress bar for colour consumables.
	local function get_progress_bar(val, max)
		return max > 10
			and val, "/"..max
			or string.rep("#", val), string.rep("#", max - val)
	end

	local function colour_can_use(self, card)
		return self and self.config.val > 0 or false
	end

	local function colour_convert_suit(self, card, area, copier, suit)
		if not (self and card) then return end
		local blacklist = {}
		for i = 1, card.ability.val do
			local temp_pool = MadLib.get_list_matches(G.hand.cards, function(v) return not v:is_suit(suit) and not blacklist[v] end)
			if #temp_pool == 0 then break end

			local eligible_card = pseudorandom_element(temp_pool, pseudoseed(self.config.key))
			blacklist[eligible_card] = true

			MadLib.simple_event(function()
				eligible_card:flip()
				play_sound('card1', 1)
				eligible_card:juice_up(0.3, 0.3)
				return true
			end, 0.15, 'after')

			MadLib.simple_event(function()
				eligible_card:flip()
				play_sound('card1', 1)
				eligible_card:change_suit(suit)
				card:juice_up(0.3, 0.5)
				return true
			end, 0.4, 'after')
		end
	end

	local function colour_add_consumable(self, card, area, copier, set, not_negative)
		if not (self and card) then return end
		for i = 1, card.ability.val do
			MadLib.simple_event(function()
				play_sound('timpani')
				local n = MadLib.get_random_card(set, G.consumeables, self.config.key)
				n:add_to_deck()
				n:set_edition({negative = not not_negative}, true)
				G.consumeables:emplace(n)
				card:juice_up(0.3, 0.5)
				return true
			end, 0.4, 'after')
		end
		delay(0.6)
	end

	local function colour_add_consumable_exact(self, card, area, copier, id, not_negative)
		if not (self and card) then return end
		for i = 1, card.ability.val do
			MadLib.simple_event(function()
				play_sound('timpani')
				local n = create_card(nil, G.consumeables, nil, nil, true, true, 'c_'..id)
				n:add_to_deck()
				n:set_edition({negative = not not_negative}, true)
				G.consumeables:emplace(n)
				card:juice_up(0.3, 0.5)
				return true
			end, 0.4, 'after')
		end
		delay(0.6)
	end

	local function colour_add_tag(self, card, area, copier, tag)
		if not (self and card) then return false end
		for i = 1, card.ability.val do
			MadLib.simple_event(function()
				add_tag(Tag('tag_'..tag))
				play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
				play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
				return true
			end)
			delay(0.2)
		end
		delay(0.6)
		return true
    end

    local function colour_add_edition (self, card, area, copier, edition)
		if not (self and card) then return false end
		for i=1, card.ability.val do
			MadLib.simple_event(function()
				local temp_pool = MadLib.get_list_matches(G.hand.cards, function(v)
					return not v.edition
				end) or {}
				local backup_pool = MadLib.get_list_matches(G.hand.cards, function(v)
					return v.edition and not v.edition['rgmc_infernal']
				end) or {}

				local pool = (#temp_pool > 0 and temp_pool) or (#backup_pool > 0 and backup_pool)
				if pool then
					local eligible_card = pseudorandom_element(pool, pseudoseed(self.config.key))
					eligible_card:set_edition({ ['rgmc_infernal'] = true }, true)
					check_for_unlock({type = 'have_edition'})
					card:juice_up(0.3, 0.5)
				end
				return true
			end, 0.4, 'after')
		end
		return true
	end

	-- loc_var for Colours
    local function get_colour_loc_vars(self, info_queue, card)
		if not (self and card) then return end
		local val, max = get_progress_bar(card.ability.partial_rounds, card.ability.upgrade_rounds)
		return MadLib.collect_vars(card.ability.val, val, max, card.ability.upgrade_rounds)
	end

	-- Magnet: Monus + Ferrous.
	local function get_poker_hand_level()
		local phand = (G.GAME and G.STATE == G.STATES.HAND_PLAYED) and G.hand or G.play
		if not (phand and phand.highlighted and #phand.highlighted > 0) then return 0 end

		local text, loc_disp_text, poker_hands, scoring_hand, disp_text = G.FUNCS.get_poker_hand_info(phand.highlighted)
		--print(poker_hands[1])

		return G.GAME.hands[poker_hands[1]] and G.GAME.hands[poker_hands[1]].level or 0
	end

	MadLib.merge_lists(list, {
		MadLib.create_atlas('morefluff_colours', 'morefluff_colours.png'),
		MadLib.create_atlas('morefluff_colours_lunacy', 'morefluff_colours_lunacy.png'),
		MadLib.create_atlas('morefluff_enhance', 'morefluff_enhancements.png'),
		MadLib.create_square_atlas('morefluff_rotarots', 'morefluff_rotarots.png', 107),
		Madcap.Funcs.GetMusic('music_madcap_ticket',function()
			return G.GAME
				and G.GAME.modifiers.rgmc_deck
				and G.GAME.superboss_active
				and 24
		end)
	}, 0.8, true)

    -- Carnation Pink: Converts suits to Goblets.
	local carnation_pink = {
		key = "carnation_pink",
		config = { val = 0, partial_rounds = 0, upgrade_rounds = 1, },
		cost = 4,
		can_use = colour_can_use(self,card),
		use = colour_convert_suit(self, card, area, copier, 'rgmc_goblets'),
		loc_vars = get_colour_loc_vars(self, info_queue, card),
	}

    -- Cobalt Blue: Converts suits to Towers.
	local cobalt_blue = {
		key = "cobalt_blue",
		config = { val = 0, partial_rounds = 0, upgrade_rounds = 1, },
		cost = 4,
		can_use = colour_can_use(self,card),
		use = colour_convert_suit(self, card, area, copier, 'rgmc_towers'),
		loc_vars = get_colour_loc_vars(self, info_queue, card),
	}

    -- Olive Green: Converts suits to Blooms.
	local olive_green = {
		key = "olive_green",
		config = { val = 0, partial_rounds = 0, upgrade_rounds = 1, },
		cost = 4,
		can_use = colour_can_use(self,card),
		use = colour_convert_suit(self, card, area, copier, 'rgmc_blooms'),
		loc_vars = get_colour_loc_vars(self, info_queue, card),
	}

    -- Venetian Red: Converts suits to Daggers
	local venetian_red = {
		key = "venetian_red",
		config = { val = 0, partial_rounds = 0, upgrade_rounds = 1, },
		cost = 4,
		can_use = colour_can_use(self,card),
		use = colour_convert_suit(self, card, area, copier, 'rgmc_daggers'),
		loc_vars = get_colour_loc_vars(self, info_queue, card),
	}

    -- Celestial Blue: Creates a Negative Cosma Tarot.
	local celestial_blue = {
		key = "celestial_blue",
		config = { val = 0, partial_rounds = 0, upgrade_rounds = 3, },
		cost = 4,
		can_use = colour_can_use(self,card),
		use = colour_add_consumable(self, card, area, copier, 'CosmaTarot'),
		loc_vars = get_colour_loc_vars(self, info_queue, card),
	}

	-- Torch Red: Converts cards to Infernal edition (1 in 4 chance to torch burn card instead)
	local torch_red = {
		key = "torch_red",
		config = { val = 0, partial_rounds = 0, upgrade_rounds = 4, odds = 3 },
		cost = 4,
		loc_vars = function(self, info_queue, card)
			-- has odds, unlike most colour cards. bad!
			local val, max = get_progress_bar(card.ability.partial_rounds, card.ability.upgrade_rounds, MadLib.base_prob(card), card.ability.odds)
			return MadLib.collect_vars(card.ability.val, val, max, card.ability.upgrade_rounds)
		end,
		can_use = colour_can_use(self,card),
		use = function(self, card, area, copier)
			for i=1, card.ability.val do
				MadLib.simple_event(function()
					local temp_pool = MadLib.get_list_matches(G.hand.cards, function(v)
						return not v.edition
					end) or {}
					local backup_pool = MadLib.get_list_matches(G.hand.cards, function(v)
						return v.edition and not v.edition['rgmc_infernal']
					end) or {}

					local pool = (#temp_pool > 0 and temp_pool) or (#backup_pool > 0 and backup_pool)
					if pool then
						local eligible_card = pseudorandom_element(pool, pseudoseed(self.config.key))
						if not MadLib.calculate_roll({ -- not 1 in X
							seed 	= self.key,
							denom 	= self.config.extra.odds
						}) then
							eligible_card:set_edition({ ['rgmc_infernal'] = true }, true)
							check_for_unlock({type = 'have_edition'})
						else
							eligible_card:start_dissolve({G.C.RED}, nil, 1.6) -- roll failed...
						end
						card:juice_up(0.3, 0.5)
					end
					return true
				end, 0.4, 'after')
			end
		end
	}

	-- Rose Gold: Create a ?!? tag for every [Y] rounds.
	local rose_gold = {
		key = "rose_gold",
		config = { val = 0, partial_rounds = 0, upgrade_rounds = 4, },
		cost = 4,
		can_use = colour_can_use(self,card),
		use = colour_add_tag(self, card, area, copier, 'rgmc_rainbow'),
		loc_vars = get_colour_loc_vars(self, info_queue, card),
	}

	-- Iridescent Indigo: Creates a Sleeping Ships for every 8 rounds.
	local iridescent_indigo = {
		key = "iridescent_indigo",
		config = { val = 0, partial_rounds = 0, upgrade_rounds = 8, },
		cost = 4,
		can_use = colour_can_use(self,card),
		use = colour_add_consumable_exact(self, card, area, copier, 'rgmc_sleeping_ships'),
		loc_vars = get_colour_loc_vars(self, info_queue, card),
	}

	-- Adds [X] Mayhem for every [Y] points.
	local sugar_plum = {
		key = "sugar_plum",
		config = { val = 0, partial_rounds = 0, upgrade_rounds = 3, extra = 0.5 },
		cost = 4,
		can_use = colour_can_use(self,card),
		use = function(self, card, area, copier)
			-- do more with this
			for i=1, card.ability.val do
				Madcap.Funcs.ease_mayhem(card.ability.extra, i==card.ability.val)
			end
		end,
		loc_vars = get_colour_loc_vars(self, info_queue, card),
	}

	-- Color of Lunacy: Temporarily sets Mayhem to maximum for [X] hands for every [Y] points.
	local lunacy = {
		key = "lunacy",
		-- custom atlas, woo!
		atlas = "morefluff_colours_lunacy",
		pos = MLIB.coords(0,4),
		config = { val = 0, partial_rounds = 0, upgrade_rounds = 3, },
		cost = 12,
		can_use = colour_can_use(self,card),
		use = function(self, card, area, copier)
			--n_random_colour_rounds(card.ability.val)
		end,
		loc_vars = get_colour_loc_vars(self, info_queue, card),
	}

	-- ???: Create a Sinister Card for every X rounds held.
	-- ???: Converts suits to Voids.
	-- ???: Converts suits to Lanterns.
	-- ???: Make a Gimmick Tag.
	-- ???: Make a SPAM!
	-- ???: Apply random enhancement to a random card
	-- ???: Create a random playing card
	-- ???: Apply Chrome to random Joker
	-- ???: Level up Dark subhand
	-- ???: Level up Light subhand
	-- ???: Random Chip Joker
	-- ???: Random Mult Joker

	-- Load the colors
	Madcap.Funcs.LoadConsumables({
		carnation_pink,
		cobalt_blue,
		olive_green,
		venetian_red,
		celestial_blue,
		torch_red,
		rose_gold,
		iridescent_indigo,
		sugar_plum,
		lunacy,
	}, 'Colour', list, 'morefluff_colours', 4, {
		display_size 	= { w = 71, h = 87 },
		pixel_size 		= { w = 71, h = 87 },
	})

	local magnet = {
		key = "magnet",
		config = { extra = { chips = 10, gain = 8 } },
		loc_vars = function(self, info_queue, card)
			return MadLib.collect_vars(self.config.extra.chips, self.config.extra.gain, self.config.extra.gain * get_poker_hand_level())
		end,
		calculate = function(self, card, context)
			if context.poker_hands then
				--print(context.poker_hands)
			end

			if context.cardarea == G.play and context.main_scoring then
				return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips,card.ability.extra.chips)
			end

			if context.playing_card_end_of_round and context.cardarea == G.hand then
				return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddChips,card,card.ability.extra.gain * get_poker_hand_level())
			end
		end,
		draw = function(self, card, layer)
			card.children.center:draw_shader("negative_shine", nil, card.ARGS.send_to_shader)
		end
	}

	local signal = {
		key = "signal",
		config = { extra = { mult = 2, gain = 1 } },
		loc_vars = function(self, info_queue, card)
			return MadLib.collect_vars(self.config.extra.mult, self.config.extra.gain, self.config.extra.gain * get_poker_hand_level())
		end,
		calculate = function(self, card, context)
			if context.cardarea == G.play and context.main_scoring then
				return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card.ability.extra.mult)
			end

			if context.playing_card_end_of_round and context.cardarea == G.hand then
				return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.gain * get_poker_hand_level())
			end
		end,
		draw = function(self, card, layer)
			card.children.center:draw_shader("negative_shine", nil, card.ARGS.send_to_shader)
		end
	}

	local crystaltine = {
		key = "crystaltine",
		config = { extra = { x_chips = 1.1, gain = 0.1 } },
		loc_vars = function(self, info_queue, card)
			return MadLib.collect_vars(self.config.extra.x_chips, self.config.extra.gain, self.config.extra.gain * get_poker_hand_level())
		end,
		calculate = function(self, card, context)
			if context.cardarea == G.play and context.main_scoring then
				return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiChips, card.ability.extra.x_chips)
			end

			if context.playing_card_end_of_round and context.cardarea == G.hand then
				return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.MultiChips, card, card.ability.extra.gain * get_poker_hand_level())
			end
		end,
		draw = function(self, card, layer)
			card.children.center:draw_shader("negative_shine", nil, card.ARGS.send_to_shader)
		end
	}

	Madcap.Funcs.LoadEnhancements({
		magnet,
		signal,
		crystaltine
	}, list, 'morefluff_enhance', 4)

	-- NEW ROTAROT CARDS!

	-- Girder!
	-- Magnet (Ferrous + Monus)
	local girder = {
		key = "rot_girder",
		config = { max_highlighted = 2, mod_conv = 'm_rgmc_magnet' },
		cost = 4,
		loc_vars = get_enhancement_tarot_loc_vars(self, info_queue, card),
		can_use = consumable_highlight_check(self, card)
	}

	-- Filament!
	-- Signal (Wolfram + Cult)
	local filament = {
		key = "rot_filament",
		config = { max_highlighted = 2, mod_conv = 'm_rgmc_signal' },
		cost = 4,
		loc_vars = get_enhancement_tarot_loc_vars(self, info_queue, card),
		can_use = consumable_highlight_check(self, card)
	}

	-- Polish!
	-- Crystaltine (Lustrous + Teal)
	local polish = {
		key = "rot_polish",
		config = { max_highlighted = 2, mod_conv = 'm_rgmc_crystaltine' },
		cost = 4,
		loc_vars = get_enhancement_tarot_loc_vars(self, info_queue, card),
		can_use = consumable_highlight_check(self, card)
	}

	-- Load the Rotarots
	Madcap.Funcs.LoadConsumables({
		girder,
		filament,
		polish
	}, 'Rotarot', list, 'morefluff_rotarots', 4, {
		display_size 	= { w = 107, h = 107 },
	})

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
