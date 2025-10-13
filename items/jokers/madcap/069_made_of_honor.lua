return {
    categories = {
        'Enhancements'
    },
    data = {
        object_type = "Joker",
        key     = 'made_of_honor',
        atlas   = 'jokers',
        rarity  = 2,
        cost    = 6,
        pos     = MLIB.coords(6,8),
        config =  {
            extra = { bismuth_adds = 1 },
            immutable = { max_adds = 40 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(math.floor(math.min(card.ability.extra.bismuth_adds, card.ability.immutable.max_adds)))
        end,
        calculate = function(self, card, context)
            if
                (context.setting_blind and not self.getting_sliced)
                or context.forcetrigger
            then
                for i=1, math.floor(math.min(card.ability.extra.bismuth_adds, card.ability.immutable.max_adds)) do
                    local front = pseudorandom_element(G.P_CARDS, pseudoseed('rgmc_made_of_honor')) -- i think it's making a random'
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1

                    -- this better not make invalid suits appear
                    local card = Card(G.discard.T.x + G.discard.T.w/2, G.discard.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_rgmc_bismuth, {playing_card = G.playing_card})

                    MadLib.simple_event(function()
                        card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                        G.play:emplace(card)
                        table.insert(G.playing_cards, card)
                        return true
                    end)

                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                        message = localize('k_plus_bismuth'),
                        colour = G.C.SECONDARY_SET.Enhanced
                    })

                    MadLib.simple_event(function()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        return true
                    end)

                    draw_card(G.play, G.deck, 90, 'up', nil)
                    playing_card_joker_effects({ card })
                    return nil, true
                end
                return true
            end
        end,
        demicoloncompat = true,
    }
}
