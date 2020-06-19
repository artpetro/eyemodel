#!/usr/bin/python
# coding=utf-8
import sys
import math
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
x_cam, y_cam, z_cam = 0, -30, -10
 
def createFrame(frame_name, eye_target):    
    with eyemodel.Renderer() as r:
        r.eye_target = eye_target
        r.camera_position = [x_cam, y_cam, z_cam]
        r.camera_target = [0, -r.eye_radius, 0]
        r.eye_closedness = 0.0
        r.iris = "light"
        r.image_size = (200, 200)
        r.focal_length = (200/2.5) / math.tan(45*math.pi/180 / 2)
        
        r.pupil_radius = 2
    
        r.lights = [
            eyemodel.Light(
                type="sun",
                location = [10, -10, 100],
                strength = 20,
                target = [0,0,0]),
            eyemodel.Light(
                strength = 5,
                location = [30, -50, -15],
                target = r.camera_target),
            eyemodel.Light(
                strength = 5,
                location = [-30, -50, -15],
                target = r.camera_target)
        ]
    
        r.render_samples = 5
        r.render(f"{frame_name}.png", params=f"{frame_name}.m", attempts=1)

def createFrames(frame_name, gaze_target):
    inter_ocular = 55
    # left eye
    x_eye = gaze_target[0] - inter_ocular
    target = [x_eye, gaze_target[1], gaze_target[2]]
    createFrame(f"{frame_name}_left", target)

    # right eye, finally must be mirrored vertically 
    x_eye = -gaze_target[0] - inter_ocular
    target = [x_eye, gaze_target[1], gaze_target[2]]

    createFrame(f"{frame_name}_right", target)


x_eye, y_eye, z_eye = 0, -1000, 0

if len(sys.argv) == 5:
    frame_name = sys.argv[1]
    x_eye = int(sys.argv[2])
    y_eye = int(sys.argv[3])
    z_eye = int(sys.argv[4])
    
    createFrames(frame_name, [x_eye, y_eye, z_eye])


