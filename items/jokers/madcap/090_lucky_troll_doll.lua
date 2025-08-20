return {
    categories = {
        'Unusual'
    },
    data = {
        object_type = "Joker",
        key     = 'lucky_troll_doll',
        atlas   = 'jokers',
        pos     = MLIB.coords(8,9),
        rarity  = 'rgmc_unusual',
        cost    = 13,
        config  =  {
            extra = { jokers = 1, numerator_mod = 1.5 },
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.jokers)
        end,
        calculate = function(self, card, context)
            if context.mod_probability and G.jokers and not context.repetition and context.trigger_obj then
                local doll = MadLib.get_item_index(card, G.jokers.cards)
                local target = MadLib.get_item_index(context.trigger_obj, G.jokers.cards)
                if (doll and target) and (target > doll) and (target <= (card.ability.extra.jokers or 1) + doll) then return { numerator = context.numerator * card.ability.extra.numerator_mod } end
            end
        end,
        demicoloncompat = true
    }
}
