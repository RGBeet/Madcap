return {
    categories = {
        'Unfinished Content',
        'Gimmick Jokers'
    },
    data = {
        object_type = "Joker",
        key     = 'jim_co_supply_crate',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 'rgmc_gimmick',
        cost    = 1,
        config  = {
            extra = { odds = 100 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'jim_co_supply_crate')
            return MadLib.collect_vars(math.max(0,number_format(_denom - _numer)), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if 
                (context.selling_self and not context.blueprint)
            then
                Madcap.Funcs.force_save()
                MadLib.simple_event(function()
                    play_sound("rgmc_open_crate")
                end, 3.75, 'after')
                if SMODS.pseudorandom_probability(card, 'jim_co_supply_crate', 1, card.ability.extra.odds) then
                    MadLib.simple_event(function()
                        play_sound("rgmc_open_riff")
                        local nc = create_card("Joker", G.jokers, nil, "rgmc_unusual", nil, nil, nil, "rgmc_sleeping_ships")
                        nc:set_edition({ negative = true })
                        nc:add_to_deck()
                        G.jokers:emplace(nc)
                        nc:juice_up(0.3, 0.5)
                        return true
                    end, 2.0, 'after')
                else -- nope!
                    MadLib.simple_event(function()
                        play_sound("rgmc_open_riff")
                        card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_nope_ex'), instant = true });
                        card:juice_up(0.3, 0.5)
                        return true
                    end, 2.0, 'after')
                end
            end
        end,
        demicoloncompat = false,
    }
}
