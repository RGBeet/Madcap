return {
    categories = {
        'Cosma Tarots',
        'New Suits'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "swan",
        atlas   = "cosma",
        pos 	= MLIB.coords(0,2),
        cost 	= 5,
        config	= { select = 2, extra = { xmult_mod = 0.04, suit = 'rgmc_goblets'} },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.select),
                localize(card.ability.extra.suit, 'suits_plural'),
                localize(card.ability.extra.suit, 'suits_singular'),
                number_format(card.ability.extra.xmult_mod),
                { MadLib.get_suit_colour(card.ability.extra.suit) })
        end,
        can_use = Madcap.Funcs.cosma_can_use,
        use = function (self, card, area, copier)
            Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, function(v)
                return true -- must have suit
            end, function(v, card)
                local no_bonus = v.base.suit ~= card.ability.extra.suit

                if no_bonus then -- switch into suit
                    MadLib.simple_event(function()
                        assert(SMODS.change_base(v, card.ability.extra.suit, nil))
                        return true
                    end, 0.2, 'after')
                else -- give permanent bonus!
                    MadLib.simple_event(function()
                        v.ability.perma_x_mult = (v.ability.perma_h_x_mult or 1) + card.ability.extra.xmult_mod
                        return true
                    end, 0.2, 'after')
                end

                -- juice
                MadLib.simple_event(function()
                    v:juice_up()
                    return true
                end, 0.08, 'immediate')
            end)
        end
    }
}
