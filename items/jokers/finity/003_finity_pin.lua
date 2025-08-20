return {
    data = {
        object_type = "Joker",
        key 	= 'finity_pin',
		atlas 	= 'jokers_finity',
        pos 		= MLIB.coords(1,0),
		soul_pos  	= MLIB.coords(1,1),
		rarity = 'finity_showdown',
		demicoloncompat = false,
		config =  { },
        immutable = { min_rarity = 'rgmc_unusual' }, extra = { blind_reduce = 0.80 },
		loc_vars = function(self, info_queue, card)
			local rarity = SMODS.Rarities[self.config.immutable.min_rarity]
			return MadLib.collect_vars(number_format(self.config.extra.blind_reduce), localize(string.lower("k_" .. rarity.key)))
		end,
		calculate = function(self, card, context)
		end
    }
}
