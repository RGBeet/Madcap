function Madcap.Funcs.discard_aoe(card, area, i, list, n, seen)
    if not area or not card then return list end
    seen = seen or {}   -- track which indices we’ve already visited
    n = n or 1          -- recursion depth allowed

    if n <= 0 then return list end
    if seen[i] then return list end  -- already visited this position

    -- mark visited
    seen[i] = true

    -- add this card
    table.insert(list, card)
    tell('Adding card at index ' .. tostring(i))

    -- recurse left
    if i > 1 then
        list = Madcap.Funcs.discard_aoe(area.cards[i-1], area, i-1, list, n-1, seen)
    end
    -- recurse right
    if i < #area.cards then
        list = Madcap.Funcs.discard_aoe(area.cards[i+1], area, i+1, list, n-1, seen)
    end

    return list
end

return {
    data = {
        object_type = 'Blind',
        key     = 'bowler',
        atlas   = "blinds",
        pos     = MLIB.coords(31),
        min_ante = 3,
        boss_colour = HEX('D8B7A4'),
        in_pool = function(self)
            return Madcap.Data.devmode
        end,
        calculate = function (self, blind, context)
            if
                (not G.GAME.blind.disabled) 
                and context.before
            then
                local pins_knocked = {}
                MadLib.loop_func(G.hand.cards, function(v,i)
                    if MadLib.list_matches_one(MadLib.RankTypes['Triangular'], function(v2)
                        return MadLib.is_rank(v, MadLib.rank_id(v2))
                    end) then
                        tell('Add pins knocked...')
                        pins_knocked = Madcap.Funcs.discard_aoe(v, G.hand, i, pins_knocked)
                    end
                end)

                if #pins_knocked > 0 then
                    MadLib.simple_event(function()
                        play_sound('rgmc_bowling')
                        return true
                    end, 0.02, 'after')
                    MadLib.loop_func(pins_knocked, function(card)
                        draw_card(G.hand, G.discard, 100, 'down', false, card)
                    end)
                end
            end
        end,
    }
}
