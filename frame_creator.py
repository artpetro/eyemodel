#!/usr/bin/python
# coding=utf-8
import sys
import math
import csv
import eyemodel

#   ^
#   |    .-.
#   |   |   | <- Head
#   |   `^u^'
# Y |      �V <- Camera    (As seen from above)
#   |      �
#   |      �
#   |      o <- Target
#
#     ----------> X
#
# +X = left
# +Y = back
# +Z = up
x_cam, y_cam, z_cam = 10, -50, -30
 
def createFrame(frame_name, eye_target, render_samples):    
    with eyemodel.Renderer() as r:
        r.eye_target = eye_target
        r.camera_position = [x_cam, y_cam, z_cam]
        r.camera_target = [0, -r.eye_radius, 0]
        r.eye_closedness = 0.0
        r.iris = "light"
        r.image_size = (200, 200)
        r.focal_length = (200/1.5) / math.tan(45*math.pi/180 / 2)
        
        r.pupil_radius = 1.5
        
        sun = eyemodel.Light(
                type="sun",
                location = [25, -100, 1000],
                strength = 20,
                target = [0,0,0])
    
        r.lights = [
            eyemodel.Light(
                strength = 6,
                location = [30, -50, -15],
                target = r.camera_target),
            eyemodel.Light(
                strength = 6,
                location = [-30, -50, -15],
                target = r.camera_target),
            eyemodel.Light(
                strength = 6,
                location = [0, -50, -15],
                target = r.camera_target),
            eyemodel.Light(
                strength = 6,
                location = [0, -30, 25],
                target = r.camera_target)
        ]
    
        r.render_samples = render_samples
        r.render(f"{frame_name}.png", params=f"{frame_name}.m", attempts=1)

def createFrames(frame_name, gaze_target, render_samples):
    inter_ocular = 55
    # left eye
    x_eye = gaze_target[0] - inter_ocular
    target = [x_eye, gaze_target[1], gaze_target[2]]
    createFrame(f"{frame_name}_left", target, render_samples)

    # right eye, finally must be mirrored vertically 
    x_eye = -gaze_target[0] - inter_ocular
    target = [x_eye, gaze_target[1], gaze_target[2]]

    createFrame(f"{frame_name}_right", target, render_samples)


x_eye, y_eye, z_eye = 0, -1000, 0

# create two frames with given target
if len(sys.argv) == 7:
    frame_name = sys.argv[1]
    output_dir = sys.argv[2]
    x_eye = int(sys.argv[3])
    y_eye = int(sys.argv[4])
    z_eye = int(sys.argv[5])
    render_samples = int(sys.argv[6])
    
    createFrames(f"{output_dir}/{frame_name}", [x_eye, y_eye, z_eye], render_samples)

# creates frames from file
if len(sys.argv) == 6:
    input_file = sys.argv[1]
    output_dir = sys.argv[2]
    render_samples = int(sys.argv[3])
    start_frame = int(sys.argv[4])
    end_frame = int(sys.argv[5])
    
    with open(input_file, 'r', newline='') as tsvfile:
        reader = csv.reader(tsvfile, delimiter='\t')
        for i, row in enumerate(reader):
            if len(row) == 4 and i >= start_frame and i <= end_frame:
                frame_name = row[0]
                x_eye = float(row[1])
                y_eye = float(row[2])
                z_eye = float(row[3])
                createFrames(f"{output_dir}/{frame_name}", [x_eye, y_eye, z_eye], render_samples)