Madcap.Lists.Bismuth = {
    'red',
    'yellow',
    'green',
    'blue',
    'purple'
}

return {
    categories = {
        'Enhancements',
    },
    data = {
        object_type = "Enhancement",
        key     = 'bismuth',
        atlas   = 'enhancements',
        pos     = MLIB.coords(0,3),
        config  = { sticker_type = 'red', charged = false },
        no_rank             = true,
        no_suit             = true,
        always_scores       = true,
        replace_base_card   = true,
        loc_vars = function(self, info_queue, card)
            if card.ability.sticker_type ~= nil then
                local capitalized = string.upper(string.sub(card.ability.sticker_type, 1, 1)) .. string.sub(card.ability.sticker_type, 2)
                info_queue[#info_queue+1] = {
                    set = 'Other',
                    key = 'rgmc_bismuth_' .. card.ability.sticker_type,
                    vars = { number_format(Madcap.Lists.BismuthValues[capitalized]) }
                }
            end
            return { vars = { } }
        end,
        calculate = function(self, card, context)
            if context.hand_drawn then
                if MadLib.list_matches_one(context.hand_drawn, function(v)
                   return v == card
                end) then
                    local new_type = pseudorandom_element(Madcap.Lists.Bismuth, pseudoseed('bismuth'))
                    card.ability.sticker_type = new_type
                    return {
                        message = "!"
                    }
                end
            end
            if context.cardarea == G.play and context.main_scoring then
                local ret = { chips = 20 }
                if card.ability.sticker_type == 'red' then
                    ret.xmult = Madcap.Lists.BismuthValues.Red
                elseif card.ability.sticker_type == 'yellow' then
                    ret.dollars = Madcap.Lists.BismuthValues.Yellow
                elseif card.ability.sticker_type == 'green' then
                    ret.repetitions = Madcap.Lists.BismuthValues.Green
                elseif card.ability.sticker_type == 'blue' then
                    ret.xchips = Madcap.Lists.BismuthValues.Blue
                elseif card.ability.sticker_type == 'purple' then
                    ret.xscore = Madcap.Lists.BismuthValues.Purple
                end
                return ret
            end
        end,
        draw = function(self, card, layer)
            local notilt = nil
            if card.area and card.area.config.type == "deck" then notilt = true end
            card.children.center:draw_shader("voucher", nil, card.ARGS.send_to_shader, notilt, card.children.center)
        end
    }
}
