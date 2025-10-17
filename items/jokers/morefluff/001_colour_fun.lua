Madcap.Lists.Colours = {
    'mf_black',
    'mf_deep_blue',
    'mf_crimson',
    'mf_seaweed',
    'mf_brown',
    'mf_grey',
    'mf_silver',
    'mf_white',
    'mf_red',
    'mf_orange',
    --'mf_yellow', -- needs to be sold!!
    'mf_green',
    'mf_blue',
    'mf_lilac',
    'mf_pink',
    'mf_peach',
    'mf_gold',
    'mf_magneta',
    'rgmc_carnation_pink',
    'rgmc_cobalt_blue',
    'rgmc_olive_green',
    'rgmc_venetian_red',
    'rgmc_celestial_blue',
    'rgmc_torch_red',
    'rgmc_rose_gold',
    'rgmc_sugar_plum',
    'rgmc_wenge',
}
--[[
    CRYPTID
    'mf_moonstone',
    'mf_gold',
    'mf_ooffoo',
    AIKOYORI
    'mf_wordlegreen',
    'mf_pastelpink',
    'mf_royalblue',
    'mf_teal',
    'mf_blank'
]]

return {
    data = {
        object_type = "Joker",
        key     = 'mf_colour_fun',
        atlas   = 'mf_jokers',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 4,
        config =  {
            extra = { chips = 0, chip_mod = 40, target = nil }
        },
        loc_vars = function(self, info_queue, card)
            if card.ability.extra.target then
                info_queue[#info_queue+1] = { key = 'c_' .. card.ability.extra.target , set = 'Colour' }
            end
            name = card.ability.extra.target ~= nil
                and MadLib.localize_name_text('Colour', 'c_' .. card.ability.extra.target)
                or "???"
            return MadLib.collect_vars(number_format(card.ability.extra.chip_mod), number_format(card.ability.extra.chips), name)
        end,
        calculate = function(self, card, context)
            if context.joker_main and card.ability.extra.chips > 0 then
                return { chips = lenient_bignum(card.ability.extra.chips) }
            end
            if
                (context.using_consumeable and context.consumeable and context.consumeable:get_config().key == ('c_'..card.ability.extra.target))
                or context.forcetrigger
            then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                card.ability.extra.target = pseudorandom_element(Madcap.Lists.Colours, pseudoseed('colour_fun'))
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                    message_card = card
                }
            end
        end,
        add_to_deck = function(self, card, from_debuff)
            if from_debuff then return end
            card.ability.extra.target = pseudorandom_element(Madcap.Lists.Colours, pseudoseed('colour_fun'))
        end,
        demicoloncompat = true,
    }
}
