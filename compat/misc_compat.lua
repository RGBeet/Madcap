-- pokermon mod compat?!

MadLib.RarityValues['poke_safari'] = {
	name 	= 	'Safari',
	value 		= 2.8, -- a little less than rare
	special 	= true,
}

MadLib.RarityValues['poke_mega'] = {
	name 		= 'Mega',
	value 		= 4.1, -- a little less than epic
	special 	= true,
}

MadLib.RarityValues['buf_spc'] = {
	name 		= 'Special',
	value 		= 0.1, -- frankly not sure where to put this
	special 	= true,
}

tell('Misc Compat loaded!')

return {
    name = "Misc Compatability",
    init = function() -- does the non item stuff ig?
		tell('Misc Compat')
    end,
    items = {}
}
