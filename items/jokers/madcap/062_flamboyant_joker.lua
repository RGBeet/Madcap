return {
    categories = {
        'Subhands',
    },
    data = {
        object_type = "Joker",
        key     = 'flamboyant_joker',
        atlas   = 'jokers',
        rarity  = 1,
        cost    = 6,
        pos     = MLIB.coords(6,1),
        config =  {
            extra = { chips = 70, subhand = 'ml_sh_spectrum' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.chips, card.ability.extra.type)
        end,
        calculate = function(self, card, context)
            if
                (context.joker_main and context.cardarea == G.jokers
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
        demicoloncompat = true,
    }
}
