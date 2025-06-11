-- finity mod compat

-- Add Showdown rarities to table
RGMC.rarities['finity_showdown'] = {
	name = 'Showdown',
	value = 5.5,
	special = true,
}

RGMC.rarity_keys['Showdown'] = 'finity_showdown'

RGMC.C.showdown = HEX('690a0f')
G.C.RGMC_SHOWDOWN = RGMC.C.showdown

tell('Finity loaded!')
