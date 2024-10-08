local jokerInfo = {
	name = 'Cousin\'s Club [WIP]',
	config = {},
	text = {
		"This Joker gains {C:chips}+1{} Chips",
		"for each {C:clubs}Club{} card scored,",
		"{C:attention}double{} if hand contains a {C:attention}Flush{}",
		"{C:inactive}(Currently {}{C:chips}+#1#{} {C:inactive}Chips){}",
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { card.ability.extra.chips }
end

function jokerInfo.set_ability(self, card, initial, delay_sprites)
	card.ability.extra = {
		chips = 0,
		chip_mod = 1
	}
end

function jokerInfo.calculate(self, card, context)
	if context.individual and context.cardarea == G.play and not self.debuff and not (context.blueprint) then
		for k, v in ipairs(context.scoring_hand) do
			if v:is_suit('Clubs') then 
				G.E_MANAGER:add_event(Event({
					func = function()
						v:juice_up()
						return true
					end
				})) 
				if get_flush(context.scoring_hand) then
					card.ability.extra.chips = card.ability.extra.chips + 2*card.ability.extra.chip_mod
				else
					card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
				end
				card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.CHIPS})
			end
		end
	end
	if context.joker_main and context.cardarea == G.jokers then
		return {
			message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
			chip_mod = card.ability.extra.chips, 
			colour = G.C.CHIPS
		}
	end
end



return jokerInfo
	