--- STEAMODDED HEADER
--- MOD_NAME: Alices Annum
--- MOD_ID: Annum
--- MOD_AUTHOR: [Alice_Reverie, nhhvhy, eremel_]
--- MOD_DESCRIPTION: Jokers made for the lulz, by the lulz
--- BADGE_COLOUR: 03A100
--- PRIORITY: 1
--- PREFIX: annum
-------------------------------------

-- Define Current Mod
alice_annum_mod = SMODS.current_mod
alice_debug = true

-- Custom Raritys (Thank you cryptid)
Game:set_globals()
G.C.RARITY["alice_fossil_tier"] = HEX("D13900");
local ip = SMODS.insert_pool
function SMODS.insert_pool(pool, center, add)
	if pool == nil then pool = {} end
	ip(pool, center, add)
end
local get_badge_colourref = get_badge_colour
function get_badge_colour(key)
	local fromRef = get_badge_colourref(key)
	if key == 'alice_fossil_tier' then return G.C.RARITY["alice_fossil_tier"] end
	return fromRef
end

--Register custom rarity pools
local is = SMODS.injectItems
function SMODS.injectItems()
	local m = is()
	G.P_JOKER_RARITY_POOLS.alice_fossil_tier = {}
	for k, v in pairs(G.P_CENTERS) do
		v.key = k
		if v.rarity and (v.rarity == 'alice_fossil_tier') and v.set == 'Joker' and not v.demo then 
			table.insert(G.P_JOKER_RARITY_POOLS[v.rarity], v)
		end
	end
	return m
end

-- MOD ICON
SMODS.Atlas{
    key = "modicon",
    path = "alice_modicon.png",
    px = 34,
    py = 34,
}

-- NATURE JOKERS

local alice_nature_jokers = SMODS.load_file("/Chunks/AliceNatureJokers.lua")()

-- FOSSIL JOKERS 

local alice_fossil_jokers = SMODS.load_file('Chunks/AliceFossilJokers.lua')()

---- MOON CARDS

local alice_moon_cards = SMODS.load_file('Chunks/AliceMoonCards.lua')()

------ Define Poker Hand Functions
-- Most Played Poker Hand
function get_most_played_poker_hand()
	local result_hand = 'High Card'
	local played_hand_count = 0
	for _, v in ipairs(G.handlist) do
		if G.GAME.hands[v].played > played_hand_count then
			result_hand = v
			played_hand_count = G.GAME.hands[v].played
		end
	end
	return result_hand
end

-- Least Played Poker Hand
function get_least_played_poker_hand()
	local result_hand = 'High Card'
	local played_hand_count = math.huge
	for _, v in ipairs(G.handlist) do
		if G.GAME.hands[v].played <= played_hand_count then
			result_hand = v
			played_hand_count = G.GAME.hands[v].played
		end
	end
	return result_hand
end

-- Level of Most Played Poker Hand
function most_played_poker_hand_level()
	local result_level = 1
	local played_hand_count = 0
	for _, v in ipairs(G.handlist) do
		if G.GAME.hands[v].played > played_hand_count then
			result_level = G.GAME.hands[v].level
			played_hand_count = G.GAME.hands[v].played
		end
	end
	return result_level
end
	
-- Level of Least Played Poker Hand
function least_played_poker_hand_level()
	local result_level = 1
	local played_hand_count = math.huge
	for _, v in ipairs(G.handlist) do
		if G.GAME.hands[v].played <= played_hand_count then
			result_level = G.GAME.hands[v].level
			played_hand_count = G.GAME.hands[v].played
		end
	end
	return result_level
end

-- Get Last Played Poker Hand Count
function last_played_poker_hand_count()
	local result_count = 0
	local last_hand = G.GAME.last_hand_played
	if last_hand ~= nil then
		result_count = G.GAME.hands[last_hand].played
	end
	return result_count
end


----

-- W I P CONSUMABLES

-- CONSUMABLE DEFINE

if alice_annum_mod.config.alice_fossil_jokers then
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
end

-- CONSUMABLE LOAD

local alice_fossil_cons = SMODS.load_file("Chunks/AliceFossilCons.lua")()

-- Atlas List --

SMODS.Atlas({
    key = "Alice Cons",
    path = "Alice Cons.png",
    px = 71,
    py = 95
})

-- Config Display --

alice_annum_mod.config_tab = function()
    return {n = G.UIT.ROOT, config = {align = "m", r = 0.1, padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 6}, nodes = {
        {n = G.UIT.R, config = {align = "cl", padding = 0, minh = 0.1}, nodes = {}},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = alice_annum_mod.config, ref_value = "alice_nature_jokers" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "Enable Nature Jokers", scale = 0.45, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = alice_annum_mod.config, ref_value = "alice_fossil_jokers" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "Enable Fossil Jokers", scale = 0.45, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},
		
		{n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = alice_annum_mod.config, ref_value = "alice_moon_cards" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "Enable Moon Cards", scale = 0.45, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.T, config = {text = "(Must restart to apply changes)", scale = 0.35, colour = G.C.UI.TEXT_LIGHT}},
        }},

    }}
end