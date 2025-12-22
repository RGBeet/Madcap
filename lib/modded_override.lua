local big_juice = function(card)
    card:juice_up(0.7)
end

-- TOGA'S Stuff
if MadLib.mod_loaded('TOGAPack') then

    function Madcap.Funcs.vista_can_apply(card,ed)
        return card and card.edition and not card.edition[ed]
    end

    --[[
    MadLib.RankManipulation['j_toga_megasxlr'] = { from_rank = '8', to_rank = 'King' }
    MadLib.RankManipulation['j_toga_hexadecimaljkr'] = { from_rank = 'Ace', to_rank = '10' }
    MadLib.RankManipulation['j_toga_binaryjkr'] = { from_rank = '10', to_rank = '2' }
    MadLib.FaceManipulation['j_toga_y2ksticker'] = { rank = '2', type = 'add' }
    ]]

    -- Windows Vista - modular rank and edition
    SMODS.Joker:take_ownership('toga_winvista', {
        config = {
            extra = { rank = '6', edition = 'negative' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.rank or '6', 'ranks'), MadLib.localize_name_text('Edition', 'e_'..(card.ability.extra.edition or 'negative')))
        end,
        calculate = function(self, card, context)
            if 
                (context.full_hand
                and #context.full_hand == 1
                and context.destroy_card == context.full_hand[1] 
                and MadLib.joker_check_rank(context.destroy_card, card, '6'))
                or context.forcetrigger 
            then
                return {
                    remove = true,
                    func = function()
                        local edition_current = card.ability.extra.edition or 'negative'
                        if #G.jokers.cards > 1 then
                            local iter, iterlimit, seljoker = 0, 10 * #G.jokers.cards, nil
                            repeat
                                iter = iter + 1
                                seljoker = pseudorandom_element(G.jokers.cards, pseudoseed('notverywow'))
                                if seljoker and Madcap.Funcs.vista_can_apply(seljoker, edition_current) then break end
                            until 
                                (seljoker and Madcap.Funcs.vista_can_apply(seljoker, edition_current)) 
                                or iter >= iterlimit
                            if Madcap.Funcs.vista_can_apply(seljoker, edition_current) then
                                MadLib.event({func = function()
                                    if seljoker and seljoker.edition and not seljoker.edition[edition_current] then
                                        local curcard = context.blueprint_card or card
                                        curcard:juice_up()
                                        seljoker:set_edition('e_'..(card.ability.extra.edition or 'negative'))
                                    end
                                    return true 
                                end })
                            end
                        end
                        return true
                    end
                }
            end
        end,
    }, true)

    SMODS.Joker:take_ownership('toga_win8', {
        config = {
            extra = { rank = '8', xmult = 0.08 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.rank or '8', 'ranks'), number_format(card.ability.extra.xmult))
        end,
        calculate = function(self, card, context)
            if 
                context.before 
                and context.full_hand 
                and #context.full_hand > 1 
            then
                local has_triggered = false
                for i = 1, #context.full_hand do
                    local pcard = context.full_hand[i]
                    if MadLib.joker_check_rank(context.full_hand[i], card, '8') then
                        if not has_triggered then 
                            has_triggered = true 
                            SMODS.calculate_effect({message = '!'}, context.blueprint_card or card)
                        end
                        SMODS.scale_card(pcard, {
                            ref_table = pcard.ability,
                            ref_value = "perma_h_x_mult",
                            scalar_table = card.ability.extra,
                            scalar_value = "xmult",
                        })
                    end
                end
                return nil, has_triggered
            end
        end,
    }, true)

    SMODS.Joker:take_ownership('toga_y2kbug', {
        config = {
            extra = { ranks = { '2', 'King' }, chips = 25, mult = 4, active = false }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.ranks[1] or '2', 'ranks'),
                localize(card.ability.extra.ranks[1] or 'King', 'ranks'),
                number_format(card.ability.extra.chips),
                number_format(card.ability.extra.mult))
        end,
        calculate = function(self, card, context)
            if context.before then
                if MadLib.list_matches_all(card.ability.extra.ranks or {'2', 'King' }, function(v)
                    return MadLib.list_matches_one(#context.full_hand, function(v2)
                        return MadLib.is_rank(v2, SMODS.Ranks[v].id)
                    end)
                end) then
                    card.ability.extra.active = true
                    return {
                        message = "!",
                        func = function()
                            MadLib.event({func = function()
                                card:juice_up(0.3, 0.3)
                                return true
                            end})
                        end
                    }
                else
                    card.ability.extra.active = false
                end
            end
            if context.individual and context.cardarea == G.play and card.ability.extra.active then
                return {chips = card.ability.extra.chips, mult = card.ability.extra.mult}
            end
        end,
    }, true)

    SMODS.Joker:take_ownership('toga_y2ksticker', {
        config = {
            extra = { rank = '2' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.ranks or '2', 'ranks'))
        end,
        rarity = 2,
        cost = 5
    }, true)
    
    local isfaceref = Card.is_face
    function Card:is_face(from_boss)
	    local result = isfaceref(self, from_boss)
        if G.jokers then
            MadLib.loop_func(G.jokers.cards, function(j)
                --local info = MadLib.FaceManipulation[j.config.center.key]
                if not info then return end
                local search = j.ability.extra.ranks or { j.ability.extra.rank } or info.ranks or { info.rank }
                local new_result = MadLib.list_matches_one(search, function(v)
                    return MadLib.is_rank(self, SMODS.Ranks[v].id)
                end)
                result = (new_result == true)
                    and ((info.type and info.type == 'remove') and false or true)
                    or ((info.type and info.type == 'set') and false or new_result)
            end)
        end
        return result
    end

    -- Mac OS X - modular rank. X is also hardcoded.
    SMODS.Joker:take_ownership('toga_mac_os_x', {
        config = {
            extra = { rank = '10', h_x_chips = 1.25 } -- nerfed
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.ranks or '10', 'ranks'),
                localize('rgmc_X', 'ranks'),
                number_format(math.max(1.25, card.ability.extra.h_x_chips)))
        end,
        rarity = 2, -- now uncommon!
        calculate = function(self, card, context)
            card.ability.extra.h_x_chips = math.max(card.ability.extra.h_x_chips, 1.25)
            if 
                context.individual 
                and context.cardarea == G.hand 
                and not context.end_of_round 
                and (MadLib.joker_check_rank(context.other_card, card, card.ability.extra.rank or '10')
                    or MadLib.joker_check_rank(context.other_card, card, 'rgmc_x'))
            then
                return not context.other_card.debuff and {
                    xchips = math.max(card.ability.extra.h_x_chips, 1)
                } or {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            end
        end,
    }, true)
    
    SMODS.Joker:take_ownership('toga_solitairejoker', {
        config = {
            extra = { rank = "Ace", poker_hand = 'Straight', draw_cards = 3 }
        },
        loc_vars = function(self, info_queue, card)
		    local togasolitaire = G.GAME.current_round.togabalatro and G.GAME.current_round.togabalatro.solitaire or {}
            return MadLib.collect_vars(localize(card.ability.extra.poker_hand, 'poker_hands'),
                math.floor(card.ability.extra.draw_cards),
                localize(card.ability.extra.rank or 'Ace', 'ranks'))
        end,
    }, true)

    -- Solitaire Jokers now have individual rank.
    togabalatro.reset_solitaire = function(run_start)
        if run_start then G.GAME.current_round.togabalatro.solitaire = {} end
        if G.jokers then
            MadLib.loop_func(G.jokers.cards, function(j)
                if j.config.center.key == 'j_toga_solitairejoker' then
                    local valid_solitaire_cards = MadLib.get_list_matches(function(v)
                        return not SMODS.has_no_rank(v)
                    end) or {}
                    if #valid_solitaire_cards > 0 then
                        local pick = pseudorandom_element(valid_solitaire_cards, pseudoseed('solitaire'..G.GAME.round_resets.ante))
                        j.ability.extra.rank = pick.base.value or 'Ace'
                    end
                end
            end)
        end
    end

    -- SMS/Redstone enhancements and Solitaire Joker.
    togabalatro.playextracards = function()
        -- SMS enhancement.
        local sms_deck = {}
        if G.deck.cards and #G.deck.cards > 0 then
            MadLib.loop_func(G.deck.cards, function(v)
                if not SMODS.has_enhancement(v, 'm_toga_sms') then return end
                table.insert(sms_deck,v)
            end)
        end
        if #sms_deck > 0 then
            MadLib.loop_func(G.deck.cards, function(v)
                for v2 = 1, #sms_deck do
                    if SMODS.has_enhancement(v, 'm_toga_sms') and sms_deck[v2] == v then
                        if v:is_face() then inc_career_stat('c_face_cards_played', 1) end
                        v.base.times_played = v.base.times_played + 1
                        v.ability.played_this_ante = true
                        G.GAME.round_scores.cards_played.amt = G.GAME.round_scores.cards_played.amt + 1
                        draw_card(G.deck, G.play, v2*100 / #sms_deck, 'up', nil, v)
                    end
                end
            end)
        end
        -- Solitaire Joker drawing cards
        if G.jokers then
            MadLib.loop_func(G.jokers.cards, function(j)
                if j.config.center.key == 'j_toga_solitairejoker' then
                    local _, _, poker_hands = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
                    if next(poker_hands[j.ability.extra.poker_hand or 'Straight']) then
                        local cur_cards = {}
                        MadLib.loop_func(G.deck.cards, function(c)
                            if MadLib.is_rank(c, j.ability.extra.rank or 'Ace') then cur_cards[#cur_cards+1] = c end
                        end)
                        MadLib.loop_func(cur_cards, function(c,i)
                            draw_card(G.deck, G.hand, i*100/#cur_cards, 'up', true, c)
                        end)
                    end
                end
            end)
        end
        -- Redstone card drawing cards
        for i = 1, #G.hand.highlighted do
            if not G.hand.highlighted[i].debuff and SMODS.has_enhancement(G.hand.highlighted[i], 'm_toga_redstone') then draw_card(G.deck, G.hand, 1, 'up') end
        end
    end

end

-- Paperback
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

    PB_UTIL.light_suits = MadLib.SuitTypes.Light
    PB_UTIL.dark_suits  = MadLib.SuitTypes.Dark

    -- Jestrica
    SMODS.Joker:take_ownership('paperback_jestrica', {
        config = {
            extra = {
                rank        = '8',
                mult        = 0,
                mult_mod    = 1,
                scored      = false
            }
        },
        loc_vars = function(self, info_queue, card)
            local scored = (card.ability.extra.scored == true) and "Active!" or "Inactive"
            return MadLib.collect_vars(number_format(card.ability.extra.mult_mod),
                localize(card.ability.extra.rank or '8', 'ranks'),
                number_format(card.ability.extra.mult), scored)
        end,
        calculate = function(self, card, context)
            -- Give mult when scored and copied
            if context.joker_main and context.cardarea == G.jokers then
                return { mult = card.ability.extra.mult }
            end
            -- Upgrade this Joker for every scored 8
            if not context.blueprint and context.individual and context.cardarea == G.play then
                if MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank or '8'].id) then
                    card.ability.extra.scored = true
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod

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
            return MadLib.collect_vars(localize(card.ability.extra.ranks[1], 'ranks'), localize(card.ability.extra.ranks[2], 'ranks'), localize(card.ability.extra.rank_to, 'ranks'))
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
        loc_vars = function(self, info_queue, card)
            local numer, denom = Madcap.Funcs.fix_probabilities(SMODS.get_probability_vars(self, 1, card.ability.extra.odds, 'power_surge'))
            return MadLib.collect_vars(localize(card.ability.extra.rank, 'ranks'), number_format(card.ability.extra.x_mult), number_format(numer), number_format(denom))
        end,
        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play then
                if MadLib.joker_check_rank(context.other_card, card, '7') then
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
            extra = { ranks = { '5', '8' }, mult = 5, chips = 8 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.ranks[1], 'ranks'), localize(card.ability.extra.ranks[2], 'ranks'), number_format(card.ability.extra.mult), number_format(card.ability.extra.chips))
        end,
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
                    mult = card.ability.extra.mult,
                    chips = card.ability.extra.chips,
                    card = card
                }
            end
        end
    }, true)

    -- Surfer
    SMODS.Joker:take_ownership('paperback_surfer', {
        config = {
            extra = {
                chips       = 0,
                chip_mod    = 10,
                rank        = '10',
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.chip_mod), 
                localize(card.ability.extra.rank or '10', 'ranks'), 
                number_format(math.floor(card.ability.extra.chip_mod/2)),
                number_format(card.ability.extra.chips))
        end,
        calculate = function(self, card, context)
            -- Gains +10 chips for each 10 held in hand at end of round
            if 
                context.end_of_round 
                and context.individual 
                and context.cardarea == G.hand 
                and not context.blueprint
                and PB_UTIL.is_rank(context.other_card, card.ability.extra.rank) 
            then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_chips',
                        vars = { card.ability.extra.chip_mod }
                    },
                    colour = G.C.CHIPS,
                    juice_card = context.other_card,
                    message_card = card,
                }
            end

            -- Gains +5 chips for each 10 scored
            if 
                context.individual 
                and context.cardarea == G.play
                and not context.blueprint
                and PB_UTIL.is_rank(context.other_card, card.ability.extra.rank)
            then
                card.ability.extra.chips = card.ability.extra.chips + math.floor(card.ability.extra.chip_mod/2)

                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_chips',
                        vars = { math.floor(card.ability.extra.chip_mod/2) }
                    },
                    colour = G.C.CHIPS,
                    juice_card = context.other_card,
                    message_card = card,
                }
            end
            
            -- Give chips during scoring
            if context.joker_main then
                return { chips = card.ability.extra.chips }
            end
        end
    }, true)

    -- Plague Doctor
    SMODS.Joker:take_ownership('paperback_plague_doctor', {
        config = {
            extra = {
                poker_hand  = 'High Card',
                rank        = 'paperback_Apostle',
                x_mult      = 1.25
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                localize(card.ability.extra.poker_hand or 'High Card', 'poker_hands'), 
                localize(card.ability.extra.rank or 'paperback_Apostle', 'ranks'), 
                number_format(card.ability.extra.x_mult)
            )
        end,
        add_to_deck = function(self, card, from_debuff)
            if MadLib.loop_func(G.hand.cards, function(v)
                return MadLib.is_rank(v, SMODS.Ranks[card.ability.extra.rank or 'paperback_Apostle'].id)
            end) >= 12 then
                G.GAME.pool_flags.plague_doctor_can_spawn = false
                MadLib.event({
                    func = function()
                        card.getting_sliced = true
                        card:start_dissolve()
                        SMODS.add_card({
                            set = 'Joker',
                            key = 'j_paperback_white_night',
                            edition = card.edition,
                            stickers = { "eternal" }
                        })
                        return true
                    end
                })
            end
        end,
        calculate = function(self, card, context)
            if 
                context.final_scoring_step 
                and context.cardarea == G.jokers 
                and not context.blueprint
            then
                local count = MadLib.loop_func(G.hand.cards, function(v)
                    return MadLib.is_rank(v, SMODS.Ranks[card.ability.extra.rank or 'paperback_Apostle'].id)
                end)

                local target_card = context.scoring_hand[1]
                local target_rank = card.ability.extra.rank or 'paperback_Apostle'

                if 
                    context.scoring_name == (card.ability.extra.poker_hand or 'High Card')
                    and not MadLib.joker_check_rank(target_card, card, target_rank)
                then
                    count = count + 1
                    MadLib.simple_event(function()
                        target_card:flip()
                        play_sound('card1', 1)
                        target_card:juice_up(0.3, 0.3)
                        return true
                    end, 0.15, 'after')
                    
                    delay(0.2)
                    MadLib.simple_event(function()
                        assert(SMODS.change_base(target_card, nil, target_rank))
                        return true
                    end, 0.1, 'after')

                    MadLib.simple_event(function()
                        target_card:flip()
                        play_sound('tarot2', 1, 0.6)
                        target_card:juice_up(0.3, 0.3)
                        return true
                    end, 0.15, 'after')

                    if PB_UTIL.config.plague_doctor_quotes_enabled then
                        local quote = (count > 12) and 12 or count
                        MadLib.simple_event(function()
                            PB_UTIL.plague_quote({
                                text = localize('paperback_plague_quote_' .. quote .. '_1'),
                                colour = G.C.RED,
                                major = G.play,
                                hold = 4 * G.SETTINGS.GAMESPEED,
                                offset = { x = 0, y = -3 },
                                scale = 0.6
                            })
                            PB_UTIL.plague_quote({
                                text = localize('paperback_plague_quote_' .. quote .. '_2'),
                                colour = G.C.RED,
                                major = G.play,
                                hold = 4 * G.SETTINGS.GAMESPEED,
                                offset = { x = 0, y = -2.2 },
                                scale = 0.6
                            })
                            return true
                        end, 0.1, 'after')
                    end
                end
            end
        end
    }, true)

    -- As Above, So Below
    SMODS.Joker:take_ownership('paperback_as_above_so_below', {
        config = { extra = { rank = 'paperback_Apostle', poker_hand = 'Straight' } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.rank or 'paperback_Apostle', 'ranks'), 
                localize(card.ability.extra.poker_hand or 'Straight', 'poker_hands'))
        end,
        calculate = function(self, card, context)
            if 
                context.before 
                and #context.scoring_hand >= 5 
                and MadLib.list_matches_one(context.scoring_hand, function(v)
                    return MadLib.joker_check_rank(v, card, 'paperback_Apostle')
                end) 
            then
                if not next(context.poker_hands[card.ability.extra.poker_hand or 'Straight']) then
                    if PB_UTIL.try_spawn_card { set = 'Tarot' } then
                        return {
                            message = localize('k_plus_tarot'),
                            colour = G.C.SECONDARY_SET.Tarot
                        }
                    end
                else
                    if PB_UTIL.try_spawn_card { set = 'Spectral' } then
                        return {
                            message = localize('k_plus_spectral'),
                            colour = G.C.SECONDARY_SET.Spectral
                        }
                    end
                end
            end
        end
    }, true)

    -- Skydiver
    SMODS.Joker:take_ownership('paperback_skydiver', {
        calculate = function(self, card, context)
            if not card.debuff then
                local active = (not MadLib.list_matches_one(context.scoring_hand, function(v)
                    return not SMODS.has_no_rank(v)
                        and PB_UTIL.compare_ranks(v:get_id(), card.ability.extra.lowest_rank)
                end))
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
                    MadLib.loop_func(context.scoring_hand, function(v)
                        if SMODS.has_no_rank(v) then return end
                        local other_rank = v.base.value
                        if not PB_UTIL.compare_ranks(last_lowest, other_rank, true) then return end
                        -- If the lowest rank is higher than or equal to the new rank, that means we have a new low
                        last_lowest = other_rank
                    end)

                    -- If the rank was updated
                    if card.ability.extra.lowest_rank ~= last_lowest then
                        card.ability.extra.lowest_rank = last_lowest
                        return { message = localize(card.ability.extra.lowest_rank, 'ranks') }
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
    }, true)

    -- One Sin and Hundreds of Good Deeds
    SMODS.Joker:take_ownership('paperback_one_sin_and_hundreds_of_good_deeds', {
        config = {
            extra = {
                rank    = '3',
                mult    = 3,
                fed     = false,
                scaling = 1,
            }
        },
        loc_vars = function(self, info_queue, card)
            if not card.ability.extra.fed then
                return MadLib.collect_vars(localize(card.ability.extra.rank, 'ranks'), number_format(card.ability.extra.mult))
            else
                -- Changes desc and loc vars to the alternate ones if One Sin is fed
                return {
                    vars = {
                        localize(card.ability.extra.rank, 'ranks'),
                        card.ability.extra.scaling * (#G.deck.cards or 0)
                    },
                    key = "j_paperback_one_sin_and_hundreds_of_good_deeds_fed"
                }
            end
        end,
        calculate = function(self, card, context)
            if
                context.individual and context.cardarea == G.play
                and MadLib.joker_check_rank(context.other_card, card, '3')
                and card.ability.extra.fed
            then
                return {
                    mult = #G.deck.cards > 0 
                        and (card.ability.extra.scaling * #G.deck.cards)
                        or card.ability.extra.mult
                }
            end

            if context.before and SMODS.find_card('j_paperback_white_night', true) then
                local target = SMODS.find_card('j_paperback_white_night', true)[1]
                if #context.full_hand == 1 and PB_UTIL.is_rank(context.full_hand[1], 'paperback_Apostle') then
                    PB_UTIL.destroy_joker(target)
                    card.ability.extra.fed = true
                    return { message = localize('paperback_confessed_ex') }
                end
            end
        end
    }, true)

end

-- Aikoyori's Shenanigans
if next(SMODS.find_mod("aikoyorisshenanigans")) then
    -- Yona Yona Dance
    SMODS.Joker:take_ownership('akyrs_yona_yona_dance', {
        config = {
            extra = { ranks = { '4', '7' }, times = 2 },
        },
        loc_vars = function(self, info_queue, card)
            if AKYRS.config.show_joker_preview then
                info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_yona_yona_ex"]
            end
            return {
                vars = {
                    card.ability.extra.times,
                    card.ability.extra.ranks[1],
                    card.ability.extra.ranks[2],
                }
            }
        end,
        calculate = function(self, card, context)
            if
                context.repetition
                and MadLib.list_matches_one(card.ability.extra.ranks, function(v)
                    return MadLib.is_rank(context.other_card, SMODS.Ranks[v].id)
                end)
            then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.times,
                }
            end
        end,
    }, true)
end

-- Bunco
if next(SMODS.find_mod("Bunco")) then
    Madcap.Lists.CropCircles = {
        Suits = {
            ['Clubs']           = 3,
            ['bunc_Fleurons']   = 4,
            ['rgmc_Blooms']     = 5,
        },
        Ranks = {
            [MadLib.RankIds['0']] = 1,
            ['6']   = 1,
            ['8']   = 2,
            ['9']   = 1,
            ['10']  = 1,
            ['rgmc_10.5']   = 1,
            ['Queen']       = 1,
            ['rgmc_16']     = 1,
            ['rgmc_64']     = 1,
            ['rgmc_128']    = 2,
        }
    }

    -- Crop Circles
    SMODS.Joker:take_ownership('bunc_crop_circles', {
        config = {
            extra = { mult_mod = 1 }
        },
        calculate = function(self, card, context)
            if
                context.individual
                and context.cardarea == G.play
                and context.other_card
            then
                local target = context.other_card
                local mult = 0

                if not SMODS.has_no_rank(target) then
                    MadLib.loop_table(Madcap.Lists.CropCircles.Ranks, function(k,v)
                        if not MadLib.is_rank(target, SMODS.Ranks[k].id) then return end
                        mult = mult + (v * card.ability.extra.mult_mod)
                    end)
                end

                if not SMODS.has_no_suit(target) then
                    MadLib.loop_table(Madcap.Lists.CropCircles.Suits, function(k,v)
                        if not target:is_suit(k) then return end
                        mult = mult + (v * card.ability.extra.mult_mod)
                    end)
                end

                if mult > 0 then
                    if not context.blueprint and BUNCOMOD.funcs.exotic_in_pool() then
                        MadLib.event({
                            blocking = false,
                            func = function()
                                card.children.center:set_sprite_pos(coordinate_from_atlas_index(73))
                                return true
                            end
                        })
                    end
                    return { mult = mult, card = card }
                end
            end
        end,
    }, true)

    -- Dogs Playing Poker
    SMODS.Joker:take_ownership('bunc_dogs_playing_poker', {
        config = {
            extra = { x_mult = 2 }
        },
        calculate = function(self, card, context)
            if
                context.joker_main
                and context.scoring_hand
            then
                if MadLib.list_matches_all(context.scoring_hand, function(v)
                    return (not SMODS.has_no_rank(context.scoring_hand[i]))
                        and MadLib.list_matches_one(Madcap.Lists.Hack, function(v2)
                            return MadLib.is_rank(v,SMODS.Ranks[v2].id)
                        end)
                end) then
                    return {
                        x_mult = card.ability.extra.x_mult,
                        colour = G.C.RED,
                        card = card
                    }
                end
            end
        end
    }, true)

    -- Zero Shapiro
    SMODS.Joker:take_ownership('bunc_zero_shapiro', {
        config = {
            extra = { odds = 8 }
        },
        calculate = function(self, card, context)
            if
                context.individual
                and context.cardarea == G.play
                and context.other_card
                and (MadLib.list_matches_one(MadLib.get_combined_list(MadLib.RankTypes.Face, MadLib.RankTypes.Irregular), function(v)
                    return MadLib.is_rank(context.other_card, SMODS.Ranks[v].id)
                end) or SMODS.has_no_rank(context.other_card))
                and SMODS.pseudorandom_probability(card, pseudorandom('zero_shapiro' .. G.SEED), 1, card.ability.extra.odds, 'bunc_zero_shapiro')
            then
                return {
                    extra = {message = '+'..localize{type = 'name_text', key = 'tag_d_six', set = 'Tag'}, colour = G.C.GREEN},
                    card = card,
                    func = function()
                        MadLib.event({func = function()
                            add_tag(Tag('tag_d_six'))
                            return true
                        end})
                    end
                }
            end
        end
    }, true)

    function Madcap.Funcs.get_lowest_rank(group)
        group = group or G.playing_cards
        if not group then return '2' end
        local min_nominal = 9999
        local rank  = '2'
        local rank2 = nil 

        MadLib.loop_func(group, function(v)
            if SMODS.has_no_rank(v) then return end
            local nominal = nil
            for _, r in pairs(SMODS.Ranks) do
                if MadLib.is_rank(v, r.id) then
                    rank2       = r.key
                    nominal     = r.nominal + (r.face_nominal or 0)
                    break
                end
            end
            if nominal and nominal < min_nominal then
                min_nominal = nominal
                rank        = rank2
            end
        end)

        return rank
    end

    -- Pawn
    SMODS.Joker:take_ownership('bunc_pawn', {
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(Madcap.Funcs.get_lowest_rank(), 'ranks'))
        end,
        calculate = function(self, card, context)
            if
                context.after
                and context.scoring_hand and
                not context.blueprint
            then
                local rank      = Madcap.Funcs.get_lowest_rank()
                local condition = false
                MadLib.loop_func(context.scoring_hand, function(v)
                    if not MadLib.is_rank(v, SMODS.Ranks[rank].id) then return end
                    MadLib.simple_event(function()
                        v:flip();
                        play_sound('card1', 1);
                        v:juice_up(0.3, 0.3);
                        return true
                    end, 0.15, 'after')
                    MadLib.simple_event(function()
                        assert(SMODS.modify_rank(v, 1))
                        return true
                    end, 0.1, 'after')
                    MadLib.simple_event(function()
                        v:flip();
                        play_sound('tarot2', 1, 0.6);
                        big_juice(card);
                        v:juice_up(0.3, 0.3);
                        return true
                    end, 0.15, 'after')
                    if condition then delay(0.7 * 1.25) end
                end)
            end
        end
    }, true)

    -- Tangram
    SMODS.Joker:take_ownership('bunc_tangram', {
        config = { extra = { rank = '7' } },
        loc_vars = function(self, info_queue, card)
            local nominal = MadLib.get_rank_nominal(card.ability.extra.rank, true)
            return MadLib.collect_vars(localize(card.ability.extra.rank, 'ranks'), nominal)
        end,
        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play then
                local numbers = MadLib.loop_func(context.full_hand, function(v)
                    return MadLib.is_rank(v, SMODS.Ranks[card.ability.extra.rank])
                end)
                if MadLib.joker_check_rank(context.other_card, card, '7') then
                    return { mult = numbers, card = card }
                end
            end
        end
    }, true)
end

-- UnStable
if next(SMODS.find_mod("UnStable")) then

    -- Power of One
    SMODS.Joker:take_ownership('unstb_power_of_one', {
        config = {
            extra = { rank = MadLib.RankIds['1'], mult = 4 }
        },
        loc_vars = function(self, info_queue, card)
            local ones = G.playing_cards and MadLib.loop_func(G.playing_cards, function(v)
                return MadLib.joker_check_rank(v, card, MadLib.RankIds['1'])
            end) or 0
            return MadLib.collect_vars(ones * card.ability.extra.mult, localize(card.ability.extra.rank, 'ranks'))
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                local ones = MadLib.loop_func(G.playing_cards, function(v)
                    return MadLib.joker_check_rank(v, card, MadLib.RankIds['1'])
                end)
                return { mult = card.ability.extra.mult * ones }
            end
        end
    }, true)

    -- Binary Number
    Madcap.Lists.BinaryNumber = { 'unstb_0', 'unstb_1', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace', 'unstb_???' }
    SMODS.Joker:take_ownership('unstb_binary_number', {
        calculate = function(self, card, context)
            if context.after then
                local hand = context.full_hand
                if #hand > 4 then return end

                local is_binary, final_rank, suit_list = true, 0, {}

                MadLib.loop_func(hand, function(v)
                    if not is_binary then return end
                    if MadLib.is_rank(v, SMODS.Ranks[MadLib.RankIds['1']].id) then
                        final_rank = final_rank + 2 ^ (#hand-i)
                        suit_list[#suit_list+1] = hand[1].base.suit
                    elseif MadLib.is_rank(v, SMODS.Ranks[MadLib.RankIds['0']].id) then
                        is_binary = false
                        return
                    end
                end)

                if is_binary then
                    target_rank = Madcap.Lists.BinaryNumber[final_rank+1] or 'unstb_???'
                    MadLib.event({
                        func = function()
                            local rank = SMODS.Ranks[target_rank].card_key
                            local suit = SMODS.Suits[pseudorandom_element(suit_list, pseudoseed('binary')..G.SEED)].card_key
                            local _card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, G.P_CARDS[suit..'_'..rank], G.P_CENTERS.c_base, {playing_card = G.playing_card})
                            --Juice up the Joker
                            card:juice_up(0.3, 0.3)
                            _card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                            G.play:emplace(_card)
                            table.insert(G.playing_cards, _card)
                            MadLib.event({
                                func = function()
                                    playing_card_joker_effects({_card})
                                    return true
                                end
                            })
                            return true
                        end
                    })
                    MadLib.event({
                        func = function()
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            return true
                        end
					})
                    delay(1)
                    MadLib.event({
                        func = function()
                            draw_card(G.play,G.deck, 90,'up', nil)
                            return true
                        end
					})
                    end
                return nil, true
            end
        end,
    }, true)

    -- Jackhammer
    SMODS.Joker:take_ownership('unstb_jackhammer', {
        config = { extra = { rank = 'Jack', retriggers = 5, active = false, target = nil } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.retriggers, localize(card.ability.extra.rank, 'ranks'))
        end,
        calculate = function(self, card, context)
            if context.before and not context.blueprint then
                card.ability.extra.active = (MadLib.loop_func(context.scoring_hand, function(v)
                    return MadLib.is_rank(v, SMODS.Ranks[card.ability.extra.rank].id)
                end) == 1)
            end

            --Main context
            if
                context.cardarea == G.play and
                context.repetition
                and not context.repetition_only
                and card.ability.extra.is_activate
                and MadLib.joker_check_rank(context.other_card, card, 'Jack')
            then
                card.ability.extra.target = context.other_card
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retriggers,
                    card = context.blueprint_card or card
                }
            end

            if
                context.destroying_card
                and not context.blueprint
            then
				--This context is called on every single card in the scoring hand
				--Check if the card called is the same as target card
				if context.destroying_card == card.ability.extra.target then
					card.ability.extra.target = nil
					return { remove = true } -- Destroy the card.
				end
            end
        end
    }, true)

    -- Jack of All Trades (UnStable)
    SMODS.Joker:take_ownership('unstb_jack_of_all_trades', {
        config = {
            extra = {
                rank    = 'Jack',
                chips   = 20,
                mult    = 3,
                x_mult  = 1.25,
                dollars = 1
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.x_mult, card.ability.extra.dollars, localize(card.ability.extra.rank, 'ranks'))
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and context.cardarea == G.play
                and MadLib.joker_check_rank(context.other_card, card, 'Jack')
            then
				ease_dollars(card.ability.extra.money)
				return {
				  chips     = card.ability.extra.chips,
				  mult      = card.ability.extra.mult,
				  x_mult    = card.ability.extra.x_mult,
				  card      = card
				}
            end
        end
    }, true)

    -- Magic Trick Card
    SMODS.Joker:take_ownership('unstb_magic_trick_card', {
        config = {
            extra = {
                ranks   = { '7', 'Queen' },
                suits   = { 'Clubs', 'Hearts' }
            },
            immutable = { side = 1 }
        },
        loc_vars = function(self, info_queue, card)
            local side = card.ability.immutable.side
            local alt_side = (side == 1) and 2 or 1
            return {
                vars = {
                    localize(card.ability.extra.ranks[side], 'ranks'),
                    localize(card.ability.extra.suits[side], 'suits_plural'),
                    localize(card.ability.extra.ranks[alt_side], 'ranks'),
                    localize(card.ability.extra.suits[alt_side], 'suits_plural'),
                    colours = {
                        G.C.SUITS[card.ability.extra.suits[side]],
                        G.C.SUITS[card.ability.extra.suits[alt_side]]
                    }
                }
            }
        end,
        calculate = function(self, card, context)
            if
                context.pre_discard
                and not context.blueprint
                and not context.retrigger_joker
            then
                MadLib.simple_event(function ()
                    card:juice_up(0.5, 0.5)
                    card.ability.immutable.side = (card.ability.immutable.side == 1) and 2 or 1
					card.children.center:set_sprite_pos({ x = (card.ability.immutable.side - 1), y = 0 })
                    return true
                end, 0.3, 'after')
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Flipped!', colour = G.C.ORANGE, instant = true})
            end

            if
                context.after
                and not context.blueprint
                and not context.retrigger_joker
            then
                MadLib.loop_func(context.scoring_hand, function(v)
                    if  not (v:is_suit(card.ability.extra.suits[card.ability.immutable.side]) and MadLib.is_rank(v, SMODS.Ranks[card.ability.extra.ranks[card.ability.immutable.side]].id)) then return end

                    MadLib.simple_event(function()
                        big_juice(card)
                        card:flip()
                        play_sound('card1', 1)
                        v:juice_up(0.3, 0.3)
                        return true
                    end, 0.1, 'after')

                    MadLib.simple_event(function()
                        SMODS.change_base(v, card.ability.extra.suits[card.ability.immutable.side], card.ability.extra.ranks[card.ability.immutable.side])
                        return true
                    end, 0.08, 'after')

                    MadLib.simple_event(function()
                        big_juice(card)
                        card:flip()
                        play_sound('tarot2', 1, 0.6)
                        v:juice_up(0.3, 0.3)
                        return true
                    end, 0.1, 'after')

                    forced_message("Changed!", currentCard, G.C.ORANGE, true)
                end)
            end
        end
    }, true)

    -- Queensland
    SMODS.Joker:take_ownership('unstb_queensland', {
        config = {
            extra = {
                rank        = 'Queen',
                count_max   = 5,
                count       = 0,
            }
        },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = {set = 'Other', key = 'resource_tooltip'}
            return MadLib.collect_vars(card.ability.extra.count_max, card.ability.extra.count_max - card.ability.extra.count, localize(card.ability.extra.rank, 'ranks'))
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and context.cardarea == G.play
                and MadLib.joker_check_rank(context.other_card, card, 'Queen')
            then
                if card.ability.extra.count < card.ability.extra.count_max then
                    if not context.blueprint then card.ability.extra.count = card.ability.extra.count + 1 end
                    local other_card = context.other_card

                    Madlib.event({
                        func = function()
                            local rank = pseudorandom_element(SMODS.Ranks, pseudoseed('queensland')..G.SEED).card_key
                            local suit = SMODS.Suits[other_card.base.suit].card_key

                            local _card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, G.P_CARDS[suit..'_'..rank], G.P_CENTERS.m_unstb_resource, {playing_card = G.playing_card})

                            big_juice(context.blueprint_card or card)

                            _card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                            G.play:emplace(_card)
                            table.insert(G.playing_cards, _card)

                            Madlib.event({
                                func = function()
                                    playing_card_joker_effects({_card})
                                    return true
                            end })

                        return true end
                    })

                    MadLib.event({
                        func = function()
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            draw_card(G.play,G.deck, 90,'up', nil)
                            return true
                        end
                    })
                end
                return nil, true
            end

            if
                context.end_of_round
                and not context.other_card
                and not context.repetition
                and not context.game_over
                and not context.blueprint
                and card.ability.extra.count > 0
            then
                card.ability.extra.count = 0
                return { message = 'Reset!' }
            end
        end
    }, true)

    -- King of Pop
    SMODS.Joker:take_ownership('unstb_king_of_pop', {
        config = { extra = { rank = 'King', odds = 4 } },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'king_of_pop')
            info_queue[#info_queue+1] = G.P_TAGS.tag_double
            return MadLib.collect_vars(math.max(0,_denom - _numer), _denom, localize(card.ability.extra.rank, 'ranks'))
        end,
        calculate = function(self, card, context)
            --Pre-hand check
            if context.before and not context.blueprint then
                MadLib.loop_func(context.scoring_hand, function(v)
                    if
                        SMODS.pseudorandom_probability(card, 'king_of_pop', 1, card.ability.extra.odds)
                        and MadLib.joker_check_rank(v, card, 'King')
                        and v.config.center ~= G.P_CENTERS.c_base
                        and (not v.config.center.disenhancement)
                    then
                        v.to_destroy = true
                    end
                end)
            end

            if
                context.destroying_card
                and context.destroying_card.to_destroy
            then
                --print(inspect(context))
                MadLib.simple_event(function()
                    add_tag(Tag('tag_double'))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end, 0.5, 'after')
                forced_message("Tag!", card, G.C.SECONDARY_SET.Enhanced)
                if not context.blueprint then return { remove = true } end
            end
        end
    }, true)

    -- Polychrome Red Seal Steel Joker
    SMODS.Joker:take_ownership('unstb_prssj', {
        config = {
            extra = { odds = 2, rank = 'King' }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'prssj')
            return MadLib.collect_vars(math.max(0,_denom*4 - _numer), _denom, _denom*2, _denom*4, localize(card.ability.extra.rank, 'ranks'))
        end,
        calculate = function(self, card, context)

            -- 1 in 8 upgrade
            if context.before then
                if MadLib.loop_func(context.scoring_hand, function(v)
                    if
                        not v.debuff
                        and SMODS.pseudorandom_probability(card, 'prssj', 1, card.ability.extra.odds * 4)
                        and MadLib.joker_check_rank(v, card, 'King')
                    then
                        edition_upgrade(current_card)
                        return true
                    end
                end) > 0 then
                    return {
                        message = 'Upgrade!',
                        colour = G.C.SECONDARY_SET.Enhanced,
                        card = context.blueprint_card or card,
                    }
                end
            end

            -- 1 in 4 retrigger
            if
                context.cardarea == G.play
                and context.repetition
                and not context.repetition_only
                and not context.other_card.debuff
                and SMODS.pseudorandom_probability(card, 'prssj', 1, card.ability.extra.odds * 2)
                and MadLib.joker_check_rank(context.other_card, card, 'Jack')
            then
                return {
                    message = 'Again!',
                    repetitions = 1,
                    card = context.blueprint_card or card
                }
            end

            -- 1 in 2 XMULT
            if
                context.individual
                and context.cardarea == G.hand
                and not context.end_of_round
                and SMODS.pseudorandom_probability(card, 'prssj', 1, card.ability.extra.odds)
                and MadLib.joker_check_rank(context.other_card, card, 'Jack')
            then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = context.blueprint_card or card,
                    }
                else
                    return {
                        x_mult = card.ability.extra.hand_xmult,
                        card = context.blueprint_card or card
                    }
                end
            end
        end
    }, true)

    -- Salmon Run
    SMODS.Joker:take_ownership('unstb_salmon_run', {
        config = { extra = { rank = '7', odds = 7 } },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'salmon_run')
            return MadLib.collect_vars(number_format(math.max(0,_denom - _numer)), number_format(_denom), localize(card.ability.extra.rank, 'ranks'))
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and context.cardarea == G.play
                and MadLib.joker_check_rank(context.other_card, card, '7')
                and SMODS.pseudorandom_probability(card, 'salmon_run', 1, card.ability.extra.odds)
            then
                MadLib.event({
                    func = function()
                        -- Copy Card
                        local _card = copy_card(context.other_card, nil, nil, G.playing_card)
                        _card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                        G.play:emplace(_card)
                        table.insert(G.playing_cards, _card)
                        MadLib.event({
                            func = function()
                                playing_card_joker_effects({_card})
                                return true
                            end
                        })
                        return true
                    end
                })

                MadLib.event({
                    func = function()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        draw_card(G.play,G.deck, 90,'up', nil)
                        return true
                    end
                })
                return nil, true
            end
        end
    }, true)

    -- Cool S
    SMODS.Joker:take_ownership('unstb_cool_s', {
        config = { extra = { rank = '8' } },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'salmon_run')
            return MadLib.collect_vars(number_format(math.max(0,_denom - _numer)), number_format(_denom), localize(card.ability.extra.rank, 'ranks'))
        end,
        calculate = function(self, card, context)
            if
                context.after
                and not context.blueprint
                and not context.retrigger_joker
            then
                MadLib.loop_func(context.scoring_hand, function(v)
                    if not MadLib.joker_check_rank(context.other_card, card, '8') then return end

                    local pool = MadLib.get_list_matches(G.P_CENTER_POOLS["Enhanced"], function(e)
                        return e.replace_base_card and not e.disenhancement
                    end)

                    MadLib.simple_event(function()
                        v:flip()
                        play_sound('card1', 1)
                        v:juice_up(0.3, 0.3)
                        return true
                    end, 0.1, 'after')

                    MadLib.simple_event(function()
                        v:set_ability(pseudorandom_element(cen_pool, pseudoseed('cool_s'..G.SEED)))
                        return true
                    end, 0.05, 'after')

                    MadLib.simple_event(function()
                        v:flip()
                        play_sound('tarot2', 1)
                        big_juice(card);
                        v:juice_up(0.3, 0.3)
                        return true
                    end, 0.1, 'after')

                    delay(0.1)
                end)
            end
        end
    }, true)

    function Madcap.Funcs.inductor_compatible(card)
        return not SMODS.has_no_rank(card)
            and not SMODS.has_no_suit(card)
            and not card.config.center.replace_base_card
    end

    -- Inductor
    SMODS.Joker:take_ownership('unstb_inductor', {
        config = { extra = { odds = 2 } },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'inductor')
            return MadLib.collect_vars(math.max(0,_denom*4 - _numer), _denom, _denom*2, _denom*4)
        end,
        calculate = function(self, card, context)
            if
                context.after
                and context.scoring_hand
                and #context.scoring_hand > 1
                and not context.blueprint
                and not context.retrigger_joker
            then

                MadLib.loop_func(context.scoring_hand, function(v)
                    if not Madcap.Funcs.inductor_compatible(v) then return end
                    MadLib.loop_func(context.scoring_hand, function(v2)
                        if
                            Madcap.Funcs.inductor_compatible(v2)
                            and MadLib.is_rank(v, v2:get_id())
                            and v:is_suit(v2.base.suit)
                        then
                            local copy_enhancement  = SMODS.pseudorandom_probability(card, 'inductor', 1, card.ability.extra.odds)
                                and v.config.center ~= v2.config.center
                            local copy_edition      = SMODS.pseudorandom_probability(card, 'inductor', 1, card.ability.extra.odds*2)
                                and (v.edition or {}).key ~= (v2.edition or {}).key
                            local copy_seal         = SMODS.pseudorandom_probability(card, 'inductor', 1, card.ability.extra.odds*4)
                                and v.seal ~= v2.seal

                            if copy_enhancement or copy_edition or copy_seal then

                                --Flipping Animation
                                MadLib.simple_event(function()
                                    v:flip()
                                    play_sound('card1', 1)
                                    v:juice_up(0.3, 0.3)
                                    return true
                                end, 0.1, 'after')

                                MadLib.simple_event(function()
                                    --Copy enhancement
                                    if copy_enhancement then v:set_ability(v2.config.center) end

                                    --Copy edition
                                    if copy_edition then v:set_edition(v2.edition, true, true) end

                                    --Copy seal
                                    if copy_seal then v:set_seal(v2.seal, true, true) end
                                    return true
                                end, 0.05, 'after')

                                MadLib.simple_event(function()
                                    v:flip()
                                    play_sound('tarot2', 1)
                                    big_juice(card)
                                    v:juice_up(0.3, 0.3)
                                    return true
                                end, 0.1, 'after')

                                forced_message("Copied!", currentCard, G.C.RED, true)
                            end
                        end
                    end)
                end)
            end
        end
    }, true)

    -- Joker Island
    SMODS.Joker:take_ownership('unstb_joker_island', {
        config = { extra = { rank = '2', odds = 6 } },
        loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = 'Other', key = 'resource_tooltip'}
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'joker_island')
            return MadLib.collect_vars(localize(card.ability.extra.rank, 'ranks'), number_format(math.max(0,_denom - _numer)), number_format(_denom))
        end,
        set_ability = function(self, card, initial, delay_sprites)
            card.ability.extra.rank = G.playing_cards
                and get_valid_card_from_deck('jokerisland'..G.SEED).rank
                or '2'
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and context.cardarea == G.play
                and SMODS.pseudorandom_probability(card, 'joker_island', 1, card.ability.extra.odds)
                and MadLib.joker_check_rank(context.other_card, card, '2')
            then
                MadLib.event({
                    func = function()
                        local rank = pseudorandom_element(SMODS.Ranks, pseudoseed('jokerisland')..G.SEED).card_key
                        local suit = SMODS.Suits[currentCard.base.suit].card_key

                        local _card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, G.P_CARDS[suit..'_'..rank], G.P_CENTERS.m_unstb_resource, {playing_card = G.playing_card})

                        _card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                        G.play:emplace(_card)
                        table.insert(G.playing_cards, _card)

                        MadLib.event({
                            func = function()
                                playing_card_joker_effects({_card})
                                return true
                            end
                        })

                    return true end
                })
                MadLib.event({
                    func = function()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        draw_card(G.play,G.deck, 90,'up', nil)
                        return true
                    end
                })
			end

		if MadLib.get_generic_end_of_round(context) and not context.other_card then
			card.ability.extra.target_rank = get_valid_card_from_deck('jokerisland' .. G.SEED).rank
			return {  message = "Randomize" }
		end
    end
    }, true)
end

-- More Fluff
if next(SMODS.find_mod("MoreFluff")) then

    -- Simplified Joker - Invisible/Stereo compat
    SMODS.Joker:take_ownership('mf_simplified', {
        config = { extra = {mult = 4} },
        loc_vars = function(self, info_queue, center)
            return { vars = { center.ability.extra.mult } }
        end,
        calculate = function(self, card, context)
            if
                context.other_joker
                and context.other_joker.config.center.rarity == 1
                and context.other_joker.ability.set == "Joker"
            then
                local amt = context.other_joker:get_quantity_value()
                if amt > 0 then
                    MadLib.event({
                        func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                        end
                    })
                    return {
                        message = localize{type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult * amt } },
                        mult_mod = card.ability.extra.mult * amt
                    }
                end
            end
            if context.forcetrigger then
                return { mult = card.ability.extra.mult * card:get_quantity_value() }
            end
        end
    }, true)

    -- Rose-Tinted Glasses
    SMODS.Joker:take_ownership('mf_rosetinted', {
        config = { extra = { rank = '2' } },
        loc_vars = function(self, info_queue, card)
            return {vars = { card and card.ability.extra.rank or self.config.extra.rank } }
        end,
        calculate = function(self, card, context)
            if
                (context.destroying_card
                and not context.blueprint
                and #context.full_hand == 1
                and MadLib.joker_check_rank(context.full_hand[1], card, '2')
                and G.GAME.current_round.hands_played == 0)
                or context.forcetrigger
            then
                local amt = context.forcetrigger and card:get_quantity_value()
                    or context.full_hand[1]:get_quantity_value()
                -- Invisible does not count it
                for i=1, amt do
                    MadLib.event({
                        func = function()
                            add_tag(Tag('tag_double'))
                            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                            return true
                        end
                    })
                end
                if not context.forcetrigger and amt > 0 then return true end
            end
        end
    }, true)

    -- Pixel Joker
    SMODS.Joker:take_ownership('mf_pixeljoker', {
        config = {
            extra = {
                x_mult = 1.5,
                ranks = { 'Ace', MadLib.RankIds['1'], '4', '9' }
            }
        },
        calculate = function(self, card, context)
            if
                (context.individual
                and context.cardarea == G.play
                and MadLib.list_matches_one(card.ability.extra.ranks, function(c)
                    return MadLib.is_rank(context.other_card, SMODS.Ranks[c].id)
                end)) or context.forcetrigger
            then
                return {
                    x_mult = card.ability.extra.x_mult,
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    }, true)

    -- Hall of Mirrors
    SMODS.Joker:take_ownership('mf_hallofmirrors', {
        config = {
            h_size = 0,
            h_mod = 1,
            extra = { rank = '6' }
        },
        loc_vars = function(self, info_queue, card)
            local funny = {}
            --(card and card.ability.extra.ranks or self.config.extra.ranks, function(v)
            --   table.insert(funny, (v == 1) and G.C.FILTER or G.C.UI.TEXT_INACTIVE)
            --end)
            return MadLib.collect_vars(card.ability.h_mod, localize(card.ability.extra.rank, 'ranks'), card.ability.h_size)
        end,
        calculate = function(self, card, context)
            if
                context.forcetrigger
                or (context.individual
                    and context.cardarea == G.play
                    and MadLib.joker_check_rank(context.other_card, card, '6')
                    and not context.blueprint)
            then
                card.ability.h_size = card.ability.h_size + card.ability.h_mod
                G.hand:change_size(card.ability.h_mod)

                return {
                    extra = { focus = card, message = localize('k_upgrade_ex') },
                    card = card,
                    colour = G.C.GREEN
                }
            end
            if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
                G.hand:change_size(-card.ability.h_size)
                card.ability.h_size = 0
            end
        end
    }, true)

    -- Sudoku
    Madcap.Lists.Sudoku = { 'Ace', '2', '3', '4', '5', '6', '7', '8', '9'}
    SMODS.Joker:take_ownership('mf_sudoku', {
        config = {
            extra = {
                mf_x_mult = 5,
                ranks = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
            }
        },
        loc_vars = function(self, info_queue, card)
            local funny = {}
            MadLib.loop_func(card and card.ability.extra.ranks or self.config.extra.ranks, function(v)
                table.insert(funny, (v == 1) and G.C.FILTER or G.C.UI.TEXT_INACTIVE)
            end)
            return {
                vars = {
                    card.ability.extra.mf_x_mult,
                    colours = funny
                },
            }
        end,
        calculate = function(self, card, context)
            -- reset at end of round
            if
                context.end_of_round
                and context.cardarea == G.jokers
                and not context.blueprint
                and not context.repetition
                and G.GAME.blind.boss
            then
                MadLib.loop_table(card and card.ability.extra.ranks, function(v)
                    v = 0
                end)
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED,
                    card = card
                }
            end
            -- record all ranks
            if
                context.individual
                and context.cardarea == G.play
                and not context.blueprint
                and not context.repetition
            then
                local noted = false
                for i=1,9 do
                    local r = Madcap.Lists.Sudoku[i]
                    if MadLib.is_rank(context.other_card, SMODS.Ranks[r].id) then
                        noted = true
                        card.ability.extra.ranks[i] = 1
                        break
                    end
                end
                -- 1 counts as Ace
                if
                    not (noted or card.ability.extra.ranks[1] == 1)
                    and MadLib.is_rank(context.other_card, SMODS.Ranks[MadLib.RankIds['1']].id)
                then
                    card.ability.extra.ranks[1] = 1
                    noted = true
                end
                if noted then return { message = localize('k_noted_ex') } end
            end
            -- once all ranks have been scored
            if
                context.cardarea == G.jokers
                and context.joker_main
            then
                if MadLib.list_matches_all(card.ability.extra.ranks, function(v)
                    return v == 1
                end) or context.forcetrigger then
                    return { xmult = card.ability.mf_x_mult, }
                end
            end
        end
    }, true)

    -- Jack of All Trades
    SMODS.Joker:take_ownership('mf_jackofalltrades', {
        config = {
            extra = {
                mult = 2,
                chips = 10,
                dollars = 1,
                rank = 'Jack',
            }
        },
        loc_vars = function(self, info_queue, card)
            return { vars = {
                card.ability.extra.mult,
                card.ability.extra.chips,
                card.ability.extra.dollars,
                localize(card.ability.extra.rank, 'ranks'),
            }}
        end,
        calculate = function(self, card, context)
            if
                context.forcetrigger
                or context.individual
                and context.cardarea == G.hand
                and not context.end_of_round
                and MadLib.joker_check_rank(context.other_card, card, 'Jack')
            then
                return {
                    card = context.other_card,
                    mult = card.ability.extra.mult,
                    chips = card.ability.extra.chips,
                    dollars = card.ability.extra.dollars,
                }
            end
        end
    }, true)

    -- Slot Machine
    SMODS.Joker:take_ownership('mf_slotmachine', {
        config = {
            extra = {
                rank = '7',
                odds = 7,
                retriggers = 7,
            }
        },
        loc_vars = function(self, info_queue, card)
            local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'slotmachine')
            return {
                vars = {
                    new_numerator,
                    new_denominator,
                    card.ability.extra.retriggers,
                    localize(card.ability.extra.rank, 'ranks'),
                }
            }
        end,
        calculate = function(self, card, context)
            if
                context.repetition
                and MadLib.joker_check_rank(context.other_card, card, '7')
                and SMODS.pseudorandom_probability(card, 'slotmachine', 1, card.ability.extra.odds, 'slotmachine')
            then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retriggers,
                    card = card
                }
            end
        end
    }, true)

    -- Bowling Ball
    SMODS.Joker:take_ownership('mf_bowlingball', {
        config = {
            extra = {
                rank = '3',
                chips = 40,
                mult = 10,
            }
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    localize(card.ability.extra.rank, 'ranks'),
                    card.ability.extra.chips,
                    card.ability.extra.mult,
                }
            }
        end,
        calculate = function(self, card, context)
            if
                (context.individual
                and context.cardarea == G.play
                and MadLib.joker_check_rank(context.other_card, card, '3'))
                or context.forcetrigger
            then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
    }, true)

    -- Joker Display compat
    if JokerDisplay then

        -- Rose-Tinted Glasses
        JokerDisplay.Definitions["j_mf_rosetinted"].calc_function = function(card)
            local _, _, scoring_hand = JokerDisplay.evaluate_hand()
            local sixth_sense_eval = #scoring_hand == 1 and MadLib.is_rank(scoring_hand[1], SMODS.Ranks[card.ability.extra.rank].id)
            card.joker_display_values.active = G.GAME and G.GAME.current_round.hands_played == 0
            card.joker_display_values.count = (card.joker_display_values.active and sixth_sense_eval) and 1 or 0
        end

        -- Pixel Joker
        JokerDisplay.Definitions["j_mf_pixeljoker"].calc_function = function(card)
            local mult = 1
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                MadLib.loop_func(scoring_hand, function(v)
                    if not MadLib.list_matches_one(card.ability.extra.ranks, function(c)
                        return MadLib.is_rank(context.other_card, SMODS.Ranks[c].id)
                    end) then return end
                    mult = mult * card.ability.extra.x_mult ^ JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end)
            end
            card.joker_display_values.x_mult = mult
        end

        -- Sudoku Joker
        local sudoku_text = { }
        MadLib.number_func(9, function(i)
            table.insert(sudoku_text, {
                ref_table = "card.joker_display_values",
                ref_value = tostring(i)..'_on', colour = G.C.FILTER
            })
            table.insert(sudoku_text, {
                ref_table = "card.joker_display_values",
                ref_value = tostring(i)..'_off', colour = G.C.UI.TEXT_INACTIVE
            })
        end)

        -- Sudoku
        JokerDisplay.Definitions["j_mf_sudoku"] = {
            text = {{
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" },
                },
            }},
            reminder_text = rtext,
            calc_function = function(card)
                local okay = true
                Madcap.loop_table(card.ability.extra.ranks, function(i,v)
                    local num = i..""
                    if i == 1 then num = "A" end
                    local on = i.."_on"
                    local off = i.."_off"

                    card.joker_display_values[on] = (v >= 1) and num or ""
                    card.joker_display_values[off] = (v == 0) and num or ""

                    if v == 0 then okay = false end
                end)
                card.joker_display_values.x_mult = okay and card.ability.my_x_mult or 1
            end,
        }

        -- Bowling Ball
        JokerDisplay.Definitions["j_mf_bowlingball"].calc_function = function(card)
            local mult, chips = 0, 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                MadLib.loop_func(scoring_hand, function(v)
                    if not MadLib.is_rank(v, SMODS.Ranks[card.ability.extra.rank].id) then return end
                    mult = mult + card.ability.extra.mult * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    chips = chips + card.ability.extra.chips * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end)
            end
            card.joker_display_values.mult = mult
            card.joker_display_values.chips = chips
        end

    end
end

-- All In Jest!!!!!
if next(SMODS.find_mod("allinjest")) then

    -- Atom
    SMODS.Joker:take_ownership('aij_atom', {
        config = {
            extra = { rank = 'Ace', poker_hand = 'High Card' },
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.poker_hand, 'poker_hands'), localize(card.ability.extra.rank, 'ranks'))
        end,
        calculate = function(self, card, context)
            if
                context.before
                and #context.full_hand == 1
                and MadLib.joker_check_rank(context.full_hand[1], card, 'Ace')
            then
                local text = card.ability.poker_hand or 'High Card'
                level_up_hand(context.blueprint_card or card, text, nil, 1)
            end
        end
    }, true)

    function MadLib.checking_hand(context)
        return not context.end_of_round
            and context.individual
            and context.cardarea == G.hand
    end

    -- Nedda
    SMODS.Joker:take_ownership('aij_nedda', {
        config = {
            extra = { rank = 'Queen', xmult = 2 },
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.xmult, localize(card.ability.extra.rank, 'ranks'))
        end,
        calculate = function(self, card, context)
            if
                MadLib.checking_hand(context)
                and MadLib.joker_check_rank(context.full_hand[1], card, 'Queen')
            then
                return (not context.other_card.debuff)
                    and {
                        card = card,
                        xmult = card.ability.extra.xmult,
                    } or {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = card,
                    }
            end
        end
    }, true)

    -- Silvio
    SMODS.Joker:take_ownership('aij_silvio', {
        config = {
            extra = { ranks = { 'King', 'Queen' } },
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.ranks[1], 'ranks'), localize(card.ability.extra.ranks[2], 'ranks'))
        end,
        calculate = function(self, card, context)
            if
                context.repetition
                and context.cardarea == G.play
                and context.other_card
                and MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.ranks[1] or 'King'].id)
            then
                local count = MadLib.loop_func(G.hand.cards, function(v)
                    return MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.ranks[2] or 'Queen'].id)
                end)
                if count > 0 then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = count,
                        card = card
                    }
                end
            end
        end
    }, true)

    -- Soviet
    Madcap.Lists.RoyaltyRanks = { 'King', 'Queen' }
    SMODS.Joker:take_ownership('aij_soviet', {
        calculate = function(self, card, context)
            if context.joker_main then
                if not MadLib.list_matches_one(context.full_hand, function(v)
                    MadLib.loop_func(card.ability.extra.ranks or Madcap.Lists.RoyaltyRanks, function(v2)
                       return MadLib.is_rank(v, SMODS.Ranks[v2].id)
                    end)
                end) then
                    return { mult = card.ability.extra.mult }
                end
            end
            return nil
        end
    }, true)

    -- Fatuus
    SMODS.Joker:take_ownership('aij_fatuus', {
        calculate = function(self, card, context)
            if context.joker_main then
                if MadLib.list_matches_one(context.full_hand, function(v)
                    MadLib.loop_func(card.ability.extra.ranks or Madcap.Lists.RoyaltyRanks, function(v2)
                       return MadLib.is_rank(v, SMODS.Ranks[v2].id)
                    end)
                end) then
                    local valid_cards = MadLib.get_list_matches(context.full_hand, function(v)
                        return not v:get_seal(true)
                    end)
                    if not (#valid_cards > 0) then return end
                    local target = pseudorandom_element(valid_cards, pseudoseed('fatuus_target'))
                    if target then
                        MadLib.simple_event(function()
                            card:juice_up(0.5, 0.5)
                            target:juice_up(0.5, 0.5)
                            target:set_seal('Blue')
                            return true
                        end, 1.0, 'before')
                    end
                end
            end
            return nil
        end
    }, true)

    -- Fou du Roi
    SMODS.Joker:take_ownership('aij_fou_du_roi', {
        config = { extra = { odds = 2 } },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'fou_du_roi')
            return MadLib.collect_vars(number_format(math.max(0, _denom - _numer)), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if
                context.joker_main
                and MadLib.list_matches_one(context.full_hand, function(v)
                    MadLib.loop_func(card.ability.extra.ranks or Madcap.Lists.RoyaltyRanks, function(v2)
                       return MadLib.is_rank(v, SMODS.Ranks[v2].id)
                    end)
                end)
                and SMODS.pseudorandom_probability(card, 'vari_seala', 1, card.ability.extra.odds)
                and (#G.consumeables.cards + G.GAME.consumeable_buffer) < G.consumeables.config.card_limit
            then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    MadLib.simple_event(function()
                        local new_card = MadLib.get_random_card("Tarot")
                        new_card:add_to_deck()
                        table.insert(G.consumeables, new_card)
                        G.consumeables:emplace(new_card)
                        return true
                    end, 0.0, 'before')
                return {
                    message = localize('k_plus_tarot'),
                    card = card
                }
            end
        end
    }, true)

    -- Comedian's Manifesto
    SMODS.Joker:take_ownership('aij_comedians_manifesto', {
        config = { extra = { trigger = false, rank = 'Jack' } },
        calculate = function(self, card, context)
            if context.open_booster then
                card.ability.extra.trigger = context.card.ability.name:find('Standard')
            end
        end,
        update = function(self, card, dt)
            if
                G.pack_cards
                and card.ability.extra.trigger
                and G.pack_cards.cards
            then
                MadLib.loop_func(G.pack_cards.cards, function(v)
                    if MadLib.list_matches_one(card.ability.extra.ranks or Madcap.Lists.RoyaltyRanks, function(v2)
                        return MadLib.is_rank(v, SMODS.Ranks[v2].id)
                    end) then
                        MadLib.simple_event(function()
                            assert(SMODS.change_base(v, nil, card.ability.extra.rank or 'Jack'))
                            return true
                        end, 0.1, 'after')
                    end
                end)
            end
        end
    }, true)

    -- Tetraphobia
    SMODS.Joker:take_ownership('aij_tetraphobia', {
        config = {
            extra = {
                rank = '4',
                mult = 0,
                mult_mod = 1
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.mult_mod, localize(card.ability.extra.rank, 'ranks'), card.ability.extra.mult or 0)
        end,
        calculate = function(self, card, context)
            if
                context.discard
                and context.other_card and not context.other_card.debuff
                and MadLib.joker_check_rank(context.other_card, card, '4')
            then
                card.ability.extra.mult = (card.ability.extra.mult or 0) + card.ability.extra.mult_mod
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = '+'..(card.ability.extra.mult or 0)..' Mult',
                    colour = G.C.MULT
                })
                return { card = card }
            end
            if
                context.individual
                and context.cardarea == G.play
                and context.other_card and not context.other_card.debuff
                and MadLib.joker_check_rank(context.other_card, card, '4')
                and (card.ability.extra.mult or 0) > 0
            then
                card.ability.extra.mult = 0
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize('k_reset')..'!',
                    colour = G.C.RED
                })
                return { card = card }
            end
            if context.joker_main and (card.ability.extra.mult or 0) > 0 then
                return { mult = card.ability.extra.mult }
            end
        end
    }, true)

    -- Trypohobia - now also takes 0s
    SMODS.Joker:take_ownership('aij_trypophobia', {
        config = {
            extra = {
                ranks = { '8', MadLib.RankIds['0'] },
                mult = 20
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.mult, localize(card.ability.extra.ranks[1], 'ranks'), localize(card.ability.extra.ranks[2], 'ranks'))
        end,
        calculate = function(self, card, context)
            if
                context.joker_main
                and MadLib.list_matches_all(context.scoring_hand, function(v)
                    return MadLib.list_matches_one(card.ability.extra.ranks, function(v)
                        return MadLib.is_rank(context.other_card, SMODS.Ranks[v].id)
                    end)
                end)
            then
                return { mult = card.ability.extra.mult }
            end
        end
    }, true)

    -- Square Eyes - now also takes 16s (basically 4x4)
    SMODS.Joker:take_ownership('aij_square_eyes', {
        config = {
            extra = {
                ranks = { '4', 'rgmc_16' },
                mult = 4
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.ranks[1], 'ranks'), localize(card.ability.extra.ranks[2], 'ranks'), card.ability.extra.mult, card.ability.extra.mult*4)
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and context.cardarea == G.play
                and context.other_card
                and MadLib.list_matches_one(card.ability.extra.ranks, function(v)
                    return MadLib.is_rank(context.other_card, SMODS.Ranks[v].id)
                end)
            then
                local mult = 0
                MadLib.loop_func(context.full_hand, function(v)
                    if MadLib.joker_check_rank(context.other_card, card, '4') then
                        mult = mult + card.ability.extra.mult
                    elseif MadLib.joker_check_rank(context.other_card, card, 'rgmc_16') then
                        mult = mult + (card.ability.extra.mult * 4)
                    end
                end)

                if mult > 0 then
                    return { mult = mult }
                end
            end
        end
    }, true)

    -- Lucky Sevens
    SMODS.Joker:take_ownership('aij_lucky_seven', {
        config = {
            extra = { rank = '7' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.rank, 'ranks'))
        end,
        calculate = function(self, card, context)
            if
                context.before
                and not context.blueprint
                and context.scoring_hand
            then
                if MadLib.loop_func(context.scoring_hand, function(v)
                    if
                        MadLib.joker_check_rank(v, card, '7')
                        and v.config.center == G.P_CENTERS.c_base
                        and not v.debuff
                    then
                        enhanced = true
                        MadLib.event({
                            func = function()
                                if v and not v.removed then v:juice_up() end
                                return true
                            end
                        })
                        return true
                    end
                end) > 0 then
                    return {
                        message = 'Lucky!',
                        card = card
                    }
                end
            end
        end
    }, true)

    -- Teeny Joker
    SMODS.Joker:take_ownership('aij_teeny_joker', {
        config = {
            extra = { rank = '2', chips = 150 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.chips, localize(card.ability.extra.rank, 'ranks'))
        end,
        calculate = function(self, card, context)
            if
                context.joker_main
                and MadLib.list_matches_all(context.full_hand, function(v)
                    return MadLib.joker_check_rank(v, card, '2')
                end)
            then
                return { chips = card.ability.extra.chips }
            end
        end
    }, true)

    -- Mondrian Joker
    SMODS.Joker:take_ownership('aij_mondrian_joker', {
        config = {
            extra = { rank = '4', mult_mod = 4 }
        },
        loc_vars = function(self, info_queue, card)
            local four_count = 0
            if G.playing_cards then
                for _, card in ipairs(G.playing_cards) do
                    if MadLib.joker_check_rank(v, card, '4') then four_count = four_count + 1 end
                end
            end
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_value = "mult_mod",
                operation = function(ref_table, ref_value, initial, change)
                    ref_table[ref_value] = four_count * (change or 1)
                end,
                no_message = true,
            })
            local current_mult = card.ability.extra.mult
            return { vars = {card.ability.extra.mult_mod, localize(card.ability.extra.rank, 'ranks'), current_mult} }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                local four_count = 0
                if G.playing_cards then
                    for _, card in ipairs(G.playing_cards) do
                        if MadLib.joker_check_rank(v, card, '4') then four_count = four_count + 1 end
                    end
                end
                SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "mult",
                        scalar_value = "mult_mod",
                        operation = function(ref_table, ref_value, initial, change)
                            ref_table[ref_value] = four_count * change
                        end,
                        no_message = true,
                })
                local total_mult = card.ability.extra.mult

                if total_mult > 0 then
                    return {
                        mult = total_mult,
                    }
                end
            end
        end
    }, true)

    -- Public Bathroom
    SMODS.Joker:take_ownership('aij_public_bathroom', {
        config = {
            extra = { rank = '2', poker_hand = 'Flush', mult = 0, mult_mod = 2 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.mult_mod, localize(card.ability.extra.rank, 'ranks'), localize(card.ability.extra.poker_hand, 'poker_hands'), card.ability.extra.mult)
        end,
        calculate = function(self, card, context)
            if
                context.before and not context.blueprint
                and context.poker_hands and next(context.poker_hands[card.ability.extra.poker_hand or 'Flush'])
            then
                local count = MadLib.loop_func(context.scoring_hand, function(v)
                    return MadLib.joker_check_rank(v, card, '2')
                end)

                if count > 0 then
                    card.ability.extra.mult = card.ability.extra.mult + (card.ability.extra.mult_mod * count)
                    card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex') })
                    return true
                end
            end
        end
    }, true)

    -- Clowns on Parade
    SMODS.Joker:take_ownership('aij_clowns_on_parade', {
        config = {
            extra = { rank = '2', chips = 0, chip_mod = 20 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.chip_mod, localize(card.ability.extra.rank, 'ranks'), card.ability.extra.chips)
        end,
        calculate = function(self, card, context)
            if
                context.before
                and not context.blueprint
                and context.full_hand
                and MadLib.loop_func(context.full_hand, function(v)
                    return MadLib.joker_check_rank(v, card, '2')
                end) >= 3
            then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return { message = localize('k_upgrade_ex') }
            end

            if context.joker_main then
                return { chips = card.ability.extra.chips }
            end
        end
    }, true)

    -- You Broke It!
    SMODS.Joker:take_ownership('aij_you_broke_it', {
        calculate = function(self, card, context)
            if
                context.before
                and not context.blueprint
            then
                local activated = false
                if context.scoring_hand and #context.scoring_hand > 0 then
                    MadLib.loop_func(context.scoring_hand, function(v)
                        if not v.debuff and MadLib.is_rank(v, G.GAME.current_round.jest_you_broke_it_card.id) then
                            v:set_ability(G.P_CENTERS[G.GAME.current_round.jest_you_broke_it_card.enhancement], nil, true)
                            activated = true
                            MadLib.event({
                                func = function()
                                    if v and not v.removed then v:juice_up() end
                                    return true
                                end
                            })
                        end
                    end)
                end
                if activated then
                    local message_text = localize {
                        type = 'name_text',
                        set = 'Enhanced',
                        key = G.GAME.current_round.jest_you_broke_it_card and G.GAME.current_round.jest_you_broke_it_card.enhancement or 'm_bonus'
                    }
                    return { message = message_text, card = card }
                end
            end
            if context.end_of_round then reset_jest_you_broke_it_card() end
        end,
    }, true)

    -- Hat Trick
    SMODS.Joker:take_ownership('aij_hat_trick', {
        config = {
            extra = { rank = '3', poker_hand = 'Three of a Kind' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.rank or '3', 'ranks'), localize(card.ability.extra.poker_hand or 'Three of a Kind', 'poker_hands'))
        end,
        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play then
                local level = to_number(G.GAME.hands[card.ability.extra.poker_hand or 'Three of a Kind'].level)
                if MadLib.joker_check_rank(v, card, '3') then
                    return { mult = level, card = card }
                end
            end
        end
    }, true)

    -- Flying Ace
    SMODS.Joker:take_ownership('aij_flying_ace', {
        config = {
            extra = { rank = 'Ace', dollars = 0, dollar_gain = 2, aces = { } }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.dollar_gain, localize(card.ability.extra.rank or '3', 'ranks'), card.ability.extra.dollars)
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and not context.blueprint
                and not context.repetition
                and context.cardarea == G.play
                and not context.other_card.debuff
                and MadLib.joker_check_rank(v, card, 'Ace')
            then
                local current_suit = context.other_card.base.suit
                if current_suit and not card.ability.extra.aces[current_suit] then
                    card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.dollar_gain
                    card.ability.extra.aces[current_suit] = true
                end
            end
            if context.cashing_out and not context.blueprint then
                card.ability.extra.aces = {}
                card.ability.extra.dollars = 0
            end
        end,
    }, true)

    -- Tetrominoker
    SMODS.Joker:take_ownership('aij_tetrominoker', {
        config = {
            extra = { rank = '4', odds = 4 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'tetrominoker')
            return MadLib.collect_vars(localize(card.ability.extra.rank or '3', 'ranks'), number_format(math.max(0,_denom - _numer)), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and not context.blueprint
                and context.cardarea == G.play
                and MadLib.joker_check_rank(context.other_card, card, '4')
                and SMODS.pseudorandom_probability(card, 'tetrominoker', 1, card.ability.extra.odds)
            then
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local copy_card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
                copy_card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, copy_card)
                G.hand:emplace(copy_card)
                copy_card.states.visible = nil
                MadLib.event({
                    func = function()
                        copy_card:start_materialize()
                        return true
                    end
                })
                return {
                    message = localize('k_copied_ex'),
                    colour = G.C.CHIPS,
                    func = function() -- This is for timing purposes, it runs after the message
                        MadLib.event({
                            func = function()
                                SMODS.calculate_context({ playing_card_added = true, cards = { copy_card } })
                                return true
                            end
                        })
                    end
                }
            end
        end
    }, true)

    -- Angel Number
    SMODS.Joker:take_ownership('aij_angel_number', {
        config = {
            extra = {
                rank            = '7',
                numerator       = 0,
                numerator_mod   = 1
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.numerator_mod, localize(card.ability.extra.rank or '7', 'ranks'), card.ability.extra.numerator)
        end,
        calculate = function(self, card, context)

            if context.mod_probability and not context.blueprint and not context.repetition then
                return { numerator = numerator }
            end

            if context.before and context.scoring_hand then
                local count = MadLib.loop_func(context.scoring_hand, function(v)
                    if MadLib.joker_check_rank(v, card, '7') then
                        card.ability.extra.numerator = card.ability.extra.numerator + (card.ability.extra.numerator_mod or 1)
                        return true
                    end
                end)
                if count > 0 then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = '+' .. tostring(count) .. ' Odds',
                        colour = G.C.GREEN
                    })
                end
            end
        end,
    }, true)

    -- Charles
    SMODS.Joker:take_ownership('aij_charles', {
        config = {
            extra = {
                rank        = 'King',
                suit        = 'Hearts',
                xmult       = 1,
                xmult_mod   = 0.25
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.xmult_mod, card.ability.extra.xmult, localize(card.ability.extra.rank or 'King', 'ranks'), localize(card.ability.extra.suit or 'Hearts', 'suits_singular'))
        end,
        calculate = function(self, card, context)
            if
                context.before
                and context.full_hand
                and MadLib.loop_func(context.full_hand, function(v)
                    return MadLib.joker_check_rank(v, card, 'King')
                        and v:is_suit(card.ability.extra.suit or 'Hearts')

                end) == #context.full_hand
                and not context.blueprint
            then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                return { message = localize('k_upgrade_ex') }
            end

            if context.joker_main then
                return { xmult = card.ability.extra.xmult, }
            end
        end
    }, true)

    -- Alexandre
    SMODS.Joker:take_ownership('aij_alexandre', {
        config = {
            extra = {
                rank        = 'King',
                suit        = 'Clubs',
                mult        = 0,
                mult_mod    = 7
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.mult_mod, card.ability.extra.mult, localize(card.ability.extra.rank or 'King', 'ranks'), localize(card.ability.extra.suit or 'Clubs', 'suits_singular'))
        end,
        calculate = function(self, card, context)
            if
                context.before
                and context.full_hand
                and MadLib.loop_func(context.full_hand, function(v)
                    return MadLib.joker_check_rank(v, card, 'King')
                        and v:is_suit(card.ability.extra.suit or 'Clubs')

                end) == #context.full_hand
                and not context.blueprint
            then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                return { message = localize('k_upgrade_ex') }
            end

            if context.joker_main then
                return { mult = card.ability.extra.mult }
            end
        end
    }, true)

    -- Cesar
    SMODS.Joker:take_ownership('aij_cesar', {
        config = {
            extra = {
                rank        = 'King',
                suit        = 'Diamonds',
                money       = 0,
                money_mod   = 1,
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.money, card.ability.extra.money_mod, localize(card.ability.extra.rank or 'King', 'ranks'), localize(card.ability.extra.suit or 'Diamonds', 'suits_singular'))
        end,
        calculate = function(self, card, context)
            if
                context.before
                and context.full_hand
                and MadLib.loop_func(context.full_hand, function(v)
                    return MadLib.joker_check_rank(v, card, 'King')
                        and v:is_suit(card.ability.extra.suit or 'Diamonds')

                end) == #context.full_hand
                and not context.blueprint
            then
                card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_mod
                return { message = localize('k_upgrade_ex') }
            end
        end
    }, true)

    -- David
    SMODS.Joker:take_ownership('aij_david', {
        config = {
            extra = {
                rank        = 'King',
                suit        = 'Spades',
                chips       = 0,
                chip_mod    = 50
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.chip_mod, card.ability.extra.chips, localize(card.ability.extra.rank or 'King', 'ranks'), localize(card.ability.extra.suit or 'Spades', 'suits_singular'))
        end,
        calculate = function(self, card, context)
            if
                context.before
                and context.full_hand
                and MadLib.loop_func(context.full_hand, function(v)
                    return MadLib.joker_check_rank(v, card, 'King')
                        and v:is_suit(card.ability.extra.suit or 'Spades')

                end) == #context.full_hand
                and not context.blueprint
            then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return { message = localize('k_upgrade_ex') }
            end

            if context.joker_main then
                return { mult = card.ability.extra.chips }
            end
        end
    }, true)

    -- Word Art
    Madcap.Lists.WordArtJokers = { 'Ace', 'King', 'Queen', 'Jack', MadLib.RankIds['Knight'], 'rgmc_X', 'rgmc_Madcap' }
    SMODS.Joker:take_ownership('aij_word_art', {
        config = {
            extra = { mult = 4 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.mult)
        end,
        calculate = function(self, card, context)
            local _cards = 0
            if context.full_hand then
                _cards = MadLib.loop_func(context.full_hand, function(v)
                    return MadLib.list_matches_one(card.ability.extra.ranks or Madcap.Lists.WordArtJokers, function(v2)
                        return MadLib.is_rank(v, SMODS.Ranks[v2].id)
                    end)
                end)
            end
            if context.joker_main and _cards > 0 then
                return { mult = card.ability.extra.mult * _cards }
            end
        end
    }, true)

    -- Petrushka
    SMODS.Joker:take_ownership('aij_petrushka', {
        config = {
            extra = { mult = 1 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.mult)
        end,
        calculate = function(self, card, context)
            if
                context.joker_main
                and context.scoring_hand
            then
                MadLib.loop_func(context.scoring_hand, function(v)
                    local value = 0

                    if has_rank then
                        for i = #MadLib.RankTypes.Base, 1, -1 do
                            if MadLib.is_rank(v, SMODS.Ranks[MadLib.RankTypes.Base[i]].id) then
                                value = i+1
                                break
                            end
                        end
                        value = (value ~= 0 and value) or SMODS.Ranks[v:get_id()].nominal
                    end

                    return { mult = card.ability.extra.mult * value }
                end)
            end
        end
    }, true)

    -- Beanstalk
    Madcap.Lists.CardLocations = { G.hand, G.play, G.deck }
    SMODS.Joker:take_ownership('aij_beanstalk', {
        config = {
            extra = { rank = 'Jack' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.rank or 'Jack', 'ranks'))
        end,
        update = function(self, card, dt)
            if G.jokers and next(SMODS.find_card("j_aij_beanstalk")) then
                MadLib.loop_func(Madcap.Lists.CardLocations, function(gr)
                    if not gr then return end
                    MadLib.loop_func(gr.cards, function(v)
                        if v.debuff and MadLib.joker_check_rank(context.other_card, card, 'Jack') then
                            v.debuff = false
                        end
                    end)
                end)
            end
        end
    }, true)

    -- Mistigri
    SMODS.Joker:take_ownership('aij_mistigri', {
        config = { h_mod = 2,  extra = { rank = 'Jack' } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.h_mod or 2, localize(card.ability.extra.rank or 'Jack', 'ranks'))
        end,
        update = function(self, card, dt)

            if
                (not card.area or card.area ~= G.jokers)
                or not (G.GAME and G.hand and G.jokers and G.hand.cards)
            then
                return
            end

            if card.debuff then
                if card.ability.current_bonus_applied and card.ability.current_bonus_applied > 0 then
                    G.hand:change_size(-card.ability.current_bonus_applied)
                    card.ability.current_bonus_applied = 0
                end
                return
            end

            card.ability.current_bonus_applied = card.ability.current_bonus_applied or 0

            local in_hand = MadLib.loop_func(G.hand.cards, function(v)
                return MadLib.joker_check_rank(context.other_card, card, 'Jack')
            end)
            local required_bonus = math.floor(in_hand / 2)
            local bonus_difference = required_bonus - card.ability.current_bonus_applied

            if bonus_difference ~= 0 then
                if G.hand then G.hand:change_size(bonus_difference) end
                card.ability.current_bonus_applied = required_bonus
            end
        end,
        remove_from_deck = function(self, card, from_debuff)
            if card.ability.current_bonus_applied and card.ability.current_bonus_applied > 0 then
                if G.hand then G.hand:change_size(-card.ability.current_bonus_applied) end
                card.ability.current_bonus_applied = 0
            end
        end
    }, true)

    -- Taikomochi
    SMODS.Joker:take_ownership('aij_taikomochi', {
        config = { extra = { chips = 100, rank = 'Jack' } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.chips, localize(card.ability.extra.rank or 'Jack', 'ranks'))
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and context.cardarea == G.hand
                and not context.end_of_round
                and MadLib.joker_check_rank(context.other_card, card, 'Jack')
            then
                return (not context.other_card.debuff)
                    and {
                        chips = card.ability.extra.chips,
                        card = card
                    } or {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = card,
                    }
            end
        end
    }, true)
end

