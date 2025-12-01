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
    --print(MadLib.RankTypes.Odd)
    return not SMODS.has_no_rank(card)
        and MadLib.list_matches_one(MadLib.RankTypes.Odd, function(v) 
            return MadLib.is_rank(card,MadLib.rank_to_id(v))
        end)
end

-- Ditto, but with Even ranks.
function MadLib.has_even_rank(card)
    --print(MadLib.RankTypes.Even)
    return not SMODS.has_no_rank(card)
        and MadLib.list_matches_one(MadLib.RankTypes.Even, function(v) 
            return MadLib.is_rank(card,SMODS.Ranks[v].id)
        end)
end

-- Ditto, but with Fibonacci ranks.
function MadLib.has_fib_rank(card)
    --print(MadLib.RankTypes.Fibonacci)
    return not SMODS.has_no_rank(card)
        and MadLib.list_matches_one(MadLib.RankTypes.Fibonacci, function(v) 
            return MadLib.is_rank(card,SMODS.Ranks[v].id)
        end)
end

-- Ditto, but with Base ranks.
function MadLib.is_base_rank(card)
    --print(MadLib.RankTypes.Base)
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


--[[


]]

SMODS.Joker:take_ownership('lusty_joker', {
    key = "lusty_joker",
    config = { extra = { s_mult = 3, suit = 'Hearts' }, },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:is_suit(card.ability.extra.suit) then
            return {
                mult = card.ability.extra.s_mult
            }
        end
    end
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
            and context.other_card:get_quantity_value() > 0
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
        local nines = MadLib.get_card_count(G.playing_cards, function(v)
            return MadLib.joker_check_rank(v, card, '9')
        end)
        return MadLib.collect_vars(card.ability.extra.dollars, localize(card.ability.extra.rank, 'ranks'), card.ability.extra.dollars * nines)
    end,
    calc_dollar_bonus = function(self, card)
        local nines = MadLib.get_card_count(G.playing_cards, function(v)
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
            and not (context.other_card.debuff or not v:get_quantity_value() > 0)
            and MadLib.is_rank(context.other_card, G.GAME.current_round.mail_card.id)
        then
            return {
                dollars = card.ability.extra * v:get_quantity_value(),
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
            if MadLib.list_matches_one(card.ability.extra.ranks, function(v)
                return MadLib.is_rank(context.other_card, SMODS.Ranks[v].id)
            end) then
                return {
                    chips       = card.ability.extra.chips,
                    mult        = card.ability.extra.mult
                }
            end
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
            if MadLib.is_rank_and_suit(context.other_card, G.GAME.current_round.vremade_idol_card.id, G.GAME.current_round.vremade_idol_card.suit) then
                return {
                    xmult = card.ability.extra.xmult,
                    target_card = context.other_card,
                }
            end
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
            local amt = context.other_card:get_quantity_value()
            if amt > 0 then
                card.ability.extra.x_mult = card.ability.extra.x_mult + (card.ability.extra.xmult_gain * amt)
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                    colour = G.C.RED
                }
                end
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

-- Invisible Joker
SMODS.Joker:take_ownership('invisible_joker', {
    config = { extra = { invis_rounds = 0, total_rounds = 2 } },
    loc_vars = function(self, info_queue, card)
        local main_end
        if G.jokers and G.jokers.cards then
            for _, joker in ipairs(G.jokers.cards) do
                if joker.edition and joker.edition.negative then
                    main_end = {}
                    localize { type = 'other', key = 'remove_negative', nodes = main_end, vars = {} }
                    break
                end
            end
        end
        return { vars = { card.ability.extra.total_rounds, card.ability.extra.invis_rounds }, main_end = main_end }
    end,
    calculate = function(self, card, context)
        if context.selling_self and (card.ability.extra.invis_rounds >= card.ability.extra.total_rounds) and not context.blueprint then
            local jokers = MadLib.get_list_matches(G.jokers.cards, function(v)
                return v:get_quantity_value() > 0
            end)
            if #jokers > 0 then
                if #G.jokers.cards <= G.jokers.config.card_limit then
                    local chosen_joker = pseudorandom_element(jokers, 'vremade_invisible')
                    local copied_joker = copy_card(chosen_joker, nil, nil, nil,
                        chosen_joker.edition and chosen_joker.edition.negative)
                    copied_joker:add_to_deck()
                    G.jokers:emplace(copied_joker)
                    return { message = localize('k_duplicated_ex') }
                else
                    return { message = localize('k_no_room_ex') }
                end
            else
                return { message = localize('k_no_other_jokers') }
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.invis_rounds = card.ability.extra.invis_rounds + 1
            if card.ability.extra.invis_rounds == card.ability.extra.total_rounds then
                local eval = function(card) return not card.REMOVED end
                juice_card_until(card, eval, true)
            end
            return {
                message = (card.ability.extra.invis_rounds < card.ability.extra.total_rounds) and
                    (card.ability.extra.invis_rounds .. '/' .. card.ability.extra.total_rounds) or
                    localize('k_active_ex'),
                colour = G.C.FILTER
            }
        end
    end,
}, true)

-- Shoot the Moon
SMODS.Joker:take_ownership('shoot_the_moon', {
    config = { extra = { rank = 'Queen', mult = 13 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(localize(card.ability.extra.rank, 'ranks'), card.ability.extra.mult)
    end,
    calculate = function(self, card, context)
        if
            context.individual
            and context.cardarea == G.hand
            and not context.end_of_round
            and MadLib.joker_check_rank(context.other_card, card, 'Queen')
        then
            local amt = context.other_card:get_quantity_value()
            if amt > 0 then
                return not context.other_card.debuff and {
                    mult = card.ability.extra.mult
                } or {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            end
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

-- Canio
SMODS.Joker:take_ownership('canio', {
    config = { extra = { xmult = 1, xmult_gain = 1 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.xmult_gain, card.ability.extra.xmult)
    end,
    calculate = function(self, card, context)
        if context.remove_playing_cards and not context.blueprint then
            local points = 0
            MadLib.loop_func(context.removed, function(v)
                if v:is_face() then points = points + v:get_quantity_value() end
            end)
            if points > 0 then
                -- See note about SMODS Scaling Manipulation on the wiki
                card.ability.extra.xmult = card.ability.extra.xmult + (points * card.ability.extra.xmult_gain)
                return { message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } } }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
}, true)

-- Yorick
SMODS.Joker:take_ownership('yorick', {
    config = { extra = { xmult = 1, xmult_gain = 1, discards = 23, discards_remaining = 23 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.xmult_gain, card.ability.extra.discards, card.ability.extra.discards_remaining, card.ability.extra.xmult)
    end,
    calculate = function(self, card, context)
        if
            context.discard
            and not context.blueprint
        then
            local points = context.other_card:get_quantity_value()
            if points > 0 then
                if card.ability.extra.discards_remaining <= points then
                    card.ability.extra.discards_remaining = card.ability.extra.discards
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                    return {
                        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } },
                        colour = G.C.RED
                    }
                else
                    card.ability.extra.discards_remaining = card.ability.extra.discards_remaining - points
                    return nil, true -- This is for Joker retrigger purposes
                end
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
}, true)

-- Perkeo: Ignores Invisible cards, twice as likely to duplicate Stereo cards
SMODS.Joker:take_ownership('perkeo', {
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'e_negative_consumable', set = 'Edition', config = { extra = 1 } }
    end,
    calculate = function(self, card, context)
        if context.ending_shop then
            local items = {}
            MadLib.loop_func(G.consumeables.cards, function(v)
                for i=0, v:get_quantity_value() do
                   items[#items+1] = v
                end
            end)
            G.E_MANAGER:add_event(Event({
                func = function()
                    local card_to_copy, _ = pseudorandom_element(items, 'vremade_perkeo')
                    local copied_card = copy_card(card_to_copy)
                    copied_card:set_edition("e_negative", true)
                    copied_card:add_to_deck()
                    G.consumeables:emplace(copied_card)
                    return true
                end
            }))
            return { message = localize('k_duplicated_ex') }
        end
    end,
}, true)

-- Erosion
SMODS.Joker:take_ownership('erosion', {
    config = { extra = { mult = 4 } },
    loc_vars = function(self, info_queue, card)
        local points = G.GAME and G.GAME.starting_deck_size or 0
        MadLib.loop_func(G.playing_cards or {}, function(v)
            points = points - v:get_quantity_value()
        end)
        return MadLib.collect_vars(card.ability.extra.mult, math.max(0, card.ability.extra.mult * points), G.GAME and G.GAME.starting_deck_size or 52)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local points = G.GAME.starting_deck_size
            MadLib.loop_func(G.playing_cards or {}, function(v)
                points = points - v:get_quantity_value()
            end)
            return {
                mult = math.max(0, card.ability.extra.mult * points)
            }
        end
    end
}, true)

-- Driver's License
SMODS.Joker:take_ownership('drivers_license', {
    config = { extra = { xmult = 3, driver_amount = 16 } },
    loc_vars = function(self, info_queue, card)
        local driver_tally, modified = MadLib.get_card_count(G.playing_cards, function(v)
            return next(SMODS.get_enhancements(v))
        end)
        return { vars = { card.ability.extra.xmult, card.ability.extra.driver_amount, driver_tally } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local driver_tally = MadLib.get_card_count(G.playing_cards, function(v)
                return next(SMODS.get_enhancements(v))
            end)
            if driver_tally >= card.ability.extra.driver_amount then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end,
}, true)

-- Gets the # of empty slots - useful for editing.
function MadLib.get_empty_slots(area)
    if not area then return 0 end
    local num = area.config.card_limit + #SMODS.find_card("j_vremade_stencil", true)
    MadLib.loop_func(area.cards, function(v)
        num = num - v:get_quantity_value() or 0
    end)
    return num
end

function Madcap.Funcs.get_modified_card_quantity(cards)
    local num = 0
    MadLib.loop_func(cards, function(v)
        num = num - v:get_quantity_value() or 0
    end)
    return num
end

-- Half Joker - now quantity compatile!
SMODS.Joker:take_ownership('half_joker', {
    config = { extra = { mult = 20, size = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.size } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and Madcap.Funcs.get_modified_card_quantity(context.full_hand) <= card.ability.extra.size then
            return { mult = card.ability.extra.mult }
        end
    end
}, true)

-- Joker Stencil - now quantity compatible!
local joker_stencil_get = function(a)
    math.min(math.max(1, MadLib.get_empty_slots(a)), a.config.card_limit)
end
SMODS.Joker:take_ownership('joker_stencil', {
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(joker_stencil_get(card.area))
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = math.max(1, joker_stencil_get(card.area))
            }
        end
    end
}, true)

-- Swashbuckler - now quantity compatible!
SMODS.Joker:take_ownership('swashbuckler', {
    config = { extra = { mult = 1 } },
    loc_vars = function(self, info_queue, card)
        local sell_cost = 0
        MadLib.loop_func(G.jokers and G.jokers.cards or {}, function(v)
            sell_cost = sell_cost + (v.sell_cost * v:get_quantity_value())
        end)
        return MadLib.collect_vars(card.ability.extra.mult * sell_cost)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local sell_cost = 0
            MadLib.loop_func(G.jokers and G.jokers.cards or {}, function(v)
                sell_cost = sell_cost + (v.sell_cost * v:get_quantity_value())
            end)
            if sell_cost > 0 then
                return {
                    mult = card.ability.extra.mult * sell_cost
                }
            end
        end
    end,
}, true)

-- Smeared Joker: does not count Invisible Jokers
local smeared_check_ref = SMODS.smeared_check
function SMODS.smeared_check(card, suit)
    if not (card:get_quantity_value() > 0) then return false end
    return smeared_check_ref(card, suit)
end

-- Glass Joker - now quantity compatible!
SMODS.Joker:take_ownership('glass_joker', {
    config = { extra = { Xmult_gain = 0.75, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
        return MadLib.collect_vars(card.ability.extra.Xmult_gain, card.ability.extra.Xmult)
    end,
    calculate = function(self, card, context)
        if
            context.remove_playing_cards and not context.blueprint
        then
            local points = 0
            MadLib.loop_func(context.removed, function(v)
                if not removed_card.shattered then return end
                points = points + get_quantity_value()
            end)
            if points > 0 then
                MadLib.event({
                    func = function()
                        MadLib.event({
                            func = function()
                                card.ability.extra.Xmult = card.ability.extra.Xmult +
                                    card.ability.extra.Xmult_gain * points
                                return true
                            end
                        })
                        SMODS.calculate_effect({
                                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult +
                                card.ability.extra.Xmult_gain * points } }
                            }, card)
                        return true
                    end
                })
                return nil, true -- This is for Joker retrigger purposes
            end
        end
        if
            context.using_consumeable
            and not context.blueprint
            and context.consumeable.config.center.key == 'c_hanged_man'
        then
            local points = 0
            MadLib.loop_func(G.hand.highlighted, function(v)
                if SMODS.has_enhancement(v, 'm_glass') then return end
                points = points + v:get_quantity_value()
            end)
            if points > 0 then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain * points
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
}, true)

-- Raised Fist - does not count Invisible cards. Also adopts UnStable's code because
-- it helps with modded ranks.
SMODS.Joker:take_ownership('raised_fist', {
    config = { extra = { x_mult = 2 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.x_mult)
    end,
	calculate = function(self, card, context)
		if
            context.individual
            and context.cardarea == G.hand
            and not context.end_of_round
        then
			local temp_mult = 99999
			local raised_card = nil

			-- Which card is it?
			MadLib.loop_func(G.hand.cards, function(v)
                if
                    SMODS.has_no_rank(v)
                    or temp_mult < SMODS.Ranks[v.base.value].sort_nominal
                    or v:get_quantity_value()
                then
                    return
                end
                temp_mult = v:get_nominal()
                raised_card = v
            end)

            -- Does the scoring
			if raised_card == context.other_card then
				if context.other_card.debuff then
					return {
						message = localize('k_debuffed'),
						colour = G.C.RED,
						card = card,
					}
				else
					return {
                        mult = card.ability.extra.x_mult * temp_mult * raised_card:get_quantity_value(),
                        card = card
                    }
				end
            end
		end
	end,
}, true)

-- Steel Joker - now quantity compatible!
SMODS.Joker:take_ownership('steel_joker', {
    config = { extra = { x_mult = 0.2 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
        local steel_tally = MadLib.loop_func(G.playing_cards, function(v)
            return SMODS.has_enhancement(playing_card, 'm_steel')
                and v:get_quantity_value() or 0
        end)
        return MadLib.collect_vars(card.ability.extra.xmult, card.ability.extra.xmult * steel_tally)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local steel_tally = MadLib.loop_func(G.playing_cards, function(v)
                return SMODS.has_enhancement(playing_card, 'm_steel')
                    and v:get_quantity_value() or 0
            end)
            return {
                xmult = 1 + card.ability.extra.x_mult * steel_tally,
            }
        end
    end,
}, true)

-- Stone Joker - now quantity compatible!
SMODS.Joker:take_ownership('stone_joker', {
    config = { extra = { chips = 25 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        local stone_tally = MadLib.loop_func(G.playing_cards, function(v)
            return SMODS.has_enhancement(playing_card, 'm_stone')
                and v:get_quantity_value() or 0
        end)
        return MadLib.collect_vars(card.ability.extra.chips, card.ability.extra.chips * stone_tally)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local stone_tally = MadLib.loop_func(G.playing_cards, function(v)
                return SMODS.has_enhancement(playing_card, 'm_stone')
                    and v:get_quantity_value() or 0
            end)
            return {
                chips = card.ability.extra.chips * stone_tally
            }
        end
    end,
}, true)

-- Abstract Joker - now quantity compatible!
SMODS.Joker:take_ownership('abstract_joker', {
    config = { extra = { mult = 3 } },
    loc_vars = function(self, info_queue, card)
        local amt = 0
        MadLib.loop_func(G.jokers and G.jokers.cards or {}, function(v) amt = amt + v:get_quantity_value() or 0 end)
        return MadLib.collect_vars(card.ability.extra.mult, card.ability.extra.mult * amt)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local amt = 0
            MadLib.loop_func(G.jokers.cards, function(v) amt = amt + v:get_quantity_value() or 0 end)
            return {  mult = card.ability.extra.mult * (v:get_quantity_value() or 0) }
        end
    end,
}, true)

-- Madness
SMODS.Joker:take_ownership('madness', {
    config = { extra = { xmult_gain = 0.5, xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.xmult_gain, card.ability.extra.xmult)
    end,
    calculate = function(self, card, context)
        if
            context.setting_blind
            and not context.blueprint
            and not context.blind.boss
        then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            local destructable_jokers = {}
            MadLib.loop_func(G.jokers.cards, function(v)
                if
                    v ~= card
                    or SMODS.is_eternal(v, card)
                    or v.getting_sliced
                    or not v:get_quantity_value() > 0 -- invisible cannot be sliced
                then
                    return
                end
                destructable_jokers[#destructable_jokers + 1] = v
            end)
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card and not SMODS.is_eternal(G.jokers.cards[i], card) and not G.jokers.cards[i].getting_sliced then
                    destructable_jokers[#destructable_jokers + 1] =
                        G.jokers.cards[i]
                end
            end
            local joker_to_destroy = pseudorandom_element(destructable_jokers, 'vremade_madness')

            if joker_to_destroy then
                joker_to_destroy.getting_sliced = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        (context.blueprint_card or card):juice_up(0.8, 0.8)
                        joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
                        return true
                    end
                }))
            end
            return { message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } } }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
}, true)

-- Square Joker - now quantity compatible!
SMODS.Joker:take_ownership('square', {
    config = { extra = { chips = 0, chip_mod = 4 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.chips, card.ability.extra.chip_mod)
    end,
    calculate = function(self, card, context)
        if
            context.before
            and not context.blueprint
            and Madcap.Funcs.get_modified_card_quantity(context.full_hand) == 4
        then
            -- See note about SMODS Scaling Manipulation on the wiki
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
}, true)

-- Vampire does not view Invisible cards
SMODS.Joker:take_ownership('vampire', {
    config = { extra = { Xmult_gain = 0.1, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.Xmult_gain, card.ability.extra.Xmult)
    end,
    calculate = function(self, card, context)
        if
            context.before
            and not context.blueprint
        then
            local points = 0
            MadLib.loop_func(context.scoring_hand, function(v)
                if
                    not (next(SMODS.get_enhancements(v)))
                    or v.debuff
                    or v.vampired
                    or not v:get_quantity_value() > 0 -- invisible cannot be sliced
                then
                    return
                end
                points = v:get_quantity_value()
                v.vampired = true
                v:set_ability('c_base', nil, true)

                MadLib.event({
                    func = function()
                        v:juice_up()
                        v.vampired = nil
                        return true
                    end
                })
            end)
            if points > 0 then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain * points
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                    colour = G.C.MULT
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
}, true)

-- Hologram
SMODS.Joker:take_ownership('hologram', {
    config = { extra = { Xmult_gain = 0.25, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.Xmult_gain, card.ability.extra.Xmult)
    end,
    calculate = function(self, card, context)
        if
            context.playing_card_added
            and not context.blueprint
        then
            local points = 0
            MadLib.loop_func(context.cards, function(v)
                points = points + v:get_quantity_value()
            end)
            if points > 0 then
                card.ability.extra.Xmult = card.ability.extra.Xmult + points * card.ability.extra.Xmult_gain
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                }
            end
        end
        if context.joker_main then
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end,
}, true)

-- Baseball Joker - now quantity compatible
SMODS.Joker:take_ownership('baseball', {
    config = { extra = { xmult = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.xmult)
    end,
    calculate = function(self, card, context)
        if
            context.other_joker
            and (context.other_joker.config.center.rarity == 2 or context.other_joker.config.center.rarity == "Uncommon")
        then
            local amt = v:get_quantity_value()
            if amt > 0 then
                return {
                    xmult = card.ability.extra.xmult ^ amt
                }
            end
        end
    end,
}, true)

-- Trading Card - now quantity compatible
SMODS.Joker:take_ownership('trading_card', {
    config = { extra = { dollars = 3 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.dollars)
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if
            context.discard
            and not context.blueprint
            and G.GAME.current_round.discards_used <= 0
            and #context.full_hand == 1
        then
            local amt = v:get_quantity_value()
            if amt > 0 then
                return {
                    dollars = card.ability.extra.dollars * amt,
                    remove = true
                }
            end
        end
    end
}, true)

-- Ramen - now quantity compatible
SMODS.Joker:take_ownership('ramen', {
    config = { extra = { Xmult_loss = 0.01, Xmult = 2 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.Xmult, card.ability.extra.Xmult_loss)
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
            if card.ability.extra.Xmult - card.ability.extra.Xmult_loss <= 1 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER
                }
            else
                local amt = v:get_quantity_value()
                if amt > 0 then
                    card.ability.extra.Xmult = card.ability.extra.Xmult - (card.ability.extra.Xmult_loss * v:get_quantity_value())
                    return {
                        message = localize { type = 'variable', key = 'a_xmult_minus', vars = { card.ability.extra.Xmult_loss * v:get_quantity_value() } },
                        colour = G.C.RED
                    }
                end
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}, true)

-- Castle - now quantity compatible
SMODS.Joker:take_ownership('castle', {
    config = { extra = { chips = 0, chip_mod = 3 } },
    loc_vars = function(self, info_queue, card)
        local suit = (G.GAME.current_round.castle_card or {}).suit or 'Spades'
        return { vars = { card.ability.extra.chip_mod, localize(suit, 'suits_singular'), card.ability.extra.chips, colours = { G.C.SUITS[suit] } } }
    end,
    calculate = function(self, card, context)
        if
            context.discard
            and not context.blueprint
            and not context.other_card.debuff
            and context.other_card:is_suit(G.GAME.current_round.castle_card.suit)
        then
            local amt = v:get_quantity_value()
            if amt > 0 then
                card.ability.extra.chips = card.ability.extra.chips + (card.ability.extra.chip_mod * amt)
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS
                }
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}, true)

MadLib.loop_func({
   'c_magician',
   'c_empress',
   'c_heirophant', -- what the fuck
   'c_lovers',
   'c_chariot',
   'c_devil',
   'c_tower',
   'c_justice',
}, function(v)
    tell('Take ownership of ' .. v)
    SMODS.Consumable:take_ownership(v, {
        loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
            return MadLib.collect_vars( card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv })
        end,
        can_use = function(self, card)
            return MadLib.can_use_transform_tarot(card)
        end
    })
end)

MadLib.loop_func({
   'c_strength',
   'c_hanged_man',
   'c_death',
}, function(v)
    tell('Take ownership of ' .. v)
    SMODS.Consumable:take_ownership(v, {
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars( card.ability.max_highlighted)
        end,
        can_use = function(self, card)
            return MadLib.can_use_transform_tarot(card)
        end
    })
end)
