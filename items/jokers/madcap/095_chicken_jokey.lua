return {
    categories = {
        'Gimmick',
    },
    data = {
        object_type = "Joker",
        key     = 'chicken_jokey',
        atlas   = 'jokers',
        pos     = MLIB.coords(9,4),
        rarity  = 'rgmc_gimmick',
        cost    = 2,
        config = {
            extra = { rounds = 0, max_rounds = 4 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.max_rounds or 4, card.ability.extra.rounds or -1)
        end,
        calculate = function(self, card, context)
            if context.setting_blind or context.forcetrigger then
                return Madcap.Funcs.do_gimmick_generator(card, context, function(v)
                    local jokey = MadLib.create_joker('popcorn', nil, 'rgmc_chicken_jokey')
                    card.ability.extra.rounds = 0
                    return {
                        message = localize("k_cjokey_ex"),
                        colour = G.C.RGMC_GIMMICK,
                    }
                end)
            end
        end,
        demicoloncompat = true,
    }
}
