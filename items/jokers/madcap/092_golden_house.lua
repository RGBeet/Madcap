return {
    categories = {
        'Unusual',
    },
    data = {
        object_type = "Joker",
        key     = 'golden_house',
        atlas   = 'jokers',
        rarity  = 'rgmc_unusual',
        cost    = 16,
        pos     = MLIB.coords(9,1),
        config = {
            extra = { chips = 0, mult = 0 }
        },
        generate_ui = Madcap.Funcs.generate_special_ui,
        long_title = {
            "From Pac-Guy: Pagoon"
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.chips,card.ability.extra.mult)
        end,
        calculate = function(self, card, context)
            if context.setting_blind or context.forcetrigger then
                local planets = MadLib.get_list_matches(G.consumeables.cards, function(v)
                    return (v.ability.set == "Planet")
                        and not (v.getting_sliced or v.ability.eternal)
                end)
                local target = pseudorandom_element(planets, pseudoseed("rgmc_golden_house"))
                if target then
                    local chippys, multys, changed = Madcap.Funcs.get_goldenhouse_chipmult(target)
                    MadLib.simple_event(function()
                        play_sound('rgmc_destroy_planet', 1, 0.5)
                        target:start_dissolve({G.C.RED}, nil, 1.6)
                        return true
                    end, 3.0, 'after')
                    -- there is chip
                    if to_big(chippys) > to_big(0) then
                        card.ability.extra.chips = card.ability.extra.chips + chippys
                        card_eval_status_text(context_blueprint_card or card, 'extra', nil, nil, nil, {
                            message = "+" .. number_format(to_big(chippys)),
                            colour = G.C.CHIPS,
                            card = card
                        })
                    end
                    -- there is mult
                    if to_big(multys) > to_big(0) then
                        card.ability.extra.mult = card.ability.extra.mult + multys
                        card_eval_status_text(context_blueprint_card or card, 'extra', nil, nil, nil, {
                            message = "+" .. number_format(to_big(multys)),
                            colour = G.C.MULT,
                            card = card
                            })
                        return true
                    end
                    --return nil, true
                end
            end
            if
                (context.joker_main or context.forcetrigger)
                and (card.ability.extra.mult > 0 or card.ability.extra.chips > 0)
            then
                return {
                    chip_mod = lenient_bignum(card.ability.extra.chips),
                    mult_mod = lenient_bignum(card.ability.extra.mult),
                }
            end
        end,
        perishable_compat = false,
        demicoloncompat = true
    }
}
