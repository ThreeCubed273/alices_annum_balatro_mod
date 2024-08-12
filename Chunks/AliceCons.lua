-- ALICE CONSUMABLES --

return {
	-- Anomalacaris / 'Odd Fossil'
	-- All played poker hands are now straights or higher
	SMODS.Consumable {
		key = 'alice_anoma_con',
		set = 'alice_fossil_cards',
		unlocked = true,
		discovered = true,
		atlas = 'Alice Cons',
		pos = { x = 0, y = 0 },	
		loc_txt =
		{
			name = 'Anomalacaris Fossil',
			text = { 'Creates a {C:attention}unique{}',
			'{C:alice_fossil_tier,E:1}Fossil{} joker upon playing',
			'{C:attention}5 Straights{}',
			'{C:inactive}(Must have space){}',
			'{C:inactive}({C:attention}nil{} remaining)'
			}
		}
	}
}