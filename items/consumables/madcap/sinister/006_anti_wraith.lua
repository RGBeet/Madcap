return {
    categories = {
        'Sinister Cards',
    },
    data = {
        object_type = 'Consumable',
        set     = "AntiSpectral",
        key		= 'anti_wraith',
        atlas   = 'sinister',
        pos 	= MLIB.coords(0,5),
        cost 	= 2,
        config	= { extra = { money = 3, rounds = 2} },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.rounds, card.ability.extra.money)
        end,
        can_use = function(self, card) -- at least one editioned playing card
            return MadLib.valid_table(MadLib.get_editioned_cards(G.playing_cards), 1)
        end,
        use 	= function(self, card, area, copier)
            play_sound('timpani')
            Madcap.Funcs.add_sinister('wraith', self.config.extra.rounds or 2)
            local wraith_targets = MadLib.get_jokers_matching_min_rarity(G.jokers.cards, 'Uncommon', true)
            MadLib.loop_func(wraith_targets, function(v)
                if not v.sinister_debuff then v:set_debuff(true) end
                v.sinister_debuff = v.sinister_debuff or {}
                v.sinister_debuff['wraith'] = true
            end)
            ease_dollars(#wraith_targets * (self.config.extra.money or 3))
        end
    }
}
