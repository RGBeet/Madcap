return {
    data = {
        object_type = "Joker",
        key     = 'legend_rio',
        atlas   = 'jokers_legendary',
        pos        = MLIB.legend(1,false),
        soul_pos   = MLIB.legend(1,true),
        rarity     = 4,
        cost       = 15,
        config =  { extra = { rank = 'Ace' } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(Madcap.Funcs.get_rio_rank(), 'ranks') .. "s")
        end,
        calculate = function(self, card, context)
            if
                context.cardarea == G.play
                and context.other_card -- must be another card
                and MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank].id)
            then
                -- just a visual gag
                return {
                    message = localize('rgmc_ace_ex'),
                    card = context.other_card
                }
            end
        end,
        demicoloncompat = false, -- doesn't really have anything to force trigger
    }
}
