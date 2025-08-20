-- thorium joker conversions
return {
    data = {
        object_type = "Joker",
        key     = 'jeweler_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,8),
        rarity  = 2,
        cost    = 8,
        config = {
            enhancement = 'rgmc_lustrous', extra = { x_mult = 0.1 }
        },
        loc_vars = function(self, info_queue, card)
            local cards = G.playing_cards
                and #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement)
                or 0
            return MadLib.collect_vars(
                    number_format(card.ability.extra.x_mult),
                    number_format(card.ability.extra.x_mult * cards))
        end,
        calculate = function(self, card, context)
            if context.joker_main or context.forcetrigger then
                local amt = #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement)
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult * (amt or 0))
            end
        end,
        demicoloncompat = true,
    },
}
