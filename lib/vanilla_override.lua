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

function MadLib.is_rank(card,id)
    if MadLib.get_quantum_rank_pass(card,id) then return true end
    return (card and card:get_id() or card.base.id) == id
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
            return MadLib.is_rank(card,MadLib.rank_to_id(v))
        end)
end

-- Ditto, but with Fibonacci ranks.
function MadLib.has_fib_rank(card)
    print(MadLib.RankTypes.Fibonacci)
    return not SMODS.has_no_rank(card)
        and MadLib.list_matches_one(MadLib.RankTypes.Fibonacci, function(v) 
            return MadLib.is_rank(card,MadLib.rank_to_id(v))
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
		    if 
                not SMODS.has_no_rank(context.other_card)
                and MadLib.list_matches_one(Madcap.Lists.Hack, function(v) 
                    return MadLib.is_rank(context.other_card,SMODS.Ranks[v].id)
                end) 
            then
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
    config = { extra = { odds = 4 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, '8ball')
        return { vars = { numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if 
            context.individual and context.cardarea == G.play and
            (#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit)
        then
            if 
                MadLib.is_rank(context.other_card, SMODS.Ranks['8'].id) 
                and SMODS.pseudorandom_probability(card, '8ball', 1, card.ability.extra.odds) 
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
	config = { extra = { mult = 4, chips = 20 } },
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.play) then 
        return MadLib.is_rank(context.other_card, SMODS.Ranks['Ace'].id) and {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips
            } or {}
        end
    end
}, true)

-- Sixth Sense
SMODS.Joker:take_ownership('sixth_sense', {
    calculate = function(self, card, context)
        if context.destroy_card and not context.blueprint then
            if 
                #context.full_hand == 1 
                and context.destroy_card == context.full_hand[1] 
                and MadLib.is_rank(context.full_hand[1], SMODS.Ranks['6'].id)
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
    calculate = function(self, card, context)
        if 
            context.joker_main and next(context.poker_hands["Straight"]) 
            and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
        then
            local ace_check = MadLib.list_matches_one(context.scoring_hand, function(v)
                return MadLib.is_rank(v, SMODS.Ranks['Ace'].id)
            end)
            if ace_check then
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
    calculate = function(self, card, context)
        if 
            context.individual 
            and context.cardarea == G.hand 
            and not context.end_of_round 
            and MadLib.is_rank(context.other_card, SMODS.Ranks['King'].id)
        then
            return not context.other_card.debuff and {
                x_mult = card.ability.extra.xmult
            } or {
                message = localize('k_debuffed'),
                colour = G.C.RED
            }
        end
    end
}, true)

-- Cloud 9
SMODS.Joker:take_ownership('cloud_9', {
    calc_dollar_bonus = function(self, card)
        local nines = 0
        MadLib.loop_func(G.playing_cards) do
            if MadLib.is_rank(v, SMODS.Ranks['9'].id) then nines = nines + 1 end
        end
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
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            return {
                dollars = card.ability.extra.dollars,
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
    config = { extra = { chips = 10, mult = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return (MadLib.is_rank(context.other_card, SMODS.Ranks['10'].id) or MadLib.is_rank(context.other_card, SMODS.Ranks['4'].id)) and {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            } or {}
        end
    end
}, true)

-- Wee Joker
SMODS.Joker:take_ownership('wee', {
    config = { extra = { chips = 0, chip_mod = 8 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_mod } }
    end,
    calculate = function(self, card, context)
        if 
            context.individual 
            and context.cardarea == G.play
            and not context.blueprint 
        then
            if MadLib.is_rank(context.other_card, SMODS.Ranks['2'].id) then 
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
    config = { extra = { xmult = 2 } },
    loc_vars = function(self, info_queue, card)
        local idol_card = G.GAME.current_round.idol_card or { rank = 'Ace', suit = 'Spades' }
        return { vars = { card.ability.extra.xmult, localize(idol_card.rank, 'ranks'), localize(idol_card.suit, 'suits_plural'), colours = { G.C.SUITS[idol_card.suit] } } }
    end,
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
    config = { extra = { xmult_gain = 0.5, xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
            if  context.other_card.debuff and MadLib.is_rank(context.other_card, SMODS.Ranks['Jack'].id) then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } },
                colour = G.C.RED
            }
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.xmult = 1
            return { message = localize('k_reset'), colour = G.C.RED }
        end
        if context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end
    end
}, true)

-- Shoot the Moon
SMODS.Joker:take_ownership('shoot_the_moon', {
    config = { extra = { mult = 13 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then 
            return MadLib.is_rank(context.other_card, SMODS.Ranks['Queen'].id) and
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
    config = { extra = { xmult = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return (MadLib.is_rank(context.other_card, SMODS.Ranks['Queen'].id) or MadLib.is_rank(context.other_card, SMODS.Ranks['King'].id))
            and {
                xmult = card.ability.extra.xmult
            } or {}
        end
    end
}, true)

if next(SMODS.find_mod("paperback")) then
    -- Fixes the Paperback rank function.
    function PB_UTIL.is_rank(card, rank)
        if not card or not card.get_id then return end
        if type(rank) == 'string' then
            return MadLib.is_rank(card, SMODS.Ranks[rank].id)
        elseif type(rank) == 'number' then
            return MadLib.is_rank(card, rank)
        end
    end

    -- Jestrica
    SMODS.Joker:take_ownership('paperback_jestrica', {
        calculate = function(self, card, context)
            -- Give mult when scored and copied
            if context.joker_main and context.cardarea == G.jokers then
                return { mult = card.ability.extra.mult }
            end
            -- Upgrade this Joker for every scored 8
            if not context.blueprint and context.individual and context.cardarea == G.play then
                if MadLib.is_rank(context.other_card, SMODS.Ranks['8'].id) then
                    card.ability.extra.scored = true
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.increase

                    return {
                        extra = {
                            focus = card,
                            message = localize('k_upgrade_ex'),
                            colour = G.C.MULT,
                        },
                        card = card
                    }
                end
            end
            -- Check if this Joker's mult should reset depending on if an 8 was scored this round
            if not context.blueprint and context.end_of_round and context.main_eval then
                if not card.ability.extra.scored and card.ability.extra.mult > 0 then
                    card.ability.extra.mult = 0

                    return {
                        message = localize('k_reset'),
                        colour = G.C.MULT
                    }
                end
                -- Reset the scored flag after round ends
                card.ability.extra.scored = false
            end
        end
    }, true)

    -- Jestrogen
    SMODS.Joker:take_ownership('paperback_jestrogen', {
        config = {
            extra = { ranks = { 'Jack', 'King' }, rank_to = 'Queen' }
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    localize(card.ability.extra.ranks[1], 'ranks'), 
                    localize(card.ability.extra.ranks[2], 'ranks'), 
                    localize(card.ability.extra.rank_to, 'ranks'),
                }
            }
        end,
        calculate = function(self, card, context)
            if 
                context.final_scoring_step 
                and context.cardarea == G.jokers 
                and not context.blueprint 
            then
                local cracked_eggs = MadLib.get_list_matches(context.scoring_hand, function(v)
                    return MadLib.list_matches_one(card.ability.extra.ranks, function(v2)
                        return MadLib.is_rank(v, SMODS.Ranks[v2].id)
                    end)
                end)
      
                if #cracked_eggs > 0 then
                    PB_UTIL.use_consumable_animation(nil, cracked_eggs, function()
                        MadLib.loop_func(cracked_eggs, function(v)
                            assert(SMODS.change_base(v, nil, card.ability.extra.rank_to))
                        end)
                        return true
                    end)
                    return {
                        message = localize('paperback_jestrogen_ex'),
                        colour = G.C.RED
                    }
                end
            end
        end
    }, true)

    -- Power Surge
    SMODS.Joker:take_ownership('paperback_power_surge', {
        config = {
            extra = { rank = '7', x_mult = 2, odds = 4 }
        },
        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play then
                if MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank].id) then
                    if PB_UTIL.chance(card, 'power_surge') then
                        local destroyed_card = #G.hand.cards > 0 and
                        pseudorandom_element(G.hand.cards, pseudoseed('power_surge_destroy'))

                        if destroyed_card then destroyed_card.ability.paperback_destroyed = true end
                    end

                    return { xmult = card.ability.extra.x_mult }
                end
            end
            if 
                context.destroy_card 
                and context.cardarea == G.hand 
                and context.destroy_card.ability.paperback_destroyed
            then
                context.destroy_card.ability.paperback_destroyed = nil
                return { remove = true }
            end
        end
    }, true)

    -- Emergency Broadcast
    SMODS.Joker:take_ownership('paperback_emergency_broadcast', {
        config = {
            extra = { ranks = { '5', '8' }, mult = 5, a_chips = 8 }
        },
        calculate = function(self, card, context)
            if 
                not card.debuff
                and context.individual 
                and context.cardarea == G.play
                and MadLib.list_matches_one(card.ability.extra.ranks, function(v)
                    return MadLib.is_rank(context.other_card, SMODS.Ranks[v].id)
                end)
            then
                return {
                    mult = card.ability.extra.a_mult,
                    chips = card.ability.extra.a_chips,
                    card = card
                }
            end
        end
    }, true)

    SMODS.Joker:take_ownership('paperback_skydiver', {
        calculate = function(self, card, context)
            local active = MadLib.list_matches_one(context.scoring_hand, function(v)
                return not SMODS.has_no_rank(v)
                    and MadLib.is_rank(v, card.ability.extra.lowest_rank)
            
            end)


        end
    }, true)

calculate = function(self, card, context)
    if not card.debuff then
      -- Give the xMult during play if conditions are met
      if context.joker_main then
        local active = true

        -- If there is a scored card with a rank that has a higher rank than the lowest
        -- recorded by this joker, do not trigger the effect
        for _, v in ipairs(context.scoring_hand) do
          if not SMODS.has_no_rank(v) and PB_UTIL.compare_ranks(v:get_id(), card.ability.extra.lowest_rank) then
            active = false
            break
          end
        end

        if active then
          return {
            x_mult = card.ability.extra.x_mult,
            card = card
          }
        end
      end

      if context.after and context.main_eval and not context.blueprint then
        local last_lowest = card.ability.extra.lowest_rank

        if context.scoring_hand then
          for _, v in pairs(context.scoring_hand) do
            if not SMODS.has_no_rank(v) then
              local other_rank = v.base.value

              -- If the lowest rank is higher than or equal to the new rank, that means we have a new low
              if PB_UTIL.compare_ranks(last_lowest, other_rank, true) then
                last_lowest = other_rank
              end
            end
          end

          -- If the rank was updated
          if card.ability.extra.lowest_rank ~= last_lowest then
            card.ability.extra.lowest_rank = last_lowest

            return {
              message = localize(card.ability.extra.lowest_rank, 'ranks'),
            }
          end
        end
      end

      if context.end_of_round and context.main_eval and not context.blueprint then
        PB_UTIL.reset_skydiver(card)

        return {
          message = localize('k_reset'),
          colour = G.C.MULT
        }
      end
    end
  end
end