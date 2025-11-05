return {
    categories = {
        'Editions',
        'Mayhem'
    },
    data = {
        object_type = "Edition",
        key 	= 'abyssal',
        shader 	= 'abyssal',
        weight  = 2,
        in_shop = true,
        extra_cost = 6,
        config = { extra = { mayhem = 1 } },
        sound = { sound = "rgmc_e_abyssal", per = 1, vol = 0.2, },
        get_weight = function(self)
            return G.GAME.edition_rate * self.weight
        end,
        loc_vars = function(self, info_queue)
            return MadLib.collect_vars(total, self.config.extra.mayhem or 1)
        end,
        calculate = function(self, card, context)
            if 
                (context.post_joker or
                (context.main_scoring and context.cardarea == G.play))
                and (G.GAME.mayhem + (self.config.extra.mayhem or 1) <= G.GAME.max_mayhem)
            then
                MadLib.event({
                    func = function()
                        Madcap.Funcs.ease_mayhem(self.config.extra.mayhem or 1, true)
                        return true
                    end,
                    delay = 0.8
                })
            end
        end,
    }
}
