return {
    categories = {
        'Subhands',
        'Potentia'
    },
    data = {
        object_type = 'Consumable',
        set     = "PotentiaCrystal",
        key     = "voide",
        atlas   = "potentia",
        pos     = MLIB.coords(0,1),
        cost    = 8,
        config  = { subhand = 'ml_sh_dark', levels = 1 },
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
