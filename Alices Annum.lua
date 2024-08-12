--- STEAMODDED HEADER
--- MOD_NAME: Alices Annum
--- MOD_ID: Annum
--- MOD_AUTHOR: [Alice_Reverie, nhhvhy]
--- MOD_DESCRIPTION: Jokers made for the lulz, by the lulz
--- BADGE_COLOUR: 03A100
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

-- Custom Raritys (Thank you cryptid)
Game:set_globals()
G.C.RARITY["alice_fossil_tier"] = HEX("D13900");
local ip = SMODS.insert_pool
function SMODS.insert_pool(pool, center, replace)
    if pool == nil then pool = {} end
    ip(pool, center, replace)
end
local get_badge_colourref = get_badge_colour
function get_badge_colour(key)
    local fromRef = get_badge_colourref(key)
    if key == 'alice_fossil_tier' then return G.C.RARITY["alice_fossil_tier"] end
    return fromRef
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

-- JOKER LOADING

local alice_jokers = SMODS.load_file(mod_path.."Chunks".."AliceJokers")

-- FOSSIL JOKERS 

--local alice_fossil_jokers = SMODS.load_file(mod_path..'Chunks'..'AliceFossilJokers')

-- CONSUMABLE DEFINE

local alice_cons =
	SMODS.ConsumableType {
		key = 'alice_fossil_cards',
		primary_colour = HEX('D17000'),
		secondary_colour = HEX('D1B492'),
		loc_txt =
			{
			name = 'Fossil',
			collection = 'Fossil Cards'
		},
		collection_rows = {6,2}
	}

-- CONSUMABLE LOAD

local alice_load_cons = SMODS.load_file(mod_path.."Files".."AliceCons")

-- Atlas List --

SMODS.Atlas({
    key = "Alice Atlas",
    path = "Alice Atlas.png",
    px = 71,
    py = 95
}):register()

--SMODS.Atlas({
--    key = "Alice Fossil Jokers",
--    path = "Alice Fossil Jokers.png",
--    px = 71,
--    py = 95
--}):register()


SMODS.Atlas({
    key = "Alice Cons",
    path = "Alice Cons.png",
    px = 71,
    py = 95
}):register()
