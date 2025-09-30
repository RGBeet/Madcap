--[[
    Does effect similar to Deck of Equilibrium
]]

return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'glitch_in_the_system',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 'rgmc_unusual',
        cost    = 20,
        config = { 
            extra = { max_mayhem  = 5 },
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.max_mayhem))
        end,
        add_to_deck = function(self, card, from_debuff)
            G.GAME.max_mayhem = G.GAME.max_mayhem + self.config.extra.max_mayhem
            Madcap.Funcs.ease_mayhem(self.config.extra.max_mayhem)
            G.GAME.rgmc_glitch_enabled = true
            print('Glitch enabled!')
        end,
        remove_from_deck = function(self, card, from_debuff)
            G.GAME.max_mayhem = G.GAME.max_mayhem - self.config.extra.max_mayhem
            Madcap.Funcs.ease_mayhem(-self.config.extra.max_mayhem)
            G.GAME.rgmc_glitch_enabled = next(SMODS.find_card('j_rgmc_glitch_in_the_system')) or false
        end,
    },
}
