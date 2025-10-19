return {
    categories = {
        'Mayhem'
    },
    data = {
        object_type = "Joker",
        key     = 'primordial_joker',
        atlas   = 'jokers',
        rarity  = 1,
        cost    = 5,
        pos     = MLIB.coords(5,0),
        config  = { extra = { mult = 0.4 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.mult,
                card.ability.extra.mult * (G.GAME and G.GAME.mayhem or 0))
        end,
        calculate = function(self, card, context)
            if context.joker_main or context.forcetrigger then
                return { mult = card.ability.extra.mult * (G.GAME and G.GAME.mayhem or 0) }
            end
        end,
        in_pool = function(self, args) -- at least 1 Mayhem
            return G.GAME.mayhem > 1
        end,
        demicoloncompat = true
    }
}
