-- DEFINES FUNCTIONALITY OF TAROT CARDS

badge_minorarcana = function(self, card, badges)
	badges[#badges + 1] = create_badge('Minor Arcana', HEX('A782D1'), G.C.WHITE, 1.2)
end

-- Atlas

SMODS.Atlas({
    key = "Alice Arcana Atlas",
    path = "Alice Arcana Atlas.png",
    px = 71,
    py = 95
})

if alice_annum_mod.config.alice_tarot_cards then
	-- ACE OF CUPS
	-- DONE
	SMODS.Consumable {
		key = 'arcana_aof_cups',
		loc_txt = {
			name = 'Ace of Cups',
			text = {'{C:attention}Upgrades{} edition of up to',
			'{C:attention}2{} selected cards in hand',
			'{C:inactive}(Edition order found in collection)'}
		},
		set = ('Tarot'),
		atlas = "Alice Arcana Atlas",
		set_card_type_badge = badge_minorarcana,
		pos = { x = 0, y = 0 },
		cost = 4,
		unlocked = true,
		discovered = true,
		can_use = function(self, card)
			return #G.hand.highlighted >= 1 and #G.hand.highlighted <= 2
		end,
		use = function(self, card, area, copier)
			for k, v in ipairs(G.hand.highlighted) do
				--sendDebugMessage(tostring(G.hand.highlighted))
				local sel_card = G.hand.highlighted[k] 
				--sendDebugMessage(tostring(G.hand.highlighted[k]))
				local found_edition = 1
				if sel_card.edition then
					for i, v in ipairs(G.P_CENTER_POOLS.Edition) do
						if v.key == sel_card.edition.key then
							--sendDebugMessage(tostring(sel_card.edition.key))
							found_edition = i
							break
						end
					end
				end
				found_edition = found_edition + 1
				--sendDebugMessage(tostring(found_edition))
				if found_edition > #G.P_CENTER_POOLS.Edition then found_edition = found_edition - #G.P_CENTER_POOLS.Edition end
				sel_card:set_edition(G.P_CENTER_POOLS.Edition[found_edition].key, nil, nil)
			end
		end
	}
	
	---- ACE OF WANDS
	---- 
	--SMODS.Consumable {
	--	key = 'arcana_aof_wands',
	--	loc_txt = {
	--		name = 'Ace of Wands',
	--		text = {''}
	--	},
	--	set = ('Tarot'),
	--	atlas = "Alice Arcana Atlas",
	--	set_card_type_badge = badge_minorarcana,
	--	pos = { x = 1, y = 0 },
	--	cost = 4,
	--	unlocked = true,
	--	discovered = true,
	--	can_use = function(self, card)
	--		return true
	--	end,
	--
	--}
	-- 
	---- ACE OF PENTACLES
	--
	--SMODS.Consumable {
	--	key = 'arcana_aof_pentacles',
	--	loc_txt = {
	--		name = 'Ace of Pentacles',
	--		text = {'{C:attention}Destroy{} one selected card,'
	--		'gain {C:money}money{} equal to {C:attention}rank{}'
	--		'of destroyed card'}
	--	},
	--	set = ('Tarot'),
	--	atlas = "Alice Arcana Atlas",
	--	set_card_type_badge = badge_minorarcana,
	--	pos = { x = 2, y = 0 },
	--	cost = 4,
	--	unlocked = true,
	--	discovered = true,
	--	can_use = function(self, card)
	--		return #G.hand.highlighted == 1
	--	end,
	--	use = function(self, card, area, copier)
	--	end
	--}
	--	
	---- ACE OF SWORDS 
	--SMODS.Consumable {
	--	key = 'arcana_aof_swords',
	--	loc_txt = {
	--		name = 'Ace of Swords',
	--		text = {'WIP'}
	--	},
	--	set = ('Tarot'),
	--	atlas = "Alice Arcana Atlas",
	--	set_card_type_badge = badge_minorarcana,
	--	pos = { x = 3, y = 0 },
	--	cost = 4,
	--	unlocked = true,
	--	discovered = true,
	--	can_use = function(self, card)
	--		return true
	--	end,
	--}
end