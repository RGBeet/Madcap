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
                localize(card.ability.extra.rank or '2', 'ranks'),
                number_format(card.ability.extra.chips))
        end,
        calculate = function(self, card, context)
            -- Reset if played hand does not contain a 2
            if MadLib.list_matches_all(context.full_hand, function(v)
                return not MadLib.is_rank(v, SMODS.Ranks[card.ability.extra.rank or '2'].id) 
            end) then 
                card.ability.extra.chips = 0
                return { message = localize('k_reset') }
            end
            -- Gains +8 chips if scoring hand contains a 2
            if 
                (context.individual 
                and context.cardarea == G.play 
                and MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank or '2'].id) 
                and not context.blueprint)
                or context.forcetrigger
            then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                    message_card = card
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
