return {
    data = {
        object_type = "Joker",
        key     = 'liberty_bell',
        atlas   = 'jokers',
        rarity  = 1,
        cost    = 3,
        pos     = MLIB.coords(5,1),
        config = {
            extra = { seals = 1 },
            immutable = { max_seals = 10 }
        },
        loc_vars = function(self, info_queue, card)
            --info_queue[#info_queue + 1] = { set = "Other", key = "rgmc_cuprum_seal" }
            return MadLib.collect_vars(math.floor(math.min(card.ability.extra.seals, card.ability.immutable.max_seals)))
        end,
        calculate = function(self, card, context)
            if
                (context.discard
                and G.GAME.current_round.discards_used == 0)
                or (context.forcetrigger and G.hand.cards)
            then -- first discard = apply bronze seal and 15 bonus chips
                local area = context.discard and G.hand.highlighted or G.hand.cards
                MadLib.loop_check_func_limited(area, function(v)
                    return not v.seal
                end, function(v)
                    MadLib.simple_event(function()
                        v:set_seal('rgmc_cuprum', true)
                        v:juice_up(0.3,0.3)
                        play_sound('tarot2', 1.2, 0.4)
                        return true
                    end, 0.4, 'before')
                end, math.min(card.ability.extra.seals, card.ability.immutable.max_seals))
            end
        end,
        demicoloncompat = true,
    }
}
