from gpanel import *
import time
import math
import copy
import csv
from mindq.eyetrax import Measurement, Stream
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation


FPS = 200
DECIMAL_PLACES = 5
MS_PER_FRAME = 1000 / FPS
EYE_SPEED = 1 / 50 # meters per millisecond

SINE = (4460, 5785, 20)
    

def readBallPositions(path):
    with Measurement(path) as measurement:
        stream = Stream.load(measurement, "BallPositions")
        
        positions = []
        
        for item in stream:
            timestamp = item["Timestamp"]
            x = item["Position"]["Item1"]
            y = item["Position"]["Item2"]
            z = item["Position"]["Item3"]
            positions.append([timestamp, x, y, z])
            
        return sorted(positions, key=lambda x: x[0])
        
           
def drawBallPositions(positions, traectory=None):    
    makeGPanel(-5, 5, -3, 3)
    setColor("blue")
    enableRepaint(False)
    bounds = range(len(positions) - 1)
    if traectory:
        bounds = range(traectory[0], traectory[1])
    for i in bounds:
        curr_pos = positions[i]
        next_pos = positions[i+1]
        dt = next_pos[0] - curr_pos[0]
        x_curr = round(curr_pos[1], DECIMAL_PLACES)
        y_curr = round(curr_pos[2], DECIMAL_PLACES)
        z_curr = curr_pos[3]
        x_next = round(next_pos[1], DECIMAL_PLACES)
        y_next = round(next_pos[2], DECIMAL_PLACES)
        z_next = next_pos[3]
        drawGrid(-4, 4, -2, 2, "gray")
        # position of the ball
        pos(x_curr, y_curr)  
        fillCircle(z_curr/30)
        repaint()
        print(i) 
        time.sleep(dt)
        clear()
    keep()
    

def drawEyePositions(positions, interval=1):
    fig, ax = plt.subplots()
    ax.set(xlim=(-3, 3), ylim=(-2, 2))
    redDot, = plt.plot([positions[0][0]], [positions[0][1]], 'ro')
    
    def animate(i):
        redDot.set_data(positions[i][0], positions[i][1])
        return redDot,

    myAnimation = animation.FuncAnimation(fig, animate, frames=range(len(positions)), \
                                      interval=interval, blit=True, repeat=False)

    plt.show()  
   
def getBallPositionsMs(positions, traectory=None):
    # TODO distance and movement
    # positions in every ms, dt = 0.001 seconds
    positions_ms = []
    bounds = range(len(positions) - 1)
    if traectory:
        bounds = range(traectory[0], traectory[1] + traectory[2])
    for i in bounds:
        curr_pos = positions[i]
        next_pos = positions[i+1]
        dt = int((next_pos[0] - curr_pos[0]) * 1000)
        x_curr = round(curr_pos[1], DECIMAL_PLACES)
        y_curr = round(curr_pos[2], DECIMAL_PLACES)
        z_curr = curr_pos[3]
        for ts in range(int(dt)):
            positions_ms.append([x_curr, y_curr, z_curr])
            
    return positions_ms


def getEyePositionsMs(positions):
    eye_positions = copy.deepcopy(positions)
    for i in range(len(positions) - 1):
        curr_pos = positions[i]
        next_pos = positions[i+1]
        x_curr = curr_pos[0]
        y_curr = curr_pos[1]
        z_curr = curr_pos[2]
        x_next = next_pos[0]
        y_next = next_pos[1]
        z_next = next_pos[2]
        dx = x_next - x_curr
        dy = y_next - y_curr
        distance = math.sqrt(dx**2 + dy**2)
        if distance > 0:
            steps = int(distance / EYE_SPEED)
            #print(f"{i} : {distance} : {steps}")
            if steps > 0:
                ddx = dx / steps
                ddy = dy / steps
                for j in range(steps):
                    idx = i + j
                    eye_positions[idx + 1][0] = eye_positions[idx][0] + ddx
                    eye_positions[idx + 1][1] = eye_positions[idx][1] + ddy
                
    return eye_positions

def storeFrames(output_file, traectory=None):
    positions = readBallPositions(path)
    positions_ms = getBallPositionsMs(positions, traectory)     
    eye_positions_ms = getEyePositionsMs(positions_ms)
    eye_positions = eye_positions_ms[0::int(MS_PER_FRAME)]
    print(f"{len(eye_positions)} frames created")
    #drawEyePositions(eye_positions, interval=MS_PER_FRAME)
    
    print(f"storing frames to {output_file} ...")
        
    with open(output_file, 'wt', newline='') as out_file:
        tsv_writer = csv.writer(out_file, delimiter='\t')
        for i, eye_position in enumerate(eye_positions):
            #negate x and y and swap y and z for compatibility with eye model coordinates system
            x = -eye_position[0]*1000
            y = -eye_position[2]*1000
            z = eye_position[1]*1000
            tsv_writer.writerow([f"frame_{i}", x, y, z])
    
    print("done")
    
output_file = 'eye_positions_sine.tsv'
if len(sys.argv) == 2:
    output_file = sys.argv[1]

#storeFrames(output_file)
path = "c70f748e-7691-4fac-ad43-0142bfec92db.eyetrax"
path = 'bfa75fd7-7ed8-4922-a74c-fd0e3be1ffd3.eyetrax'
positions = readBallPositions(path)
#drawBallPositions(positions, SINE)
positions_ms = getBallPositionsMs(positions, SINE)     
eye_positions_ms = getEyePositionsMs(positions_ms)
eye_positions = eye_positions_ms[0::int(MS_PER_FRAME)]
#drawEyePositions(eye_positions, interval=MS_PER_FRAME)

storeFrames('eye_positions_sine.tsv', traectory=SINE)