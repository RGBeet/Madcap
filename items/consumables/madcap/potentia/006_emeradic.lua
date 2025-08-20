return {
    categories = {
        'Subhands',
        'Potentia'
    },
    data = {
        object_type = 'Consumable',
        set     = "PotentiaCrystal",
        key     = "emeradic",
        atlas   = "potentia",
        pos     = MLIB.coords(0,5),
        cost    = 9,
        config  = { subhand = 'Balanced', levels = 1 },
        aurinko = true,
        loc_vars = function(self, info_queue, center)
            return Madcap.Funcs.get_potentia_vars(self.config.subhand, self.config.levels)
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.use_potentia_card(card)
        end,
    }
}
