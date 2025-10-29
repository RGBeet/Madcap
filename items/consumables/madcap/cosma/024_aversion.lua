if not (SMODS.Mods["Cryptid"] or {}).can_load then
	local set_spritesref = Card.set_sprites
	function Card:set_sprites(_center, _front)
		set_spritesref(self, _center, _front)
		if _center and _center.soul_pos and _center.soul_pos.extra then
			self.children.floating_sprite2 = Sprite(
				self.T.x,
				self.T.y,
				self.T.w,
				self.T.h,
				G.ASSET_ATLAS[_center.atlas or _center.set],
				_center.soul_pos.extra
			)
			self.children.floating_sprite2.role.draw_major = self
			self.children.floating_sprite2.states.hover.can = false
			self.children.floating_sprite2.states.click.can = false
		end
	end
	SMODS.DrawStep({
		key = "floating_sprite2",
		order = 59,
		func = function(self)
			if
				self.config.center.soul_pos
				and self.config.center.soul_pos.extra
				and (self.config.center.discovered or self.bypass_discovery_center)
			then
				local scale_mod = 0.07 -- + 0.02*math.cos(1.8*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
				local rotate_mod = 0 --0.05*math.cos(1.219*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2
				if self.children.floating_sprite2 then
					self.children.floating_sprite2:draw_shader(
						"dissolve",
						0,
						nil,
						nil,
						self.children.center,
						scale_mod,
						rotate_mod,
						nil,
						0.1 --[[ + 0.03*math.cos(1.8*G.TIMERS.REAL)--]],
						nil,
						0.6
					)
					self.children.floating_sprite2:draw_shader(
						"dissolve",
						nil,
						nil,
						nil,
						self.children.center,
						scale_mod,
						rotate_mod
					)
				else
					local center = self.config.center
					if _center and _center.soul_pos and _center.soul_pos.extra then
						self.children.floating_sprite2 = Sprite(
							self.T.x,
							self.T.y,
							self.T.w,
							self.T.h,
							G.ASSET_ATLAS[_center.atlas or _center.set],
							_center.soul_pos.extra
						)
						self.children.floating_sprite2.role.draw_major = self
						self.children.floating_sprite2.states.hover.can = false
						self.children.floating_sprite2.states.click.can = false
					end
				end
			end
		end,
		conditions = { vortex = false, facing = "front" },
	})
	SMODS.draw_ignore_keys.floating_sprite2 = true
end

return {
    categories = {
        'Cosma Tarots',
        'Unusual'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "aversion",
        atlas   = "cosma",
        pos 	   = { x = 4, y = 2 },
        soul_pos   = { x = 6, y = 2, extra = { x = 5, y = 2 } },
        config = { immutable = { jokers = 1 } },
        can_use 	= function(self, card)
            return G.jokers
        end,
        hidden = true, -- Hard as hell to get
        use 	= function(self, card, area, copier)
            for i=1,card.ability.immutable.jokers do
                -- Create a Chaotic Joker
                MadLib.simple_event(function()
                    play_sound("timpani")
                    local card = create_card("Joker", G.jokers, nil, "rgmc_chaotic", nil, nil, nil, "rgmc_aversion")
                    --check_for_unlock { type = 'spawn_legendary' }

                    card:add_to_deck()
                    G.jokers:emplace(card)
                    card:juice_up(0.3, 0.5)
                    return true
                end, 0.4, 'after')
            end
        end
    }
}
