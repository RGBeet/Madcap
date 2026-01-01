-- If Modded Suits are not enabled, Three Trees does not require a modded suit - just a light and dark.
return {
    data = {
        object_type = "Joker",
        key     = 'jimbos_funeral',
        atlas   = 'jokers',
        pos     = MLIB.coords(4,0),
        rarity  = 3,
        cost    = 7,
        config =  {
            extra = { active = true, }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.active and localize("k_active_ex") or localize("rgmc_inactive"))
        end,
        calculate = function(self, card, context)
            if context.checktrigger then
                return context.joker_main 
                    and G.GAME.current_round.discards_left > 0
                    and card.ability.extra.active 
                    and G.GAME.current_round.hands_left == 0
                    and not context.blueprint
            end
            if context.setting_blind then -- active!
                card.ability.extra.active = true
            end
            -- show it's about to POP OFF!
            if
                context.before
                and G.GAME.current_round.hands_left == 1
                and card.ability.extra.active
                and not context.blueprint
            then
                local eval = function() return G.GAME.current_round.hands_left == 0 end
                juice_card_until(card, eval, true)
            end
            -- changes hands and discards before you can get a game over
            -- if you have 0 discards, don't even bother!
            if
                (context.joker_main 
                    and G.GAME.current_round.discards_left > 0
                    and card.ability.extra.active 
                    and G.GAME.current_round.hands_left == 0
                    and not context.blueprint)
                or context.forcetrigger
            then
                -- do the thing RIGHT NOW
                ease_discard(G.GAME.current_round.hands_left-G.GAME.current_round.discards_left, nil, true)
                ease_hands_played(G.GAME.current_round.discards_left)
                -- give safe message
                if not context.forcetrigger then -- if demicolon'd, don't
                    card.ability.extra.active = false -- activated for the round
                    -- do the stuff
                    MadLib.event({
                        trigger = 'after',
                        delay = 0.3,
                        blockable = false,
                        func = function()
                            return {
                                message = localize("k_upgrade_ex"), -- Safe!
                                card = card,
                            }
                        end
                    })
                end
            end
        end,
        demicoloncompat = true,
        quasicoloncheck = true,
    }
}
