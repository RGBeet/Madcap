return {
    categories = {
        'Subhands',
        'Potentia'
    },
    data = {
        object_type = 'Consumable',
        set     = "PotentiaCrystal",
        key     = "palis",
        atlas   = "potentia",
        pos     = MLIB.coords(0,2),
        cost    = 8,
        config  = { subhand = 'ml_sh_high', levels = 1 },
        aurinko = true,
        loc_vars = function(self, info_queue, center)
            return Madcap.Funcs.get_potentia_vars(self.config.subhand, self.config.levels)
        end,
        can_use = function(self, card)
            return true
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.use_potentia_card(card)
        end,
    }
}
