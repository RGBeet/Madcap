return {
    categories = {
        'Sinister Cards',
    },
    data = {
        object_type = 'Consumable',
        set     = "AntiSpectral",
        key		= 'anti_ectoplasm',
        atlas   = 'sinister',
        pos 	= MLIB.coords(0,8),
        cost 	= 2,
        config	= { extra = { jokers = 1, h_size = 1 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.jokers, card.ability.extra.h_size)
        end,
        can_use = function(self, card)
            return (G.jokers.config.card_limit - self.config.extra) >= 0
        end,
        use 	= function(self, card, area, copier)
            play_sound('timpani')
            Madcap.Funcs.add_sinister('ectoplasm', self.config.extra.rounds or 2, self.config.extra.h_size)
            local ectoplasm_targets = MadLib.get_cards_from_shuffled_deck(G.joker.cards, math.max(self.config.card_limit - 4, 1), function(v) return true end)
            MadLib.loop_func(ectoplasm_targets, function(v)
                if not v.sinister_debuff then v:set_debuff(true) end
                v.sinister_debuff = v.sinister_debuff or {}
                v.sinister_debuff['ectoplasm'] = true
            end)
        end
    }
}
