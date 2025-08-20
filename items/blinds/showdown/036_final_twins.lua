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
        calculate = function (self, blind, context)
            if
                not G.GAME.blind.disabled
                and context.scoring_hand
                and context.final_scoring_step
                and next(context.poker_hands["Pair"]) -- at least ONE pair is played
            then
                local cards_by_rank = {}

                -- add card
                MadLib.loop_func(context.scoring_hand, function(v,i)
                    local _rank = v:get_id()
                    cards_by_rank[_rank] = cards_by_rank[_rank] or {}
                    table.insert(cards_by_rank[_rank],v)
                end)

                -- look through ranks
                MadLib.loop_func(cards_by_rank, function(list,i)
                    table.sort(list, MadLib.get_coin_flip())
                    local num_pairs = math.floor(#list/2)
                    for j=0, num_pairs-1 do
                        local _left, _right = list[j*2], list[j*2+1]
                        local _target = MadLib.get_coin_flip() and _left or _right
                        _target:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                    end
                end)
            end
        end,
    }
}
