-- no vars here, kind of not needed?

local ext, list = 'ogg', {}

Madcap.Funcs.LoadSounds({
    MadLib.keypath_simple('bowling',ext),
    MadLib.keypath_simple('e_iridescent',ext),
    MadLib.keypath_simple('e_infernal',ext),
    MadLib.keypath_simple('e_chrome',ext),
    MadLib.keypath_simple('e_disco',ext),
    MadLib.key_path('e_phasing','e_disco.ogg'),
    MadLib.keypath_simple('contagion',ext),
    MadLib.keypath_simple('ominous',ext),
    MadLib.keypath_simple('pogladontasaurus',ext),
    MadLib.keypath_simple('spam_enter',ext),
    MadLib.keypath_simple('lobster_thermidor',ext),
    MadLib.keypath_simple('sauce',ext),
    MadLib.keypath_simple('spam1',ext),
    MadLib.keypath_simple('spam2',ext),
    MadLib.keypath_simple('spam3',ext),
    MadLib.keypath_simple('spam4',ext),
    MadLib.keypath_simple('spam_remove1',ext),
    MadLib.keypath_simple('spam_remove2',ext),
    MadLib.keypath_simple('spam_remove3',ext),
    MadLib.keypath_simple('mayhemize',ext),
    MadLib.keypath_simple('mayhem_t1',ext),
    MadLib.keypath_simple('mayhem_t2',ext),
    MadLib.keypath_simple('mayhem_t3',ext),
    MadLib.keypath_simple('mayhem_up',ext),
    MadLib.keypath_simple('door_close',ext),
    MadLib.keypath_simple('clown_fail',ext),
    MadLib.keypath_simple('clown_ow',ext),
    MadLib.keypath_simple('glass_save',ext),
    MadLib.keypath_simple('laser',ext),
    MadLib.keypath_simple('revert',ext),
    MadLib.keypath_simple('mug_yep',ext),
}, list)

return {
    name = "Sounds",
    init = function() print(tostring(#list) .."Sounds!") end,
    items = list
}
