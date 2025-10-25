function MadLib.change_blind_size(a, card, pitch)
    card_eval_status_text(card, "extra", nil, nil, nil, { message = "+" .. number_format(a), colour = G.C.RED })
    MadLib.event({
        func = function()
            G.GAME.blind.chips = math.max(0, math.floor(G.GAME.blind.chips + a))
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
            G.HUD_blind:recalculate()
            G.hand_text_area.blind_chips:juice_up()
            if card then
                card:juice_up()
            end
            play_sound('timpani', 1.0, 0.6)
        return true end
    })
end

return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_irate",
        atlas   = 'stickers',
        pos     = MLIB.coords(1,2),
        badge_colour = HEX('C14454'),
        loc_vars = function(self, info_queue, card)
            local amt = math.max(0.1, math.min(0.5, 0.1 * (G.GAME and G.GAME.current_round and G.GAME.current_round.hands_left or 0)))
            return MadLib.collect_vars(number_format(amt))
        end,
        calculate = function(self, card, context)
            if context.joker_main or (context.main_scoring and (context.cardarea == G.play or context.cardarea == G.hand)) then
                local amt = math.max(0.1, math.min(0.5, 0.1 * (G.GAME and G.GAME.current_round and G.GAME.current_round.hands_left or 0)))
                MadLib.change_blind_size(G.GAME.blind.chips * amt, card)
            end
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_irate = true
        end,
    }
}
