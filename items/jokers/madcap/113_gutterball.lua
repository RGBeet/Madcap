-- Give $3 if hand has 3+ unscored cards
return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'gutterball',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 6,
        config = {
            extra = { dollars = 3 },
            immutable = { unscored = 3 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.immutable.unscored, card.ability.extra.dollars)
        end,
        calculate = function(self, card, context)
            if 
                (context.joker_main and (#(context.full_hand or {}) - #(context.scoring_hand or {})) >= card.ability.immutable.unscored)
                or context.forcetrigger
            then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars,
                    func = function()
                        MadLib.event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        })
                    end
                }
            end
        end,
        demicoloncompat = true
    }
}
