return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'found',
        atlas   = 'jokers',
        pos     = MLIB.coords(10,9),
        rarity  = 1,
        cost    = 0,
        config = { extra = { mult = 8 }},
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.mult)
        end,
        in_pool = function(self, args) -- never appears normally
            return false
        end,
        demicoloncompat = false, -- hell no
        calculate = function(self, card, context)
            if context.check_eternal then
                return true
            end
            if (context.joker_main and (G.GAME.current_round.hands_played == 0 or G.GAME.current_round.hands_left == 0)) then
                return { mult = card.ability.extra.mult }
            end
        end
    },
}
