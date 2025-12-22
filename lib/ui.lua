local toggle_shop_ref = G.FUNCS.toggle_shop
function G.FUNCS.toggle_shop(e)
    if 
        G.STATE == G.STATES.RGMC_IMPOUND_SHOP
        and G.shop_jokers 
        and G.impound 
    then
        MadLib.loop_func(G.shop_jokers.cards, function(v)
            draw_card(G.shop_jokers, G.impound, nil, nil, nil, v)
        end)
    end
    print("There are now " .. tostring(#G.impound.cards) .. " cards.")
    toggle_shop_ref(e)
end

function create_UIBox_subhand_tip(sh)
	if not G.GAME.subhands[sh].example then return {n=G.UIT.R, config={align = "cm"},nodes = {}} end

	local cardarea = CardArea(2, 2, 3.5 * G.CARD_W, 0.75 * G.CARD_H, { card_limit = 5, type = 'title', highlight_limit = 0 })
	for k, v in ipairs(G.GAME.subhands[sh].example) do
		local card = Card(0,0, 0.5*G.CARD_W, 0.5*G.CARD_H, G.P_CARDS[v[1]], G.P_CENTERS[v.enhancement or 'c_base'])
		if v.edition then card:set_edition(v.edition, true, true) end
		if v.seal then card:set_seal(v.seal, true, true) end
		if v[2] then card:juice_up(0.3, 0.2) end
		if k == 1 then play_sound('paper1',0.95 + math.random()*0.1, 0.3) end
		ease_value(card.T, 'scale',v[2] and 0.25 or -0.15,nil,'REAL',true,0.2)
		--if v['akyrs_letter'] then card:set_letters(v['akyrs_letter']) card.ability.forced_letter_render = true end
		if v.is_null then card.is_null = true end
		cardarea:emplace(card)
	end

	return {n=G.UIT.R, config={align = "cm", colour = G.C.WHITE, r = 0.1}, nodes={
		{n=G.UIT.C, config={align = "cm"}, nodes={ {n=G.UIT.O, config={object = cardarea}}}}
	}}
end

-- Subhand Order of Subhand
Madcap.Lists.SubhandOrder = {
	'ml_sh_light',
	'ml_sh_dark',
	'ml_sh_high',
	'ml_sh_low',
	'ml_sh_spectrum',
	'ml_sh_balanced',
}


function G.UIDEF.subhands()
	local subhands = {}
	if not (G.GAME and G.GAME.subhands) then
		tell('ERROR! No subhands')
		return
	end
	MadLib.loop_func(Madcap.Lists.SubhandOrder, function(sh)
		local current_subhand = G.GAME.subhands[sh]
		local empower = current_subhand.empower and current_subhand.empower > 0

		local cm_minw 	= (not empower) and 1.1 or (1.1 * 0.8)
		local cm_scale 	= (not empower) and 0.45 or (0.45 * 0.8)

		if not current_subhand or (not current_subhand.enabled and current_subhand.level == 1) then return end
		--print(current_subhand.chips)
		subhands[#subhands+1] = {n=G.UIT.R, config={align = "cm", padding = 0.05, r = 0.1, colour = darken(G.C.JOKER_GREY, current_subhand.enabled and 0.1 or 0.4), emboss = 0.05, hover = false, force_focus = true, on_demand_tooltip = {filler = {func = create_UIBox_subhand_tip, args = sh}}}, nodes={
		{n=G.UIT.C, config={align = "cl", padding = 0, minw = 5}, nodes={
			{n=G.UIT.C, config={align = "cm", padding = 0.01, r = 0.1, colour = G.C.HAND_LEVELS[math.min(7, current_subhand.level)], minw = 1.5, outline = 0.8, outline_colour = G.C.WHITE}, nodes={
			{n=G.UIT.T, config={text = localize('k_level_prefix')..current_subhand.level, scale = 0.5, colour = G.C.UI.TEXT_DARK}}
			}},
			{n=G.UIT.C, config={align = "cm", minw = 4.5, maxw = 4.5}, nodes={
			{n=G.UIT.T, config={text = ' '..localize(sh), scale = 0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
			}}
		}},
			{n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.BLACK,r = 0.1}, nodes={
				{n=G.UIT.C, config={align = "cr", padding = 0.01, r = 0.1, colour = G.C.CHIPS, minw = cm_minw}, nodes={
					{n=G.UIT.T, config={text = 'x'..number_format(current_subhand.chips, 1000000), scale = cm_scale, colour = G.C.UI.TEXT_LIGHT}},
					{n=G.UIT.B, config={w = 0.08, h = 0.01}}
				}},
				{n=G.UIT.T, config={text = ",", scale = cm_scale, colour = G.C.WHITE}},
				{n=G.UIT.C, config={align = "cl", padding = 0.01, r = 0.1, colour = G.C.MULT, minw = cm_minw}, nodes={
				{n=G.UIT.B, config={w = 0.08,h = 0.01}},
				{n=G.UIT.T, config={text = 'x'..number_format(current_subhand.mult, 1000000), scale = cm_scale, colour = G.C.UI.TEXT_LIGHT}}
				}},
				empower and {n=G.UIT.T, config={text = ",", scale = cm_scale, colour = G.C.WHITE}} or nil,
				empower and {n=G.UIT.C, config={align = "cl", padding = 0.01, r = 0.1, colour = darken(G.C.RGMC_UNUSUAL, 0.5), minw = cm_minw}, nodes={
				{n=G.UIT.B, config={w = 0.08,h = 0.01}},
				{n=G.UIT.T, config={text = 'x'..number_format(Madcap.Funcs.get_potentia_bonus(sh), 1000000), scale = cm_scale, colour = G.C.UI.TEXT_LIGHT}}
				}} or nil,
			}},
			{n=G.UIT.C, config={align = "cm"}, nodes={
				{n=G.UIT.T, config={text = '  #', scale = 0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
				}},
			{n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.L_BLACK,r = 0.1, minw = 0.9}, nodes={
				{n=G.UIT.T, config={text = "???", scale = 0.45, colour = G.C.FILTER, shadow = true}},
			}}
		}}
	end)

	local t = {n=G.UIT.ROOT, config={align = "cm", minw = 3, padding = 0.1, r = 0.1, colour = G.C.CLEAR}, nodes={
		{ n=G.UIT.R, config = {align = "cm", padding = 0.04}, nodes = subhands },
	}}

	return t
end

Madcap.Funcs.generate_special_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    if not card or not card.ability then return end
    --[[
    if card.ability.subtitle then
        if #card.ability.subtitle > 1 then
            local _subtitle_string = ""

            for i = 1, #card.ability.subtitle do
                if i == 1 then
                    _subtitle_string = _subtitle_string .. card.ability.subtitle[i]
                else

                    _subtitle_string = _subtitle_string .. ", " .. card.ability.subtitle[i]
                end
            end
        end
    end]]
    full_UI_table.name = {
        {
            n = G.UIT.C,
            config = { align = "cm", padding = 0.05 },
            nodes = {
                {
                    n = G.UIT.R,
                    config = { align = "cm" },
                    nodes = full_UI_table.name
                },
            }
        }
    }
    local place = full_UI_table.name[1].nodes
    if card.config.center.long_title then
        for i=1,#card.config.center.long_title do
            local line = tostring(card.config.center.long_title[i])
            place[#place+1] = { n = G.UIT.R, config = { align = 'cm'}, nodes = Madcap.Funcs.make_long_title_line(line) }
        end
    end
end

-- used to make fake titles that are absurdly long
Madcap.Funcs.make_long_title_line = function(text)
    local _full_text = text or "NULL"
    local _scale_base = 1.0
    return {{
        n = G.UIT.O,
        config = {
            object = DynaText({
                    string      = { _full_text },
                    colours     = { G.C.WHITE },
                    bump        = true,
                    silent      = true,
                    pop_in      = 0,
                    pop_in_rate = 4,
                    maxw        = 5,
                    shadow      = true,
                    y_offset    = 0,
                    spacing     = math.max(0, 0.32 * (17 - #_full_text)),
                    scale       = (0.4 - 0.004* #_full_text) * _scale_base
            })
        }
    }}
end

--[[
	CONFIG
]]

local config_content = {
	['mechanics'] = {
		'subhands',
	},
	['rarities'] = {
		'rarity_unusual',
		'rarity_gimmick',
		'rarity_chaotic',
	},
	['ranks'] = {
		'ranks_static',
		'ranks_high',
		'ranks_uno',
	},
	['suits'] = {
		'suits_parallel',
		'suits_chaotic',
	},
	['items'] = {
		'items_cosma',
		'items_spatia',
		'items_potentia',
	},
	['tags'] = {
		'tags',
		'antags',
	},
	['modifiers'] = {
		'enhancements',
		'editions'
	},
	['other_features'] = {
		'blinds',
		'boosters',
		'vouchers',
		'stakes',
	},
	['misc'] = {
		'music',
		'jokers',
		'crossmod',
		'sleeves',
		'partners',
		'wip_stuff'
	},
}
local config_order = {
	'mechanics',
	'rarities',
	'ranks',
	'suits',
	'items',
	'tags',
	'modifiers',
	'other_features',
	'misc'
}
local function create_toggle_category(k)
	local button_group = {}

	MadLib.loop_func(config_content[k], function(v)
		button_group[#button_group+1] = create_toggle{
			label = v,
			ref_table = MadcapConfig,
			ref_value = v
		}
	end)

	return { n = G.UIT.C, config = { align = 'cm' }, nodes = button_group }
end

local function create_toggle_settings()
	local columns = 3
	local page_nodes = {}
	MadLib.loop_func(config_order, function(k)
		page_nodes[#page_nodes+1] = create_toggle_category(k)
	end)
	return { n = G.UIT.R, config = { align = 'cm' }, nodes = {} }
end

SMODS.current_mod.config_tab = function()
	local _scale 	= 0.35
	local _label 	= 0.2
	local _box 		= 0.5

	local _width1 		= 5
	local _width2 		= 3
	local _total_width 	= 8

	local misc_nodes = {}

	misc_nodes[#misc_nodes+1] = create_toggle{ label = "Music", align = 'cl', ref_table = MadcapConfig, ref_value = 'music',w = _width1, scale = _box, label_scale = _label, shadow = true }
	misc_nodes[#misc_nodes+1] = create_toggle{ label = "Sleeves", align = 'cl',  ref_table = MadcapConfig, ref_value = 'sleeves', w = _width1, scale = _box, label_scale = _label, shadow = true }

	if Partner_API then misc_nodes[#misc_nodes+1] = create_toggle{ label = "Partners", align = 'cl', ref_table = MadcapConfig, ref_value = 'partners', w = _width1, scale = _box, label_scale = _label, shadow = true } end
	if CardSleeves then misc_nodes[#misc_nodes+1] = create_toggle{ label = "Crossmod", align = 'cl',  ref_table = MadcapConfig, ref_value = 'crossmod', w = _width1, scale = _box, label_scale = _label, shadow = true } end
	misc_nodes[#misc_nodes+1] = create_toggle{ label = "WIP Content", align = 'cl', ref_table = MadcapConfig, ref_value = 'wip_stuff', w = _width1, scale = _box, label_scale = _label, shadow = true }

	local content = {
		n = G.UIT.ROOT,
		config = { align = 'cm', padding = 0.05, emboss = 0.05, r = 0.1, colour = G.C.BLACK },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = 'tl', w = _total_width*3 },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = 'tr', colour = darken(G.C.BLUE, 0.5), w = _total_width, padding = 0.05, },
						nodes = {
							{ n = G.UIT.T, config = {
								align = 'tr,',
								text = "Mechanics",
								scale = _scale,
								colour = G.C.UI.TEXT_LIGHT,
								w = _width2,
								shadow = true,
							}},
							{ n = G.UIT.C, config = { align = 'cr' }, nodes = {
								create_toggle{ label = "Subhands", align = 'cl', ref_table = MadcapConfig, ref_value = 'subhands', w = _width1, scale = _box, label_scale = _label, shadow = true },
							}}
						},
					},
					{
						n = G.UIT.C,
						config = { align = 'tr', colour = darken(G.C.RED, 0.5), w = _total_width, padding = 0.05, },
						nodes = {
							{ n = G.UIT.T, config = {
								align = 'tr,',
								text = "Items",
								scale = _scale,
								colour = G.C.UI.TEXT_LIGHT,
								w = _width2,
								shadow = true,
							}},
							{ n = G.UIT.C, config = { align = 'cr' }, nodes = {
								create_toggle{ label = "Cosma", align = 'cl', ref_table = MadcapConfig, ref_value = 'item_cosma', w = _width1, scale = _box, label_scale = _label, shadow = true },
								create_toggle{ label = "Spatia", align = 'cl', ref_table = MadcapConfig, ref_value = 'item_spatia', w = _width1, scale = _box, label_scale = _label, shadow = true },
								create_toggle{ label = "Potentia", align = 'cl', ref_table = MadcapConfig, ref_value = 'item_potentia', w = _width1, scale = _box, label_scale = _label, shadow = true },
							}}
						},
					},
					{
						n = G.UIT.C,
						config = { align = 'tr', colour = darken(G.C.BLUE, 0.5), w = _total_width, padding = 0.05, },
						nodes = {
							{ n = G.UIT.T, config = {
								align = 'tr,',
								text = "Rarities",
								scale = _scale,
								colour = G.C.UI.TEXT_LIGHT,
								w = _width2,
								shadow = true,
							}},
							{ n = G.UIT.C, config = { align = 'cr' }, nodes = {
								create_toggle{ label = "Unusual", align = 'cl',  ref_table = MadcapConfig, ref_value = 'rarity_unusual', w = _width1, scale = _box, label_scale = _label, shadow = true },
								create_toggle{ label = "Gimmick", align = 'cl',  ref_table = MadcapConfig, ref_value = 'rarity_gimmick', w = _width1, scale = _box, label_scale = _label, shadow = true },
								create_toggle{ label = "Chaotic", align = 'cl',  ref_table = MadcapConfig, ref_value = 'rarity_chaotic', w = _width1, scale = _box, label_scale = _label, shadow = true },
							}}
						},
					},
				}
			},
			{
				n = G.UIT.R,
				config = { align = 'tr', w = _total_width*3, colour = darken(G.C.GREEN, 0.5) },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = 'tr', colour = darken(G.C.RED, 0.5), w = _total_width, padding = 0.05, },
						nodes = {
							{ n = G.UIT.T, config = {
								align = 'tr,',
								text = "Ranks",
								scale = _scale,
								colour = G.C.UI.TEXT_LIGHT,
								w = _width2,
								shadow = true,
							}},
							{ n = G.UIT.C, config = { align = 'cr' }, nodes = {
								create_toggle{ label = "Static", align = 'cl',  ref_table = MadcapConfig, ref_value = 'ranks_static', w = _width1, scale = _box, label_scale = _label, shadow = true },
								create_toggle{ label = "Dynamic", align = 'cl',  ref_table = MadcapConfig, ref_value = 'ranks_dynamic', w = _width1, scale = _box, label_scale = _label, shadow = true },
								create_toggle{ label = "High", align = 'cl', ref_table = MadcapConfig, ref_value = 'ranks_high', w = _width1, scale = _box, label_scale = _label, shadow = true },
								create_toggle{ label = "UNO", align = 'cl', ref_table = MadcapConfig, ref_value = 'ranks_uno',w = _width1, scale = _box, label_scale = _label, shadow = true },
							}}
						},
					},
					{
						n = G.UIT.C,
						config = { align = 'tr', colour = darken(G.C.BLUE, 0.5), w = _total_width, padding = 0.05, },
						nodes = {
							{ n = G.UIT.T, config = {
								align = 'tr,',
								text = "Suits",
								scale = _scale,
								colour = G.C.UI.TEXT_LIGHT,
								w = _width2,
								shadow = true,
							}},
							{ n = G.UIT.C, config = { align = 'cr' }, nodes = {
								create_toggle{ label = "Parallel",  align = 'cl', ref_table = MadcapConfig, ref_value = 'suits_parallel', w = _width1, scale = _box, label_scale = _label, shadow = true },
								create_toggle{ label = "Chaotic",  align = 'cl', ref_table = MadcapConfig, ref_value = 'suits_chaotic', w = _width1, scale = _box, label_scale = _label, shadow = true },
							}}
						},
					},
					{
						n = G.UIT.C,
						config = { align = 'tr', colour = darken(G.C.RED, 0.5), w = _total_width, padding = 0.05, },
						nodes = {
							{ n = G.UIT.T, config = {
								align = 'tr,',
								text = "Modifiers",
								scale = _scale,
								colour = G.C.UI.TEXT_LIGHT,
								w = _width2,
								shadow = true,
							}},
							{ n = G.UIT.C, config = { align = 'cr' }, nodes = {
								create_toggle{ label = "Enhancements", align = 'cl', ref_table = MadcapConfig, ref_value = 'enhancements', w = _width1, scale = _box, label_scale = _label*0.6, shadow = true },
								create_toggle{ label = "Editions",  align = 'cl', ref_table = MadcapConfig, ref_value = 'editions', w = _width1, scale = _box, label_scale = _label, shadow = true },
								create_toggle{ label = "Seals",  align = 'cl', ref_table = MadcapConfig, ref_value = 'seals', w = _width1, scale = _box, label_scale = _label, shadow = true },
							}}
						},
					},
				}
			},
			{
				n = G.UIT.R,
				config = { align = 'tr', w = _total_width*3, colour = darken(G.C.GREEN, 0.5) },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = 'tr', colour = darken(G.C.BLUE, 0.5), w = _total_width, padding = 0.05, },
						nodes = {
							{ n = G.UIT.T, config = {
								align = 'tr,',
								text = "Collectibles",
								scale = _scale*0.8,
								colour = G.C.UI.TEXT_LIGHT,
								w = _width2,
								shadow = true,
							}},
							{ n = G.UIT.C, config = { align = 'cr' }, nodes = {
								create_toggle{ label = "Tags", align = 'cl', ref_table = MadcapConfig, ref_value = 'tags',w = _width1, scale = _box, label_scale = _label, shadow = true },
								create_toggle{ label = "Boosters", align = 'cl',  ref_table = MadcapConfig, ref_value = 'boosters', w = _width1, scale = _box, label_scale = _label, shadow = true },
								create_toggle{ label = "Vouchers", align = 'cl', ref_table = MadcapConfig, ref_value = 'vouchers', w = _width1, scale = _box, label_scale = _label, shadow = true },
							}}
						},
					},
					{
						n = G.UIT.C,
						config = { align = 'tr', colour = darken(G.C.RED, 0.5), w = _total_width, padding = 0.05, },
						nodes = {
							{ n = G.UIT.T, config = {
								align = 'tr,',
								text = "Gameplay",
								scale = _scale*0.8,
								colour = G.C.UI.TEXT_LIGHT,
								w = _width2,
								shadow = true,
							}},
							{ n = G.UIT.C, config = { align = 'cr' }, nodes = {
								create_toggle{ label = "Blinds", align = 'cl', ref_table = MadcapConfig, ref_value = 'blinds',w = _width1, scale = _box, label_scale = _label, shadow = true },
								create_toggle{ label = "Decks", align = 'cl',  ref_table = MadcapConfig, ref_value = 'decks', w = _width1, scale = _box, label_scale = _label, shadow = true },
								create_toggle{ label = "Stakes", align = 'cl', ref_table = MadcapConfig, ref_value = 'stakes', w = _width1, scale = _box, label_scale = _label, shadow = true },
							}}
						},
					},
					{
						n = G.UIT.C,
						config = { align = 'tr', colour = darken(G.C.BLUE, 0.5), w = _total_width, padding = 0.05, },
						nodes = {
							{ n = G.UIT.T, config = {
								align = 'tr,',
								text = "Misc",
								scale = _scale*0.8,
								colour = G.C.UI.TEXT_LIGHT,
								w = _width2,
								shadow = true,
							}},
							{ n = G.UIT.C, config = { align = 'cr' }, nodes = misc_nodes or {} }
						},
					},
				}
			}
		}
	}

	return content
end

Madcap.Funcs.remove_formatting = function(string_in)
    return string.gsub(string_in, "{.-}", "")
end

Madcap.Funcs.full_ui_add = function(nodes, key, scale)
    local m = G.localization.descriptions["DescriptionDummy"][key]
    if not m then assert("You forgot the localization!") end
    local l = {
        {
            n = G.UIT.R,
            nodes = {
                { n = G.UIT.T, config = { text = m.name, colour = G.C.UI.TEXT_LIGHT, scale = scale*1.2 }},
            }
        }
    }
    if m.text and false then
        for i, tx in ipairs(m.text) do
            table.insert(l,
                {
                    n = G.UIT.R,
                    nodes = {{ n = G.UIT.T, config = { text = AKYRS.remove_formatting(tx), colour = G.C.UI.TEXT_LIGHT, scale = scale }},}
                }
            )
        end
    end

    local x = {
        n = G.UIT.C,
        config = { align = "lm", padding = 0.1 },
        nodes = {{ n = G.UIT.R, config = {}, nodes = l },}
    }
    table.insert(nodes, x)
end

Madcap.Funcs.generate_multiblind_ui = function(blinds, config)
	print('multiblind ui time!!!')
    if not blinds then return end

    local tbl 		= config.table or {}
    local cache 	= config.cache or false
    local icon_size = config.icon_size or false
    --local atlas, pos, mod_prefix = AKYRS.blind_icons_data(blinds)

    local full_ui 	= config.full_ui or false
    local fsz 		= config.font_size or false
    local dfctysz 	= config.text_size_for_full or false

    local info_queue = config.info_queue or {}

    --[[
    local sprite = nil
    if cache then
        AKYRS.icon_sprites[diff] = AKYRS.icon_sprites[diff] or Sprite(0,0,1*icon_size,1*icon_size, atlas, pos)
        sprite = AKYRS.icon_sprites[diff]
    else
        sprite = Sprite(0,0,1*icon_size,1*icon_size, atlas, pos)
    end
	]]

    -- local blind_txt_dmy = "dd_"..(mod_prefix and (mod_prefix.."_") or "")..diff.."_blind"
	MadLib.loop_func(blinds, function(v)
		if not G.P_BLINDS[v] then return end
		print('added blind')
		local bb = G.P_BLINDS[v]
		local temp_blind = AnimatedSprite(0,0,1,1, G.ANIMATION_ATLAS[bb.atlas or 'blind_chips'], bb.pos)
		temp_blind:define_draw_steps({ {shader = 'dissolve', shadow_height = 0.05}, {shader = 'dissolve'} })

		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = (function()
			G.CONTROLLER:snap_to{node = temp_blind}
				return true
			end)
		}))

		temp_blind.scale = 1
		temp_blind.float = true
		temp_blind.states.hover.can = true
		temp_blind.states.drag.can = false
		temp_blind.states.collide.can = true
		temp_blind.config = {blind = bb, force_focus = true}

		temp_blind.hover = function()
			if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
				if not temp_blind.hovering and temp_blind.states.visible then
					temp_blind.hovering = true
					temp_blind.hover_tilt = 3
					temp_blind:juice_up(0.05, 0.02)
					play_sound('chips1', math.random()*0.1 + 0.95, 0.12)
					temp_blind.config.h_popup = create_UIBox_blind_popup(bb, true)
					temp_blind.config.h_popup_config = { align = 'cl', offset = { x=-0.1, y=0 }, parent = temp_blind}
					Node.hover(temp_blind)
					if temp_blind.children.alert then
					temp_blind.children.alert:remove()
					temp_blind.children.alert = nil
					temp_blind.config.blind.alerted = true
					end
				end
			end
		end

		temp_blind.stop_hover = function()
			temp_blind.hovering = false
			Node.stop_hover(temp_blind)
			temp_blind.hover_tilt = 0
		end

		tbl[#tbl+1] = {
			n = full_ui and G.UIT.R or G.UIT.C, config = { r = 0.2, align = "cm", colour = G.C.DYN_UI.BOSS_DARK, can_collide = true, hover = true },
			nodes = { {
				n=G.UIT.O, config= { object = temp_blind, focus_with_object = true }}
			}
		}
	end)

    if full_ui then
        Madcap.Funcs.full_ui_add(tbl[#tbl].nodes, blind_txt_dmy, dfctysz)
        --info_queue[#info_queue+1] = AKYRS.DescriptionDummies[blind_txt_dmy]
    end
end

Madcap.Funcs.add_blind_info = function(blind, ability_text_table, args)
    args = args or {}

    local icon_size 	= args.icon_size or 0.8
    local font_size		= args.font_size or 0.5
    local dfont_size	= args.dfont_size or 0.5
    local border_size	= args.border_size or 1
    local cached_icons	= args.cache_icons or false
    local is_row		= args.row or false
    local full_ui		= args.full_ui or false

    local ret = {}

    local data = {
		table 				= ret,
		cache 				= cache,
		icon_size 			= icon_size,
		full_ui 			= full_ui,
		font_size 			= font_size,
		text_size_for_full 	= dfont_size,
		info_queue 			= info_queue
	}

    --print(inspect(G.GAME.blind))

	if blind and blind.debuff then
        if blind.debuff.rgmc_blind_multiblind then
			print('bonus blind ID is ' .. (G.GAME.rgmc_bonus_blind or 'NIL'))
			if G.GAME.rgmc_bonus_blind then
				Madcap.Funcs.generate_multiblind_ui({ G.GAME.rgmc_bonus_blind }, data)
            end
        end
    end

    return ret
end

function MadLib.get_blind_text(key, collection)
	local active = (G.GAME.blind and not G.GAME.blind.disabled)
    if (key == "bl_rgmc_final_gauntlet") and (active and not collection) then
        return { "??? / ???", "Bosses Defeated"}
    else
        return {nil,nil}
    end
end

-- HOOK: Set up multi-stage Blind ref
local hud_blind_ref = create_UIBox_HUD_blind
function create_UIBox_HUD_blind()
	local ret = hud_blind_ref()

    local blind_setup = G.P_BLINDS[G.GAME.round_resets.blind_choices[G.GAME.blind_on_deck]]
    local shit = Madcap.Funcs.add_blind_info(blind_setup, nil, {
		font_size = 0.35,
		border_size = 0.3,
		dfont_size = 0.3,
		cached_icons = true,
		row = true
	})

    local bl = G.P_BLINDS[G.GAME.round_resets.blind_choices[G.GAME.blind_on_deck]]
    local elem = ret.nodes[2].nodes[2].nodes[2]

    --[[
    if bl and elem then
        local blindloc = MadLib.get_blind_text(G.GAME.round_resets.blind_choices[G.GAME.blind_on_deck] or G.P_BLINDS['bl_small'])
        local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)
        if blindloc[1] then elem.nodes[1].nodes[1].config.text = blindloc[1] end
        if blindloc[2] then elem.nodes[2].nodes = {
            { n = G.UIT.O, config = { w = 0.5, h = 0.5, colour = G.C.BLUE, object = stake_sprite, hover = true, can_collide = false } },
            { n = G.UIT.B, config = { h = 0.1, w = 0.1 } },
            { n = G.UIT.T, config = { text = blindloc[2], scale = 0.4, colour = G.C.RED, id = 'HUD_blind_count', shadow = true } }
        }
        end
    end
	]]
    if #shit > 0 then
        G.rgmc_bonus_blind_icons = true
        table.insert(ret.nodes[2].nodes, 2, {
            n = G.UIT.R, config = { align = "cm", id = "rgmc_blind_info"}, nodes = shit
        })
        table.insert(ret.nodes[2].nodes, 2, { n = G.UIT.B, config = { h = 0.1, w = 0.1 } })
    else
        G.rgmc_bonus_blind_icons = nil
    end

	return ret
end

function MadLib.remove_all(t, predicate)
    for i=#t, 1, -1 do
        local v=t[i]
        table.remove(t, i)
        if v and predicate(v) and v.children then
            MadLib.remove_all(v.children, predicate)
        end
        if v and predicate(v) then v:remove() end
        v = nil
    end
    for _, v in pairs(t) do
        if predicate(v) then
            if v.children then
                MadLib.remove_all(v.children, predicate)
            end
            v:remove()
            v = nil
        end
    end
end

function Madcap.Funcs.recalculate_blind_ui()
    if G.HUD_blind then
        Madcap.do_not_remove_blind = true
        local conf = (G.HUD_blind.config)
        G.HUD_blind:remove()
        G.HUD_blind = UIBox{
            definition = create_UIBox_HUD_blind(),
            config = conf
        }

        --[[
        MadLib.remove_all(G.HUD_blind.children,function(v) print("A") return v and v.config and (v.config.object ~= G.GAME.blind) end)
        G.HUD_blind.UIRoot:remove()
        G.HUD_blind.definition = create_UIBox_HUD_blind()
        G.HUD_blind:set_parent_child(G.HUD_blind.definition, nil)]]

        Madcap.do_not_remove_blind = nil
        G.HUD_blind:recalculate()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0,
          func = function()
            if G.SHOP_SIGN then
                G.SHOP_SIGN.alignment.offset.y = -15
            end
            return true
          end
        }))
        G.GAME.rgmc_ui_should_recalculate = nil
    end
end

function rgmc_get_blind_icon(bb)
	local temp_blind = AnimatedSprite(0,0,1,1, G.ANIMATION_ATLAS[bb.atlas or 'blind_chips'], bb.pos)
	temp_blind:define_draw_steps({
		{shader = 'dissolve', shadow_height = 0.05},
		{shader = 'dissolve'}
	})

	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = (function()
		G.CONTROLLER:snap_to{node = temp_blind}
			return true
		end)
	}))

	temp_blind.scale = 1
	temp_blind.float = true
	temp_blind.states.hover.can = true
	temp_blind.states.drag.can = false
	temp_blind.states.collide.can = true
	temp_blind.config = {blind = bb, force_focus = true}

	temp_blind.hover = function()
		if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
			if not temp_blind.hovering and temp_blind.states.visible then
				temp_blind.hovering = true
				temp_blind.hover_tilt = 3
				temp_blind:juice_up(0.05, 0.02)
				play_sound('chips1', math.random()*0.1 + 0.55, 0.12)
				temp_blind.config.h_popup = create_UIBox_blind_popup(bb, true)
				temp_blind.config.h_popup_config ={align = 'cl', offset = {x=-0.1,y=0},parent = temp_blind}
				Node.hover(temp_blind)
				if temp_blind.children.alert then
				temp_blind.children.alert:remove()
				temp_blind.children.alert = nil
				temp_blind.config.blind.alerted = true
				end
			end
		end
	end

	temp_blind.stop_hover = function()
		temp_blind.hovering = false
		Node.stop_hover(temp_blind)
		temp_blind.hover_tilt = 0
	end

	return temp_blind
end

local edit_uibox_ref = MadLib.edit_uibox_contents
function MadLib.edit_uibox_contents(contents, scale)
	contents = edit_uibox_ref(contents, scale)
	for i=1,2 do
		contents.buttons[1].nodes[i].config.minw = contents.buttons[1].nodes[i].config.minw * 0.75
		contents.buttons[1].nodes[i].config.minh = contents.buttons[1].nodes[i].config.minh * 0.6
	end
	--contents.dollars_chips = nil
	
	return contents
end

local uibox_ref = create_UIBox_HUD
function create_UIBox_HUD()
	local orig = uibox_ref()
		--if not Entropy.DeckOrSleeve("doc") then return orig end
    return orig
end