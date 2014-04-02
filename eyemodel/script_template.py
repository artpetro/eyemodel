import bpy
import math
import mathutils
import os
import sys
import functools
import collections
from mathutils import Vector, Matrix
try:
    import numpy as np
except:
    np = None

Light = collections.namedtuple("Light", ["location", "target", "size", "strength", "view_angle"])

$INPUTS

scene = bpy.context.scene
armature = bpy.data.objects['Armature Head']
camera_obj = bpy.data.objects['Camera']
camera = bpy.data.cameras['Camera']

eyeL = bpy.data.objects['eye.L']

eyeLbone = armature.pose.bones['def_eye.L']
pupilLbone = armature.pose.bones['eyepulpex.L']
eyeLblinkbone = armature.pose.bones['eyeblink.L']
eyeRbone = armature.pose.bones['def_eye.R']
pupilRbone = armature.pose.bones['eyepulpex.R']
eyeRblinkbone = armature.pose.bones['eyeblink.R']

cornea_material = bpy.data.materials['eye cornea']

armature_matrix = armature.matrix_world

scene.frame_current = 0
scene.frame_start = 0
scene.frame_end = 0

# Get world eye radius and centre
# All other locations are translated/scaled to be relative to these
eye_radius = eyeLbone.bone.length
eye_centre = armature_matrix*eyeLbone.head

def input_to_world(val):
    scale = eye_radius/input_eye_radius
    if isinstance(val, Vector):
        return (val - input_eye_pos) * scale + eye_centre
    else:
        return val*scale

def world_to_input(val):
    scale = eye_radius/input_eye_radius
    if isinstance(val, Vector):
        return (val - eye_centre) / scale + input_eye_pos
    else:
        return val/scale

def look_at_mat(target, up, pos):
    zaxis = (target - pos).normalized()
    xaxis = up.cross(zaxis).normalized()
    yaxis = zaxis.cross(xaxis).normalized()
    return Matrix([xaxis, yaxis, zaxis]).transposed()

def look_at(obj, target, up, pos, initPoseMat):
    if isinstance(obj, bpy.types.PoseBone):
        pos = armature_matrix * obj.head
    else:
        pos = obj.location

    obj_rot_mat = look_at_mat(target,up,pos) * initPoseMat
    #obj_rot_mat = initPoseMat

    if obj.parent:
        P = obj.parent.matrix.decompose()[1].to_matrix()
        obj_rot_mat = P * obj_rot_mat * P.inverted()

    obj.rotation_mode = 'QUATERNION'
    obj.rotation_quaternion = obj_rot_mat.to_quaternion()

corneaGroup = eyeL.vertex_groups['eyecornea.L']
corneaVertices = [v for v in eyeL.data.vertices if corneaGroup.index in [g.group for g in v.groups]]

def fitsphere(points):
    n = len(points)
    points = np.asarray(points)
    centroid = np.mean(points, axis=0)

    points = points - centroid
    sqmag = [[sum(x*x for x in p)] for p in points]

    Z = np.bmat([sqmag, points, np.ones((n,1))])

    M = Z.T * Z / n

    R = np.ravel(np.asarray(M[-1,:]))
    N = np.eye(len(R), dtype=points.dtype)
    N[:,0] = 4*R
    N[0,:] = 4*R
    N[0,0] = 8*R[0]
    N[-1,0] = 2
    N[0,-1] = 2
    N[-1,-1] = 0

    # M A = mu N A = N mu A
    # inv(N)M A = mu A
    mu,E = np.linalg.eig(np.linalg.inv(N)*M);
    idx = np.argsort(mu);
    A = E[:,idx[1]];

    A = np.ravel(np.asarray(A))

    return (-A[1:-1]/A[0]/2 + centroid,
              math.sqrt((sum(a*a for a in A[1:-1]) - 4*A[0]*A[-1]))/abs(A[0])/2)

if np:
    eye_cornea_centre, eye_cornea_radius = fitsphere([tuple(v.co) for v in corneaVertices])
    eye_cornea_centre = Vector(eye_cornea_centre)
    cornea_centre = eyeL.matrix_local * eye_cornea_centre
    cornea_radius = (eyeL.matrix_local * (eye_cornea_centre+Vector((eye_cornea_radius,0,0))) - cornea_centre).length
else:
    # If the user doesn't have numpy, don't dynamically calculate cornea params, just use hardcoded
    cornea_centre = input_to_world(Vector([-0.016783643513917923, -5.577363014221191, 0.04836755618453026]))
    cornea_radius = input_to_world(7.922206814944914)
    print("WARNING: Blender's python installation doesn't have numpy, using hardcoded cornea parameters")


for obj in list(bpy.data.objects):
    if obj.type == 'LAMP':
        scene.objects.unlink(obj)
        bpy.data.objects.remove(obj)

# Add lights
for i,light in enumerate(input_lights):
    # Create new lamp datablock
    lamp_data = bpy.data.lamps.new(name="Lamp.{}".format(i), type='SPOT')

    # Create new object with our lamp datablock
    lamp_object = bpy.data.objects.new(name="Lamp.{}".format(i), object_data=lamp_data)

    # Link lamp object to the scene so it'll appear in this scene
    scene.objects.link(lamp_object)

    lamp_data.use_nodes = True

    lamp_object.location = input_to_world(light.location)
    look_at(lamp_object,
            input_to_world(light.target),
            input_to_world(input_cam_up) - input_to_world(Vector([0,0,0])),
            light.location,
            Matrix([[-1, 0, 0],
                    [ 0, 1, 0],
                    [ 0, 0,-1]]))
    lamp_data.shadow_soft_size = input_to_world(light.size)
    lamp_data.spot_size = light.view_angle*math.pi/180
    lamp_data.spot_blend = 1.0
    lamp_data.node_tree.nodes['Emission'].inputs['Strength'].default_value = light.strength
    lamp_data.cycles.use_multiple_importance_sample = True
    lamp_data.show_cone = True

# Remove eye IK constraint
for c in list(eyeLbone.constraints.values()):
    eyeLbone.constraints.remove(c)
for c in list(eyeRbone.constraints.values()):
    eyeRbone.constraints.remove(c)

# Set eye target
look_at(eyeLbone,
        input_to_world(input_eye_target),
        (input_to_world(input_eye_up) - input_to_world(Vector([0,0,0]))),
        eye_centre,
        Matrix([[ 1, 0, 0],
                [ 0, 0, 1],
                [ 0,-1, 0]]))
look_at(eyeRbone,
        input_to_world(input_eye_target),
        (input_to_world(input_eye_up) - input_to_world(Vector([0,0,0]))),
        eye_centre,
        Matrix([[ 1, 0, 0],
                [ 0, 0, 1],
                [ 0,-1, 0]]))

# Set eye blink location
eyeLblinkbone.location[2] = input_eye_closedness * eyeLblinkbone.constraints['Limit Location'].max_z
eyeRblinkbone.location[2] = input_eye_closedness * eyeRblinkbone.constraints['Limit Location'].max_z


# Calculate base pupil diameter by finding mean distance of pupil vertex to pupil vertex centroid
pupilGroup = eyeL.vertex_groups['eyepulpex.L']
pupilVertices = [eyeL.matrix_local * v.co for v in eyeL.data.vertices if pupilGroup.index in [g.group for g in v.groups]]
pupilVertexCentre = functools.reduce(lambda x,y: x+y, pupilVertices)/len(pupilVertices)
pupil_base_radius = sum((v-pupilVertexCentre).length for v in pupilVertices)/len(pupilVertices)
# Set pupil scale
pupil_scale = input_to_world(input_pupil_radius) / pupil_base_radius
if pupil_scale < pupilLbone.constraints["Limit Scaling"].min_x:
    raise RuntimeError("Pupil size {} is too small. Minimum size is {}".format(
                        input_pupil_radius,
                        world_to_input(pupilLbone.constraints["Limit Scaling"].min_x * pupil_base_radius)))
if pupil_scale > pupilLbone.constraints["Limit Scaling"].max_x:
    raise RuntimeError("Pupil size {} is too large. Maximum size is {}".format(
                        input_pupil_radius,
                        world_to_input(pupilLbone.constraints["Limit Scaling"].max_x * pupil_base_radius)))
pupilLbone.scale = Vector([pupil_scale,1,pupil_scale])
pupilRbone.scale = Vector([pupil_scale,1,pupil_scale])


# Calculate iris radius by finding mean distance of iris vertex to iris vertex centroid
irisGroup = eyeL.vertex_groups['eyeiris.L']
irisVertices = [eyeL.matrix_local * v.co for v in eyeL.data.vertices if irisGroup.index in [g.group for g in v.groups]]
irisVertexCentre = functools.reduce(lambda x,y: x+y, irisVertices)/len(irisVertices)
iris_radius = sum((v-irisVertexCentre).length for v in irisVertices)/len(irisVertices)

cornea_material.node_tree.nodes['TrickyGlass'].inputs[
    cornea_material.node_tree.nodes['TrickyGlass'].inputs.find('IOR') # workaround for blender bug
].default_value = input_eye_cornea_refrative_index

# Set camera location
camera_obj.location = input_to_world(input_cam_pos)
# Set camera target
look_at(camera_obj,
        input_to_world(input_cam_target),
        input_to_world(input_cam_up) - input_to_world(Vector([0,0,0])),
        camera_obj.location,
        Matrix([[-1, 0, 0],
                [ 0, 1, 0],
                [ 0, 0,-1]]))

scene.render.resolution_x = input_cam_image_size[0]
scene.render.resolution_y = input_cam_image_size[1]

camera.sensor_width = 35.
camera.sensor_height = camera.sensor_width*input_cam_image_size[1]/input_cam_image_size[0]
camera.lens_unit = 'MILLIMETERS'
camera.lens = camera.sensor_width * input_cam_focal_length / input_cam_image_size[0]
camera.dof_distance = input_to_world(input_cam_focus_distance)
camera.cycles.aperture_fstop = input_cam_fstop

scene.cycles.aa_samples = input_render_samples

scene.update()

# Use CUDA if possible
try:
    bpy.context.user_preferences.system.compute_device_type = 'CUDA'
except:
    pass

if output_params_path:
    def mlabVec(vec):
        return "[{}]".format(", ".join(str(x) for x in vec))
    def mlabMat(mat):
        return "[{}]".format(";".join(mlabVec(x) for x in mat))

    # Get actual pupil vertex positions by applying modifiers to eye mesh
    eyeL_mesh = eyeL.to_mesh(scene, True, 'RENDER')
    def isPupil(vertex):
        for g in vertex.groups:
            if g.group == pupilGroup.index and g.weight == 1.0:
                return True

    pupilRealVertices = [eyeL.matrix_local * v.co for v in eyeL_mesh.vertices if isPupil(v)]

    with open(output_params_path, "w") as params_file:
        lines = [
            "eye_pos = {};".format(mlabVec(input_eye_pos)),
            "eye_target = {};".format(mlabVec(input_eye_target)),
            "eye_radius = {};".format(input_eye_radius),
            "cornea_centre = {};".format(mlabVec(world_to_input(cornea_centre))),
            "cornea_radius = {};".format(world_to_input(cornea_radius)),
            "iris_radius = {};".format(world_to_input(iris_radius)),
            "pupil_centre = {};".format(mlabVec(world_to_input(armature_matrix * eyeLbone.tail))),
            "pupil_radius = {};".format(input_pupil_radius),
            "",
            "eye_matrix = {};".format(mlabMat(look_at_mat(pos=input_eye_pos,
                                                   target=input_eye_target,
                                                   up=input_eye_up)*Matrix([[-1, 0, 0],[ 0, 1, 0],[ 0, 0,-1]]))),
            "eye = eye_make(cornea_radius, eye_matrix);",
            "eye.pos_cornea = [cornea_centre(1) -cornea_centre(3) cornea_centre(2) 1]';",
            "eye.depth_cornea = cornea_radius - sqrt(cornea_radius^2 - iris_radius^2);",
            "eye.n_cornea = {};".format(input_eye_cornea_refrative_index),
            "eye.pos_apex = eye.pos_cornea + [0 0 -cornea_radius 0]';",
            "eye.pos_pupil = [eye_matrix \ pupil_centre' ; 1];",
            "eye.across_pupil = [pupil_radius 0 0 0]';",
            "eye.up_pupil = [0 pupil_radius 0 0]';",
            "",
            "camera_pos = {};".format(mlabVec(input_cam_pos)),
            "camera_target = {};".format(mlabVec(input_cam_target)),
            "",
            "camera_matrix = {};".format(mlabMat(look_at_mat(pos=input_cam_pos,
                                                   target=input_cam_target,
                                                   up=input_cam_up)*Matrix([[-1, 0, 0],[ 0, 1, 0],[ 0, 0,-1]]))),
            "camera = camera_make();",
            "camera.trans = [camera_matrix camera_pos' ; 0 0 0 1];",
            "camera.rest_trans = camera.trans;",
            "camera.focal_length = {};".format(input_cam_focal_length),
            "camera.resolution = [{} {}];".format(*input_cam_image_size),
            "",
        ]
        for i,light in enumerate(input_lights):
            lines += [
                "light{} = light_make();".format(i),
                "light{}.pos = [{} 1]';".format(i, mlabVec(light.location)),
                "cr{i} = eye_find_cr(eye, light{i}, camera);".format(i=i),
                "",
            ]
        lines += [
            "pupil_vertices = [ " + ";".join(" ".join(str(x) for x in world_to_input(v)) + " 1" for v in pupilRealVertices) + "]';"
            "",
        ]
        lines += [
            "figure(1)",
            "clf;",
            "hold on;",
            "eye_draw(eye);",
            "plot3([eye_pos(1)], [eye_pos(2)], [eye_pos(3)], 'bx');",
            "trans_cornea_centre = eye_matrix * eye.pos_cornea(1:3);",
            "plot3([trans_cornea_centre(1)], [trans_cornea_centre(2)], [trans_cornea_centre(3)], 'gx');",
            "trans_pupil_centre = eye_matrix * eye.pos_pupil(1:3);",
            "plot3([trans_pupil_centre(1)], [trans_pupil_centre(2)], [trans_pupil_centre(3)], 'rx');",
            "pupil_circle = eye_get_pupil(eye);",
            "pupil_circle = [pupil_circle pupil_circle(:,1)];",
            "plot3(pupil_circle(1,:), pupil_circle(2,:), pupil_circle(3,:), 'm-');",
            "eye_target_short = 2 * eye_radius * eye_target / norm(eye_target);",
            "plot3([eye_pos(1) eye_target_short(1)], [eye_pos(2) eye_target_short(2)], [eye_pos(3) eye_target_short(3)], 'b--');",
            "",
            "plot3(camera.trans(1,4), camera.trans(2,4), camera.trans(3,4), 'k*');",
            "",
            "up=[0 5 0 1]';",
            "across=[10 0 0 1]';",
            "in=[0 0 -5 1]';",
            "trans_up = camera.trans*up;",
            "trans_across = camera.trans*across;",
            "trans_in = camera.trans*in;",
            "plot3([camera.trans(1,4) trans_up(1)], [camera.trans(2,4) trans_up(2)], [camera.trans(3,4) trans_up(3)], 'k-');",
            "plot3([camera.trans(1,4) trans_across(1)], [camera.trans(2,4) trans_across(2)], [camera.trans(3,4) trans_across(3)], 'k-');",
            "plot3([camera.trans(1,4) trans_in(1)], [camera.trans(2,4) trans_in(2)], [camera.trans(3,4) trans_in(3)], 'k:');",
            "",
        ]
        for i,light in enumerate(input_lights):
            lines += [
                "light_draw(light{i});".format(i=i),
                "if ~isempty(cr{i})".format(i=i),
                "    plot3(cr{i}(1), cr{i}(2), cr{i}(3), 'xr');".format(i=i),
                "end",
            ]
        lines += [
            "",
            "hold off;",
            "axis equal;",
            "xlim auto;",
            "ylim auto;",
            "zlim auto;",
            "view(45, 2*eye_radius);",
            "",
        ]
        lines += [
            "figure(2);",
            "clf;",
            "I = imread('{}');".format(output_render_path),
            "imshow(I);",
            "hold on;",
            "pupil_refracted_vertices = zeros(4,0);",
            "for i=1:size(pupil_vertices, 2)",
            "    img=eye_find_refraction(eye, camera.trans(:,4), pupil_vertices(:,i));",
            "    if ~isempty(img)",
            "        pupil_refracted_vertices(:,end+1)=img;",
            "    end",
            "end",
            "pupil_points = camera_project(camera, pupil_refracted_vertices);",
            "pupil_points = pupil_points(:, convhull(pupil_points'));",
            "plot(camera.resolution(1)/2 + pupil_points(1,:), camera.resolution(2)/2 - pupil_points(2,:), '-m', 'LineWidth', 1.5);",
        ]
        for i,light in enumerate(input_lights):
            lines += [
                "if ~isempty(cr{i})".format(i=i),
                "    pcr = camera_project(camera, cr{i});".format(i=i),
                "    plot(camera.resolution(1)/2 + pcr(1), camera.resolution(2)/2 - pcr(2), 'xr', 'LineWidth', 1.5, 'MarkerSize', 15);".format(i=i),
                "end",
            ]
        lines += [
            "hold off;"
        ]
        params_file.write("\n".join(lines))
        #params_file.write("pupil centre = {}\n".format(strVec(world_to_input(armature_matrix * eyeLbone.tail))))
        #    " centre = {}\n".format(strVec(world_to_input(eye_centre))))
        #params_file.write("eye centre = {}\n".format(strVec(world_to_input(eye_centre))))
        #params_file.write("eye radius = {}\n".format(world_to_input(eye_radius)))
        #params_file.write("eye target = {}\n".format(strVec(input_eye_target)))
        #params_file.write("eye up = {}\n".format(strVec(input_eye_up)))
        #params_file.write("eye closedness = {}\n".format(input_eye_closedness))
        #params_file.write("cornea centre = {}\n".format(strVec(world_to_input(cornea_centre))))
        #params_file.write("cornea radius = {}\n".format(world_to_input(cornea_radius)))
        #params_file.write("cornea refractive index = {}\n".format(input_eye_cornea_refrative_index))
        #params_file.write("pupil centre = {}\n".format(strVec(world_to_input(armature_matrix * eyeLbone.tail))))
        #params_file.write("pupil radius = {}\n".format(world_to_input(pupilLbone.scale.x * pupil_base_radius)))
        #params_file.write("iris radius = {}\n".format(world_to_input(iris_base_radius)))
        #params_file.write("camera position = {}\n".format(strVec(world_to_input(camera_obj.location))))
        #params_file.write("camera target = {}\n".format(strVec(input_cam_target)))
        #params_file.write("camera up = {}\n".format(strVec(input_cam_up)))
        #params_file.write("camera focal length = {}\n".format(input_cam_focal_length))
        #params_file.write("camera focus distance = {}\n".format(input_cam_focus_distance))
        #params_file.write("camera fstop = {}\n".format(input_cam_fstop))
        #params_file.write("image size = {}\n".format(tuple(input_cam_image_size)))
