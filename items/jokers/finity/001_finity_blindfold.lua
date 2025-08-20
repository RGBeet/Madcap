return {
    data = {
        object_type = "Joker",
        key 	= 'finity_blindfold',
		atlas 	= 'jokers_finity',
        pos 		= MLIB.coords(0,0),
		soul_pos  	= MLIB.coords(0,1),
		rarity = 'finity_showdown',
		demicoloncompat = true,
		config =  { extra = { add_tags = 1, incr_add = 1, }, immutable = { max_incr = 10 } },
		loc_vars = function(self, info_queue, card)
			return MadLib.collect_vars(number_format(card.ability.extra.add_tags), number_format(math.min(card.ability.extra.incr_add, card.ability.immutable.max_incr)))
		end,
		calculate = function(self, card, context)
		end
    }
}
