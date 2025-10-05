function MadLib.get_quantum_rank_pass(card,id)
    local pass_id = id
    if card:get_id() == SMODS.Ranks['rgmc_Infinity'].id then -- Infinity (counts as all ranks in scoring)
        print('This is an Infinity card.') 
        return true
    elseif card:get_id() == SMODS.Ranks['rgmc_X'].id then -- X (counts as a random rank in deck)
        pass_id = SMODS.Ranks[G.GAME.x_value]
        return pass_id and (id == pass_id.id)
    elseif card:get_id() == SMODS.Ranks['rgmc_Draw2'].id then -- Draw 2 (also counts as a 2)
        return id == SMODS.Ranks['2'].id 
    elseif card:get_id() == SMODS.Ranks['rgmc_Phi'].id then -- Phi (also counts as a 1 and 2)
        return id == SMODS.Ranks['2'].id or id == SMODS.Ranks[MadLib.RankIds['1']].id 
    end
    return false
end

MadLib.RankManipulation = {}
MadLib.FaceManipulation = {}

function MadLib.is_rank(card, id, bypass_rankless, base_id)
    base_id = base_id or (card and card.base.id)
    if not base_id then
        tell('Card is nil?')
        return false
    end
    if G.jokers then
        MadLib.loop_func(G.jokers.cards, function(v)
            local info = MadLib.RankManipulation[v.config.center.key]
            if not info then return end
            base_id = (base_id == info.from_rank) and info.to_rank or base_id
        end)
    end
    if (SMODS.has_no_rank(card) and not bypass_rankless) then return false end
    if MadLib.get_quantum_rank_pass(card,id) then return true end
    return (card and card:get_id() or card.base.id) == id
end

function MadLib.get_value(card)
    return card.base.value
end

function MadLib.get_rank_nominal(rank,no_face)
    local info = SMODS[rank]
    return info and (info.nominal + (no_face and 0 or info.face_nominal)) or nil
end

function MadLib.rank_to_id(key)
    return SMODS.Ranks[key] and SMODS.Ranks[key].id or nil 
end

-- Includes all ranks considered Odd by MadLib.
function MadLib.has_odd_rank(card)
    print(MadLib.RankTypes.Odd)
    return not SMODS.has_no_rank(card)
        and MadLib.list_matches_one(MadLib.RankTypes.Odd, function(v) 
            return MadLib.is_rank(card,MadLib.rank_to_id(v))
        end)
end

-- Ditto, but with Even ranks.
function MadLib.has_even_rank(card)
    print(MadLib.RankTypes.Even)
    return not SMODS.has_no_rank(card)
        and MadLib.list_matches_one(MadLib.RankTypes.Even, function(v) 
            return MadLib.is_rank(card,SMODS.Ranks[v].id)
        end)
end

-- Ditto, but with Fibonacci ranks.
function MadLib.has_fib_rank(card)
    print(MadLib.RankTypes.Fibonacci)
    return not SMODS.has_no_rank(card)
        and MadLib.list_matches_one(MadLib.RankTypes.Fibonacci, function(v) 
            return MadLib.is_rank(card,SMODS.Ranks[v].id)
        end)
end

-- Ditto, but with Base ranks.
function MadLib.is_base_rank(card)
    print(MadLib.RankTypes.Base)
    return not SMODS.has_no_rank(card)
        and MadLib.list_matches_one(MadLib.RankTypes.Base, function(v)
            return card.base.value == v
        end)
end

function MadLib.joker_check_rank(card, joker, default)
    local rank = (joker.ability.extra and joker.ability.extra.rank) or default
    return MadLib.is_rank(card, SMODS.Ranks[rank].id)
end

Madcap.Lists.RankUIs = {
    rgmc_Infinity   = 'infinity',
    rgmc_X          = 'x',
    rgmc_Sum        = 'sum',
    rgmc_Draw2      = 'draw_2',
    rgmc_Skip       = 'skip',
    rgmc_Reverse    = 'reverse',
    rgmc_0          = '0'
}

-- Adds UI for special ranks!
function MadLib.set_pcard_ui(card, specific_vars, desc_nodes)
    if not card then return loc_vars end
    MadLib.loop_table(Madcap.Lists.RankUIs, function(k,v)
        if card:get_id() == SMODS.Ranks[k].id then
            localize{ type = 'other', key = 'rgmc_info_'..v, nodes = desc_nodes }
        end
    end)
    return loc_vars
end

-- Custom Hack compatability.
Madcap.Lists.Hack = {}
MadLib.loop_table(SMODS.Ranks, function(k,v)
    if math.floor(v.nominal) <= 5 then table.insert(Madcap.Lists.Hack, v.key) end
end)

-- Hack - reworked to include all ranks with nominal <= 5. Also includes compatibility for Unstable 0 and 1.
SMODS.Joker:take_ownership('hack', {
	config = { extra = 1 },
	loc_vars = function(self, info_queue, card)
		local key = self.key
		return { key = key, vars = {card and card.ability.extra or self.config.extra} }
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
		    if MadLib.list_matches_one(Madcap.Lists.Hack, function(v)
                return MadLib.is_rank(context.other_card,SMODS.Ranks[v].id)
            end) then
				return {
				    message = localize('k_again_ex'),
				    repetitions = card.ability.extra,
				    card = context.blueprint_card or card
				}
		    end
		end
	end,
}, true)

-- Fibonacci - reworked to include all Fibonacci ranks, gives +13 instead of +8 for non-base ranks.
SMODS.Joker:take_ownership('fibonacci', {
	config = { extra = { mult = 8, mult2 = 13 } },
	loc_vars = function(self, info_queue, card)
        local key = self.key
		return { key = key, vars = {
            (card and card.ability.extra.mult or self.config.extra.mult),
            (card and card.ability.extra.mult2 or self.config.extra.mult2)
        }}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			return MadLib.has_fib_rank(context.other_card) and ({
				  mult = MadLib.is_base_rank(card) and card.ability.extra.mult or card.ability.extra.mult2,
				  card = card
			}) or {}
		end
    end
}, true)

-- Odd Todd - reworked to include all odd ranks. Nerfed to give +25 instead of +31.
SMODS.Joker:take_ownership('odd_todd', {
	config = { extra = { chips = 25 } },
	loc_vars = function(self, info_queue, card)
        local key = self.key
		return { key = key, vars = {card and card.ability.extra.chips or self.config.extra.chips} }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			return MadLib.has_odd_rank(context.other_card) and {
				  chips = card.ability.extra.chips,
				  card = card
			} or {}
		end
    end
}, true)

-- Even Steven - reworked to include all even ranks.
SMODS.Joker:take_ownership('even_steven', {
	config = { extra = { mult = 4 } },
	loc_vars = function(self, info_queue, card)
        local key = self.key
		return { key = key, vars = {card and card.ability.extra.mult or self.config.extra.mult} }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			return MadLib.has_even_rank(context.other_card) and {
				  mult = card.ability.extra.mult,
				  card = card
			} or {}
		end
    end
}, true)

-- Raised Fist - reworked to include nonstandard ranks outside the hardcoded rank ID.
SMODS.Joker:take_ownership('raised_fist', {
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand and not context.end_of_round then
			local _mult, _value = 15, 99999
			local raised_card = nil
            MadLib.loop_func(G.hand.cards, function(v)
                if not (not SMODS.has_no_rank(v) and _value >= SMODS.Ranks[v.base.value].sort_nominal) then return end 
				_mult = v.base.nominal
				_value = SMODS.Ranks[v.base.value].sort_nominal
				raised_card = v
            end)
			return (raised_card == context.other_card) and 
                ((not context.other_card.debuff) and {
					h_mult = 2*_mult,
					card = card,
                } or {
					message = localize('k_debuffed'),
					colour = G.C.RED,
					card = card,
                })
			or {}
		end
	end,
}, true)

--[[
    The following Jokers have been reworked to incorporate MadLib's quantum rank stuff. 
]]

-- 8-Ball
SMODS.Joker:take_ownership('8_ball', {
    config = { extra = { rank = '8', odds = 4 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, '8_ball')
        numerator = math.min(numerator, denominator)
        return MadLib.collect_vars(numerator, denominator, localize(card.ability.extra.rank or '8', 'ranks'))
    end,
    calculate = function(self, card, context)
        if 
            context.individual and context.cardarea == G.play and
            (#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit)
        then
            if 
                MadLib.joker_check_rank(context.other_card, card, '8')
                and SMODS.pseudorandom_probability(card, '8_ball', 1, card.ability.extra.odds) 
            then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return {
                    extra = {
                        message = localize('k_plus_tarot'),
                        message_card = card,
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    SMODS.add_card { set = 'Tarot', key_append = '8_ball' }
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end)
                            }))
                        end
                    }
                }
            end
        end
    end
}, true)

-- Scholar
SMODS.Joker:take_ownership('scholar', {
	config = { extra = { rank = 'Ace', mult = 4, chips = 20 } },
	loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(localize(card.ability.extra.rank or 'Ace', 'ranks'), card.ability.extra.chips, card.ability.extra.mult)
    end,
    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.play) then 
        return MadLib.joker_check_rank(context.other_card, card, 'Ace') and {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips
            } or {}
        end
    end
}, true)

-- Sixth Sense
SMODS.Joker:take_ownership('sixth_sense', {
    config = { extra = { rank = '6' } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(localize(card.ability.extra.rank, 'ranks'))
    end,
    calculate = function(self, card, context)
        if context.destroy_card and not context.blueprint then
            if 
                #context.full_hand == 1 
                and context.destroy_card == context.full_hand[1] 
                and MadLib.joker_check_rank(context.destroy_card, card, '6')
                and G.GAME.current_round.hands_played == 0 
            then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    MadLib.event({
                        func = function()
                            SMODS.add_card { set = 'Spectral', key_append = 'sixth_sense' }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    })
                    return {
                        message = localize('k_plus_spectral'),
                        colour = G.C.SECONDARY_SET.Spectral,
                        remove = true
                    }
                end
                return { remove = true }
            end
        end
    end
}, true)

-- Superposition
SMODS.Joker:take_ownership('superposition', {
    config = {
        extra = { rank = 'Ace', poker_hand = 'Straight' }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(localize(card.ability.extra.rank, 'ranks'), localize(card.ability.extra.poker_hand, 'poker_hands'))
    end,
    calculate = function(self, card, context)
        if 
            context.joker_main and next(context.poker_hands[card.ability.extra.poker_hand])
            and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
        then
            if MadLib.list_matches_one(context.scoring_hand, function(v)
                return MadLib.joker_check_rank(v, card, 'Ace')
            end) then
                MadLib.event({
                    func = (function()
                        SMODS.add_card { set = 'Tarot', key_append = 'superposition' }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                })
                return {
                    message = localize('k_plus_tarot'),
                    colour = G.C.SECONDARY_SET.Tarot,
                }
            end
        end
    end
}, true)

-- Baron
SMODS.Joker:take_ownership('baron', {
    config = { extra = { rank = 'King', x_mult = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(localize(card.ability.extra.rank, 'ranks'), card.ability.extra.x_mult)
    end,
    calculate = function(self, card, context)
        if 
            context.individual 
            and context.cardarea == G.hand 
            and not context.end_of_round 
            and MadLib.joker_check_rank(context.other_card, card, 'King')
        then
            return not context.other_card.debuff and {
                x_mult = card.ability.extra.x_mult
            } or {
                message = localize('k_debuffed'),
                colour = G.C.RED
            }
        end
    end
}, true)

-- Cloud 9
SMODS.Joker:take_ownership('cloud_9', {
    config = { extra = { rank = '9', dollars = 1 } },
    loc_vars = function(self, info_queue, card)
        local nines = MadLib.loop_func(G.playing_cards, function(v)
            return MadLib.joker_check_rank(v, card, '9')
        end)
        return MadLib.collect_vars(card.ability.extra.dollars, localize(card.ability.extra.rank, 'ranks'), card.ability.extra.dollars * nines)
    end,
    calc_dollar_bonus = function(self, card)
        local nines = MadLib.loop_func(G.playing_cards, function(v)
            return MadLib.joker_check_rank(v, card, '9')
        end)
        return nines > 0 and (card.ability.extra.dollars * nines) or nil
    end
}, true)

-- Mail-In Rebate
SMODS.Joker:take_ownership('mail', {
    calculate = function(self, card, context)
        if 
            context.discard 
            and not context.other_card.debuff
            and MadLib.is_rank(context.other_card, G.GAME.current_round.mail_card.id)
        then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra
            return {
                dollars = card.ability.extra,
                func = function() -- This is for timing purposes, it runs after the dollar manipulation
                    MadLib.simple_event(function()
                        G.GAME.dollar_buffer = 0
                        return true
                    end, 0.0, 'immediate')
                end
            }
        end
    end
}, true)

-- Walkie Talkie
SMODS.Joker:take_ownership('walkie_talkie', {
    config = { extra = { ranks = { '10', '4' }, chips = 10, mult = 4 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(localize(card.ability.extra.ranks[1], 'ranks'), localize(card.ability.extra.ranks[2], 'ranks'), card.ability.extra.chips, card.ability.extra.mult)
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return MadLib.list_matches_one(card.ability.extra.ranks, function(v)
                return MadLib.is_rank(context.other_card, SMODS.Ranks[v].id)
            end) and {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            } or {}
        end
    end
}, true)

-- Wee Joker
SMODS.Joker:take_ownership('wee', {
    config = { extra = { rank = '2', chips = 0, chip_mod = 8 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.chip_mod, localize(card.ability.extra.rank, 'ranks'), card.ability.extra.chips)
    end,
    calculate = function(self, card, context)
        if 
            context.individual 
            and context.cardarea == G.play
            and not context.blueprint 
        then
            if MadLib.joker_check_rank(context.other_card, card, '2') then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                    message_card = card
                }
            end
        end
        if context.joker_main then
            return { chips = card.ability.extra.chips }
        end
    end
}, true)

function MadLib.is_rank_and_suit(card,rank,suit)
    return card and MadLib.is_rank(card,rank) and card:is_suit(suit)
end

-- The Idol
SMODS.Joker:take_ownership('idol', {
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return MadLib.is_rank_and_suit(context.other_card, G.GAME.current_round.vremade_idol_card.id, G.GAME.current_round.vremade_idol_card.suit) and {
                xmult = card.ability.extra.xmult
            } or {}
        end
    end
}, true)

-- Hit the Road
SMODS.Joker:take_ownership('hit_the_road', {
    config = { extra = { rank = 'Jack', xmult_mod = 0.5, x_mult = 1 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.xmult_mod, localize(card.ability.extra.rank, 'ranks'), card.ability.extra.x_mult)
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
            if
                context.other_card.debuff
                and MadLib.joker_check_rank(context.other_card, card, 'Jack')
            then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.xmult_gain
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                colour = G.C.RED
            }
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.x_mult = 1
            return { message = localize('k_reset'), colour = G.C.RED }
        end
        if context.joker_main then
            return { xmult = card.ability.extra.x_mult }
        end
    end
}, true)

-- Shoot the Moon
SMODS.Joker:take_ownership('shoot_the_moon', {
    config = { extra = { rank = 'Queen', mult = 13 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(localize(card.ability.extra.rank, 'ranks'), card.ability.extra.mult)
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then 
            return MadLib.joker_check_rank(context.other_card, card, 'Queen') and
                (not context.other_card.debuff and {
                    mult = card.ability.extra.mult
                } or {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                })
            or {}
        end
    end
}, true)

-- Triboulet
SMODS.Joker:take_ownership('triboulet', {
    config = { extra = { ranks = { 'Queen', 'King' }, x_mult = 2 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(localize(card.ability.extra.ranks[1], 'ranks'), localize(card.ability.extra.ranks[2], 'ranks'), card.ability.extra.x_mult)
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return MadLib.list_matches_one(card.ability.extra.ranks, function(v)
                return MadLib.is_rank(context.other_card, SMODS.Ranks[v].id)
            end) and {
                xmult = card.ability.extra.x_mult
            } or {}
        end
    end
}, true)
