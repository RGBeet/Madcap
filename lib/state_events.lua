-- Injected into start of run, regardless if Madcap is playing or not.
function Madcap.Funcs.run_start()
    tell('Run Start')

    G.GAME.subhands = {}
    G.GAME.subhand_minimum = (G.GAME.subhand_minimum or 5)
	G.GAME.dead_jokers = {}
    G.GAME.temp = {}

    for _,v in pairs(SubHands) do
        local k = v.name
        G.GAME.subhands[k] = {}
        G.GAME.subhands[k].level    	= 1
        G.GAME.subhands[k].mult     	= v.x_mult
        G.GAME.subhands[k].chips    	= v.x_chips
        G.GAME.subhands[k].l_mult   	= v.l_mult or 0.1
        G.GAME.subhands[k].l_chips  	= v.l_chips or 0.1
        G.GAME.subhands[k].enabled  	= false
        G.GAME.subhands[k].empower		= 0
    end

    local madcap_vals = {
		mayhem				= 0,
		mayhem_state		= 0,
		max_mayhem			= G.GAME.starting_params.add_max_mayhem or 10,
		rgmc_luxury_pts		= G.GAME.starting_params.rgmc_luxury_pts or 0,
		dead_jokers			= {},
		missed_jokers		= {},
        blinds_skipped      = 0,        -- number of blinds skipped
        boss_blinds         = 0,        -- number of boss blinds defeated
        showdown_blinds     = 0,        -- number of showdown blinds defeated
        x_value             = 10,       -- value of x cards (linked to wisteria chimes)
        temporary_hands     = 0,        -- hands you get when you run out
        temporary_discards  = 0,        -- discards you get when you run out
		max_temp_hands		= 5,
        max_temp_discards	= 5,
        last_enhancement    = nil,      -- used for chrome edition and ??? enhancement
        punisher_mode       = false,
        rank_dist           = nil,      -- used to see which
        force_poker_hand    = nil,      -- in case cryptid isnt here.
        pick_5              = nil,		-- TODO: readd pick 5 shit
        best_hand           = {
            score   = 0,
            hand    = {},   -- held in hand
            play    = {},   -- highlighted and played
            ante    = 0
        },
		potentias_used		= 0
    }
	MadLib.loop_table(madcap_vals, function(k,v) G.GAME[k] = v end)

	-- Silently add mayhem if deck starts with more mayhem
	if G.GAME.starting_params.add_mayhem then
		Madcap.Funcs.ease_mayhem(G.GAME.starting_params.add_mayhem, true, false, true)
		Madcap.Funcs.read_mayhem()
	end

	-- Borrowed from Bunco
    G.GAME.Exotic = G.GAME.Exotic or false -- Used for exotic suits and ranks?

    -- Challenge rules.
    if G.GAME.modifiers['rgmc_rule_waveworx'] then -- Reduce all hands but Straight to Level 0
		MadLib.loop_table(G.GAME.hands, function(k,v)
			if k ~= 'Straight' then
				v.level = 0
				v.chips = math.floor(v.chips/2)
				v.mult 	= math.floor(v.mult/2)
				v.hidden = true
			else
				v.level = 2
				v.chips = v.chips + v.l_chips
				v.mult 	= v.mult + v.l_mult
			end
		end)
	elseif G.GAME.modifiers['rgmc_rule_halved_interest'] then
		G.GAME.interest_amount = MadLib.round(G.GAME.interest_amount/2, 1)
	end
end

-- Upon winning the blind...
function Madcap.Funcs.blind_end()

    -- end of blind
    tell('Blind End')

	-- Remove round
	if G.GAME.rgmc_sinister then
		MadLib.loop_table(G.GAME.rgmc_sinister, function(k,v)
			v.rounds = v.rounds - 1
			-- cash out
			if v.rounds <= 0 then
				if v.money then ease_dollars(v.money or 5) end
				if v.consumeable then G.consumables:change_size(v.consumeable or 1) end
				MadLib.simple_event(function()
					play_sound('timpani',1.2)
					return true
				end, 0.1, 'after')
				G.GAME.rgmc_sinister[k] = nil -- we are done
				return true
			end
		end)
	end

	-- Do a mayhem check
	if G.GAME.mayhem and G.GAME.mayhem > 0 then
		Madcap.Funcs.blind_end_mayhem_check() -- done in case others want to edit this function
	end

    if
        G.GAME.blind
        and G.GAME.blind.boss
    then
        G.GAME.boss_blinds = G.GAME.boss_blinds + 1
        if G.GAME.blind.boss and Madcap.Funcs.is_finisher_ante() then G.GAME.showdown_blinds = G.GAME.showdown_blinds + 1 end
    end

    if G.GAME.punisher_mode then
        G.GAME.punisher_mode = false
    end

end

-- Upon starting an ante
function Madcap.Funcs.ante_start()
    -- start of ante
    tell('Ante Start')

	local blinds = {'Small', 'Big', 'Boss'}

	G.GAME.ante = {
		hands			= 0,	-- hands played
		discards		= 0,	-- discards played
		purchases		= 0,	-- shop purchases / booster items chosen
		hand_types 		= {}, 	-- hand types played
		suits 			= {}, 	-- suits scored
		ranks			= {}, 	-- ranks scored
		unique_suits    = 0,
		unique_ranks    = 0,
		blind_values	= {},
		faces_scored	= 0,	-- face cards scored
		first_hand_type	= nil	-- first hand type (for madcap mouth)
	}

	local x_card = G.playing_cards and pseudorandom_element(G.playing_cards, pseudoseed('rgmc_x_value')) or nil -- pick a card, any card...
	G.GAME.x_value = x_card and x_card.base.value or "10" -- The rank becomes the x's rank

	-- Pale Deck
	if G.GAME.modifiers.rgmc_pale then
        -- check if the force has been defeated

        if -- antes 9, 17, 25, etc.
            G.GAME.round_resets.ante > G.GAME.win_ante
            and G.GAME.round_resets.ante % G.GAME.win_ante == 1
        then -- set the force chance
            G.GAME.modifiers.rgmc_force_chance = G.GAME.win_ante - 1
        elseif
            G.GAME.modifiers.rgmc_force_chance > 0 -- if set to <1, don't even bother
            and (pseudorandom(pseudoseed("rgmc_pale_force")) < ((G.GAME.probabilities.normal) / G.GAME.modifiers.rgmc_force_chance))
        then -- force reroll into the force
			G.GAME.round_resets.blind_choices.Boss = get_new_boss()
        else -- increase force chance
            G.GAME.modifiers.rgmc_force_chance = G.GAME.modifiers.rgmc_force_chance - 1
        end
	end


	G.GAME.pick_5 = {}
	--[[
	local pick_5_cards = MadLib.shuffle_sort_list(G.deck.cards, 5, function(v)
        return (v ~= nil) and not SMODS.has_no_rank(v)
    end)

	tell('Pick 5:')
	MadLib.loop_func(pick_5_cards, function(v)
		table.insert(G.GAME.pick_5, {
			rank 	= v.base.value,
			suit 	= v.base.suit
		})
		print(G.GAME.pick_5[#G.GAME.pick_5])
	end)]]
end

-- Upon ending an ante?
function Madcap.Funcs.ante_finish()
    -- end of ante
    tell('Ante End')

end

-- Upon starting a shop
function Madcap.Funcs.shop_start()
    -- start of shop
    tell('Shop Start')

end

-- Upon recording a singular card?
function Madcap.Funcs.record_card(card)
    -- recording card
    tell('Record Card')
end

-- Upon playing a hand...
function Madcap.Funcs.play_hand(hand)
    --tell('Play Hand')
    G.GAME.ante.hands = G.GAME.ante.hands + 1
	MadLib.loop_func(G.discard.cards, function(v)
		if v and v.seal == 'rgmc_cherry' then
			tell('Cherry active is'..tostring(v.cherry_active))
			if v.cherry_active then
				G.discard:remove_card(v)
				G.play:emplace(v)
				delay(0.2)
			end
		end
	end)
end

-- Record hand
function Madcap.Funcs.record_hand_before(scoring_hand,text)
    local hand_type = G.GAME.ante.hand_types[text]

	G.GAME.ante.ranks = G.GAME.ante.ranks or {}
	tell('Jeff time!')
	print(G.GAME.ante.ranks)
	tell(#G.GAME.ante.ranks .. ' ranks recorded.')

	MadLib.loop_func(scoring_hand, function(v)
		local _rank, _suit = v:get_id(), v.base.suit

		G.GAME.ante.ranks[_rank] = G.GAME.ante.ranks[_rank] or 0
		G.GAME.ante.ranks[_suit] = G.GAME.ante.ranks[_suit] or 0

		print(_rank .. ':' .. G.GAME.ante.ranks[_rank])
		print(_suit .. ':' .. G.GAME.ante.ranks[_suit]) -- rank type stuff

        if G.GAME.ante.ranks[_rank] == 0 then
            G.GAME.ante.unique_ranks = G.GAME.ante.unique_ranks + 1
			tell('There are now ' .. tostring(G.GAME.ante.unique_ranks) .. ' unique ranks recorded.')
        end

        -- suit type stuff
        if G.GAME.ante.suits[_suit] == 0 then
            G.GAME.ante.unique_suits = G.GAME.ante.unique_suits + 1
			tell('There are now ' .. tostring(G.GAME.ante.unique_suits) .. ' unique suits recorded.')
        end

        G.GAME.ante.ranks[_rank]	= (G.GAME.ante.ranks[_rank] or 0) + 1
        G.GAME.ante.suits[_suit]	= (G.GAME.ante.suits[_suit] or 0) + 1
        G.GAME.ante.faces_scored = (G.GAME.ante.faces_scored or 0) + (v:is_face(true) and 1 or 0)

    	G.GAME.ante.hand_types[text] = G.GAME.ante.hand_types[text] or 0
    	G.GAME.ante.hand_types[text] = G.GAME.ante.hand_types[text] + 1

        if v.config.center ~= G.P_CENTERS.c_base then G.GAME.last_enhancement = v.config.center end
	end)
end

function Madcap.Funcs.record_hand_after(_chips, _mult, _pow)
	local total_chips = to_big(_chips) ^ (_pow or 1) * to_big(_mult)
    local current_score, high_score = to_big(total_chips), to_big(G.GAME.best_hand.score)

    if high_score < current_score then -- Update high score information
        G.GAME.best_hand = {
            score   = total_chips,
            hand    = MadLib.get_hand_info(G.hand.cards),
            play    = MadLib.get_hand_info(G.play.cards),
            ante    = G.GAME.round_resets.ante
        }
    	SMODS.calculate_context({ rgmc_high_score = total_chips })
		tell('New High Score! (' .. tostring(total_chips) .. ')')
    end
    SMODS.calculate_context({ rgmc_total_score = total_chips })
    return true
end

function Madcap.Funcs.show_tag_effect_text(text)
	attention_text({ scale = 1.25, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7}, major = G.play })
end

-- Upon discarding a hand...
function Madcap.Funcs.discard_hand(hand, chips, text)
    -- recording hand
    tell('Discard Hand')
    G.GAME.ante.discards = G.GAME.ante.discards + 1
end

-- When the player skips the blind on the UI
function Madcap.Funcs.blind_skip()
    -- start of blind
    tell('Blind Skip')
    G.GAME.blinds_skipped = G.GAME.blinds_skipped and G.GAME.blinds_skipped + 1 or 0
end

function Madcap.Funcs.do_after_scoring_stuff()
    --tags
    for i = 1, #G.GAME.tags do
        local ret = G.GAME.tags[i]:apply_to_run({type = 'rgmc_after'})
	end

    -- Cont2nuum
    if next(SMODS.find_card('j_rgmc_cont2nuum')) then
        MadLib.loop_func(G.hand.cards, function(v)
            MadLib.simple_event(function()
                v.area:remove_from_highlighted(v)
                return true
            end, 0.05, 'after')
        end)
    end
end

function Madcap.Funcs.hand_display_mod(hand, text, disp_text, poker_hands, scoring_hand)

    local subhands = MadLib.get_subhands(scoring_hand)
    local return_true = nil
    local prefix, suffix = '', ''

    -- Add subhands stuff first
	if #subhands > 0 and (#scoring_hand > 0 or #hand > 0) then
		local pre_lvl_col	= G.hand_text_area.hand_level.config.colour or G.C.HAND_LEVELS[1]
		suffix, prefix = ' (+',''

		MadLib.loop_func(subhands,function(v,i)
			-- hand name prefix
        	prefix = prefix .. ' '.. localize(v)
			-- level suffix
			if not G.GAME.subhands and G.GAME.subhands[v] and G.GAME.subhands[v].level > 0 then return end
			suffix = suffix .. tostring(G.GAME.subhands[v].level)

			if G.GAME.subhands[v].empower > 0 then
				suffix = suffix .. '(' .. tostring(G.GAME.subhands[v].empower) .. ')'
			end

			if i < #subhands then
				suffix = suffix .. ','
			else
				suffix = suffix .. ')'
			end
		end)

		local _mult 	= MadLib.calculate_mult(G.GAME.hands[text].mult, subhands)
		local _chips 	= MadLib.calculate_chips(G.GAME.hands[text].chips, subhands)
        disp_text = prefix .. ' ' .. disp_text

        update_hand_text({ immediate = nil, nopulse = true, delay = 0}, {
			level = G.GAME.hands[text].level .. suffix,
			handname = disp_text,
			mult = _mult,
			chips = _chips
		})
		G.hand_text_area.hand_level.config.colour = pre_lvl_col
		return_true = true
	end

	disp_text = MadLib.normalize_spaces(disp_text)

	if AKYRS then
        return_true = return_true or AKYRS.hand_display_mod(hand, text, disp_text, poker_hands) ~= nil
    end

    return return_true
end
