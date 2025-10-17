function Madcap.Funcs.get_mayhem()
	return G.GAME and G.GAME.mayhem or 0
end

function Madcap.Funcs.get_max_mayhem()
	return G.GAME and G.GAME.max_mayhem or 10
end

function Madcap.Funcs.get_mayhem_state()
	local mayhem = (G.GAME.mayhem or 0)

	local mayhem_state = 0
	if mayhem > 9 then
		mayhem_state = 3
	elseif mayhem >= 6 then
		mayhem_state = 2
	elseif mayhem >= 3 then
		mayhem_state = 1
	end

	return mayhem_state
end

function Madcap.Funcs.read_mayhem()
	tell('Mayhem is now ' .. tostring(G.GAME.mayhem) .. ' / ' .. tostring(G.GAME.max_mayhem) .. '.')
	tell('Mayhem State is now ' .. tostring(Madcap.Funcs.get_mayhem_state()) .. '.')
end

function Madcap.Funcs.ease_mayhem(_mod, _check, _silent, _instant)
	_mod = _mod or 0
    MadLib.simple_event(function()
        local round_UI = G.HUD:get_UIE_by_ID('mayhem_UI_count')
        local add_mayhem, lose_mayhem = to_big(_mod) > to_big(0), to_big(_mod) < to_big(0)

        local text  = add_mayhem and '+' or ''
        local col   = (add_mayhem and G.C.RGMC_MAYHEM) or (lose_mayhem and G.C.RED) or G.C.FILTER

		if (G.GAME.mayhem + _mod) > G.GAME.max_mayhem then
        	_mod = _mod - (G.GAME.mayhem + _mod - G.GAME.max_mayhem)
        end
		if _mod == 0 then return end

		if round_UI then
            G.HUD:recalculate()
            if MadLib.is_animation_enabled() then
                attention_text({
                    text            = text .. tostring(_mod),
                    scale           = 0.75,
                    hold            = _instant and 0 or 0.7,
                    cover           = round_UI.parent,
                    cover_colour    = col,
                    align           = 'cm',
                })
            end
        end

		G.GAME.mayhem			= G.GAME.mayhem + _mod
		local mayhem_state 		= Madcap.Funcs.get_mayhem_state(recalculate)
		local sound 			= 'rgmc_mayhem_t' .. tostring(math.max(1,math.min(3,mayhem_state)))

        --Play a SPOOKY noise sound
        if MadLib.is_animation_enabled() and not _silent then
            if lose_mayhem then
                play_sound('rgmc_mayhem_down', 0.8)
                --play_sound('timpani')
			elseif add_mayhem then
				if mayhem_state > G.GAME.mayhem_state then
					play_sound(sound)
					delay(2.0)
				else
					--play_sound('timpani')
					play_sound('rgmc_mayhem_up', 0.8)
				end
            end
        end

		if mayhem_state ~= G.GAME.mayhem_state then
			G.GAME.mayhem_state = mayhem_state
		end

        SMODS.calculate_context({ mayhem_changed = G.GAME.mayhem })
        if _check then Madcap.Funcs.read_mayhem() end -- does post-setting calculations (if requested)
        return true
    end, 0.5, 'immediate')
    return true
end

function Madcap.Funcs.set_mayhem(_mod, _check, _silent,_instant)
    local _diff = (_mod or G.GAME.mayhem) - G.GAME.mayhem
	if _diff < -G.GAME.mayhem then _diff = -G.GAME.mayhem end
    return Madcap.Funcs.ease_mayhem(_diff, _check, _silent, _instant)
end

function Madcap.Funcs.handle_glass_card_scoring(card)
    local dead = not card.debuff and pseudorandom('glass') < G.GAME.probabilities.normal/card.ability.extra
	--print('Glass card is ' .. (dead and 'dead' or 'alive') .. '.')
    return dead -- if the card would be dead, then let the game know
end

function Madcap.Funcs.get_mayhem_data()

	-- Get stuff from cards
	local voids,lanterns,modded_suits, base_suits,enhancements,editions,seals = 0,0,0,0,0,0,0
	local suits,ranks = {},{}
	MadLib.loop_func(G.playing_cards, function(v)
		-- Voids add more Mayhem than other suits.
		suits[v.base.suit] 	= true
		ranks[v.base.value] = true

		local check_modded = true
		if v:is_suit('rgmc_voids') then
			voids = voids + 1
			check_modded = false
		end
		-- Lanterns reduce mayhem despite being a modded suit.
		if v:is_suit('rgmc_lanterns') then
			lanterns = lanterns + 1
			check_modded = false
		end
		-- Modded suits add Mayhem, Base suits reduce it
		if check_modded and not MadLib.list_matches_one(MadLib.SuitTypes.Base, function(s)
			return v:is_suit(s)
		end) then
			modded_suits = modded_suits + 1 -- goblets/towers/blooms/daggers/etc.
		else
			base_suits = base_suits + 1 -- hearts/diamonds/spades/clubs
		end

		if v.config.center.key ~= 'c_base' then -- has an enhancement
			enhancements = enhancements + 1
		end
		if v.edition then -- has an edition
			editions = editions + 1
		end
		if v.seal then -- has a seal
			seals = seals + 1
		end
	end)

	-- How many cards does the player have?
	local card_offset = math.abs(#G.playing_cards - Madcap.Funcs.get_starting_deck_size())
	local suit_offset = math.abs(#suits - 4)

	-- How many cards does the player have?
	local jokers = (G.jokers and #G.jokers.cards) or 0

	return {
		voids 			= { amount = voids, mult = 1/50 },
		lanterns 		= { amount = lanterns, mult =  -1/100 },
		modded_suits 	= { amount = modded_suits, mult = 1/100 },
		base_suits		= { amount = base_suits, mult = -1/200 },
		enhancements	= { amount = enhancements, mult = 1/20 },
		editions		= { amount = editions, mult = 1/10 },
		seals			= { amount = seals, mult = 1/40 },
		card_offset		= { amount = card_offset, mult = 1/100 },
		suit_offset		= { amount = suit_offset, mult = 1/40 },
		jokers			= { amount = jokers, mult = 1/40 }
	}

end

function Madcap.Funcs.calculate_mayhem_add()
	-- Mayhem decay
	local mayhem = G.GAME.mayhem or 0
	local max_mayhem_mult = 1.1
	local mayhem_decay = G.GAME.mayhem_decay or 0.85

	local total = 0
	local data = Madcap.Funcs.get_mayhem_data() -- done this way so other mods can add on

	MadLib.loop_table(data, function(k,v)
		total = total + (v.amount * v.mult)
		tell(k .. ' - Add ' .. tostring(v.amount) .. ' * ' .. tostring(v.mult))
	end)

	local mayhem_add = MadLib.round(MadLib.clamp(total, -5, 5), 2)
	tell('+Mayhem is ' .. tostring(mayhem_add) .. '.')
	return mayhem_add
end

function Madcap.Funcs.blind_end_mayhem_check()

	Madcap.Funcs.ease_mayhem(Madcap.Funcs.calculate_mayhem_add())
	local mayhem_state = G.GAME.mayhem_state or 0 -- set state if NIL
	Madcap.Funcs.read_mayhem()

	local args

	-- state 1: randomize values
	if mayhem_state > 0 then
		MadLib.loop_func(G.playing_cards, function(v,i)
			Madcap.Funcs.mayhemize(v, args, true)
		end)

		MadLib.loop_func(G.jokers.cards, function(v,i)
			Madcap.Funcs.mayhemize(v, args)
		end)
	end
end

function Madcap.Funcs.get_mayhem_multiplier(mayhem)
    local t = MadLib.clamp(mayhem / 10, 0, 1)
    -- Use an easing function to skew the curve toward the high end
    local eased = t ^ 2.2  -- You can adjust this exponent for fine-tuning
	local min_mult = 1 / (8 ^ eased)
    local max_mult = 8 ^ eased
    -- Random multiplier within that range
    return math.random() * (max_mult - min_mult) + min_mult
end

local mayhemize_funcs = {
	['joker_slots'] 	= mfuncs.change_joker_slots,
	['booster_limit'] 	= mfuncs.change_booster_limit,
	['voucher_limit'] 	= mfuncs.change_voucher_limit,
	['extra_choices'] 	= mfuncs.change_extra_choices,
	['max_mayhem'] 		= function(_old,_new)
		if _new == _old then return false end
		G.GAME.max_mayhem = (G.GAME.max_mayhem or 10) + (_new - _old)
		return true
	end,
	['add_mayhem'] = function(_old,_new)
		if _new == _old then return false end
		Madcap.Funcs.ease_mayhem(_new - _old)
		return true
	end,
	['rift_limit'] 		= function(_old,_new)
		if _new == _old then return false end
		G.GAME.rift_limit = (G.GAME.rift_limit or 10) + (_new - _old)
		return true
	end,
	['hand_size'] 		= mfuncs.change_hand_size,
	['handsize'] 		= mfuncs.change_hand_size,
	['h_size'] 			= mfuncs.change_hand_size,
	['h_mod']			= mfuncs.change_hand_size,
	['consumable_limit'] = mfuncs.change_consumable_limit,
	['holygrail']		= function(_old,_new)
		mfuncs.change_hand_size(_old,_new)
		mfuncs.change_consumable_limit(_old,_new)
		mfuncs.change_booster_limit(_old,_new)
	end
}

function Madcap.Funcs.can_mayhemize_value(_level,_type)
	local level_check = _level <= mfuncs.get_mayhem_state()

	return level_check
end

function Madcap.Funcs.mayhemize_table(_card, _table, _args)
	-- loop through the table
	local success = false
	MadLib.loop_table(_table, function(k,v)
		-- is this a blacklisted term?
		if Madcap.MayhemBlacklist[k] == nil then -- not blacklisted
			if type(v) == 'table' then -- we must go deeper
				Madcap.Funcs.mayhemize_table(_card, v, _args)

			elseif type(v) == 'number' then -- do the number
				local _prefix = string.sub(_card.config.center.key,1,2)
				local _type = (_prefix == 'j_') and 'joker'
					or (_card.config.center.key == 'c_base' or _prefix == 'm_') and 'card'
				local _xval

				local _key = k ~= 'extra' and k and string.lower(k)
				local _data

				if Madcap.DefineExtras[_card.config.center.key] then
					--tell('Finding extra value...')
					_data = Madcap.DefineExtras[_card.config.center.key][k]
				else
					_data = Madcap.MayhemConversions[_key]
				end
				_xval = (_data and _data.multiply)

				if
					not _data -- no data
					or (not _xval and v == 0) 			-- additive value at 0.00
					or (_xval and v == 1 or v == 0)		-- multiplying value at 1.00 (or 0.00)
				then
					return false
				end -- don't bother if multiplying value and not set
				--tell('Key ' .. k .. ' explored!')

				local factor = (_data and _data.factor) or 1
				local must_round = (_data and _data.round or false)
				local nu_min, nu_max = MadLib.deep_copy(_args.min), MadLib.deep_copy(_args.max)
				local center, half_range = (nu_min + nu_max) / 2, math.abs(nu_max - nu_min) / 2 * factor
				nu_min, nu_max = center - half_range, center + half_range

				local _mult = MadLib.random_between(nu_min, nu_max, 2)
				--if _xval then tell('This is an multiplying value!') end

				local _base = v - (_xval and 1 or 0)
				_table[k] = MadLib.round((_base * _mult) + (_xval and 1 or 0), must_round and 0 or 2)

				if _data and _data.type and mayhemize_funcs[_data.type] then
					mayhemize_funcs[_data.type](v,_table[k])
				end
				success = true

				--tell(tostring(k)..' is now '..tostring(_table[k])..' ('..tostring(v)..').')
			end -- don't mess with bools and strings.
		end
	end)
	return success
end

-- Messes up the values of the targeted cards based on
function Madcap.Funcs.mayhemize(_card, _args, _silent)
	local low_mult 		= (_args and _args.min_mult) or (1/2)
	local high_mult		= (_args and _args.max_mult) or 2
	local mayhem_state	= mfuncs.get_mayhem_state()
	local arguments 	= { min	= low_mult, max	= high_mult }

	if not (_args and _args.force_values) then
		local limits = (mayhem_state < 1 and 2)
			or (mayhem_state < 2 and 4)
			or (mayhem_state < 3 and 8)
			or 12
		--tell('Limit is ' .. tostring(limits))
		low_mult	= low_mult * limits
		high_mult	= high_mult / limits
	end

	local success = Madcap.Funcs.mayhemize_table(_card, _card.ability, arguments)
	-- loop through each
	-- max mayhem (10 has between x1/8 and x8 mult)
	-- 0 mayhem is x1 mult
	if not _silent then
		MadLib.simple_event(function()
        	_card:juice_up(0.3, 0.4)
        	play_sound("rgmc_mayhemize")
			return true
		end, 0.1, 'after')
	end
	return _card
end

function Card:is_void()
	return self.base.suit == 'rgmc_voids'
end

function Card:is_lantern()
	return self.base.suit == 'rgmc_lanterns'
end

function Madcap.Funcs.clamp_mayhem(m)
	local mod = m + 0
	local mayhem, max_mayhem = G.GAME.mayhem or 0, G.GAME.max_mayhem or 10
	return (mayhem + mod > 0 and mayhem + mod <= max_mayhem) and m or (mod < 0) and -mayhem or (max_mayhem - mayhem)
end

function Card:get_mayhem()
	if self:is_void() then
		return 0.1
	elseif self:is_lantern() then
		return -0.1
	else
		return 0
	end
end

-- Checks cards before scoring
function Madcap.Funcs.check_eval_card(card,i)
	--G.GAME.blind_stats = G.GAME.blind_stats or {}
	if not SMODS.has_no_suit(card) then -- has a suit
		table.insert(G.GAME.blind_stats.suits, card.base.suit)
	end
	if not SMODS.has_no_rank(card) then -- has a rank
		table.insert(G.GAME.blind_stats.ranks, card.base.value)
	end

	-- handle mayhem stuff
	if card:is_void() then
		local mayhem_gain = card:get_mayhem()
		local eval = {
			message = '+' .. tostring(mayhem_gain) .. ' M!',
			colour = G.C.RED,
			func = function()
				Madcap.Funcs.ease_mayhem(mayhem_gain)
			end
		}
		card_eval_status_text(card, "extra", nil, nil, nil, eval)
	elseif card:is_lantern() then
		local mayhem_loss = card:get_mayhem()
		local eval = {
			message = tostring(mayhem_loss) .. ' M!',
			colour = G.C.RED,
			func = function()
				Madcap.Funcs.ease_mayhem(mayhem_loss)
			end
		}
		card_eval_status_text(card, "extra", nil, nil, nil, eval)
	end
end
