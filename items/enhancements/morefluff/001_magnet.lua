return {
    categories = {
        'Enhancements',
    },
    data = {
        object_type = "Enhancement",
        key     = 'magnet',
        atlas   = 'mf_enhancements',
        pos     = MLIB.coords(0,0),
		config = { extra = { chips = 10, gain = 8 } },
		loc_vars = function(self, info_queue, card)
			return MadLib.collect_vars(card.ability.extra.chips, card.ability.extra.gain, card.ability.extra.gain * (Madcap.Funcs.get_poker_hand_level() or 0))
		end,
        calculate = function(self, card, context)
			if context.cardarea == G.play and context.main_scoring then
				return { chips = card.ability.extra.chips }
			end

			if context.playing_card_end_of_round and context.cardarea == G.hand then
                card.ability.extra.mult = card.ability.extra.chips + (card.ability.extra.gain * (Madcap.Funcs.get_poker_hand_level() or 0))
                return { message = localize('k_upgrade_ex'), colour  = G.C.CHIPS}
			end
		end,
        draw = function(self, card, layer)
            card.children.center:draw_shader("negative_shine", nil, card.ARGS.send_to_shader)
        end
    }
}
