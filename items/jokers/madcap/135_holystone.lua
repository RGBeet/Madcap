return {
    categories = {
        'Unfinished Content',
        'New Suits',
        'Voids and Lanterns'
    },
    data = {
        object_type = "Joker",
        key     = 'holystone',
        atlas   = 'jokers',
        pos     = MLIB.coords(13,4),
        rarity  = 3,
        cost    = 6,
        config =  {
            extra = {  
                suit        = 'rgmc_lanterns',
                odds        = 3,
                x_mult      = 1,
                xmult_mod   = 0.1,
                mayhem_mod  = 0.05
            }
        },
        loc_vars = function(self, info_queue, card)
            local numer, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'holystone')
            return MadLib.collect_vars_colours(
                localize(Madcap.Funcs.get_joker_suit(card, 'rgmc_lanterns'), 'suits_plural'),
                numer,
                denom,
                number_format(card.ability.extra.xmult_mod),
                number_format(card.ability.extra.x_mult),
                number_format(-card.ability.extra.mayhem_mod),
                { G.C.SUITS[Madcap.Funcs.get_joker_suit(card, 'rgmc_lanterns')] })
        end,
        calculate = function(self, card, context)
            -- Retrigger held/scored
            if 
                context.individual 
                and context.cardarea == G.hand
                and not context.blueprint
                and context.other_card:is_suit(card.ability.extra.suit or 'rgmc_lanterns')
            then
                -- Remove a random enhancement enhancement, edition, or seal
                if SMODS.pseudorandom_probability(card, 'holystone', 1, card.ability.extra.odds) then
                    local number = pseudorandom('holystone', 1, 6)
                    local target = nil

                    if number < 4 and MadLib.list_matches_one(G.hand.cards, function(v)
                        return v:has_enhancement()
                    end) then -- enhancement
                        target = pseudorandom_element(MadLib.get_list_matches(G.hand.cards, function(v)
                            return v:has_enhancement()
                        end), pseudoseed('holystone'))
                        target:set_ability('c_base', nil, true)
                    elseif number < 6 and MadLib.list_matches_one(G.hand.cards, function(v)
                        return v:has_seal()
                    end) then -- seal
                        target = pseudorandom_element(MadLib.get_list_matches(G.hand.cards, function(v)
                            return v:has_seal()
                        end), pseudoseed('holystone'))
                        target:set_seal(nil)
                    elseif MadLib.list_matches_one(G.hand.cards, function(v)
                        return v:has_edition()
                    end) then -- edition
                        target = pseudorandom_element(MadLib.get_list_matches(G.hand.cards, function(v)
                            return v:has_edition()
                        end), pseudoseed('holystone'))
                        target:set_edition(nil)
                    end

                    if target then
                        Madcap.Funcs.ease_mayhem(-card.ability.extra.mayhem_mod)
                        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.xmult_mod
                        return {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.MULT
                        }
                    end
                end
            end
        end,
        demicoloncompat = false,
    }
}
