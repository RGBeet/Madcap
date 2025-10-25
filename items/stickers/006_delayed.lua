if togabalatro and togabalatro.areaprocess then
    local area_process_ref = togabalatro.areaprocess
    togabalatro.areaprocess = function(t)
        local input = area_process_ref(t)

        local delayed = {}
        local regular = {}

        -- rearrange them
        MadLib.loop_func(input, function(v)
            if v.ability then
                if v.ability.rgmc_delayed then
                    delayed[#delayed+1] = v
                    return
                end
            end
            regular[#regular+1] = v
        end)

        -- put em all together
        local output = {}
        MadLib.loop_func({ regular, delayed }, function(u)
            MadLib.loop_func(u, function(v)
                output[#output+1] = v
            end)
        end)

        return output
    end
end

return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_delayed",
        atlas   = 'stickers',
        pos     = MLIB.coords(1,0),
        badge_colour = HEX('D85D5D'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(0))
        end,
        calculate = function(self, card, context)
            if
                context.end_of_round
                and not context.repetition
                and not context.individual
            then
               -- ???
            end
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_delayed = true
        end,
    }
}
