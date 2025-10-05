Madcap.ProvidenceEditions = MadLib.get_list_matches(MadLib.PointValues.Editions, function(v) return v < 10 end)
return {
    data = {
        object_type = 'Consumable',
        set     = "Tarot",
        key     = "providence",
        atlas   = "tarots",
        pos     = MLIB.coords(0,3),
        cost    = 4,
        config = {
            extra = { odds = 4, max_cards	= 2 },
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(self, 1, card.ability.extra.odds, 'providence')
            return MadLib.collect_vars(_numer, _denom, (card.ability.extra.max_cards or 2))
        end,
        can_use = function(self, card)
            if not (G.hand and G.hand.cards) then return false end
            local editionless_cards = SMODS.Edition:get_edition_cards(G.hand, true)
            return #editionless_cards > 0 -- is there a hand of cards available?
        end,
        use = function(self, card, area, copier)
            if SMODS.pseudorandom_probability(card, 'providence', 1, card.ability.extra.odds) then
                local editionless_cards = SMODS.Edition:get_edition_cards(G.hand, true)
                local eligible_cards = MadLib.shuffle_sort_list(editionless_cards, math.min(card.ability.extra.max_cards, #G.hand.cards), function(v)
                    return not v.edition -- no edition
                end, function(a,b)
                    return MadLib.get_card_total_value(a) > MadLib.get_card_total_value(b)
                end)
                print(eligible_cards)
                MadLib.loop_func(eligible_cards, function(v)
                    MadLib.simple_event(function()
                        local edition = poll_edition('providence', nil, true, true)
                        v:set_edition(edition, true)
                        check_for_unlock({ type = 'have_edition' })
                        return true
                    end, 0.5, 'after')
                end)
            else
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        attention_text({
                            text = localize('k_nope_ex'),
                            scale = 1.3,
                            hold = 1.4,
                            major = card,
                            backdrop_colour = G.C.SECONDARY_SET.Tarot,
                            align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
                                'tm' or 'cm',
                            offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
                            silent = true
                        })
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.06 * G.SETTINGS.GAMESPEED,
                            blockable = false,
                            blocking = false,
                            func = function()
                                play_sound('tarot2', 0.76, 0.4)
                                return true
                            end
                        }))
                        play_sound('tarot2', 1, 0.4)
                        card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
            end
        end,
    }
}
