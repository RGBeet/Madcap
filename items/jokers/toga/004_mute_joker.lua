function Madcap.Funcs.get_volume(a)
    return G.SETTINGS.SOUND[a or 'volume']
end

function Madcap.Funcs.set_volume(a,b) -- trololol
    G.SETTINGS.SOUND[b or 'volume'] = a
end

return {
    data = {
        object_type = "Joker",
        key     = 'toga_mute_joker',
        atlas   = 'toga_jokers',
        pos     = MLIB.coords(0,3),
        rarity  = 'rgmc_gimmick',
        cost    = 5,
        config =  {
            extra = {
                x_mult = 2.5
            }
        },
        calculate = function(self, card, context)
            if context.joker_main or context.forcetrigger then
                local volume = Madcap.Funcs.get_volume()
                if volume ~= 0 and Madcap.Funcs.get_volume('music_volume') ~= 100 then
                    Madcap.Funcs.set_volume('music_volume', 100)
                end
                return { xmult = volume == 0 and card.ability.extra.x_mult or 1 }
            end
        end,
        loc_vars = function(self, info_queue, card)
            local volume = Madcap.Funcs.get_volume()
            tell('Current Volume is ' .. number_format(volume) .. '.')
            return MadLib.collect_vars(number_format(volume == 0 and card.ability.extra.x_mult or 1))
        end,
        demicoloncompat = true,
    }
}
