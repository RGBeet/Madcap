function Madcap.Funcs.rotate_list(list, item)
    local idx = nil
    for i = #list, 1, -1 do
        if list[i] == item then
            idx = i
            break
        end
    end
    if not idx then return list end -- nothing to do if item not found

    local new_list = {}
    
    for i = idx + 1, #list do table.insert(new_list, list[i]) end
    
    for i = 1, idx do table.insert(new_list, list[i]) end
    return new_list
end

-- If TOGA's Mod is installed, perform shenanigans in here.
-- TODO: Find alternative not involving TOGA (in case not installed)
if togabalatro then
    local areaprocess_ref = togabalatro.areaprocess 
    function togabalatro.areaprocess(t)
        local output = areaprocess_ref(t)
        if next(SMODS.find_card('j_rgmc_outside_the_box')) then
            local otb = SMODS.find_card('j_rgmc_outside_the_box')
            output = Madcap.Funcs.rotate_list(output,otb[#otb])
        end
        return output
    end
else
    Madcap.Funcs.process_area = function(t)
        t = t or {}
        local output = t

        -- Outside the Box
        if next(SMODS.find_card('j_rgmc_outside_the_box')) then
            local otb = SMODS.find_card('j_rgmc_outside_the_box')
            output = Madcap.Funcs.rotate_list(output,otb[#otb])
        end
        
        return output
    end

    Madcap.Funcs.process_area_order = function(t)
        return togabalatro.Madcap.Funcs.process_area(t)
    end
end

return {
    categories = {
        'Unfinished Content',
        'Luxury Points'
    },
    data = {
        object_type = "Joker",
        key     = 'outside_the_box',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 'rgmc_unusual',
        cost    = 12,
        calculate = function(self, card, context)
        end,
        demicoloncompat = false,
    }
}
