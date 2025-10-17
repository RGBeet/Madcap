Madcap.Lists.RotarotConversions = {}

MadLib.loop_func({
    'fool',
    'magician',
    'high_priestess',
    'empress',
    'emperor',
    'hierophant',
    'lovers',
    'chariot',
    'justice',
    'hermit',
    'wheel_of_fortune',
    'strength',
    'hanged_man',
    'death',
    'temperance',
    'devil',
    'tower',
    'star',
    'moon',
    'sun',
    'judgement',
    'world'
}, function(v)
    Madcap.Lists.RotarotConversions['c_'..v] = 'c_mf_rot_'..v
end)

return {
    data = {
        object_type = "Joker",
        key     = 'mf_purpendicular',
        atlas   = 'mf_jokers',
        pos     = MLIB.coords(0,1),
        rarity  = 2,
        cost    = 7,
        config =  { extra = { consumable_slots = 1 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.consumable_slots)
        end,
        calculate = function(self, card, context)
            if
                (context.end_of_round
                and context.cardarea == G.jokers
                and not context.game_over
                and context.beat_boss)
                or context.forcetrigger
            then
                -- Turn all
                MadLib.loop_func(G.consumeables.cards, function(v)
                    if
                        v.ability.set ~= 'Tarot'
                        or not Madcap.Lists.RotarotConversions[v.config.center.key]
                    then
                        return
                    end -- tarots only bub!!!
                    SMODS.destroy_cards(v)
                    delay(0.05)
                    SMODS.add_card({ key = Madcap.Lists.RotarotConversions[v.config.center.key] })
                    delay(0.05)
                end)
            end
        end,
        add_to_deck = function(self, card, from_debuff)
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.consumable_slots
        end,
        remove_from_deck = function(self, card, from_debuff)
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.consumable_slots
        end,
        demicoloncompat = true,
    }
}
