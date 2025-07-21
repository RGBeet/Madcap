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
	}

	local rr_j_invert = {
		key = 'invert',
	}

	local rr_j_space_bar = {
		key = 'space_bar',
	}

	local rr_j_minus_world = {
		key = 'minus_world',
	}

	local rr_j_think_therefore_ram = {
		key = 'think_therefore_ram',
	}

	local rr_j_purest_unobtanium = {
		key = 'purest_unobtanium',
	}

	local rr_j_evil_orbsman = {
		key = 'evil_orbsman',
	}

	function Madcap.Funcs.LoadJokers(_f,_t,_atlas,_args)
		if
			type(_f) ~= 'table'
			or type(_t) ~= 'table'
			or type(_atlas) ~= 'string'
			or (_args and type(_args) ~= 'table')
		then
			return false
		end
		-- should have key, rarity, and some sort of vars/calculation.
		MadLib.loop_func_list(_f,function(w,i)
			w.pos         		= w.pos or Madcap.Funcs.LoadCoords(w, i, (w.args and w.args.width or 0))
			w.order     		= (w.order or Madcap.Orders['Joker']) + (w.args and w.args.priority or 0)
			w.cost				= w.cost or 3 -- default price is $3
			w.unlocked			= w.unlocked or true
			w.discovered		= w.discovered or true
			-- sticker compat defaults to true unless stated otherwise
			w.eternal_compat	= w.eternal_compat or true
			w.perishable_compat = w.perishable_compat or true
			w.blueprint_compat 	= w.blueprint_compat or true,
			w.demicoloncompat	= w.demicoloncompat or false, -- must state demicolon compat!
			table.insert(_t,w)
		end)
	end

	Madcap.Funcs.LoadJokers({
		rr_j_webdings,
		rr_j_invert,
		rr_j_space_bar,
		rr_j_minus_world,
		rr_j_think_therefore_ram,
		rr_j_purest_unobtanium,
		rr_j_evil_orbsman
	}, list, 'jokers_riftraft',{
		priority = 1000 -- +1000 order
	})

	-- NEW RIFT CARDS
	local rr_rc_wavelength = {
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

	-- Register all Rift Cards
	MadLib.loop_func({
		rr_rc_wavelength
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
