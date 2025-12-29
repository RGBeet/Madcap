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
                    return (v.ability.set == "Planet") and not (v.getting_sliced or v.ability.eternal)
                end)
                local target = pseudorandom_element(planets, pseudoseed("rgmc_golden_house"))
                if target then
                    local chippys, multys, changed = Madcap.Funcs.get_goldenhouse_chipmult(target)
                    MadLib.simple_event(function()
                        play_sound('rgmc_destroy_planet', 1, 0.5)
                        target:start_dissolve({G.C.RED}, nil, 1.6)
                        return true
                    end, 3.0, 'after')
                    local scale_table = { c = chippys, m = multys }
                    -- there is chip
                    if MadLib.is_positive_number(chippys) then
                        SMODS.scale_card(card, {
				            ref_table       = card.ability.extra,
				            ref_value       = "chips",
                            scalar_table    = scale_table, 
				            scalar_value    = "c",
				            message_key     = "a_chips",
				            message_colour  = G.C.CHIPS,
			            })
                    end
                    if MadLib.is_positive_number(multys) then
                        SMODS.scale_card(card, {
				            ref_table       = card.ability.extra,
				            ref_value       = "mult",
                            scalar_table    = scale_table, 
				            scalar_value    = "m",
				            message_key     = "a_mult",
				            message_colour  = G.C.MULT,
			            })
                    end
                end
            end
            if context.joker_main or context.forcetrigger then
                return {
                    chips = MadLib.is_positive_number(card.ability.extra.chips) and card.ability.extra.chips,
                    mult = MadLib.is_positive_number(card.ability.extra.mult) and card.ability.extra.mult,
                }
            end
        end,
        perishable_compat = false,
        demicoloncompat = true
    }
}
