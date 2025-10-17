return {
    categories = {
        'Modded Ranks',
        'Modded Suits'
    },
    data = {
        object_type = "Joker",
        key     = 'venn_diagram',
        atlas   = 'jokers',
        pos     = MLIB.coords(3,7),
        rarity  = 2,
        cost    = 6,
        config =  {
            extra = { mult = 9 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.mult))
        end,
        calculate = function(self, card, context)
            -- so basically i'm monke
            if (context.individual and context.cardarea == G.play
                and not MadLib.has_suit_in_list(context.other_card, MadLib.SuitTypes.Base)
                and not MadLib.has_rank_in_list(context.other_card, MadLib.RankTypes.Base))
                or context.forcetrigger -- demicolon compat
            then -- has to have custom rank and suit
                return { mult = card.ability.extra.mult, card = card }
            end
        end,
        in_pool = function(self, args) -- Exotic suits/ranks enabled
            return G.GAME.Exotic
        end,
        demicoloncompat = true,
    },
}
