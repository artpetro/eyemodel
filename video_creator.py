import os
import sys
import re
import cv2 as cv
from tqdm import tqdm

def atoi(text):
    return int(text) if text.isdigit() else text

def natural_keys(text):
    return [ atoi(c) for c in re.split(r'(\d+)', text) ]

def readFrames(directory, is_left_eye):
    filename = 'frame_[0-9]*_right.png'
    if is_left_eye:
        filename = 'frame_[0-9]*_left.png'
    frames = [x for x in os.listdir(directory) if re.match(filename, x)]
    frames.sort(key=natural_keys)
    return frames

def writeFrames(src_dir, dst_dir, is_left_eye, frames, frame_rate):
    file_name = 'eye0.mp4'
    if is_left_eye:
        file_name = 'eye1.mp4'
    height, width = cv.imread(f'{src_dir}/{frames[0]}').shape[:2]
    size = (width, height)
    out = cv.VideoWriter(f'{dst_dir}/{file_name}', cv.VideoWriter_fourcc(*'mp4v'), frame_rate, size)
    
    for i in tqdm(range(len(frames)), desc = "writing video"):
        img = cv.imread(f'{src_dir}/{frames[i]}')
        img = cv.flip(img, 1)
        if is_left_eye:
            img = cv.flip(img, 0)
        out.write(img)
    out.release()

# creates frames from file
if len(sys.argv) == 3:
    input_dir = sys.argv[1]
    output_dir = sys.argv[2]

    is_left_eye = True
    frames = readFrames(input_dir, is_left_eye)
    writeFrames(input_dir, output_dir, is_left_eye, frames, 200)
    
    is_left_eye = False
    frames = readFrames(input_dir, is_left_eye)
    writeFrames(input_dir, output_dir, is_left_eye, frames, 200)

#is_left_eye = True
#frames = readFrames('output/output', is_left_eye)
#writeFrames('output/output', 'output/video', is_left_eye, frames, 200)