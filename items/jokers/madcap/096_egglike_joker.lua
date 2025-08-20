return {
    categories = {
        'Gimmick',
    },
    data = {
        object_type = "Joker",
        key     = 'egglike_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(9,5),
        rarity  = 'rgmc_gimmick',
        cost    = 1,
        config = {
            extra = { rounds = 0, max_rounds = 4 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.max_rounds or 4, card.ability.extra.rounds or -1)
        end,
        calculate = function(self, card, context)
            if context.setting_blind or context.forcetrigger then
                return Madcap.Funcs.do_gimmick_generator(card, context, function(v)
                    local jokey = MadLib.create_joker('egg', nil, 'rgmc_egglike')
                    card.ability.extra.rounds = 0
                    return {
                        message = "!!",
                        colour = G.C.RGMC_GIMMICK,
                    }
                end)
            end
        end,
        demicoloncompat = true,
    }
}
