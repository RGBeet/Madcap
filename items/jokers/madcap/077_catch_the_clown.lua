return {
    data = {
        object_type = "Joker",
        key     = 'catch_the_clown',
        atlas   = 'jokers',
        rarity  = 2,
        cost    = 7,
        pos     = MLIB.coords(7,6),
        config = {
            extra = { chips = 0, chip_mod = 60, caught = false, failed = false, },
            immutable = { max_misses  = 3, misses = 0, }
        },
        loc_vars = function(self, info_queue, card)
            local _result = (card.ability.extra.caught and 'k_mission_in_progress')
                or (card.ability.extra.failed and 'k_mission_failed')
                or 'k_mission_in_progress'
            MadLib.collect_vars(number_format(card.ability.extra.chip_mod), number_format(_numer), number_format(_denom))
            return {
                vars = {
                    card.ability.extra.chip_mod,
                    number_format(card.ability.immutable.max_misses - card.ability.immutable.misses),
                    number_format(card.ability.extra.chips),
                    localize(_result)
                }
            }
        end,
        calculate = function(self, card, context)
            if
                context.first_hand_drawn
            then -- add clown sticker to card in first half of deck
                local _cards   = MadLib.get_possible_deck(G.deck.cards)
                local _index   =  math.floor(math.random() * #_cards) + 1
                --tell("Card is ".. tostring(_index))
                SMODS.Stickers["rgmc_clown"]:apply(_cards[_index], true)
                card.ability.extra.caught = false
                MadLib.pair_cards(card, _cards[_index],'rgmc_clown',5)
                MadLib.event({
                    trigger = 'after',
                    func = function()
                        play_sound('rgmc_clown_jingle', 1, 0.4)
                        return true
                    end
                })
            end
            if context.after then
                local _index = nil
                for i=1,#G.deck.cards do
                    if MadLib.compare_ids(card, G.deck.cards[i], 'rgmc_clown') then
                        _index = i
                        break
                    end
                end
            end
            -- Target card does not score.
            if not card.ability.extra.caught and not context.blueprint and context.before then
                local unscoring_cards = MadLib.get_list_matches(G.play.cards, function(v)
                    return not MadLib.list_matches_one(context.scoring_hand, function(v2)
                        return v2 == v
                    end)
                end)
                if MadLib.list_matches_one(unscoring_cards, function(v)
                    return MadLib.compare_ids(card, v, 'rgmc_clown')
                end) then
                    card.ability.extra.caught = false
                    card.ability.extra.failed = true
                    return {
                        message = "Mission Failed..."
                    }
                end
            end
            -- Target card is destroyed.
            if context.remove_playing_cards and not context.blueprint and not (card.ability.extra.failed or card.ability.extra.caught) then
                local failed = MadLib.list_matches_one(context.removed, function(v)
                    return MadLib.compare_ids(card, v, 'rgmc_clown')
                end)
                if failed then
                    card.ability.extra.failed = true
                    return { message = "Mission Failed..." }
                end
            end
            -- Upgrade
            if context.cardarea == G.play and not (card.ability.extra.failed or card.ability.extra.caught) and context.individual and context.other_card and not card.ability.extra.failed then
                local target = context.other_card
                if MadLib.compare_ids(card, target, 'rgmc_clown') then
                    --tell('Win!')
                    card.ability.extra.caught = true
                    card.ability.extra.failed = false
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                    MadLib.pair_cards(card, target, 'rgmc_clown', nil, true)
                    MadLib.event({
                        trigger = 'immediate',
                        func = function()
                            SMODS.Stickers["rgmc_clown"]:apply(target, false)
                            play_sound('rgmc_success', 1, 0.4)
                            return true
                        end
                    })
                    MadLib.event({
                        trigger = 'after',
                        func = function()
                            return true
                        end
                    })
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.CHIPS,
                        card = card
                    }
                end
            end
            -- Scoring
            if (context.joker_main or context.forcetrigger) and card.ability.extra.chips > 0 then
                return { chips = card.ability.extra.chips }
            end
            -- End of round stuff
            if context.end_of_round and context.cardarea == G.jokers then
                -- Fail
                if (not card.ability.extra.caught and card.ids and card.ids['rgmc_clown'] ~= nil) or card.ability.extra.failed then
                    MadLib.event({
                        trigger = 'immediate',
                        func = function()
                            play_sound('rgmc_clown_fail', 1, 0.4)
                            return true
                        end
                    })
                    card.ability.immutable.misses = card.ability.immutable.misses + 1
                    -- Get rid of the ID and the sticker.
                    for i=1, #G.playing_cards do
                        local _card = G.playing_cards[i]
                        if MadLib.compare_ids(card, _card, 'rgmc_clown') then
                            tell('Removed Clown Seal')
                            SMODS.Stickers["rgmc_clown"]:apply(_card, false)
                            MadLib.pair_cards(card, _card, 'rgmc_clown', nil, true)
                            break
                        end
                    end
                    -- Remove the card altogether, you failed.
                    if card.ability.immutable.misses == card.ability.immutable.max_misses then
                        return MadLib.banana_remove(card, "rgmc_spam_deathex")
                    else
                        return {
                            message = localize(k_reset), -- replace with actual thing!
                            card = card,
                            colour = G.C.RED
                        }
                    end
                else
                -- Clown caught
                    return {
                        message = localize(k_reset),
                        card = card,
                        colour = G.C.GREEN
                    }
                end
            end
        end,
        demicoloncompat = true,
    }
}
