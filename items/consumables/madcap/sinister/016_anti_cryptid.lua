return {
    categories = {
        'Sinister Cards',
    },
    data = {
        object_type = 'Consumable',
        set     = "AntiSpectral",
        key		= 'anti_cryptid',
        atlas   = 'sinister',
        pos 	= MLIB.coords(1,5),
        cost 	= 2,
        config	= { extra = { ante = 4, slots = 2 }},
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.ante, card.ability.extra.slots)
        end,
        can_use = function(self, card)
            return true -- always!
        end,
        use 	= function(self, card, area, copier)
            ease_ante(card.ability.extra.ante or 4)
            G.jokers.config.card_limit = lenient_bignum(G.jokers.config.card_limit + to_big(card.ability.extra.slots or 1))
        end
    }
}
