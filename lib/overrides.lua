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
	RGMC.funcs.reset_rgmc_barbershop_order()

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

