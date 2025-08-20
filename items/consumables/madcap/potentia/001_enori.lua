return {
    categories = {
        'Subhands',
        'Potentia'
    },
    data = {
        object_type = 'Consumable',
        set     = "PotentiaCrystal",
        key     = "enori",
        atlas   = "potentia",
        pos     = MLIB.coords(0,0),
        cost    = 8,
        config  = { subhand = 'Light', levels = 1 },
        aurinko = true,
        loc_vars = function(self, info_queue, center)
            return Madcap.Funcs.get_potentia_vars(self.config.subhand, self.config.levels)
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.use_potentia_card(card)
        end,
    }
}
