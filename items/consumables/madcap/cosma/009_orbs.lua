Madcap.Lists.MadcapUpgrades = {
    ['m_bonus']     = {'m_rgmc_ferrous'},
    ['m_mult']      = {'m_rgmc_wolfram'},
    ['m_steel']     = {'m_rgmc_lustrous'},
    ['m_wild']      = {'m_rgmc_bismuth'},
    ['m_gold']      = {'m_rgmc_luxury'},
}

Madcap.Funcs.orb_compatible = function(card)
    local enhancement = card.config.center.key
    print(enhancement)
    return enhancement == 'c_base'
        or Madcap.Lists.MadcapUpgrades[enhancement] ~= nil
end

if next(SMODS.find_mod("MoreFluff")) then
    Madcap.Lists.MadcapUpgrades['m_mf_monus']    = {'m_rgmc_magnet'}
    Madcap.Lists.MadcapUpgrades['m_mf_cult']     = {'m_rgmc_signal'}
    Madcap.Lists.MadcapUpgrades['m_mf_teal']     = {'m_rgmc_crystaltine'}
end

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
            local compatible = MadLib.get_list_matches(G.playing_cards,function(v)
                return Madcap.Funcs.orb_compatible(v)
            end)
            return (G.hand and G.hand.cards and #compatible > 0)
        end,
        use = function (self, card, area, copier)
            Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, function(v)
                return Madcap.Funcs.orb_compatible(v)
            end, function(v)
                if not SMODS.pseudorandom_probability(card, 'orbs', 1, card.ability.extra.odds) then -- add random enhancement
                    local selection = nil
                    if v.config.center.key == 'c_base' then
                        local pool = {}
                        MadLib.loop_table(Madcap.Lists.MadcapUpgrades, function(k) table.insert(pool,k) end)
                        selection = pseudorandom_element(pool, pseudoseed('orbs'))
                    else
                        selection = pseudorandom_element(Madcap.Lists.MadcapUpgrades[v.config.center.key])
                    end
                    v:set_ability(selection)
                else
                    tell('KABOOM!')
                    local _first_dissolve = nil
                    MadLib.simple_event(function()
                        v:start_dissolve(nil, _first_dissolve)
                        _first_dissolve = true
                        return true
                    end, 0.08, 'after')
                end
                MadLib.simple_event(function()
                    v:juice_up()
                    return true
                end, 0.08, 'immediate')
            end)
        end,
    }
}
