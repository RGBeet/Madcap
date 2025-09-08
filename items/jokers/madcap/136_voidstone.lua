return {
    categories = {
        'Unfinished Content',
        'New Suits',
        'Voids and Lanterns'
    },
    data = {
        object_type = "Joker",
        key     = 'voidstone',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 6,
        config =  {
            extra = {  
                suit        = 'rgmc_voids',
                odds        = 4,
                mayhem_mod  = 0.08
            }
        },
        loc_vars = function(self, info_queue, card)
            local numer, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'holystone')
            return MadLib.collect_vars_colours(
                localize(card.ability.extra.suit, 'suits_plural'),
                numer,
                denom,
                number_format(card.ability.extra.mayhem_mod),
                { G.C.SUITS[card.ability.extra.suit] })
        end,
        calculate = function(self, card, context)
            -- Retrigger held/scored
            if 
                context.individual 
                and context.cardarea == G.hand
                and not context.blueprint
                and context.other_card:is_suit(card.ability.extra.suit or 'rgmc_voids')
            then
                -- Remove a random enhancement enhancement, edition, or seal
                if SMODS.pseudorandom_probability(card, 'holystone', 1, card.ability.extra.odds) then
                    local number = pseudorandom('holystone', 1, 6)
                    local target, apply = nil, nil

                    if number < 4 and MadLib.list_matches_one(G.hand.cards, function(v)
                        return not v:has_enhancement()
                    end) then 
                        -- enhancement
                        target = pseudorandom_element(MadLib.get_list_matches(G.hand.cards, function(v)
                            return not v:has_enhancement()
                        end), pseudoseed('voidstone'))
                        -- set enhancement
                        apply = SMODS.poll_enhancement({ guaranteed = true })
                        target:set_ability(G.P_CENTERS[apply], nil, true)
                    elseif number < 6 and MadLib.list_matches_one(G.hand.cards, function(v)
                        return not v:has_seal()
                    end) then 
                        -- seal
                        target = pseudorandom_element(MadLib.get_list_matches(G.hand.cards, function(v)
                            return not v:has_seal()
                        end), pseudoseed('holystone'))
                        -- set seal
                        apply = SMODS.poll_seal({ guaranteed = true })
                        target:set_seal(apply)
                    elseif MadLib.list_matches_one(G.hand.cards, function(v)
                        return not v:has_edition()
                    end) then -- edition
                        target = pseudorandom_element(MadLib.get_list_matches(G.hand.cards, function(v)
                            return not v:has_edition()
                        end), pseudoseed('holystone'))
                        -- set edition
                        apply = poll_edition('holystone_edition', nil, true, true)
                        target:set_edition(apply, true)
                    end

                    if target then
                        Madcap.Funcs.ease_mayhem(card.ability.extra.mayhem_mod)
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
