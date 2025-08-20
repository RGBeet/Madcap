return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "orbs",
        atlas   = "cosma",
        pos 	= MLIB.coords(0,8),
        cost 	= 5,
        config	= { select = 2, extra = { odds = 4 } },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(self, 1, card.ability.extra.odds, 'orbs')
            return MadLib.collect_vars(number_format(card.ability.select), number_format(_numer), number_format(_denom))
        end,
        can_use = function(self, card)
            return (G.hand and G.hand.cards and #G.hand.cards > 1)
        end,
        use = function (self, card, area, copier)
            Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, function(v)
                return true -- must have suit
            end, function(v, card)

                if not SMODS.pseudorandom_probability(card, 'orbs', 1, card.ability.extra.odds) then -- add random enhancement
                --print("this passes")
                    local _enhancement = MadLib.get_weighted_enhancement()
                    print(_enhancement)
                    MadLib.event({
                        func = function()
                            v:juice_up(0.5,0.5)
                            v:set_ability(G.P_CENTERS[_enhancement.center.key])
                            return true
                        end,
                        delay 	= 0.5,
                        trigger = 'immediate'
                    })
                else -- fucking blow up
                --print("this does not pass")
                    local _first_dissolve = nil
                    MadLib.simple_event(function()
                        _card:start_dissolve(nil, _first_dissolve)
                        _first_dissolve = true
                        return true
                    end, 0.08, 'after')
                end
                -- juice
                MadLib.simple_event(function()
                    v:juice_up()
                    return true
                end, 0.08, 'immediate')
            end)
        end,
    }
}
