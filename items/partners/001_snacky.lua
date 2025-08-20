return {
	devmode = true,
    categories = {
        'Partners',
        'Score'
    },
    data = {
        object_type = "Partner",
        atlas = 'partners',
        pos = MLIB.coords(0,0),
		key = "snacky",
		config = {
			immutable = { mode = 1 },
			extra = {
				effects = {
					10,     -- +chips
					2,      -- +mult
					30,     -- +chips
					5,      -- +mult
					60,    	-- +chips
					1.25,   -- Xmult
					1.75,   -- Xmult
					1.75    -- Xscore
				},
			}
		},
		link_config = { j_rgmc_chinese_takeout = 1 },
		loc_vars = function(self, info_queue, card)
			local str = "null"
			if card.ability.immutable.mode > 0 and card.ability.immutable.mode < 8 then
				str = "rgmc_chinese_effect"..tostring(card.ability.immutable.mode)
			end
			--tell(card.ability.immutable.mode)
			info_queue[#info_queue + 1] = {
				set = "Other",
				key = str,
				vars = { card.ability.extra.effects[card.ability.immutable.mode] }
			}
			return MadLib.collect_vars(number_format(card.ability.extra.rounds_remaining),
				number_format(card.ability.extra.effects[card.ability.immutable.mode]))
		end,
		calculate = function(self, card, context)
			-- Start of blind
			if context.setting_blind then
				local new_food = math.random(1, 8)
				card.ability.immutable.mode = new_food
				if card.ability.immutable.mode > 0 and card.ability.immutable.mode <= 8 then
					return { message = localize("rgmc_chinese_line" .. card.ability.immutable.mode) }
				end
			end
			-- Scoring?
			if (context.cardarea == G.jokers and context.joker_main) then
				tell('Value: '..number_format(card.ability.extra.effects[card.ability.immutable.mode]))
				local _mode = card.ability.immutable.mode
				local _scorekey = _mode < 6
					and (_mode % 2 == 1 and MadLib.ScoreKeys.AddChips or MadLib.ScoreKeys.AddMult)
					or (_mode < 8 and MadLib.ScoreKeys.MultiMult)
					or MadLib.ScoreKeys.MultiScore
				local _amt = card.ability.extra.effects[card.ability.immutable.mode]

				return MadLib.get_simple_score_data(_scorekey, card, _mode)
			end
		end,
    }
}
