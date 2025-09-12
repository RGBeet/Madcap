Madcap.Lists.CosmaConversions = {
    ['c_fool']              = 'c_rgmc_demise',
    ['c_magician']          = 'c_rgmc_phoenix',
    ['c_high_priestess']    = 'c_rgmc_life_on_earth',
    ['c_empress']           = 'c_rgmc_bridge',
    ['c_emperor']           = 'c_rgmc_pathways',
    ['c_heirophant']        = 'c_rgmc_veil',
    ['c_lovers']            = 'c_rgmc_soulmates',
    ['c_chariot']           = 'c_rgmc_spirit_plane',
    ['c_hermit']            = 'c_rgmc_cosmic_tree',
    ['c_wheel_of_fortune']  = 'c_rgmc_life_map',
    ['c_strength']          = 'c_rgmc_karma',
    ['c_hanged_man']        = 'c_rgmc_sacrifice',
    ['c_death']             = 'c_rgmc_past_lives',
    ['c_temperance']        = 'c_rgmc_maze',
    ['c_devil']             = 'c_rgmc_vessel',
    ['c_tower']             = 'c_rgmc_shore',
    ['c_star']              = 'c_rgmc_peacock',
    ['c_moon']              = 'c_rgmc_crow',
    ['c_sun']               = 'c_rgmc_swan',
    ['c_judgement']         = 'c_rgmc_unknown',
    ['c_world']             = 'c_rgmc_pelican',
    ['c_soul']              = 'c_rgmc_sleeping_ships'
}

return {
    data = {
        object_type = 'Consumable',
        set     = "Spectral",
        key     = "aspire",
        atlas   = "placeholder",
        pos     = MLIB.get_coords(0,0),
        cost    = 4,
        config  = { },
        loc_vars = function(self, info_queue, card)
        end,
        can_use = function(self, card)
            return MadLib.list_matches_one(G.consumeables, function(v)
                return Madcap.Lists.CosmaConversions[v.config.center.key]
            end)
        end,
        use = function(self, card, area, copier)
            MadLib.loop_func(G.consumeables, function(v)
                if not (v and v.area and Madcap.Lists.CosmaConversions[v.config.center.key]) then return end
                v:start_dissolve({ G.C.SPECTRAL, G.C.WHITE })
                MadLib.simple_event(function()
                    v:remove_card()
                    return true
                end, 0.5, 'after')
                MadLib.simple_event(function()
                    play_sound('timpani')
                    SMODS.add_card({ key = Madcap.Lists.CosmaConversions[v.config.center.key] })
                    card:juice_up(0.3, 0.5)
                    return true
                end, 0.5, 'after')
            end)
        end,
    }
}
