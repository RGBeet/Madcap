return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'cuica',
        atlas   = 'jokers',
        pos     = MLIB.coords(10,4),
        rarity  = 1,
        cost    = 6,
        config = { 
            extra = { chips = 0, chip_mod = 8, rank = '2' }
        },
        loc_vars = function(self, info_queue, card)
            
            return MadLib.collect_vars(number_format(card.ability.extra.chip_mod),
                MadLib.get_rank_locvar(card, '2'),
                number_format(card.ability.extra.chips))
        end,
        calculate = function(self, card, context)
            -- Reset if played hand does not contain a 2
            if context.before and MadLib.list_matches_all(context.full_hand, function(v)
                return not MadLib.joker_check_rank(context.other_card, card, '2')
            end) then 
                card.ability.extra.chips = 0
                return { message = localize('k_reset') }
            end
            -- Gains +8 chips if scoring hand contains a 2
            if 
                (context.individual 
                and context.cardarea == G.play 
                and MadLib.joker_check_rank(context.other_card, card, '2')
                and not context.blueprint)
                or context.forcetrigger
            then
                card.ability.extra.chips = MadLib.add(card.ability.extra.chips, card.ability.extra.chip_mod)
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                    message_card = card,
                    sound = pseudorandom('cuica')*3 < 2 and 'rgmc_cuica1' or 'rgmc_cuica2'
                }
            end
            -- Give the chips
            if context.joker_main then
                return { chips = card.ability.extra.chips }
            end
        end,
        demicoloncompat = true
    }
}
