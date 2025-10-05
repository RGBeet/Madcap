return {
    categories = {
        'Unfinished Content',
        'Subhands',
    },
    data = {
        object_type = "Joker",
        key     = 'variegated',
        atlas   = 'jokers',
        pos     = MLIB.coords(13,6),
        rarity  = 3,
        cost    = 7,
        config =  {
            extra = { x_chips = 2, subhand = 'ml_sh_spectrum' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.x_chips)
        end,
        calculate = function(self, card, context)
            if
                (context.cardarea == G.jokers
                    and MadLib.context_has_subhand(context, card.ability.extra.subhand or 'ml_sh_spectrum'))
                or context.forcetrigger
            then
                return { chips = card.ability.extra.chips }
            end
        end,
        in_pool = function(self, args)
            return (G.GAME.subhands and G.GAME.subhands[self.config.extra.subhand or 'ml_sh_spectrum'])
                or MadLib.get_suit_count(G.playing_cards) > 4
        end,
        demicoloncompat = false,
    }
}
