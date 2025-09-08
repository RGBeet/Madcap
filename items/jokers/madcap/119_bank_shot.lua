return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'bank_shot',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 7,
        config = {
            extra = { max_retriggers = 4, retriggers = 0 },
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.max_retriggers),
                number_format(card.ability.extra.retriggers),
                {   
                    card.ability.extra.retriggers > 0 
                        and MadLib.get_warning_colour(card.ability.extra.max_retriggers / card.ability.immutable.max_rounds)
                        or G.C.FILTER 
                })
        end,
        calculate = function(self, card, context)
            if 
                (context.individual 
                and context.cardarea == G.play
                and not context.blueprint)
                or context.forcetrigger
            then
                if (SMODS.has_no_rank(context.other_card) or context.forcetrigger) then
                    card.ability.extra.retriggers = (card.ability.extra.max_retriggers or 4)
                    local eval = function(card) return (card.ability.extra.retriggers == 0) and (not G.RESET_JIGGLES) end
                    juice_card_until(card, eval, true)
                    return {
                        message = localize('k_active_ex'),
                        colour  = G.C.GREEN
                    }
                elseif card.ability.extra.retriggers > 0 then
                    card.ability.extra.retriggers = card.ability.extra.retriggers - 1
                    return { repetitions = 1 }
                end
            end
        end,
        demicoloncompat = true
    }
}
