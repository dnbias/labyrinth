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

is_finished = False
global startpos
startpos = (-1,-1)
walls = []
goals = []

def toggle(x,y):
    x = int(x)
    y = int(y)
    print('toggle:',x,y)
    if (x,y) in walls:
        walls.remove((x,y))
        cb.fillcolor("white")
    else:
        walls.append((x,y))
        cb.fillcolor("black")
    cb.stamp()

def toggle_goal(x,y):
    x = int(x)
    y = int(y)

    print('toggle_goal:',x,y)
    if (x,y) in goals:
        goals.remove((x,y))
        cb.fillcolor("white")
    else:
        goals.append((x,y))
        cb.fillcolor("red")
    cb.stamp()

def toggle_start(x,y):
    global startpos
    x = int(x)
    y = int(y)
    print('toggle_start:',x,y)
    print(startpos)
    (start_x,_) = startpos
    if start_x < 0:
        old_start = None
    else:
        old_start = startpos

    start = (x,y)
    startpos = (x,y)
    cb.fillcolor("green")
    cb.stamp()

    if old_start != None:
        (old_x,old_y) = old_start
        cb.goto(old_x*30,old_y*30)
        cb.fillcolor("white")
        cb.stamp()


def goto(x, y):
    print('goto:',x,y)
    global is_finished, max_x, max_y

    if (x < -15 or y < -15):
        return
    elif (x > max_x+15 or y > max_y+15):
        return

    if not is_finished:
        x = abs(x+15) // 30
        y = abs(y+15) // 30
        cb.goto(x*30, y*30)
        toggle(x,y)
    else:
        pass

def goto_goal(x, y):
    print('goto_goal:',x,y)
    global is_finished, max_x, max_y

    if (x < -15 or y < -15):
        return
    elif (x > max_x+15 or y > max_y+15):
        return

    if not is_finished:
        x = abs(x+15) // 30
        y = abs(y+15) // 30
        cb.goto(x*30, y*30)
        toggle_goal(x,y)
    else:
        pass

def goto_start(x, y):
    print('goto_start:',x,y)
    global is_finished, max_x, max_y

    if (x < -15 or y < -15):
        return
    elif (x > max_x+15 or y > max_y+15):
        return

    if not is_finished:
        x = abs(x+15) // 30
        y = abs(y+15) // 30
        cb.goto(x*30, y*30)
        toggle_start(x,y)
    else:
        pass

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
            cb.stamp()
            cb.forward(30)

            # cb.end_fill()
            # cb.hideturtle()
            # turtle.done()

    # Gets coordinates of click
    cb.hideturtle()
    # turtle.done()
    turtle.onscreenclick(goto)
    turtle.onscreenclick(goto_goal,2)
    turtle.onscreenclick(goto_start,3)


    button = turtle.Turtle()
    button.hideturtle()
    button.shape('circle')
    button.fillcolor('red')
    button.penup()
    button.goto(40, -80)
    button.write("Export!", align='center', font=FONT)
    button.sety(-80 + CURSOR_SIZE + FONT_SIZE)
    button.onclick(draw_onclick)
    button.showturtle()


def draw_onclick(x, y):
    turtle.hideturtle()
    turtle.shape('circle')
    turtle.fillcolor('green')
    turtle.penup()
    turtle.goto(40, -80)
    turtle.sety(-80 + CURSOR_SIZE + FONT_SIZE)
    turtle.showturtle()
    finish()

def finish():
    global startpos
    import os
    _, _, files = next(os.walk("./maps"))
    file_count = len(files)
    print(file_count)
    # write to file

    filename = 'maps/map'+str(file_count)+'.pl'
    file = open(filename,'w')
    file.write('num_righe('+str(HEIGHT)+').\n')
    file.write('num_colonne('+str(WIDTH)+').\n')
    if startpos != None:
        (start_x,start_y) = startpos
        file.write('iniziale(pos('+str(start_x)+','+str(start_y)+')).\n')
    else:
        print('Error: no starting position')
        return
    for (w_x,w_y) in walls:
        file.write('occupata(pos('+str(w_x)+','+str(w_y)+')).\n')
    for (g_x,g_y) in goals:
        file.write('finale(pos('+str(g_x)+','+str(g_y)+')).\n')
    file.close()


if __name__ == "__main__":
    draw_board()
    turtle.mainloop()
