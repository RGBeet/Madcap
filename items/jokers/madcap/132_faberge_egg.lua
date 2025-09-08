return {
    categories = {
        'Unfinished Content',
        'New Suits',
        'Luxury Points'
    },
    data = {
        object_type = "Joker",
        key     = 'faberge_egg',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 9,
        force_luxury = true,
        config = {
            extra = { price = 4 } 
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(cash_to_lp(card.ability.extra.price)))
        end,
        calculate = function(self, card, context)
            if 
                (context.end_of_round 
                and context.game_over == false 
                and context.main_eval and 
                not context.blueprint)
                or context.forcetrigger
            then
                card.ability.extra_value = card.ability.extra_value + card.ability.extra.price
                card:set_cost()
                return {
                    message = localize('k_val_up'),
                    colour = G.C.RGMC_LUXURY
                }
            end
        end,
        demicoloncompat = true,
    }
}
