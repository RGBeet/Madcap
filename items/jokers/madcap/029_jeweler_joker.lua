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
                    number_format(MadLib.add(MadLib.multiply(card.ability.extra.x_mult, cards)), 1))
        end,
        calculate = function(self, card, context)
            if context.checktrigger then
                return context.joker_main
            end
            if context.joker_main or context.forcetrigger then
                return { x_mult = MadLib.multiply(card.ability.extra.x_mult, #MadLib.get_enhanced_cards(G.playing_cards, card.ability.enhancement)) }
            end
        end,
        in_pool = function(self, args) -- At least one Lustrous Card
            return MadLib.list_matches_one(G.playing_cards or {}, function(v)
                return SMODS.has_enhancement(v, 'm_rgmc_lustrous')
            end)
        end,
        demicoloncompat = true,
        quasicoloncheck = true
    }
}
