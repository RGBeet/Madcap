--Init stuff at the start of the game
local gigo = Game.init_game_object
function Game:init_game_object()
	local G = gigo(self)
	-- Add initial dropshot and number blocks card
	G.current_round.rgmc_edwin_card = { rank = "5", suit = "Hearts" }

	-- Create G.GAME.events when starting a run, so there's no errors
	G.events = {}
	G.jokers_sold = {}
	return G
end

-- Calculate individual effect fixing
if SMODS and SMODS.calculate_individual_effect then
	local cie = SMODS.calculate_individual_effect
	function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
		if
			( key == "x_mult"
				or key == "xmult"
				or key == "Xmult"
				or key == "x_mult_mod"
				or key == "xmult_mod"
				or key == "Xmult_mod")
			and amount ~= 1
		then

			-- Squeezy Cheeze
			local list = SMODS.find_card('j_rgmc_squeezy_cheeze')

			for _, v in pairs(list)do
				--tell("SQUEEZY CHEEZE ACTIVATED - "..tostring(amount))
				-- adds the mult to the joker

				v.ability.extra.xmult_store = lenient_bignum(to_big(v.ability.extra.xmult_store) + to_big(amount))

				if v.ability.extra.xmult_store > 1 then
				tell("New xmult_store is "..lenient_bignum(v.ability.extra.xmult_store))
					local m = 0
					while (v.ability.extra.xmult_store - 1) > 0 do
						v.ability.extra.xmult_store = v.ability.extra.xmult_store - 1 -- go down bith
						-- uhhh
						m = m + 1
					end

					local xm = 1 + v.ability.extra.xchip_mod * m
					G.E_MANAGER:add_event(Event({
						func = function()
							play_sound("tarot2")
							v:juice_up()
							return true
						end
					}))

					card_eval_status_text(v, "extra", nil, nil, nil, {
						message = localize({
							type = "variable",
								key = "a_xchips",
								vars = { number_format(xm) },
							}),
						colour = G.C.CHIPS,
					})

					--hand_chips = mod_chips(to_big(hand_chips) * to_big(xm)) -- stupid way of doing x1.5 chips
					tell(to_big(hand_chips))
				end
			end
		end

		local ret = cie(effect, scored_card, key, amount, from_edition)
		if ret then return ret end
	end
end


-- reset_castle_card hook for things like Dropshot and Number Blocks
-- Also exclude specific ranks/suits (such as abstract cards)
-- taken from cryptid, it's a really solid way of doing start of round shit
local rcc = reset_castle_card
function reset_castle_card()
	rcc()

	-- neighborhood watch
	G.GAME.current_round.rgmc_edwin_card = { rank = "5", suit = "Hearts" }
	G.GAME.current_round.rgmc_wizard_card = { rank = "9", suit = "Spades", rank_discovered = false, suit_discovered = false }

	-- barbershop joker
	G.GAME.current_round.rgmc_barbershop = { suit = nil, order = {} }

	local valid_castle_cards = {}
    for k, v in ipairs(G.playing_cards) do
		if not RGMC.funcs.card_is_rankless_suitless(v) then valid_castle_cards[#valid_castle_cards + 1] = v end
	end

	if valid_castle_cards[1] then -- there are cards with ranks and suits
		-- Neighborhood Watch (Edwin)
		local castle_card = pseudorandom_element(valid_castle_cards, pseudoseed("rgmc_neighborhood_watch" .. G.GAME.round_resets.ante))
		if not G.GAME.current_round.rgmc_edwin_card then G.GAME.current_round.rgmc_edwin_card = {} end
		G.GAME.current_round.rgmc_edwin_card.suit  = castle_card.base.suit
		G.GAME.current_round.rgmc_edwin_card.rank  = castle_card.base.value
		G.GAME.current_round.rgmc_edwin_card.id    = castle_card.base.id

		-- make this end of ante later
		local castle_card2 = pseudorandom_element(valid_castle_cards, pseudoseed("rgmc_conspiracy_wizard" .. G.GAME.round_resets.ante))
		if not G.GAME.current_round.rgmc_edwin_card then G.GAME.current_round.rgmc_edwin_card = {} end
		G.GAME.current_round.rgmc_edwin_card.suit  = castle_card.base.suit
		G.GAME.current_round.rgmc_edwin_card.rank  = castle_card.base.value
		G.GAME.current_round.rgmc_edwin_card.id    = castle_card.base.id
	end

	-- This is for the Barbershop Joker
	G.GAME.current_round.rgmc_barbershop.changed = false
    G.GAME.current_round.rgmc_barbershop.index = G.GAME.current_round.rgmc_barbershop.index or 1

    local suit_set = {}
    for _, v in ipairs(G.playing_cards) do
        if not v:nosuit() then
            suit_set[v.base.suit] = true
        end
    end

    local suits = {}
    for suit, _ in pairs(suit_set) do
        table.insert(suits, suit)
    end

    -- Sort to ensure a defined order before shuffling (optional)
    table.sort(suits)

    -- Ensuring a structured shuffle (rotated shuffle approach)
    local seed = pseudoseed('rgmc_barbershop_joker'..tostring(G.GAME.round_resets.ante)..tostring(G.GAME.round_resets.ante))

    -- Assign the shuffled order
    pseudoshuffle(suits,seed)
    G.GAME.current_round.rgmc_barbershop.order = suits

    -- Ensure rgmc_barbershop.index is valid before accessing suits
    local index = G.GAME.current_round.rgmc_barbershop.index or 1
    if index < 1 or index > #suits then index = 1 end  -- Default to 1 if out of bounds

    G.GAME.current_round.rgmc_barbershop.suit = G.GAME.current_round.rgmc_barbershop.order[index]

end

-- Glass Michel better work.
local crdsht = Card.shatter
function Card:shatter()
	-- if sticker prevents it?
	if find_joker("rgmc_glass_michel") then
		return { message = localize("k_safe_ex") }
	else -- not safe!
		crdsht()
	end
end

-- temporary discard addition
local ease_discard_ref = ease_discard
function ease_discard(mod, instant, silent)
	ease_discard_ref(mod,instant,silent)
	tell_stat('discards',G.GAME.current_round.discards_left)
    if
        G.GAME.current_round.discards_left + mod == 0
        and G.GAME.MADCAP.temporary_discards > 0
    then
        ease_discard(1, instant, silent)
		local words = localize("rgmc_temp_discard_minus_ex")
		attention_text({
			scale = 0.7,
			text = words,
			maxw = 12,
			hold = RGMC.funcs.get_default_attention_hold(words),
			align = 'cm',
			offset = {x = 0, y = -1},
			major = G.play
		})
    end
end

-- temporary hand addition
local ease_hands_played_ref = ease_hands_played
function ease_hands_played(mod, instant)
	ease_hands_played_ref(mod,instant)
	tell_stat('hands',G.GAME.current_round.hands_left)
    if
        G.GAME.current_round.hands_left + mod == 0
        and G.GAME.MADCAP.temporary_hands > 0
    then
        ease_hands_played(1, instant, silent)
        G.GAME.MADCAP.temporary_hands = G.GAME.MADCAP.temporary_hands - 1
		local words = localize("rgmc_temp_hand_minus_ex")
		attention_text({
			scale = 0.7,
			text = words,
			maxw = 12,
			hold = RGMC.funcs.get_default_attention_hold(words),
			align = 'cm',
			offset = {x = 0, y = -1},
			major = G.play
		})
    end
end

-- Setting the cost of the card, likely for the shop?
local card_set_cost_ref = Card.set_cost
function Card:set_cost()
    local ret = card_set_cost_ref(self)

    if self.ability.rgmc_engraved then
        self.sell_cost = -1 -- bad luck!
    end

    if self.ability.rgmc_shielded then
        self.sell_cost = math.floor(self.sell_cost / 2) -- stickers reduce sell value regardless
    end

    return ret
end

local get_new_boss_ref = get_new_boss
function get_new_boss()


	-- Some Madcap decks have set finishers
	if
		G.GAME.MADCAP.deck_finishers 		-- has a deck finisher list
		and G.GAME.round_resets.ante > 0	-- dont do it ante 0 or earlier :(
		and G.GAME.round_resets.ante % G.GAME.win_ante == 0
	then
		local yes_please = G.GAME.round_resets.ante <= G.GAME.win_ante

		if not yes_please then -- past ante 8
			if RGMC.funcs.calculate_roll({
				seed 	= 'rgmc_finisher',	-- finisher seed
				numer 	= 1,	-- hardcoded 1 in 3, as to avoid stupidity
				denom 	= 3
			}) then
				yes_please = true -- 1 in 3 chance to do the thing
			end
		end

		if yes_please then
			local eligible_bosses = {}

			for _, v in pairs(G.GAME.MADCAP.deck_finishers) do -- might be more than one
				eligible_bosses[v] = true
			end

			local _, boss = RGMC.funcs.get_random_from_list(eligible_bosses)
			return boss or "bl_final_vessel" -- evil
		end
	end

	-- Pale Deck: The Force appears more often.
	if G.GAME.modifiers.rgmc_pale then
		if G.GAME.modifiers.rgmc_force_awakened then -- Force chance activated
			return "bl_rgmc_force"
		end
	end

	-- Punisher Tag: rerolls boss blind into finisher blind.
	if G.GAME.MADCAP.force_finisher_blind then
		G.GAME.MADCAP.force_finisher_blind = nil -- dont need this anymore

		local blind, is_showdown = G.P_BLINDS[G.GAME.round_resets.blind_choices["Boss"]], false
		if blind.boss and blind.boss.showdown then is_showdown = true end -- if showdown blind
		local eligible_bosses = {}

		for k, v in pairs(G.P_BLINDS) do
			if v.boss and v.boss.showdown then eligible_bosses[k] = true end
		end

		for k, v in pairs(G.GAME.banned_keys) do
			if eligible_bosses[k] then eligible_bosses[k] = nil end
		end

		-- TODO: showdowns reroll into specific superbosses or DX blinds?
		return new_boss
	end

	-- if not punishing, just carry on as usual!
	return get_new_boss_ref()
end


-- Used for Sangria Deck
local deck_apply_to_run_ref = Back.apply_to_run
function Back.apply_to_run(self)
    deck_apply_to_run_ref(self)

    if
        self.effect.config.starting_suits
        and not self.effect.config.starting_ranks 	-- No starting ranks, only affects suits
    then
        local size = #self.effect.config.starting_suits -- number of suits
        local suits = self.effect.config.starting_suits -- the list of suits
        local doubles = self.effect.config.starting_suits_doubles or false

        local ranks = 13                -- number of starting ranks available (usually 13)
        local deck_size = ranks * size  -- deck size

        if doubles then
            for i = #suits, 1, -1 do
                suits[#suits+1] = suits[i]
            end
            table.sort(suits, cmp)
            deck_size = deck_size * 2 -- double that shit
        end

        -- do the suit shit i guess
        G.E_MANAGER:add_event(Event({
            func = function()

                -- modify existing cards
                for i = #G.playing_cards, 1, -1 do
                    if i > deck_size then
                        G.playing_cards[i]:start_dissolve(nil, true)
                    else
                        local m = math.ceil(i/ranks)
                        --tell_stat('SUIT',suits[m])
                        G.playing_cards[i]:change_suit(suits[m])
                    end
                end

                if #G.playing_cards < deck_size then
                    local difference = (#G.playing_cards - deck_size)

                    for i = difference, 1, -1 do
                        local m = math.ceil(#G.playing_cards/ranks)

                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local _card = copy_card(G.playing_cards[i])
                        --tell_stat('SUIT',suits[m])
                        G.playing_cards[i]:change_suit(suits[m])

                        _card:add_to_deck()
                    end
                end

                return true
            end
        }))
    elseif
        self.effect.config.starting_suits		-- Specified starting suits and ranks
        and self.effect.config.starting_ranks
    then
        local suit_size = #self.effect.config.starting_suits -- number of suits
        local suit_list = self.effect.config.starting_suits -- the list of suits

        local rank_size = #self.effect.config.starting_ranks -- number of ranks
        local rank_list = self.effect.config.starting_ranks -- the list of ranks

        local deck_size = suit_size * rank_size

        local suit_index, rank_index, total = 1, 1, 0
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = 1,#G.playing_cards do
                    if suit_index > suit_size then
                        if rank_index+1 > rank_size then
                            break
                        else
                            rank_index = rank_index + 1
                        end
                        suit_index = 1
                    end
                    local r, s = rank_list[rank_index], suit_list[suit_index]
                    assert(SMODS.change_base(G.playing_cards[i], s, r))

                    suit_index = suit_index + 1
                    total = total + 1
                end


                for i = 1, (deck_size - total) do
                    if suit_index > suit_size then
                        if rank_index+1 > rank_size then
                            break
                        else
                            rank_index = rank_index + 1
                        end
                        suit_index = 1
                    end
                    local r, s = rank_list[rank_index], suit_list[suit_index]

					local _card = copy_card(G.playing_cards[#G.playing_cards])
                    assert(SMODS.change_base(_card, s, r))
					_card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.deck:emplace(_card)

                    suit_index = suit_index + 1
                    total = total + 1
                end

                return true
            end
        }))
    end
end

-- Levelling up hands shenanigans
local level_up_hand_ref = level_up_hand
function level_up_hand(card, hand, instant, amount, context)

	if
		to_big(amount) > to_big(0)
	then -- actually levelling up the hand

		if  -- Rocket Keychain: using specific Planet card levels up most played hand as well!
			#SMODS.find_card('j_rgmc_rocket_keychain') > 0
		then
			-- loop thru
			for k, v in ipairs(G.jokers.cards) do
				if
					v.config.center.key == 'j_rgmc_rocket_keychain'
				then
					if hand == v.ability.extra.target_hand then
						level_up_hand_ref(card, RGMC.funcs.get_most_played_hand(), instant, v.ability.extra.level_ups)
					end
				end
			end
		end
	end

	level_up_hand_ref(card, hand, instant, amount)
end

-- Some stickers prevent debuffs
local set_debuff_ref = Card.set_debuff
function Card:set_debuff(should_debuff)
    if
		not self.ability.shielded 			-- shielded cannot be debuffed
		and not self.ability.engraved           -- this would be too easy
		and not self.ability.painted 		-- painted cannot be debuffed because paint is cool
	then
		set_debuff_ref(self, should_debuff)
	end
end


-- Some stickers prevent death
local start_dissolve_ref = Card.start_dissolve
function Card:start_dissolve(...)
    if
		not self.ability.shielded 			-- shielded cannot be killed
		and not self.ability.twinkling 		-- twinkling cannot be killed, because plot armor
	then
        return start_dissolve_ref(self, ...)
    end
end
