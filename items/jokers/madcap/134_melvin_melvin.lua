return {
    categories = {
        'Unfinished Content',
        'New Ranks'
    },
    data = {
        object_type = "Joker",
        key     = 'melvin_melvin',
        atlas   = 'jokers',
        pos     = MLIB.coords(13,3),
        rarity  = 3,
        cost    = 6,
        config =  {
            extra = { rank = 'rgmc_Madcap', retriggers = 1 }
        },
		generate_ui = Madcap.Funcs.generate_special_ui,
        long_title = { "Brother of the Joker" },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.rank or 'rgmc_Madcap', 'ranks'), number_format(card.ability.extra.retriggers))
        end,
        calculate = function(self, card, context)
            -- Retrigger discarded?
            if 
                context.repeat_discard
                and MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank or 'rgmc_Madcap'].id)
            then
                return card.ability.extra.repetitions
            end

            -- Retrigger held/scored
            if 
                context.individual 
                and (context.cardarea == G.play or context.cardarea == G.hand)
                and not context.blueprint
                and MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank or 'rgmc_Madcap'].id)
            then
                return { repetitions = card.ability.extra.repetitions }
            end
        end,
        demicoloncompat = false,
    }
}
