-- thorium joker conversions
return {
    data = {
        object_type = "Joker",
        key     = 'iron_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,6),
        rarity  = 2,
        cost    = 6,
        config = {
            enhancement = 'rgmc_ferrous', extra = { chips = 25 }
        },
        loc_vars = function(self, info_queue, card)
            local cards = G.playing_cards
                and #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement)
                or 0
            return MadLib.collect_vars(
                    number_format(card.ability.extra.chips),
                    number_format(MadLib.multiply(card.ability.extra.chips, cards)))
        end,
        calculate = function(self, card, context)
            if context.checktrigger then
                return context.joker_main
            end
            if context.joker_main or context.forcetrigger then
                return { chips = MadLib.multiply(card.ability.extra.chips, #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement)) }
            end
        end,
        in_pool = function(self, args) -- At least one Ferrous Card
            return MadLib.list_matches_one(G.playing_cards or {}, function(v)
                return SMODS.has_enhancement(v, 'm_rgmc_ferrous')
            end)
        end,
        demicoloncompat = true,
        quasicoloncheck = true
    },
}
