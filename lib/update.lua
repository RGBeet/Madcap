local upd = Game.update
local enable_animations = true

local function update_sprite_delta(spr,dt)
	local anim = AnimatedJokers[spr]
	if
		anim
		and G.P_CENTERS[spr]
	then
		if anim.delta_time > 0.1 then
			local obj = G.P_CENTERS[spr]
			anim.delta_time = 0
			if
				obj.pos.x 		== anim.end_x
				and obj.pos.y 	== anim.end_y
			then
				obj.pos.x = 0
				obj.pos.y = 0
			elseif obj.pos.x+1 < anim.width then
				obj.pos.x = obj.pos.x + 1
				--print("X")
			elseif obj.pos.y < anim.height then
				obj.pos.x = 0
				obj.pos.y = obj.pos.y + 1
				--print("Y")
			end
		else
			anim.delta_time = anim.delta_time + dt * anim.delta_speed
		end
		if anim.func then
			anim.func(anim)
		end
	end
	return anim
end

rgmc_spam_dt = 0
Madcap.Rainbow = {G.C.RED, G.C.ORANGE, G.C.GOLD, G.C.GREEN, G.C.BLUE, G.C.PURPLE}

-- Animated Colors
Madcap.C = {
	MAYHEM    	= { colours = { HEX('75188F'), HEX('3A188F') } },
	UNUSUAL   	= { colours = { HEX('9C87F6'), HEX('F6879B') } },
	CHAOTIC   	= { colours = { HEX('F25B3A'), HEX('3AF2BF') } },
	ECHIPS   	= { colours = { HEX('000994'), HEX('9A00FF') } },
	EMULT     	= { colours = { HEX('A41818'), HEX('9A00FF') } },
	XSCORE		= { colours = { HEX('8867A5'), HEX('9A00FF') } },
	ESCORE    	= { colours = { HEX('9A00FF'), HEX('00FF9A') } },
	GIMMICK   	= { colours = { HEX('FF8B60'), HEX('9494FF') } },
	EVIL      	= { colours = { HEX('D53600'), HEX('700E01') } },
	LUXURY    	= { colours = { HEX('D3AC2C'), HEX('B16C04') } },
	LIGHT     	= { colours = { HEX('FF6361'), HEX('FFD380') } },
	DARK      	= { colours = { HEX('BC5090'), HEX('00202E') } },
	SINISTER  	= { colours = { HEX('78322A'), HEX('677F93') } },
	BISMUTH  	= { colours = { G.C.RED, G.C.GOLD, G.C.GREEN, G.C.BLUE, G.C.PURPLE }, cycle = 0.5 },
}
MadLib.loop_table(Madcap.C, function(k,v)
	SMODS.Gradient{
		key 			= k,
		colours 		= v.colours,
		cycle 			= v.cycle and (1 / v.cycle) or 1,
		interpolation 	= v.interpolation or 'linear'
	}
end)

function Game:update(dt)
	upd(self, dt)

	if enable_animations then
		for k,v in pairs(AnimatedJokers) do
			update_sprite_delta(k,dt)
		end
	end
	--[[
		local anim_timer = self.TIMERS.REAL * 1.5
		local p = 0.5 * (math.sin(anim_timer) + 1)

		MadLib.loop_table(Madcap.C, function(k,c)
			if not G.C["RGMC_" .. k]
				then G.C["RGMC_" .. k] = { 0, 0, 0, 0 }
			end
			for i = 1, 4 do
				G.C["RGMC_" .. k][i] = c[1][i] * p + c[2][i] * (1 - p)
			end
		end,true)
	]]
end

local function animate_deck_sprite(atlas_id,deck_id)
	for k, v in pairs(G.I.CARD) do
		if v.children.back and v.children.back.atlas.name == "rgmc_deck_lunacy" then
			v.children.back:set_sprite_pos(G.P_CENTERS['b_rgmc_lunacy'].pos or G.P_CENTERS['b_red'].pos)
		end
	end
end

AnimatedJokers = {
	j_rgmc_spam = {
		atlas 	= 'spam',
		width 	= 4,
		height 	= 5,
		end_x	= 3,
		end_y	= 4,
		delta_speed = 1,
		delta_time 	= 0
	},
	b_rgmc_lunacy = {
		atlas 	= 'rgmc_deck_lunacy',
		width 	= 8,
		height 	= 4,
		end_x	= 7,
		end_y	= 3,
		delta_speed = 1,
		delta_time 	= 0,
		func = function(self)
			animate_deck_sprite(self.atlas,self.name)
			return true
		end
	},
	c_rgmc_lunacy = {
		atlas 	= 'rgmc_mf_lunacy',
		width 	= 4,
		height 	= 8,
		end_x	= 3,
		end_y	= 7,
		delta_speed = 1,
		delta_time 	= 0
	}
}
