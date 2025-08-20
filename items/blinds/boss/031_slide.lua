function Madcap.Funcs.pendulum_end(self, silent)
    MadLib.loop_func({ G.jokers, G.hand }, function(v,_)
        if v and (#v.cards > 0) then
            MadLib.flip_cards(v.cards, function(c)
                c:set_debuff(false)
            end, nil, function(c)
                c:juice_up(0.3, 0.3)
            end)
        end
    end)
    return true
end

return {
    data = {
        object_type = 'Blind',
        key     = 'slide',
        atlas   = "blinds",
        pos     = MLIB.coords(30),
        min_ante = 3,
        boss_colour = HEX('427B85'),
        in_pool = function(self)
            return Madcap.Data.devmode
        end,
        debuff_hand = function(self, cards, hand, handname, check)
            if not G.GAME.blind.disabled then
                for i=2, #cards do
                    local this_rank = SMODS.Ranks[cards[i]:get_id()]
                    local that_rank = SMODS.Ranks[cards[i-1]:get_id()]

                    local n1 = (this_rank.base.nominal + this_rank.base.face_nominal)
                    local n2 = (that_rank.base.nominal + that_rank.base.face_nominal)

                    if n1 > n2 then
                        G.GAME.blind.triggered = true
                    return true
                    end
                end
            end
            return false
        end,
    }
}
