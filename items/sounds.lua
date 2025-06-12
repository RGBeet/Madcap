-- no vars here, kind of not needed?

local ext, list = 'ogg', {}

local sounds = {
    key_path_simple('e_iridescent',ext),
    key_path_simple('e_infernal',ext),
    key_path_simple('e_chrome',ext),
    key_path_simple('e_disco',ext),
    key_path('e_phasing','e_disco.ogg'),
    key_path_simple('contagion',ext)
}

for i=1, #sounds do
    sounds[i].object_type = "Sound"
    list[#list+1] = sounds[i]
end

return {
    name = "Sounds",
    init = function() print("Sounds!") end,
    items = list
}
