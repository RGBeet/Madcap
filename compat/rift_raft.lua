local list = {} -- loads a blank list if mod is not added
local mod_id, mod_name = "RiftRaft", "Rift-Raft"
local loaded = mod_loaded(mod_id)

if loaded then -- load the items

	-- Make a table for Rift Raft specific variables.
	Madcap.RiftRaft = {}
	Madcap.RiftRaft.HighCost = {
		'c_soul',
		'c_black_hole'
	}
	
	-- Gets whether the card cand be rifted
	function Madcap.Funcs.get_riftability(_card)
		if not _card or type(_card) ~= 'table' then return false end
		local _cost = _card.cost or 0

		-- High-rarity Jokers (higher than Rare, which has a 3.0 rarity rating) 
		-- and items in the "high-cost list" are twice as expensive
		local high_cost = MadLib.list_matches_one(Madcap.RiftRaft.HighCost, function(v)
			return _card.config.center.key == v
		end)
		local _rarity = _card.config.center.rarity and MadLib.get_rarity_value(_card.config.center.rarity) or -1
		if _rarity > 3 or high_cost then _cost = _cost * 2 end

		if _cost > 0 and (to_big(G.GAME.dollars) - to_big(cost) < to_big(G.GAME.bankrupt_at)) then
			return false
		end
		
		return true
	end

	
	-- Gets the "number of cards rifted"
	function Madcap.Funcs.get_rift_amount()
		return G.GAME.cards_rifted and G.GAME.cards_rifted.blind or 0
	end

	-- Gets the rifting limit.
	function Madcap.Funcs.get_rift_limit()
		local _limit = G.GAME.rift_limit
		-- add onto the limit when mayhem is higher.
		if G.GAME.MayhemState > 2 then -- 100% higher limit
			_limit = math.floor(_limit * 2)
		elseif G.GAME.MayhemState > 1 then -- 50% higher limit
			_limit = math.floor(_limit * 1.5)
		end
		return _limit
	end

	-- Revamp the update_text_state function to include new mechanics.
	function RIFTRAFT.VoidCardArea:update_text_state()
		self.children.text:remove_group()
		local text = {
			type = 'variable', 
			key = "k_riftraft_send"
		}

		local scale = 0.4
		if mfuncs.get_rift_limit() == mfuncs.get_rift_amount() then -- rifting limit is reached
			text.type = 'k_riftraft_limit_reached'
		elseif self.selecting_soul then -- selected an unriftable card
			text.type = 'k_riftraft_nope'
			scale = 0.75
		elseif self.selecting_shop then -- shop rifting moment
			local cost = 0
			local shop_card = (G.shop_jokers and G.shop_jokers.highlighted and G.shop_jokers.highlighted[1])
							or (G.shop_booster and G.shop_booster.highlighted and G.shop_booster.highlighted[1])
							or (G.shop_vouchers and G.shop_vouchers.highlighted and G.shop_vouchers.highlighted[1])
			if shop_card then
				cost = shop_card.cost
				if RIFTRAFT.allow_buy_always and not G.GAME.used_vouchers.v_riftraft_riftshop_send then cost = math.max(cost*2, 1) end
			end
			text.type = 'k_riftraft_buy'
		end
		
		self.text_node = simple_text_container(text, {scale = scale, colour = HEX("6b8286"), shadow = true})
		self.children.text:add_child({n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes = {self.text_node}})
		self.children.text:hard_set_VT()
	end

	-- Revamp the can_send function to include new mechanics.
	function RIFTRAFT.VoidCardArea:can_send()
		self.selecting_shop = false
		self.selecting_soul = false
		local send_card = nil
		local cost = 0

		-- check rift limit
		if G.GAME.cards_rifted.blind >= G.GAME.rift_limit then
			self.limit_reached = true 
			return false
		elseif self.limit_reached then
			self.limit_reached = false
		end

		if  -- shop stuff
			G.STATE == G.STATES.SHOP 	
			and (G.GAME.used_vouchers.v_riftraft_riftshop_send or RIFTRAFT.allow_buy_always) 
		then
			-- card cost
			send_card = (G.shop_jokers and G.shop_jokers.highlighted and G.shop_jokers.highlighted[1])
					or (G.shop_booster and G.shop_booster.highlighted and G.shop_booster.highlighted[1])
					or (G.shop_vouchers and G.shop_vouchers.highlighted and G.shop_vouchers.highlighted[1])
			if not send_card then return false end
			self.selecting_shop = true
			cost = send_card.cost

			-- send to uhhh place
			if 
				RIFTRAFT.allow_buy_always 
				and not G.GAME.used_vouchers.v_riftraft_riftshop_send
			then 
				cost = math.max(cost*2, 1)
			end
		else
			if 
				not (G.STATE == G.STATES.TAROT_PACK
       	 			or G.STATE == G.STATES.SPECTRAL_PACK
        			or G.STATE == G.STATES.PLANET_PACK
        			or G.STATE == G.STATES.BUFFOON_PACK
        			or (RIFTRAFT.negative_playing_cards and G.STATE == G.STATES.STANDARD_PACK)
        			or (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and not RIFTRAFT.in_void_pack()))
        	then 
				return false 
			end
        	send_card = G.pack_cards and G.pack_cards.highlighted and G.pack_cards.highlighted[1]
        	if not send_card then return false end
    	end
		
		-- can't rift if not riftable
    	if mfuncs.get_riftability(send_card) == false then
        	self.selecting_shop = false; 
			self.selecting_soul = true; 
			return false
    	end

		-- can't rift from void?
    	if send_card.ability.riftraft_from_void then
        	self.selecting_shop = false
			return false
    	end

		-- can't rift playing cards (if disabled)
   	 	if 
			(not send_card.ability.consumeable) 
			and (send_card.config.center.set ~= 'Joker')
    		and (not RIFTRAFT.negative_playing_cards 
				or (send_card.config.center.set ~= 'Default' 
				and send_card.config.center.set ~= 'Enhanced')) 
		then
        	self.selecting_shop = false
			return false
    	end

		-- can't void rift cards
		if send_card.config.center.set == 'Rift' then
			self.selecting_shop = false
			return false
		end

		return true
	end

	local should_show_ref = RIFTRAFT.VoidCardArea.should_show
	function RIFTRAFT.VoidCardArea:should_show()
		return should_show_ref(self)
		-- don't show in any high-level packs
	end

	local get_starting_params_ref = get_starting_params
	function get_starting_params()
		local params = get_starting_params_ref()

		params.rift_limit = 3

		return params
	end

	-- Update to include Rift-Raft stuff
	local run_start_ref = mfuncs.run_start
	function Madcap.Funcs.run_start()
		G.GAME.rift_limit = G.GAME.starting_params.rift_limit or 3
		G.GAME.cards_rifted = {
			run 	= 0,
			ante 	= 0,
			blind 	= 0
		}
		run_start_ref()
	end

	local ante_start_ref = mfuncs.ante_start
	function Madcap.Funcs.ante_start()
		ante_start_ref()
		G.GAME.cards_rifted.ante = 0
	end

	local blind_start_ref = mfuncs.blind_start
	function Madcap.Funcs.blind_start()
		blind_start_ref()
		G.GAME.cards_rifted.blind = 0
	end

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

	-- NEW JOKERS
	local rr_j_webdings = {
		key = 'webdings',
    	atlas   = 'placeholder',
    	pos     = {x = 0, y = 0},
    	rarity  = 2,
    	cost    = 6,
		config = { extra = { mult = 0, mult_mod = 3 } },
    	demicoloncompat     = true,
		loc_vars = function(self, info_queue, card)
			return MadLib.collect_vars(card.ability.extra.mult)
		end,
		calculate = function(self, card, context)
			-- gain +mult
			if context.remove_from_void then
            	return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult_mod)
			end
			-- +mult time
			if context.joker_main or context.forcetrigger then
				return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
			end
		end
	}

	local rr_j_invert = {
		key 	= 'invert',
    	atlas   = 'placeholder',
    	pos     = {x = 0, y = 0},
    	rarity  = 3,
    	cost    = 8,
		config = { extra = { odds = 3 } },
		calculate = function(self, card, context)
        	if 
				(context.buying_card or context.getting_booster_card) 
				and not context.blueprint
            	and Madcap.Funcs.calculate_card_odds(card, 'invert')
			then
				--basically just copies mimicry lol
				local _card = context.card
				if _card then
  	 	 	 		local new_card = copy_card(_card, nil, nil, nil, true)
        			new_card:add_to_deck()
        			
					local added_playing = {}
        			if new_card.ability.consumeable then
            			G.consumeables:emplace(new_card)
            			new_card:hard_set_VT()
            			new_card:start_materialize()
        			elseif new_card.ability.set == "Default" or new_card.ability.set == "Enhanced" then
            			G.deck.config.card_limit = G.deck.config.card_limit + 1
            			table.insert(G.playing_cards, new_card)
            			table.insert(added_playing, new_card)
            			G.riftraft_rifthand:emplace(new_card)
            			new_card:start_materialize()
						MadLib.simple_event(function()
							draw_card(G.riftraft_rifthand, G.deck, nil,'down', nil, new_card, 0.08)
							return true
						end, 0.1, 'after')
        			elseif new_card.ability.set == "Joker" then
            			G.jokers:emplace(new_card)
            			new_card:hard_set_VT()
            			new_card:start_materialize()
        			end
        			playing_card_joker_effects(added_playing)
				end
			end
		end
	}

	local rr_j_space_bar = {
		key		= 'space_bar',
    	atlas   = 'placeholder',
    	pos     = {x = 0, y = 0},
    	rarity  = 1,
    	cost    = 4,
		config = { extra = 2 },
        add_to_deck = function(self, card, from_debuff)
			G.GAME.rift_limit = G.GAME.rift_limit + (card.ability.extra or 2)
		end,
        remove_from_deck = function(self, card, from_debuff)
			G.GAME.rift_limit = G.GAME.rift_limit - (card.ability.extra or 2)
		end,
	}

	local rr_j_minus_world = {
		key 	= 'minus_world',
    	atlas   = 'placeholder',
    	pos     = {x = 0, y = 0},
    	rarity  = 2,
    	cost    = 6,
		config = { },
		calculate = function(self, card, context)
			if 
				context.add_to_void 
				and context.added -- table!
				and Madcap.Funcs.calculate_card_odds(card,'minus_world')
			then
				-- mayhemize the card
				Madcap.loop_func(context.added,function(v)
					Madcap.Funcs.mayhemize(v)
				end)
			end
		end
	}
	

	local get_rift_cards = function()
		return (G.riftraft_void and (#G.riftraft_void.cards + #G.riftraft_rifthand.cards) or 0)
	end

	--[[
		self.config.real_card_limit = (self.config.real_card_limit or self.config.card_limit) + delta
        self.config.card_limit = math.max(0, self.config.real_card_limit)
	]]

	local rr_j_think_therefore_ram = {
		key 	= 'think_therefore_ram',
    	atlas   = 'placeholder',
    	pos     = {x = 0, y = 0},
    	rarity  = 3,
    	cost    = 8,
		config = { immutable = { h_mod = 0 } },
		calculate = function(self, card, context)
			if 
				context.add_to_void
				and context.added
			then
				card.ability.immutable.h_mod = card.ability.immutable.h_mod + #context.added
				G.hand:change_size(#context.added)
			elseif
				context.remove_from_void
				and context.added
			then
				card.ability.immutable.h_mod = card.ability.immutable.h_mod - #context.added
				G.hand:change_size(-#context.added)
			end
		end,
        add_to_deck = function(self, card, from_debuff)
			card.ability.immutable.h_mod = get_rift_cards()
			G.hand:change_size(card.ability.immutable.h_mod)
		end,
        remove_from_deck = function(self, card, from_debuff)
			G.hand:change_size(-card.ability.immutable.h_mod)
		end,
	}

	local rr_j_purest_unobtanium = {
		key 	= 'purest_unobtanium',
    	atlas   = 'placeholder',
    	pos     = {x = 0, y = 0},
    	rarity  = 2,
    	cost    = 6,
		config = { extra = { odds = 2 } },
		calculate = function(self, card, context)
            if 
				context.end_of_round -- randomize suits/cards in void
				and G.riftraft_void
			then
                Madcap.loop_func(G.riftraft_void.cards, function(v,i)
            		if not Madcap.Funcs.calculate_card_odds(card, 'purest_unobtanium') then return false end
					if math.random()<0.5 then -- suit
        				local _suit = pseudorandom_element(SMODS.Suits, 'purest_unobtanium')
						MadLib.simple_event(function()
                    		assert(SMODS.change_base(v, _suit.key, nil))
							return true
						end, 0.1, 'after')
					else -- rank
        				local _rank = pseudorandom_element(SMODS.Ranks, 'purest_unobtanium')
						MadLib.simple_event(function()
                    		assert(SMODS.change_base(v, nil, _rank.key))
							return true
						end, 0.1, 'after')
					end
				end)
            end
		end,
	}

	function Madcap.Funcs.do_boosty_thing(boosty, context)
		if boosty.config.center.cry_digital_hallucinations then
			local conf = boosty.config.center.cry_digital_hallucinations
						
			MadLib.simple_event(function()
				conf.create()
				return true
			end, 0, 'before')

			card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil, { message = localize(conf.loc_key), colour = conf.colour })

			return nil, true
		end
		
		-- consumables
		local consums 	= { "Arcana", "Celestial", "Spectral" }
		local short1 	= { "tarot", "planet", "spectral" }
		local short2 	= { "Tarot", "Planet", "Spectral" }
		for i = 1, #consums do
			if boosty.ability.name:find(consums[i]) then
						
				MadLib.simple_event(function()
					local ccard = create_card(short2[i], G.consumeables, nil, nil, nil, nil, nil, "diha")
					ccard:set_edition({ negative = true }, true)
					ccard:add_to_deck()
					G.consumeables:emplace(ccard)
					return true
				end, 0, 'before')

				card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil, { message = localize("k_plus_" .. short1[i]), colour = G.C.SECONDARY_SET[short2[i]] })
				return nil, true -- this triggers BEFORE a retrigger joker and looks like jank. i can't get a message showing up without status text so this is the best option rn
			end
		end

		-- joker
		if boosty.ability.name:find("Buffoon") then
			MadLib.simple_event(function()
				local ccard = create_card("Joker", G.jokers, nil, nil, nil, nil, nil, "diha")
				ccard:set_edition({ negative = true }, true)
				ccard:add_to_deck()
				G.jokers:emplace(ccard)
				ccard:start_materialize()
				return true
			end, 0, 'before')

			card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil, { message = localize("k_plus_joker"), colour = G.C.FILTER })
			return nil, true
		end

		if boosty.ability.name:find("Standard") then
			MadLib.simple_event(function()
				local front = pseudorandom_element(G.P_CARDS, pseudoseed("diha_p"))
					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					local ccard = Card(
						G.play.T.x + G.play.T.w / 2,
						G.play.T.y,
						G.CARD_W,
						G.CARD_H,
						front,
						G.P_CENTERS.c_base,
						{ playing_card = G.playing_card })
						
					ccard:set_edition({ negative = true }, true)
					ccard:start_materialize({ G.C.SECONDARY_SET.Enhanced })
					G.play:emplace(ccard)
					playing_card_joker_effects({ ccard }) -- odd timing
					table.insert(G.playing_cards, ccard)
				return true
			end, 0, 'before')
			
			card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil, { message = localize("cry_plus_card"), colour = G.C.FILTER })

			MadLib.simple_event(function()
				G.deck.config.card_limit = G.deck.config.card_limit + 1
				return true
			end)
				
			draw_card(G.play, G.deck, 90, "up", nil)
			return nil, true
		end
	end

	local rr_j_evil_orbsman = {
		key 	= 'evil_orbsman',
    	atlas   = 'placeholder',
    	pos     = {x = 0, y = 0},
    	rarity  = 2,
    	cost    = 6,
		config = { },
		calculate = function(self, card, context)

			if
            	context.open_booster
				and Madcap.Funcs.calculate_card_odds(card, 'evil_orbsman')
			then
				Madcap.Funcs.do_boosty_thing(context.card, context)
			end
		end
	}

	local jokers = {
		rr_j_webdings,
		rr_j_invert,
		rr_j_space_bar,
		rr_j_minus_world,
		rr_j_think_therefore_ram,
		rr_j_purest_unobtanium,
	}

	for i=1, #jokers do
		jokers[i].object_type = "Joker"
		jokers[i].order = 1000+i-1
		jokers[i].unlocked = true
		list[#list+1] = jokers[i]
	end

	--[[
		List of NEW Rift cards:
		- +1 Voiding Limit
		playing cards
		- Add 3 random [enhanced playing cards] to Void
		- Add 2 playing cards of most common suit in Void
		consumables
		- Add 2 random [Cosma Tarots] to Void
		- Randomize values of [3 random consumables] in Void
		jokers
		- add a previously deleted OR skipped joker to the void
		- add 2 colors to the void
	]]

	-- NEW RIFT CARDS
	local rr_rc_void_limit = {
		key = "void_limit",
		loc_vars = function(self, info_queue, card)
        	return MadLib.collect_vars(card.ability.extra or 1)
		end,
		config = {
			extra = 1, -- voiding limit
		},
		pos = get_pos(0,1),
		cost = 7,
		in_pool = function(self, args)
			return false -- void only
		end,
		can_use = function(self, card)
			return true -- always
		end,
		use = function(self, card, area)
			G.GAME.rift_limit = G.GAME.rift_limit + 1
		end,
	}
	
	local rr_rc_enhanced_cards = {
		key = "enhanced_cards",
		loc_vars = function(self, info_queue, card)
        	return MadLib.collect_vars(card.ability.extra or 1)
		end,
		config = {
			extra = 2, -- number of random cards to add
		},
		pos = get_pos(0,1),
		cost = 7,
		in_pool = function(self, args)
			return false -- void only
		end,
		can_use = function(self, card)
			return true
		end,
		use = function(self, card, area)
			MadLib.number_func(card.ability.extra or 1, function(v)
				local _card = SMODS.create_card { 
					set = "Enhanced",
					seal = SMODS.poll_seal({ mod = 10 }), 
					area = G.hand
				}
            	G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            	_card.playing_card = G.playing_card
            	table.insert(G.playing_cards, _card)
			end)
		end,
	}

	local rr_rc_cosma_tarots = {
		key = "cosma_tarots",
		loc_vars = function(self, info_queue, card)
        	return MadLib.collect_vars(card.ability.extra or 1)
		end,
		config = {
			extra = 1, -- voiding limit
		},
		pos = get_pos(0,1),
		cost = 7,
		in_pool = function(self, args)
			return false -- void only
		end,
		can_use = function(self, card)
			return true -- always
		end,
		use = function(self, card, area)
			G.GAME.rift_limit = G.GAME.rift_limit + 1
		end,
	}

	-- Register all Rift Cards
	MadLib.loop_func({
		rr_rc_void_limit,
		rr_rc_enhanced_cards
	}, function(v, i)
		v.set 		= 'Rift'
		v.atlas 	= 'riftraft_riftcards'
		v.order 	= 100+i
		v.set_ability = function(self, card, initial, delay_sprites)
			if not card.edition then card:set_edition({negative = true}, true, true) end
		end
		Madcap.RiftCard(v)
	end)
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
