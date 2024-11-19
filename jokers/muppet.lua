local jokerInfo = {
    name = "Movin' Right Along",
    config = {
        dollars_before = nil,
        extra = {
            x_mult = 1,
            x_mult_mod = 0.5,
        }
    },
    rarity = 3,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_mod} }
end

function jokerInfo.calculate(self, card, context)
    if G.shop and not card.ability.dollars_before then
        card.ability.dollars_before = G.GAME.dollars
    end
    if context.ending_shop and not context.blueprint then
        if card.ability.dollars_before and G.GAME.dollars == card.ability.dollars_before then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}}, colour = G.C.MULT})
        end
        card.ability.dollars_before = nil
    end
    if context.joker_main and context.cardarea == G.jokers then
        return {
            message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
            Xmult_mod = card.ability.extra.x_mult,
            --colour = G.C.MULT
        }
    end
end

return jokerInfo