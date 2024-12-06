rows(8).
cols(8).
iniziale(
    gameState(
        monster(pos(0,0)),
        gems([
            gem(pos(5,5)),
            gem(pos(7,5))
        ]),
        ice_blocks([
            ice(pos(7,6))
        ]),
        hammer(pos(0,7)),
        0
    )
).
finale(
    gameState(
        _,
        _,
        _,
        _,
        1
    )
).
wall(pos(0,5)).
wall(pos(0,6)).
wall(pos(4,5)).
wall(pos(7,4)).
wall(pos(5,7)).
wall(pos(6,7)).
portal(pos(7,7)).