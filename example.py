#!/usr/bin/python
# coding=utf-8
import sys
import math
import eyemodel

#   ^
#   |    .-.
#   |   |   | <- Head
#   |   `^u^'
# Y |      ¦V <- Camera    (As seen from above)
#   |      ¦
#   |      ¦
#   |      o <- Target
#
#     ----------> X
#
# +X = left
# +Y = back
# +Z = up
x_cam, y_cam, z_cam = 0, -30, -10
x_eye, y_eye, z_eye = 0, -1000, 0

if len(sys.argv) == 4:
    x_eye = int(sys.argv[1])
    y_eye = int(sys.argv[2])
    z_eye = int(sys.argv[3])
    
with eyemodel.Renderer() as r:
    r.eye_target = [x_eye, y_eye, z_eye]
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
            location = [0, -50, -10],
            strength = 3,
            target = [0,0,0]),
        eyemodel.Light(
            strength = 1,
            location = [30, -50, -15],
            target = r.camera_target),
        eyemodel.Light(
            strength = 1,
            location = [-30, -50, -15],
            target = r.camera_target),
        eyemodel.Light(
            strength = 1,
            location = [20, y_cam, 30],
            target = r.camera_target),
        eyemodel.Light(
            strength = 1,
            location = [-20, y_cam, 30],
            target = r.camera_target)
        
    ]

    r.render_samples = 10
    r.render(f"example_{x_eye}_{y_eye}_{z_eye}_right.png", params="example.m", attempts=1)
