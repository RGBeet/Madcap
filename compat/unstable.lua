-- cryptid mod compat
local list = {} -- loads a blank list if mod is not added
local mod_id, mod_name = "UnStable", "UnStable"
local loaded = mod_loaded(mod_id)

if loaded then -- load the items
    local UnStable_Mod = loaded[1]

    --print(UnStable_Mod)

    local enable_aux        = UnStable_Mod
    local enable_seals      = enable_aux
    local enable_suit_seals = enable_seals
    local suit_colors       = {
        ['rgmc_goblets']   = HEX('FFFFFF'),
        ['rgmc_towers']    = HEX('FFFFFF'),
        ['rgmc_blooms']    = HEX('FFFFFF'),
        ['rgmc_daggers']   = HEX('FFFFFF'),
    }

    -- Suit Seals
    if enable_suit_seals then
        local i = 1
        list[#list+1] = MadLib.create_atlas('unstable_seals', 'unstb_seals.png')
        MadLib.merge_tables(SuitSeal.suit_seal_colors, suit_colors, true)
        -- make stuff for the uhh suits
        MadLib.loop_func_table(suit_colors, function(k,v)
            SuitSeal.initSeal(k, "suit_seal", i-1)
            unstb_global.SUIT_SEAL[k] = {}
            unstb_global.SUIT_SEAL[k].seal_key  = 'unstb_'..string.lower(k)
            unstb_global.SUIT_SEAL[k].aux_key   = 'c_unstb_aux_'..string.lower(k)
            i = i+1
        end)
    end

    -- Aux Cards
    if enable_aux then
        local aux_cards = {}
        list[#list+1] = MadLib.create_atlas('unstable_aux', 'unstable_aux.png', 71, 95)

        MadLib.get_consumable_hand_count = function(card,hand)
            return MadLib.get_loop_func(hand, function(v, i)
                return v ~= card
            end)
        end

        -- Apply the seals
        local aux_apply_seal = function(self, card)
            MadLib.simple_event(function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end, 0.4, 'after')
            for i = 1, #G.hand.highlighted do
                MadLib.simple_event(function()
                    G.hand.highlighted[i]:set_seal(card.ability.extra.seal, nil, true)
                    return true
                end, 0.2, 'after')
            end
            delay(0.5)
            MadLib.simple_event(function()
                G.hand:unhighlight_all();
                return true
            end, 0.4, 'after')
        end

        -- Checks if you can apply.
        local aux_can_apply = function(self, card)
            return G.hand
                and MadLib.get_consumable_hand_count(card, G.hand.highlighted) >= 1
                and MadLib.get_consumable_hand_count(card, G.hand.highlighted) <= card.ability.extra.count
        end

        -- Turns a table of arguments into a proper table.
        local get_seal_card = function(args)
            return {
                key = args.key,
                config = args.config or {
                    extra = {
                        count = args.count or 2,
                        seal = string.lower(args.seal or args.key)
                    }
                },
                loc_vars    = args.loc_vars or (function(self, info_queue, card)
                    info_queue[#info_queue+1] = {set = 'Other', key = args.key .. '_seal'}
                    return {vars = {card.ability.extra.count}}
                end),
                can_use     = args.can_use or aux_can_apply,
                use         = args.use or aux_apply_seal,
                pos         = args.pos
            }
        end

        -- Seal suits are enabled
        if enable_suit_seals then
            local i=1
            --Suit Seals Addition Cards
            MadLib.loop_func_table(suit_colors, function(k,v)
                table.insert(aux_cards, get_seal_card({
                    key     = 'aux_'..string.lower(k),
                    seal    = 'rgmc_' .. string.lower(k),
                    pos     = { x = (i-1)%4, y = math.floor(i-1)/4 },
                    loc_vars = function(self, info_queue, card)
                        local suit = localize(k, 'suits_singular') ..' Seal'
                        local suit_color = G.C.SUITS[k]
                        info_queue[#info_queue+1] = {set = 'Other', key = 'suit_seal'}
                        return {vars = {card.ability.extra.count, suit, colours = {suit_color}}}
                    end,
                }))
                i=i+1
            end)
        end

        if enable_seals then
            local light = get_seal_card({
                key     = 'aux_light',
                seal    = 'rgmc_light',
                pos     = MLIB.coords(0,4)
            })

            -- Light Seal makes the card count as a light suit card
            -- regardless of suit
            local light_suit_ref = Card.has_light_suit
            function Card:has_light_suit()
                return self.seal == 'rgmc_light' or light_suit_ref
            end

            local dark = get_seal_card({
                key     = 'aux_dark',
                seal    = 'rgmc_dark',
                pos     = MLIB.coords(0,5)
            })

            -- Dark Seal makes the card count as a dark suit card
            -- regardless of suit
            local dark_suit_ref = Card.has_dark_suit
            function Card:has_dark_suit()
                return self.seal == 'rgmc_dark' or dark_suit_ref
            end

            local dazzling = get_seal_card({
                key     = 'aux_dazzling',
                seal    = 'rgmc_dazzling',
                pos     = MLIB.coords(2,0)
            })

            -- Dazzling Seals count towards five unique enhancement requirement,
            -- regardless of # of seals
            local dazzling_ref = MadLib.get_unique_enhancements
            function MadLib.get_unique_enhancements(group)
                local _list = dazzling_ref(group)

                MadLib.loop_func(group, function(v)
                    if v.seal == 'rgmc_dazzling' then
                        _list[v.seal] = (_list[v.seal] or 0) + 1
                    end
                end)
                return dazzling_ref(_list)
            end
            
            MadLib.loop_func({'0', '0.5', '1', 'r2', 'e', 'Pi', '???', '21', '11', '12', '13', '25', '161'}, function(v)
                MadLib.RankKeyId[SMODS.Ranks['unstb_' .. v].id] = ('unstb_' .. v)
            end)

            MadLib.merge_tables(aux_cards, {
                light,
                dark,
                dazzling
            }, true)
        end

        for i=1, #aux_cards do
            aux_cards[i].object_type    = "Consumable"
            aux_cards[i].set            = 'Auxiliary'
            aux_cards[i].atlas          = "unstable_aux"
            aux_cards[i].discovered     = true
            list[#list+1] = aux_cards[i]
        end
    end

    --[[
        - Vainglorious Joker, Acedia Joker,
        and Cinnabar should work with
        new Suit Seals

        - Black Jack should work with new
        ranks (check just in case!)

        - Library Card should do the following
        for new suits:
            - Goblet  = +20 Chips, +4 Mult
            - Tower   = +15 Chips, +4 Mult
            - Bloom   = +15 Chips, +4 Mult
            - Dagger  = +20 Chips, +4 Mult
            - Void    = +10 Chips, +4 Mult
            - Lantern = +25 Chips, +4 Mult
    ]]
end

return {
    name = mod_name .. " Compatability",
    init = function() -- does the non item stuff ig?
		if not mod_loaded(mod_id) then
			tell(mod_name .. "is not loaded - skipping!")
			return false
		end

		return true
    end,
    items = list
}
