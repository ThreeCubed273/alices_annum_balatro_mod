--- STEAMODDED HEADER
--- MOD_NAME: Alices Annum
--- MOD_ID: Annum
--- MOD_AUTHOR: [Alice_Reverie, nhhvhy]
--- MOD_DESCRIPTION: Jokers made for the lulz, by the lulz
--- PREFIX: annum_
-------------------------------------

local MOD_PREFIX = "annum_"

local annum_jokers =

	-- Venus Fly Trap
	SMODS.Joker {
	key = 'key_venus_fly_trap',
	config = {extra = { bonus = 0.50, current = 1.00 }},
	loc_txt = {
		name = 'Venus Fly Trap',
		text = { 
			"This joker gains {X:mult,C:white}X#1#{} Mult",
			"if played hand contains",
			"a {C:attention}Three of a Kind{}",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{} Mult)"
			}
		},
	rarity = 3,
	cost = 8,
	unlocked=true, 
    discovered=true, 
	atlas = 'Alice Atlas',
	pos = { x = 0, y = 0 },
	loc_vars = function(self, info_queue, card) return {vars = {card.ability.extra.bonus, card.ability.extra.current}} end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and not context.blueprint
		and (next(context.poker_hands['Three of a Kind']) or next(context.poker_hands['Full House']) or next(context.poker_hands['Flush House']))
		then
				card.ability.extra.current = card.ability.extra.current + card.ability.extra.bonus
				return {
					message = localize('k_level_up_ex')
				}
			else if context.joker_main and card.ability.extra.current > 1 and not context.before and not context.after then
				return {
					message = localize{type='variable',key='a_xmult',vars={card.ability.extra.current}},
					Xmult_mod = card.ability.extra.current
				}
				end
			end
		end
	},
	
	-- CODE CREDIT TO: nhhvhy 
	SMODS.Joker {
        key = 'key_octopus',
        config = {extra = { bonus = 30, current = 20 }, prev = 0},
        loc_txt = {
            name = 'Octopus',
            text = { 'Gains {C:chips}+#1#{} Chips for',
            'each scoring {C:attention}8{}',
            '{C:inactive}(Currently {C:chips}+#2#{} Chips)'}
        },
        rarity = 2,
        cost = 6,
        unlocked=true,
        discovered=true,
        atlas = 'Alice Atlas',
        pos = { x = 1, y = 0 },
        loc_vars = function(self, info_queue, card) return {vars = {card.ability.extra.bonus, card.ability.extra.current}} end,
        calculate = function(self, card, context)
            if context.individual and not context.blueprint then 
                local rank = context.other_card:get_id()
                if card.ability.prev == 8 then
                    card.ability.prev = 0
                    if rank == 8 then
                        card.ability.extra.current = card.ability.extra.current + card.ability.extra.bonus
                        card.ability.prev = 8
                    end
						return {
							card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_level_up_ex'), colour = G.C.CHIPS}),
							card = card,
							colour = G.C.chips
						}
                end
                if context.cardarea == G.play then 
                    if rank == 8 then
                        card.ability.extra.current = card.ability.extra.current + card.ability.extra.bonus
                    end
                end
                card.ability.prev = rank
            end
            -- context.other_card:get_id()
            -- card.ability.extra.current = card.ability.extra.current + card.ability.extra.bonus
            if context.cardarea == G.jokers and not context.before and not context.after then
                if card.ability.prev == 8 then
                    card.ability.prev = 0
                        return {
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_level_up_ex'), colour = G.C.CHIPS}),
                            card = card,
                            colour = G.C.chips
                        }
                end
                return {
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.current}},
                    colour = G.C.CHIPS,
                    chip_mod = card.ability.extra.current
                }
                end
            end
        }
	
	-- Sun Fish
	SMODS.Joker {
	key = 'key_sun_fish',
	loc_txt = {
		name = 'Sun Fish',
		text = { 'Spawns {C:tarot}The Sun{} if',
		'played hand contains',
		'a {C:attention}Two Pair',
		'{C:inactive}(Must have room)'
		}
	},
	rarity = 1,
	cost = 4,
	unlocked = true, 
    discovered = true, 
	atlas = 'Alice Atlas',
	pos = { x = 2, y = 0 },
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.joker_main and not context.blueprint
		and (next(context.poker_hands['Two Pair']) or next(context.poker_hands['Full House']) or next(context.poker_hands['Flush House']))
		and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({trigger = 'before',
					delay = 0.0,
					func = (function() local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_sun', nil)
						card:add_to_deck()
						G.consumeables:emplace(card)
						G.GAME.consumeable_buffer = 0
						card:juice_up(0.8, 0.5)
					return true
				end)}))
				return {
					message = localize('k_plus_tarot')
				}
			end
		end
	}
	
	-- Honey Bee
	-- WIP --
	SMODS.Joker {
	key = 'key_honey_bee',
	loc_txt = {
		name = 'Honey Bee',
		text = {'{C:attention}WIP{}',
		'Effect ERROR Unavailable',
		'Error Code: BZZZ'}
	},
	rarity = 2,
	------------------- cost free until WIP fixed
	cost = 0,
	unlocked = true, 
    discovered = true, 
	atlas = 'Alice Atlas',
	pos = { x = 3, y = 0 }
	-- calculate = function(self, card, context)
	--	if context.cardarea == G
	}
	
	--Earth Worm
	-- WIP --
	SMODS.Joker {
	key = 'key_earth_worm',
	loc_txt = {
		name = 'Earth Worm',
		text = {'{C:attention}WIP{}',
		'Cards {C:attention}held in hand{}',
		'become {C:attention}Stone{} cards',
		'after hand is played'}
	},
	rarity = 1,
	------------------- cost free until WIP fixed
	cost = 0,
	unlocked = true,
	discovered = true,
	atlas = 'Alice Atlas',
	pos = { x = 4, y = 0 },
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.hand and not context.blueprint then
			for i = 1, #G.hand.cards do
                if context.other_card.ability.name == nil or 0 then
                    local v = G.hand.cards[i]
					v:set_ability(G.P_CENTERS.m_stone, nil, true)
					G.E_MANAGER:add_event(Event({
					func = function()
						v:juice_up()
						return true
					end
				}))
				end
			end
        end  
	end
	}

-- Ideas --
---- Octopus
-- Gains +30 chips for each scoring 8

---- Mola Mola / Sun Fish
-- Spawns 'XIX - The Sun' if played hand contains a two pair.

--- Honey Bee
-- Has a 1/6 chance to spawn a Polychrome (???) upon playing a 6
-- Adds a gold seal to all played sixes and threes
-- All played sixes give x6 mult when scored
-- Retriggers all sixes played and held in hand.

--- Earth Worm
-- Create a negative Earth card upon playing a full house.
-- Upgrade level of played hand if it contains a full house.
-- ** Unenhanced cards held in hand become Stone Cards
-- Stone Cards give +5$ upon being scored.

--- King Cobra
-- Kings held in hand have a 1/2 chance to spawn 'VIII - Strength'

--- Hermit Crab
-- Spawns 'The Hermit' upon 

-- Atlas List --

SMODS.Atlas({
    key = "Alice Atlas",
    path = "Alice Atlas.png",
    px = 71,
    py = 95
}):register()
