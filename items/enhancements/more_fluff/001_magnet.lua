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
			return MadLib.collect_vars(self.config.extra.chips, self.config.extra.gain, self.config.extra.gain * get_poker_hand_level())
		end,
        calculate = function(self, card, context)
			if context.poker_hands then
				--print(context.poker_hands)
			end

			if context.cardarea == G.play and context.main_scoring then
				return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips,card.ability.extra.chips)
			end

			if context.playing_card_end_of_round and context.cardarea == G.hand then
				return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddChips,card,card.ability.extra.gain * get_poker_hand_level())
			end
		end,
        draw = function(self, card, layer)
            card.children.center:draw_shader("negative_shine", nil, card.ARGS.send_to_shader)
        end
    }
}
