G.STATES.RGMC_LUXURY_SHOPPE = 241
G.STATES.RGMC_IMPOUND_SHOP  = 242

local get_shop_state_ref = MadLib.get_shop_state
function MadLib.get_shop_state()
    local ret = get_shop_state_ref()
    return ret or G.STATE == G.STATES.RGMC_LUXURY_SHOPPE
end

local get_hide_hand_area_ref = MadLib.get_hide_hand_area
function MadLib.get_hide_hand_area()
    local ret = get_hide_hand_area_ref()
    return ret 
        or G.STATE == G.STATES.RGMC_LUXURY_SHOPPE
        or G.STATE == G.STATES.RGMC_IMPOUND_SHOP
end

local get_card_setting_ability_ref = MadLib.get_card_setting_ability
function MadLib.get_card_setting_ability()
    local ret = get_card_setting_ability_ref()
    return ret 
        and G.STATE ~= G.STATES.RGMC_LUXURY_SHOPPE
        and G.STATE ~= G.STATES.RGMC_IMPOUND_SHOP
end

function Madcap.Funcs.get_next_round_button()
    local _text     = { localize('b_next_round_1'), localize('b_next_round_2') }
    local _color    = G.C.RED
    local _func     = 'toggle_shop'
    local _tooltip  = nil

    local impound_shop_enabled = true
    local luxury_shoppe_enabled = true
    
    if Madcap.Funcs.luxury_shoppe_enabled() and not (G.GAME.shops_visited and G.GAME.shops_visited['luxury']) then
        _func     = 'goto_luxury_shoppe'
        _color   = G.C.BLUE
        _text     = { localize('b_luxury_shoppe_1'), localize('b_luxury_shoppe_2') }
        _tooltip  = { title = "Luxury Shoppe", text = {"Appears when", "5+ LP"} }
    elseif Madcap.Funcs.impound_shop_enabled() and not (G.GAME.shops_visited and G.GAME.shops_visited['impound']) then
        _func     = 'goto_impound_shop'
        _color   = G.C.PURPLE
        _text     = { localize('b_impound_shop_1'), localize('b_impound_shop_2') }
        _tooltip  = { title = "Impound Center", text = {"Buy back your", "impounded cards"} }
    end

    return {n=G.UIT.R,config={id = 'next_round_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = _color, one_press = true, button = _func, hover = true, shadow = true, tooltip = _tooltip }, nodes = {
        {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                {n=G.UIT.T, config={text = _text[1], scale = 0.4, colour = G.C.WHITE, shadow = true}}
            }},
            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                {n=G.UIT.T, config={text = _text[2], scale = 0.4, colour = G.C.WHITE, shadow = true}}
            }}   
        }},              
    }}
end

local hide_hand_ui_ref = MadLib.hide_hand_ui
function MadLib.hide_hand_ui()
    return hide_hand_ui_ref() 
        or state == G.STATES.RGMC_LUXURY_SHOPPE
        or state == G.STATES.RGMC_IMPOUND_SHOP
end

function Madcap.Funcs.edit_shop_ui_t1(card)
    local bg_colour   = darken(G.C.BLACK, 0.2)
    local fg_colour   = lighten(G.C.BLACK, 0.1)
    local currency    = localize('$')
    local value       = 'cost'
    local colours     = { G.C.MONEY }

    
    if Madcap.Funcs.uses_lp(card) then
      currency = localize('£')
      bg_colour   = lighten(G.C.GOLD, 0.1)
      fg_colour   = darken(G.C.RED, 0.7)
      colours[1] = G.C.RGMC_LUXURY
      value = 'lp'
    end

    card.lp = cash_to_lp(card.cost)

    return { n=G.UIT.ROOT, config = {minw = 0.6, align = 'tm', colour = bg_colour, shadow = true, r = 0.05, padding = 0.05, minh = 1}, nodes={
        {n=G.UIT.R, config={align = "cm", colour = fg_colour, r = 0.1, minw = 1, minh = 0.55, emboss = 0.05, padding = 0.03}, nodes={
            {n=G.UIT.O, config={object = DynaText({string = {{prefix = currency, ref_table = card, ref_value = value }}, colours = colours, shadow = true, silent = true, bump = true, pop_in = 0, scale = 0.5})}},
        }}
    }}
end

function Madcap.Funcs.edit_shop_ui_t2(card)
    local is_luxury   = Madcap.Funcs.uses_lp(card)
    local what_do     = nil
    local colour      = G.C.GREEN
    local check       = nil
    local words       = localize('b_buy')

    if card.ability.set == 'Voucher' then
        words   = localize('b_redeem')
        check   = 'can_redeem'
        what_do = 'redeem_from_shop'
    elseif card.ability.set == 'Booster' then
        words   = localize('b_open')
        check   = 'can_open'
        what_do = 'open_booster'
    else
        check   = 'can_buy'
        what_do = 'buy_from_shop'
    end

    if is_luxury then 
        check = check .. '_luxury'
    end

    return {n=G.UIT.ROOT, config = {ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = colour, shadow = true, r = 0.08, minh = 0.94, func = check, one_press = true, button = what_do, hover = true}, nodes={
        {n=G.UIT.T, config={text = words, colour = G.C.WHITE, scale = 0.4}}
    }}
end

function Madcap.Funcs.edit_shop_ui_t3(card)
    local what_do     = 'buy_from_shop'
    local check       = 'can_buy_and_use'
    
    if is_luxury then 
        check = check .. '_luxury'
    end
    
    return {n=G.UIT.ROOT, config = {id = 'buy_and_use', ref_table = card, minh = 1.1, padding = 0.1, align = 'cr', colour = G.C.RED, shadow = true, r = 0.08, minw = 1.1, func = check, one_press = true, button = what_do, hover = true, focus_args = {type = 'none'}}, nodes={
        {n=G.UIT.B, config = {w=0.1,h=0.6}},
        {n=G.UIT.C, config = {align = 'cm'}, nodes={
            {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
                {n=G.UIT.T, config={text = localize('b_buy'),colour = G.C.WHITE, scale = 0.5}}
            }},
            {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
                {n=G.UIT.T, config={text = localize('b_and_use'),colour = G.C.WHITE, scale = 0.3}}
            }},
        }} 
    }}
end

function Madcap.Funcs.handle_booster_cost(card)
    local is_luxury   = Madcap.Funcs.uses_lp(card)
    if MadLib.compare_numbers(card.cost, 0) < 1 then
        delay(0.2)
    elseif is_luxury then
        MadLib.event({trigger = 'after', delay = 0.2, func = function()
            card:juice_up()
            return true end 
        })
        ease_lp(MadLib.get_negative(card:calc_lp()))
    else
        MadLib.event({trigger = 'after', delay = 0.2, func = function()
            inc_career_stat('c_shop_dollars_spent', card.cost)
            card:juice_up()
            return true end 
        })
        ease_dollars(MadLib.get_negative(card.cost))
    end
end

function Madcap.Funcs.handle_voucher_cost(card)
    local is_luxury   = Madcap.Funcs.uses_lp(card)
    if MadLib.compare_numbers(card.cost, 0) < 1 then
        delay(0.2)
    elseif is_luxury then
        ease_lp(MadLib.get_negative(card:calc_lp()))
    else
        ease_dollars(MadLib.get_negative(card.cost))
    end
end

-- Continue updating at the right part.
local update_check_state_ref = MadLib.update_check_state
function MadLib.update_check_state(g,dt)
    update_check_state_ref(g)
    if g.state == g.STATES.RGMC_LUXURY_SHOPPE then
        g:update_luxury_shoppe(dt)
    end
    if g.state == g.STATES.RGMC_IMPOUND_SHOP then
        g:update_impound_shop(dt)
    end
end

