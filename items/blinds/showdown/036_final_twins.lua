return {
    data = {
        object_type = 'Blind',
        key     = 'final_twins',
        atlas   = "blinds",
        pos     = MLIB.coords(32),
        min_ante = 5,
        in_pool = function(self)
            return true
        end,
        boss_colour = HEX('88A5D9'),
        calculate = function (self, blind, context)
            if
                not G.GAME.blind.disabled
                and context.scoring_hand
                and context.final_scoring_step
                and next(context.poker_hands["Pair"]) -- at least ONE pair is played
            then
                local cards = {}
                -- add card
                MadLib.loop_func(context.scoring_hand, function(v,i)
                    local x = v:get_id()
                    cards[x] = cards[x] or {}
                    table.insert(cards[x], v)
                end)

                -- look through ranks
                MadLib.loop_table(cards, function(k,v1)
                    if #v1 < 2 then return end
                    pseudoshuffle(cards[k], pseudoseed('final_twins'))
                    MadLib.loop_func(cards[k], function(_,i)
                        if not (i%2 == 0 or i+1 < #cards[k]) then return end
                        v:start_dissolve({ HEX("88A5D9") }, nil, 1.5)
                    end)
                end)
            end
        end,
    }
}
