local jokerInfo = {
	name = 'Depressed Brother',
	config = {extra = {
		chips = 13,
		chip_mod = 13
	}},
	rarity = 2,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "guestartist1", set = "Other"}
	return { vars = {card.ability.extra.chips, card.ability.extra.chips_mod} }
end

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.chips, card.ability.extra.chip_mod} }
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main and context.cardarea == G.jokers then
		if G.GAME.blind.triggered and not (context.blueprint or context.repetition or context.individual) then 
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
			card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.CHIPS})
		end

		return {
			message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
			chip_mod = card.ability.extra.chips, 
			colour = G.C.CHIPS
		}
	end
end



return jokerInfo
	