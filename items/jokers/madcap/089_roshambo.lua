-- Returns nothing if Unusuals aren't available
Madcap.Funcs.FlipRoshamboCycle = MadcapConfig['Unusual'] and function(a,b)
    return false
end or function(a,b)
    local change_cards = {}
    MadLib.loop_func({G.play.cards, G.hand.cards}, function(list)
        MadLib.loop_func(list, function(v)
            if MadLib.list_matches_one(Madcap.Lists.RoshamboKeys, function(m) return v.config.center.key == m end) then
                table.insert(change_cards,v)
            end
        end)
    end)
    MadLib.loop_func(change_cards, function(v,i)
        local index = MadLib.get_item_index(v.config.center.key,Madcap.Lists.RoshamboKeys)
        local old_index = index
        local old_values = Madcap.Lists.RoshamboValues[index]
        index = MadLib.get_moved_index(index, a, #Madcap.Lists.RoshamboKeys)
        local new_values = Madcap.Lists.RoshamboValues[index]
        -- set old value to blank, set new value to base
        v.config.center = G.P_CENTERS[Madcap.Lists.RoshamboKeys[index]]
        if b == 'before' then
            v.rgmc_temp = {}
            -- set old value
            for k,rsh in pairs(old_values) do
                v.rgmc_temp[k]  = v.ability[k] or rsh[1]
                v.ability[k]    = rsh[2]
                tell('for enhc ' .. Madcap.Lists.RoshamboKeys[old_index] .. ', ability ' .. k .. ' is now ' .. tostring(v.ability[k]) .. '.')
            end
            for k,rsh in pairs(new_values) do
                v.ability[k]    = rsh[1]
                tell('for enhc ' .. Madcap.Lists.RoshamboKeys[old_index] .. ', ability ' .. k .. ' is now ' .. tostring(v.ability[k]) .. '.')
            end
        elseif b == 'after' then
            v.rgmc_temp = nil
        end
        MadLib.simple_event(function()
            MadLib.simple_event(function()
                v:flip()
                return true
            end, 0.2, 'after')
            MadLib.simple_event(function()
            v:set_ability(G.P_CENTERS[Madcap.Lists.RoshamboKeys[index]])
                return true
            end, 0.2, 'after')
            MadLib.simple_event(function()
                v:flip()
                return true
            end, 0.2, 'after')
            return true
        end, 0.2, 'after')
    end)
end
return {
    categories = {
        'Unusual'
    },
    data = {
        object_type = "Joker",
        key     = 'roshambo',
        atlas   = 'jokers',
        pos     = MLIB.coords(8,8),
        rarity  = 'rgmc_unusual',
        cost    = 16,
        config = {
            extra = { mult = 15, money = 20, chips   = 50, x_mult  = 1.5 },
        },
        loc_vars = function(self, info_queue, card)
            local full_vars = {
                MadLib.localize_name_text('Enhanced', 'm_stone'),
                MadLib.localize_name_text('Enhanced', 'm_lucky'),
                MadLib.localize_name_text('Enhanced', 'm_steel')
            }
            for i=1,3 do full_vars[#full_vars+1] = MadLib.localize_name_text('Enhanced', Madcap.Lists.RoshamboKeys[(i%3)+1]) end
            return { vars = full_vars }
        end,
        calculate = function(self, card, context)
            if context.rgmc_before_scoring or context.forcetriggger then Madcap.Funcs.FlipRoshamboCycle(1,'before') end
        end,
        demicoloncompat = true
    }
}
