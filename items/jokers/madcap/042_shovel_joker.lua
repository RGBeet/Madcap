-- If Modded Suits are not enabled, Three Trees does not require a modded suit - just a light and dark.
return {
    categories = { 'New Suit' },
    data = {
        object_type = "Joker",
        key     = 'shovel_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(4,1),
        rarity  = 3,
        cost    = 7,
        config =  {
            extra = { rank = 'rgmc_Knight', x_mult = 2 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(Madcap.Funcs.get_joker_rank(card, 'rgmc_Knight'), 'ranks'),
                number_format(card.ability.extra.x_mult))
        end,
        calculate = function(self, card, context)
            if context.checktrigger then
                return context.cardarea == G.play
                    and context.individual
                    and context.other_card
                    and MadLib.is_rank(context.other_card, card.ability.extra.rank or 'rgmc_Knight')
                    and MadLib.has_suit_in_list(context.other_card, MadLib.SuitTypes.Dark)
            end
            if
                (context.cardarea == G.play
                    and context.individual
                    and context.other_card
                    and MadLib.is_rank(context.other_card, card.ability.extra.rank or 'rgmc_Knight')
                    and MadLib.has_suit_in_list(context.other_card, MadLib.SuitTypes.Dark))
                    or context.forcetrigger -- demicolon
            then
                return { xmult = card.ability.extra.x_mult, card = card }
            end
        end,
        in_pool = function(self, args) -- at least one Knight rank
            return MadLib.list_matches_one(G.playing_cards or {}, function(v)
                return MadLib.is_rank(v, self.config.extra.rank or 'rgmc_Knight')
                    and MadLib.has_suit_in_list(v, MadLib.SuitTypes.Dark)
            end)
        end,
        demicoloncompat = true,
        quasicoloncheck = true,
    }
}
