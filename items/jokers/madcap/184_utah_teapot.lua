Madcap.Lists.UtahTeapot = {
    MadLib.RankIds['1'],
    '2',
    '4',
    '8',
    'rgmc_16',
    'rgmc_32',
    'rgmc_64',
    'rgmc_128'
}
return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'utah_teapot',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 'rgmc_unusual',
        cost    = 16,
        config = { },
        loc_vars = function(self, info_queue, card)
            return { vars = {} }
        end,
        calculate = function(self, card, context)

            if
                context.joker_main
                and next(context.poker_hands['Pair'])
                and not next(context.poker_hands['Three of a Kind'])
            then
                local pair_cards    = {}
                local deleted_cards = {}
                MadLib.loop_func(context.scoring_hand, function(v) pair_cards[#pair_cards+1] = v end)
                MadLib.loop_func(pair_cards, function(v,i)
                    for j=i+1,#pair_cards do
                        if MadLib.is_rank(pair_cards[j], pair_cards[i]:get_id()) then
                            if not MadLib.list_matches_one(deleted_cards, function(v2)
                               return pair_cards[i] == v2 or pair_cards[j] == v2
                            end) then
                                deleted_cards[#deleted_cards+1] = pair_cards[i]
                                deleted_cards[#deleted_cards+1] = pair_cards[j]

                                local index = 0
                                for k=1,#Madcap.Lists.UtahTeapot-1 do
                                    if deleted_cards[#deleted_cards]:get_id() == SMODS.Ranks[Madcap.Lists.UtahTeapot[k]].id then
                                        index = k+1
                                        break
                                    end
                                end

                                if index > 0 then
                                    local enhancements = { pair_cards[i].config.center.key, pair_cards[j].config.center.key }
                                    local suits = { pair_cards[i].base.suit, pair_cards[j].base.suit }
                                    local ecard = context.blueprint_card or card
                                    MadLib.event({
                                        func = function()
                                            local _card = SMODS.create_card({ set = 'Playing Card',
                                                rank        = Madcap.Lists.UtahTeapot[index],
                                                suit        = pseudorandom_element(suits, pseudoseed('utah_teapot')),
                                                enhancement = pseudorandom_element(enhancements, pseudoseed('utah_teapot')),
                                                area        = G.discard,
                                            })
                                            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                                            _card.playing_card = G.playing_card
                                            table.insert(G.playing_cards, _card)
                                            MadLib.event({
                                                func = function()
                                                    G.hand:emplace(_card)
                                                    _card:start_materialize()
                                                    G.GAME.blind:debuff_card(_card)
                                                    G.hand:sort()
                                                    if context.blueprint_card then
                                                        context.blueprint_card:juice_up()
                                                    else
                                                        card:juice_up()
                                                    end
                                                    SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                                                    save_run()
                                                    return true
                                                end
                                            })
                                            SMODS.destroy_cards(deleted_cards, nil, nil, true)
                                            return true
                                        end
                                    })
                                end
                            end
                        end
                    end
                end)
            end
        end
    },
}
