SMODS.Atlas({
    key = "marcPoke5",
    path = "Pokedex5.png",
    px = 71,
    py = 95
}):register()

-- Get mod path and load other files
mod_dir = ''..SMODS.current_mod.path
if (SMODS.Mods["Pokermon"] or {}).can_load then
    pokermon_config = SMODS.Mods["Pokermon"].config
end

--Load pokemon file
local pfiles = NFS.getDirectoryItems(mod_dir.."pokemon")

for _, file in ipairs(pfiles) do
  sendDebugMessage ("The file is: "..file)
  local pokemon, load_error = SMODS.load_file("pokemon/"..file)
  if load_error then
    sendDebugMessage ("The error is: "..load_error)
  else
    local curr_pokemon = pokemon()
    if curr_pokemon.init then curr_pokemon:init() end
    
    if curr_pokemon.list and #curr_pokemon.list > 0 then
      for i, item in ipairs(curr_pokemon.list) do
        if (pokermon_config.jokers_only and not item.joblacklist) or not pokermon_config.jokers_only  then
          item.discovered = true
          if not item.key then
            item.key = item.name
          end
          if not pokermon_config.no_evos and not item.custom_pool_func then
            item.in_pool = function(self)
              return pokemon_in_pool(self)
            end
          end
          if not item.config then
            item.config = {}
          end
          if item.ptype then
            if item.config and item.config.extra then
              item.config.extra.ptype = item.ptype
            elseif item.config then
              item.config.extra = {ptype = item.ptype}
            end
          end
          if item.item_req then
            if item.config and item.config.extra then
              item.config.extra.item_req = item.item_req
            elseif item.config then
              item.config.extra = {item_req = item.item_req}
            end
          end
          if item.evo_list then
            if item.config and item.config.extra then
              item.config.extra.evo_list = item.evo_list
            elseif item.config then
              item.config.extra = {item_req = item.evo_list}
            end
          end
          if pokermon_config.jokers_only and item.rarity == "poke_safari" then
            item.rarity = 3
          end
          item.discovered = not pokermon_config.pokemon_discovery 
          SMODS.Joker(item)
        end
      end
    end
  end
end