return {
    data = {
        object_type = "Joker",
        key     = 'conspiracy_wizard',
        atlas   = 'jokers',
        pos     = MLIB.coords(3,2),
        rarity  = 2,
        cost    = 4,
        config =  {
            extra = { mult = 5, chips = 10 },
        },
        loc_vars = function(self, info_queue, card)
            local rank, suit = localize('rgmc_sekrit'), localize('rgmc_sekrit')
            if
                G.GAME and G.GAME.current_round
                and G.GAME.current_round.rgmc_wizard_card
            then
                if G.GAME.current_round.rgmc_wizard_card.rank_discovered then
                    rank = localize(G.GAME.current_round.rgmc_wizard_card.rank, 'ranks')
                end
                if G.GAME.current_round.rgmc_wizard_card.suit_discovered then
                    suit = localize(G.GAME.current_round.rgmc_wizard_card.suit, 'suits_plural')
                end
            end

            return MadLib.collect_vars(
                number_format(card.ability.extra.mult),
                number_format(card.ability.extra.chips),
                (Madcap.Data.devmode and G.GAME.MADCAP) and G.GAME.current_round.rgmc_wizard_card.rank or "SEKRIT",
                (Madcap.Data.devmode and G.GAME.MADCAP) and Madcap.Data.devmode and G.GAME.current_round.rgmc_wizard_card.suit or "SEKRIT")
        end,
        calculate = function(self, card, context)

            if
                context.cardarea == G.play
                and context.individual
                and not context.blueprint
                and not context.forcetrigger
            then
                if MadLib.is_card(context.other_card, SMODS.Ranks[G.GAME.current_round.rgmc_wizard_card.rank].id) then -- u got the rank (prioritizes over suit)
                    G.GAME.current_round.rgmc_wizard_card.rank_discovered = true
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
                end
                if context.other_card:is_suit(G.GAME.current_round.rgmc_wizard_card.suit) then -- u got the suit
                    G.GAME.current_round.rgmc_wizard_card.suit_discovered = true
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
                end
            end

            if context.forcetrigger then -- do both chip and mult, but do not reveal the cards
                MadLib.simple_event(function()
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
                end, 0.3, 'immediate')

                MadLib.simple_event(function()
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
                end, 0.3, 'immediate')
            end
        end,
        demicoloncompat = true,
    },
}
