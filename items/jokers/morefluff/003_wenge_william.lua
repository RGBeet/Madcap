return {
    data = {
        object_type = "Joker",
        key     = 'mf_wenge_william',
        atlas   = 'mf_jokers',
        pos     = MLIB.coords(0,2),
        rarity  = 3,
        cost    = 9,
        config =  {
            extra = { odds = 4 }
        },
        calculate = function(self, card, context)
            if
                context.ending_shop
                and G.consumeables.cards[1]
                and SMODS.pseudorandom_probability(card, 'wenge_william', 1, card.ability.extra.odds)
            then
                local target = pseudorandom_element(MadLib.get_list_matches(G.consumeables.cards, function(v)
                    return v.ability.set == "Colour"
                end), pseudoseed('wenge_william'))
                SMODS.destroy_cards(target, nil, nil, true)
                MadLib.event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        if G.consumeables.config.card_limit > #G.consumeables.cards then
                            play_sound('timpani')
                            SMODS.add_card({ key = 'c_rgmc_wenge' })
                            card:juice_up(0.3, 0.5)
                        end
                        return true
                    end
                })
            end
        end,
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'vari_seala')
            return MadLib.collect_vars(math.max(0,number_format(_denom - _numer)), number_format(_denom))
        end,
        demicoloncompat = true,
    }
}
