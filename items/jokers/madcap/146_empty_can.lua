return {
    categories = {
        'Unfinished Content',
        'Gimmick Jokers'
    },
    data = {
        object_type = "Joker",
        key     = 'empty_can',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 'rgmc_gimmick',
        cost    = 3,
        config  = {
            extra = { mult = 13 }
        },
        loc_vars = function(self, info_queue, card)
            local slots = (G.jokers.config.card_limit - #G.jokers.cards) + #SMODS.find_card("j_rgmc_empty_can", true) or 1
            return MadLib.collect_vars(number_format(card.ability.extra.mult), 
                number_format(card.ability.extra.mult * slots))
        end,
        calculate = function(self, card, context)
            if 
                context.joker_main 
                or context.forcetrigger 
            then
                local slots = (G.jokers.config.card_limit - #G.jokers.cards) + #(SMODS.find_card("j_rgmc_empty_can", true)) or 1
                return { xmult = slots * card.ability.extra.mult }
            end
        end,
        demicoloncompat = true,
    }
}
