return {
    categories = {
        'Decks',
        'Sinister Cards'
    },
    data = {
        object_type = "Back",
        key     = "target",
        atlas   = 'decks',
        pos     = MLIB.coords(0,3),
        config = { good_max = 0.5, bad_min = 1.5 },
        loc_vars = function(self)
            return MadLib.collect_vars(self.config.good_max, self.config.bad_min)
        end,
        apply = function(self)
            Madcap.Funcs.init_deck('target', {
                finishers       = { 'bl_rgmc_final_target' }, -- force ???
                target_logic    = true
            })
            G.GAME.Exotic = true -- Exotic Suits show up!
        end,
        calculate = function(self, card, context)
            if context.end_of_round and not context.game_over and not context.individual and not context.repetition then
                local diff = math.abs(to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)) -- difference between your chips and blind chips
                local div = to_big(diff) / to_big(G.GAME.blind.chips) -- blind chips / difference

                local punishment, prize = false, false
                tell_stat('Diff / Chips',div)

                if div < 0.5 then -- div less than 50%
                    -- Receive a prize!
                    prize = true

                        local boosters = {}

                    for k, v in pairs(G.P_CENTERS) do
                        if v.set == 'Booster' then table.insert(boosters, k) end
                    end

                    if div < 0.01 then -- div less than 1% (prize 5)
                        Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk2')
                        Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                    elseif div < 0.05 then -- div less than 5% (prize 4)
                        Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                        Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                    elseif div < 0.10 then -- div less than 10% (prize 3)
                        Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk2')
                    elseif div < 0.25 then -- div less than 25% (prize 2)
                        Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                    else -- prize 1
                        Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
                    end
                elseif div > 1 then -- div 100% or greater
                    -- Receive a punishment!
                    punishment = true

                    if div < 1.5 then -- div less than 150% (punishment 1)
                        -- apply rental to joker
                    elseif div < 2.5 then -- div less than 250% (punishment 2)
                        -- apply perishable to joker
                    elseif div < 4.0 then -- div less than 400% (punishment 3)
                        --  gain antag (right now only the boomerang one)
                    elseif div < 6.0 then -- div less than 600% (punishment 4)
                        -- lose 1 joker or 1 joker slot
                    else -- div 600% or greater (punishment 5)
                        -- lose 1 hand size
                    end
                end
            end
        end
    }
}
