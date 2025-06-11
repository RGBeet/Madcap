-- cryptid mod compat

-- Add Epic, Exotic, Candy, and Cursed rarities to table
RGMC.rarities['cry_exotic'] = {
	name = 'Exotic',
	value = 6,
	special = true,
}

RGMC.rarities['cry_epic'] = {
	name = 'Exotic',
	value = 3.75,
	special = true,
}

RGMC.rarities['cry_candy'] = {
	name = 'Candy',
	value = 2.5,
	special = true,
}

RGMC.rarities['cry_cursed'] = {
	name = 'Cursed',
	value = 0.5,
	special = true,
}

tell('Cryptid loaded!')
