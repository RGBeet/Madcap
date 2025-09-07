return {
    categories = {
        'Gimmick',
        'Spam'
    },
    data = {
        object_type = "Joker",
        key     = 'lobster_thermidor',
        atlas   = 'jokers',
        rarity  = 'rgmc_gimmick',
        cost    = 48,
        pos     = MLIB.coords(9,3),
        generate_ui = Madcap.Funcs.generate_special_ui,
        long_title = {
            "With A Mornay Sauce",
            "Garnished With Truffle Pâté," ,
            "Brandy, And A Fried Egg On Top"
        },
        config = {
            extra = { emult   = 0.02, extra   = 1.01 },
            immutable = { mode = 1 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.emult, (1+card.ability.extra.emult) * card.ability.extra.extra)
        end,
        calculate = function(self, card, context)
            if (context.cardarea == G.jokers and context.joker_main) or context.forcetrigger then
                play_sound('rgmc_spam_enter', 1, 1)
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.ExpMult, card,
                    card.ability.extra.e_mult)
            end
        end,
        in_pool = function(self, args)
            return G.GAME.spams_eaten and G.GAME.spams_eaten > 8
        end,
        demicoloncompat = true,
    }
}
