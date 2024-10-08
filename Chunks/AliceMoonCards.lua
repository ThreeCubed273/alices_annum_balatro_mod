----- MOON CELESTIAL CARDS -----

badge_jovianmoon = function(self, card, badges)
	badges[#badges + 1] = create_badge('Jovian Moon', HEX('D66024'), G.C.WHITE, 1.2)
end

-- Atlas

SMODS.Atlas({
    key = "Alice Moon Atlas",
    path = "Alice Moon Atlas.png",
    px = 71,
    py = 95
})

-- Consumables

if alice_annum_mod.config.alice_moon_cards then
	
	-- GANYMEDE
	SMODS.Consumable
	{
		key = "moon_ganymede",
		loc_txt = {
			name = 'Ganymede',
			text = {'Increases level of {C:attention}most{} played poker hand',
			'by level of {C:attention}least{} played poker hand',
			'{C:inactive}(Most: {C:attention}#1#{}{C:inactive}, Level {C:attention}#2#{}{C:inactive}){}',
			'{C:inactive}(Least: {C:attention}#3#{}{C:inactive}, Level {C:attention}#4#{}{C:inactive}){}'}
		},
		set = ('Planet'),
		atlas = "Alice Moon Atlas",
		config = {extra = {most_hand = 'High Card', most_level = 1, least_hand = 'High Card', least_level = 1}},
		set_card_type_badge = badge_jovianmoon,
		pos = { x = 1, y = 0 },
		cost = 4,
		aurinko = true,
		unlocked = true,
		discovered = true,
		can_use = function(self, card)
			return true
		end,
		loc_vars = function(self, info_queue, card)
			return {vars = {get_most_played_poker_hand(), most_played_poker_hand_level(), get_least_played_poker_hand(), least_played_poker_hand_level()}}
		end,
		use = function(self, card, area, copier)
		
			local most_hand = get_most_played_poker_hand()
			local least_hand = get_least_played_poker_hand()
			
			for _, hand in ipairs(G.handlist) do
				--sendDebugMessage(tostring(hand))
				--sendDebugMessage(tostring(most_played_poker_hand_level()))
				if hand == most_hand then
					card.ability.extra.most_level = most_played_poker_hand_level()
					--sendDebugMessage(tostring(G.GAME.hands[hand].level))
				end
				if hand == least_hand then
					card.ability.extra.least_level = least_played_poker_hand_level()
					--sendDebugMessage(tostring(G.GAME.hands[hand].level))
				end
			end
			
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(most_hand, 'poker_hands'),chips = G.GAME.hands[most_hand].chips, mult = G.GAME.hands[most_hand].mult, level=G.GAME.hands[most_hand].level})
			level_up_hand(card, most_hand, nil, math.ceil(card.ability.extra.least_level))
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
		end,
		bulk_use = function(self, card, area, copier, number)
		
			local most_hand = get_most_played_poker_hand()
			local least_hand = get_least_played_poker_hand()
			
			for _, hand in ipairs(G.handlist) do
				if hand == most_hand then
					card.ability.extra.most_level = most_played_poker_hand_level()
				end
				if hand == least_hand then
					card.ability.extra.least_level = least_played_poker_hand_level()
				end
			end
			
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(most_hand, 'poker_hands'),chips = G.GAME.hands[most_hand].chips, mult = G.GAME.hands[most_hand].mult, level=G.GAME.hands[most_hand].level})
			level_up_hand(card, most_hand, nil, math.ceil(card.ability.extra.least_level) * number)
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
		end
	}
	
	--	IO --
	SMODS.Consumable
	{
		key = "moon_io",
		loc_txt = {
			name = 'Io',
			text = {'{C:attention}Averages{} level of',
			'all poker hands',
			'{C:inactive}(Rounded up){}'},
		},
		set = ('Planet'),
		atlas = "Alice Moon Atlas",
		set_card_type_badge = badge_jovianmoon,
		pos = { x = 0, y = 0 },
		cost = 4,
		aurinko = true,
		unlocked = true,
		discovered = true,
		can_use = function(self, card)
			return true
		end,
		use = function(self, card, area, copier)
			local poker_hand_count = 0
			local poker_hand_total_level = 0
			for _, hand in ipairs(G.handlist) do	
				if G.GAME.hands[hand].visible then
					poker_hand_count = poker_hand_count + 1
					poker_hand_total_level = poker_hand_total_level + G.GAME.hands[hand].level
				end
				--sendDebugMessage(tostring(poker_hand_count))
				--sendDebugMessage(tostring(poker_hand_total_level))
			end
			--sendDebugMessage('Before ---' .. tostring(poker_hand_total_level))
			poker_hand_total_level = (poker_hand_total_level / poker_hand_count)
			--sendDebugMessage('After ---' .. tostring(poker_hand_total_level))
			for _, hand in ipairs(G.handlist) do
				local poker_hand_difference = 0
				poker_hand_difference = math.ceil(poker_hand_total_level - G.GAME.hands[hand].level)
				--sendDebugMessage(tostring(poker_hand_difference))
				if math.abs(poker_hand_difference) > 0 and G.GAME.hands[hand].visible then
					update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(hand, 'poker_hands'),chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level=G.GAME.hands[hand].level})
					level_up_hand(card, hand, nil, math.ceil(poker_hand_difference))
					update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
				end
			end
		end 
	}
	
	-- CALLISTO
	SMODS.Consumable 
	{
		key = 'moon_callisto',
		loc_txt = {
			name = 'Callisto',
			text = {'Level up {C:attention}last played poker hand{} by',
			'{C:attention}number of times{} poker hand has been played',
			'{C:inactive}(Currently {}{C:attention}#1#{}{C:inactive}, {}{C:attention}#2#{}{C:inactive} times played){}'
			}
		},
		set = ('Planet'),
		atlas = "Alice Moon Atlas",
		config = {extra = {last_hand = 'High Card', times_played = 1}},
		set_card_type_badge = badge_jovianmoon,
		pos = { x = 3, y = 0 },
		cost = 4,
		aurinko = true,
		unlocked = true,
		discovered = true,
		can_use = function(self, card)
			return true
		end,
		loc_vars = function(self, info_queue, card)
			return {vars = {G.GAME.last_hand_played or 'High Card', last_played_poker_hand_count()}}
		end,
		use = function(self, card, area, copier)
			local last_hand = G.GAME.last_hand_played
			local times_played = G.GAME.hands[last_hand].played
			
			sendDebugMessage(tostring(last_hand))
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(last_hand, 'poker_hands'),chips = G.GAME.hands[last_hand].chips, mult = G.GAME.hands[last_hand].mult, level=G.GAME.hands[last_hand].level})
			level_up_hand(card, last_hand, nil, math.ceil(G.GAME.hands[last_hand].played))
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
		end,
		bulk_use = function(self, card, area, copier, number)
			local last_hand = G.GAME.last_hand_played
			local times_played = G.GAME.hands[last_hand].played
			
			sendDebugMessage(tostring(last_hand))
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(last_hand, 'poker_hands'),chips = G.GAME.hands[last_hand].chips, mult = G.GAME.hands[last_hand].mult, level=G.GAME.hands[last_hand].level})
			level_up_hand(card, last_hand, nil, math.ceil(G.GAME.hands[last_hand].played) * number)
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
		end
	}
	
	-- EUROPA
	SMODS.Consumable 
	{
		key = 'moon_europa',
		loc_txt = {
			name = 'Europa',
			text = {'Gives {C:money}$#2#{}, equal to',
			'the {C:attention}level{} of your',
			'{C:attention}least played poker hand.{}',
			'{C:inactive}(Currently{} {C:attention}#1#{}{C:inactive}, level{} {C:attention}#2#{}{C:inactive}){}'
			}
		},
		set = ('Planet'),
		atlas = "Alice Moon Atlas",
		config = {extra = {least_hand = 'High Card', least_level = least_played_poker_hand_level}},
		set_card_type_badge = badge_jovianmoon,
		pos = { x = 2, y = 0 },
		cost = 3,
		aurinko = true,
		unlocked = true,
		discovered = true,
		can_use = function(self, card)
			return true
		end,
		loc_vars = function(self, info_queue, card)
			return {vars = {get_least_played_poker_hand(), least_played_poker_hand_level()}}
		end,
		use = function(self, card, area, copier)
			ease_dollars(least_played_poker_hand_level())
		end,
		bulk_use = function(self, card, area, copier, number)
			ease_dollars(least_played_poker_hand_level() * number)
		end
	}
end
