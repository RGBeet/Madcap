return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'funeral_for_a_friend',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 11,
        config = { 
            extra = { 
                x_mult      = 1,
                xmult_mod   = 0.2, 
                rank        = 'Jack'
            },
            immutable = {
                suits_destroyed  = {},
                max_suits        = 7
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                localize(card.ability.extra.rank,'ranks'),
                number_format(card.ability.extra.xmult_mod),
                number_format(card.ability.extra.x_mult),
                number_format(card.ability.extra.xmult_mod))
        end,
    },
}
