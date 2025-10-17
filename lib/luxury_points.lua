-- convert cash to lp
function cash_to_lp(m)
	return math.ceil(m/2)
end

function Card:calc_lp()
	return cash_to_lp(self.cost)
end

function ease_lp(mod, instant)
    local function _mod(mod)
        local dollar_UI = G.HUD:get_UIE_by_ID('luxury_text_UI')
        mod = mod or 0
        local text = '+'..localize('$')
        local col = G.C.RGMC_LUXURY
        if mod < 0 then
            text = '-'..localize('$')
            col = G.C.RED
        else
          --inc_career_stat('c_dollars_earned', mod)
        end
        --Ease from current chips to the new number of chips
        G.GAME.rgmc_luxury_pts = G.GAME.rgmc_luxury_pts + mod
        dollar_UI.config.object:update()
        G.HUD:recalculate()
        --Popup text next to the chips in UI showing number of chips gained/lost
        attention_text({
          text = text..tostring(math.abs(mod)),
          scale = 0.8,
          hold = 0.7,
          cover = dollar_UI.parent,
          cover_colour = col,
          align = 'cm',
          })
        --Play a chip sound
        if mod > 0 then
          play_sound('rgmc_kaching')
        end
    end
    if instant then
        _mod(mod)
    else
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            _mod(mod)
            return true
        end
        }))
    end
end

-- different one for luxury points
G.FUNCS.can_buy_luxury = function(e)
	local lp_cost = cash_to_lp(e.config.ref_table.cost)
    if lp_cost > G.GAME.rgmc_luxury_pts and lp_cost > 0 then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.DARK_EDITION
        e.config.button = 'buy_from_shop'
    end
    if e.config.ref_parent and e.config.rref_parent.children.buy_and_use then
      if e.config.ref_parent.children.buy_and_use.states.visible then
        e.UIBox.alignment.offset.y = -0.6
      else
        e.UIBox.alignment.offset.y = 0
      end
    end
end

function Madcap.Funcs.uses_lp(card)
    return card.ability.force_lp
end
