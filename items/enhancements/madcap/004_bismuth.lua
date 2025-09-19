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
        config  = { immutable = { sticker_type = 'red' } },
        no_rank             = true,
        no_suit             = true,
        always_scores       = true,
        replace_base_card   = true,
        loc_vars = function(self, info_queue, card)
            return { vars = { } }
        end,
        calculate = function(self, card, context)
            if context.setting_blind then
                local new_type = pseudorandom_element(Madcap.Lists.Bismuth, pseudoseed('rgmc_bismuth'))
                if new_type ~= card.ability.immutable.sticker_type then
                    card.ability.immutable.sticker_type = new_type
                    card.ability['rgmc_bismuth_'..new_type] = true
                    SMODS.Stickers['rgmc_bismuth_'..new_type]:apply(self,true)
                end
            end
            if context.playing_card_end_of_round then
                local old_type = card.ability.immutable.sticker_type
                card.ability.immutable.sticker_type = nil
                card.ability['rgmc_bismuth_'..old_type] = false
                SMODS.Stickers['rgmc_bismuth_'..old_type]:apply(self,false)
            end
        end,
        draw = function(self, card, layer)
            local notilt = nil
            if card.area and card.area.config.type == "deck" then notilt = true end
            card.children.center:draw_shader("voucher", nil, card.ARGS.send_to_shader, notilt, card.children.center)
        end
    }
}
