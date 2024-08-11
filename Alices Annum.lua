--- STEAMODDED HEADER
--- MOD_NAME: Alices Annum
--- MOD_ID: Annum
--- MOD_AUTHOR: [Alice_Reverie, nhhvhy]
--- MOD_DESCRIPTION: Jokers made for the lulz, by the lulz
--- PREFIX: annum_
-------------------------------------

-- local debugSay = sendDebugMessage()
local mod_path = ''..SMODS.current_mod.path
local mod_prefix = "annum_"

-- Configs -- 
local alice_config = {["Alice Jokers"] = true}
local read_config = SMODS.load_file("alice_config.lua")
if read_config then
    alice_config = read_config()
end

-- File loading based on Relic-Jokers
local files = NFS.getDirectoryItems(mod_path.."Chunks")
for _, file in ipairs(files) do
    print("Loading file "..file)
    local f, err = NFS.load(mod_path.."Chunks/"..file)
    if err then print("Error loading file: "..err) else
      local curr_obj = f()
      if true then
          if curr_obj.init then curr_obj:init() end
         -- for _, item in ipairs(curr_obj.stuffToAdd) do
         --     if SMODS[item.object_type] then
		--		if item.object_type == "Joker" and not debugMode then
		--			item.discovered = false
		--		end
         --       SMODS[item.object_type](item)
         --     else
         --       print("Error loading item "..item.key.." of unknown type "..item.object_type)
         --     end
        --  end
      end
    end
end

local aalice_jokers = SMODS.load_file(mod_path.."Files".."Alice Jokers")
sendDebugMessage(tostring(annum_jokers))

local alice_con =
	SMODS.ConsumableType {
		key = 'alice_key_con_fossil',
		primary_colour = HEX('D17000'),
		secondary_colour = HEX('D1B492'),
		loc_txt =
			{
			name = 'Fossil',
			collection = 'Fossil Cards'
		},
		collection_rows = {6,2}
	}


	

	
-- Atlas List --

SMODS.Atlas({
    key = "Alice Atlas",
    path = "Alice Atlas.png",
    px = 71,
    py = 95
}):register()
