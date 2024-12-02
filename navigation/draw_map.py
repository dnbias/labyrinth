#!/usr/bin/env python3

import turtle
from typing import List
sc = turtle.Screen()
cb = turtle.Turtle()

colors = ["white", "black"]
HEIGHT=10
WIDTH=10
CURSOR_SIZE = 20
FONT_SIZE = 12
FONT = ('Arial', FONT_SIZE, 'bold')

def draw_board():
    """
    When this function runs, run labyrint creation
    """

    global is_finished, max_x, max_y

    is_finished = False
    max_x = 30 * (WIDTH-1)
    max_y = 30 * (HEIGHT-1)

    # set screen
    sc.setup(width=500, height=500, startx=0, starty=100)
    # print(sc.screensize())
    sc.setworldcoordinates(-20,-150, sc.window_width()-20, sc.window_height()-150)
    # set turtle object speed
    cb.shape("square")
    cb.pencolor("black")
    cb.shapesize(1.5,1.5,2)
    cb.speed(30)
    # loops for board
    # cb.left(90)
    col = 'white'
    cb.fillcolor(col)
    cb.up()
    for i in range(HEIGHT):
        # not ready to draw
        # set position for every row
        cb.setpos(0, 30 * i)
        # ready to draw
        # cb.down()
        # row
        for j in range(WIDTH):
            # cb.begin_fill()

            # draw()
            # if occupata() cb.fillcolor('black')
            cb.stamp()
            cb.forward(30)

            # cb.end_fill()
            # cb.hideturtle()
            # turtle.done()

    cb.hideturtle()
    turtle.done()
