return {
    categories = {
        'Cosma Tarots',
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "unknown",
        atlas   = "cosma",
        pos 	= MLIB.coords(2,0),
        cost 	= 7,
        config	= { extra = { min = 0.5, max = 1.5 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.min), number_format(card.ability.extra.max))
        end,
        can_use = function(self, card)
            return true
        end,
        use = function(self, card, area, copier)
            local roll = math.ceil(math.random() * 6)
            local _card

                local roll2 = math.floor(math.random() * 100)
                local _rarity
                if roll2 > 99 then
                    _rarity = 'Legendary'
                elseif roll2 > 80 then
                    _rarity = 'Rare'
                elseif roll2 > 50 then
                    _rarity = 'Uncommon'
                else
                    _rarity = 'Common'
                end

                _card = SMODS.add_card {
                    set = 'Joker',
                    edition = 'e_negative',
                    rarity = _rarity,
                    key_append = 'rgmc'
                }
                G.GAME.joker_buffer = 0
                return { message = "+1", colour = G.C.DARK_EDITION }
        end
    }
}
