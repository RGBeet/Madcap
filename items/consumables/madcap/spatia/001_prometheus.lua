Madcap.Lists.SpatiaWhitelist = {
    'Straight',
    'Flush',
    'Full House',
    'Straight Flush',
    'Five of a Kind',
    'Flush House',
    'Flush Five',
}

function Madcap.Funcs.get_spatia_vars(hand_list, subhand_list)
	local all_vars     = { }
	local all_colours  = { }
    --[[
	MadLib.loop_func(hand_list, function(ha)
		local hand = G.GAME.hands and G.GAME.hands[ha]
		table.insert(all_vars, hand and hand.level or 1)
		table.insert(all_vars, localize(ha,'poker_hands') or "???")
		table.insert(all_vars, hand and hand.l_mult or 0)
		table.insert(all_vars, hand and hand.l_chips or 0)
		table.insert(all_colours,(
			to_big(hand and hand.level or 1) == to_big(1) and G.C.UI.TEXT_DARK
			or G.C.HAND_LEVELS[to_number(math.min(7, hand and hand.level or 1))]
		))
	end)]]

	MadLib.loop_func(subhand_list, function(sh)
		local subhand = G.GAME.subhands and G.GAME.subhands[SubHands[sh].name]
		table.insert(all_vars, subhand and subhand and subhand.level or 1)
		table.insert(all_vars, localize(SubHands[sh].name))
		table.insert(all_vars, (subhand and subhand.l_mult
			or SubHands[sh].l_mult) + 1)
		table.insert(all_vars, (subhand and subhand.l_chips
			or SubHands[sh].l_chips) + 1)
		table.insert(all_colours,(
			to_big(subhand and subhand.level or 1) == to_big(1) and G.C.UI.TEXT_DARK
			or G.C.HAND_LEVELS[to_number(math.min(7, subhand and subhand.level or 1))]
		))
	end)
	all_vars['colours'] = all_colours
	return { vars = all_vars }
end

function Madcap.Funcs.card_level_subhand(card, sh, levels)
    if not G.GAME.subhands[sh] then return end
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 2.0}, {
		handname	= localize(sh),
		chips 		= G.GAME.subhands[sh].chips,
		mult 		= G.GAME.subhands[sh].mult,
		level 		= G.GAME.subhands[sh].level
	})
    Madcap.Funcs.level_up_subhand(card, sh, false, levels or 1)
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 2.0}, {mult = 0, chips = 0, handname = '', level = ''})
    if G.GAME.current_round.current_hand.handname ~= "" then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                G.hand:parse_highlighted()
                return true
            end
        }))
    end
end

function Madcap.Funcs.card_level_hand(card, hand_type)
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {
		handname 	= localize(hand_type, 'poker_hands'),
		chips 		= G.GAME.hands[hand_type].chips,
		mult 		= G.GAME.hands[hand_type].mult,
		level		= G.GAME.hands[hand_type].level
	})
    level_up_hand(card, hand_type)
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    if G.GAME.current_round.current_hand.handname ~= "" then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                G.hand:parse_highlighted()
                return true
            end
        }))
    end
end

function Madcap.Funcs.use_spatia_card(card)
	MadLib.loop_func(card.ability.subhands, function(v) Madcap.Funcs.card_level_subhand(card, v, card.ability.level_factor or 1) end)
    local hand = pseudorandom_element(Madcap.Lists.SpatiaWhitelist, pseudoseed('spatia' .. tostring(G.GAME.round_resets.ante)))
    Madcap.Funcs.card_level_hand(card, hand)
end

return {
    categories = {
        'Subhands',
        'Spatia'
    },
    data = {
        object_type = 'Consumable',
        set     = "SpatiaPlanet",
        key     = "prometheus",
        atlas   = "spatia",
        pos     = MLIB.coords(0,0),
        cost    = 4,
        aurinko = false,
        config  = {
            subhands		= { 'ml_sh_dark' },
            level_factor	= 1
        },
        set_card_type_badge = function(self, card, badges)
            badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
        end,
        loc_vars = function(self, info_queue, center)
            return Madcap.Funcs.get_spatia_vars(self.config.subhands)
        end,
        can_use = function(self, card)
            return true
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.use_spatia_card(card, card.ability.subhands, card.ability.level_factor)
        end,
    }
}
