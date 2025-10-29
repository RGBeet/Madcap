return {
    data = {
        object_type = "Joker",
        key     = 'squash_keychain',
        atlas   = 'jokers',
        pos     = MLIB.coords(8,4),
        rarity  = 3,
        cost    = 10,
        config = {
            extra = { spectral_id = "c_cryptid" }
        },
        loc_vars = function(self, info_queue, card)
            local tarot_id = MadLib.localize_name_text('Spectral', card.ability.extra.spectral_id)
            return MadLib.collect_vars(tarot_id)
        end,
        calculate = function(self, card, context)
            if (context.using_consumeable and context.consumeable and context.consumeable:get_config().key == (card.ability.extra.tarot_id) and not (context.consumeable).edition) or context.forcetrigger then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                MadLib.simple_event(function()
                    local dupe = SMODS.add_card({ key = card.ability.extra.tarot_id })
                    dupe:set_edition({negative = true}, true)
                    dupe:set_cost()
                    G.GAME.consumeable_buffer = 0
                    return true
                end, 2.0, 'after')
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
                -- destroys a random base of this card, if exists
                if context.forcetrigger then
                    local card_to_destroy = MadLib.get_first_list_match(G.consumeables.cards, function(v)
                        return v:get_config().key == (card.ability.extra.tarot_id)
                    end)
                    if card_to_destroy then MadLib.handle_consumable_destroy(card_to_destroy) end
                end
                MadLib.simple_event(function()
                    local new_pick = pseudorandom_element(G.P_CENTER_POOLS.Spectral, pseudoseed('rgmc_pumpkin_keychain')).key
                    card.ability.extra.tarot_id = new_pick -- pick new card?
                    return true
                end, 2.0, 'after')
            end
        end,
        demicoloncompat = true,
    }
}
