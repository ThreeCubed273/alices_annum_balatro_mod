--- STEAMODDED HEADER
--- MOD_NAME: Alices Annum
--- MOD_ID: Annum
--- MOD_AUTHOR: [Alice_Reverie, nhhvhy]
--- MOD_DESCRIPTION: Jokers made for the lulz, by the lulz
--- PREFIX: annum_
-------------------------------------

local MOD_PREFIX = "annum_"

------- JOKERS -------

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
	
	-- Octopus
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
              --  if card.ability.prev == 8 then
              --      card.ability.prev = 0
              --          return {
              --              card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_level_up_ex'), colour = G.C.CHIPS}),
              --              card = card,
              --              colour = G.C.chips
              --          }
              --  end
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
		text = {'Played {C:attention}6{}',
		'become {C:attention}Gold{} upon',
		'being scored.'
		}
	},
	rarity = 1,
	cost = 4,
	unlocked = true, 
    discovered = true, 
	atlas = 'Alice Atlas',
	pos = { x = 3, y = 0 },
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.before and not context.blueprint then
			for k, v in ipairs(context.scoring_hand) do
				local rank = context.scoring_hand[k]:get_id()
                if rank == 6 then 
                    local six_card = context.scoring_hand[k]
					six_card:set_ability(G.P_CENTERS.m_gold, nil, true)
					G.E_MANAGER:add_event(Event({
					func = function()
						six_card:juice_up()
						return true
					end}))
					card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_gold'), colour = G.C.MONEY})
                end
            end
        end  
	end
	}
	
	-- Earth Worm
	-- WIP --
	SMODS.Joker {
	key = 'key_earth_worm',
	loc_txt = {
		name = 'Earth Worm',
		text = {
		'Cards {C:attention}held in hand{} that',
		'are {C:mult}not{} enhanced',
		'become {C:attention}Stone{} cards'
		}
	},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = true,
	atlas = 'Alice Atlas',
	pos = { x = 4, y = 0 },
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and not context.blueprint then
			local cards_changed = 0;
			for i=1, #G.hand.cards do
                local stone_card = G.hand.cards[i]
				if stone_card.ability.effect ~= 'Stone Card' and stone_card.ability.effect == 'Base' then
					cards_changed = cards_changed + 1
					stone_card:set_ability(G.P_CENTERS.m_stone, nil, true)
					G.E_MANAGER:add_event(Event({
					func = function()
						stone_card:juice_up()
						return true
					end}))
				end
            end
			if cards_changed >= 1 then
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Stone', colour = G.C.PURPLE})
			end
        end  
	end
	}
	
	-- Pufferfish
	SMODS.Joker {
	key = 'key_pufferfish',
	loc_txt = {
		name = 'Pufferfish',
		text = { 
		'If played hand contains',
		'a single {C:attention}face{} card,',
		'destroy it and create a',
		'random {C:spectral}Spectral{} card',
		'{C:inactive}(Must have room)'
		}
	},
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = true,
	atlas = 'Alice Atlas',
	pos = { x = 5, y = 0 },
	calculate = function(self, card, context)
		if context.destroying_card and #context.full_hand == 1 and not context.blueprint then
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				local playcard = context.full_hand[1]
				local rank = playcard:get_id()
				if rank == 11 or rank == 12 or rank == 13 then
				G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                                local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'key_pufferfish')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                            return true
                        end)}))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					func = function()
						playcard:start_dissolve()
					return true
				end}))
				end
			end
		end
	end
	}
	

-- Atlas List --

SMODS.Atlas({
    key = "Alice Atlas",
    path = "Alice Atlas.png",
    px = 71,
    py = 95
}):register()
