eye_pos = [0.0, 0.0, 0.0];
eye_target = [-55.0, -5000.0, 1500.0];
eye_radius = 12.0;
cornea_centre = [-0.016783643513917923, -5.577363014221191, 0.04836755618453026];
cornea_radius = 7.922206814944914;
iris_radius = 4.770825802016765;
pupil_centre = [-0.12642410397529602, -11.493279457092285, 3.447996139526367];
pupil_radius = 1.5;

eye_matrix = [[-0.999939501285553, 0.003160460153594613, 0.010535504668951035];[0.01099933497607708, 0.2873145639896393, 0.9577731490135193];[0.0, 0.957831084728241, -0.2873319387435913]];
eye = eye_make(cornea_radius, eye_matrix);
eye.pos_cornea = [cornea_centre(1) -cornea_centre(3) cornea_centre(2) 1]';
eye.depth_cornea = cornea_radius - sqrt(cornea_radius^2 - iris_radius^2);
eye.n_cornea = 1.336;
eye.pos_apex = eye.pos_cornea + [0 0 -cornea_radius 0]';
eye.pos_pupil = [eye_matrix \ pupil_centre' ; 1];
eye.across_pupil = [pupil_radius 0 0 0]';
eye.up_pupil = [0 pupil_radius 0 0]';

camera_pos = [0.0, -30.0, -15.0];
camera_target = [0.0, -12.0, 0.0];

camera_matrix = [[1.0, 0.0, 0.0];[0.0, -0.6401844024658203, -0.7682212591171265];[0.0, 0.7682212591171265, -0.6401844024658203]];
camera = camera_make();
camera.trans = [camera_matrix camera_pos' ; 0 0 0 1];
camera.rest_trans = camera.trans;
camera.focal_length = 193.1370849898476;
camera.resolution = [200 200];

light0 = light_make();
light0.pos = [[30.0, -50.0, -15.0] 1]';
cr0 = eye_find_cr(eye, light0, camera);

light1 = light_make();
light1.pos = [[-30.0, -50.0, -15.0] 1]';
cr1 = eye_find_cr(eye, light1, camera);

light2 = light_make();
light2.pos = [[0.0, -50.0, -15.0] 1]';
cr2 = eye_find_cr(eye, light2, camera);

light3 = light_make();
light3.pos = [[0.0, -30.0, 25.0] 1]';
cr3 = eye_find_cr(eye, light3, camera);

pupil_vertices = [ 0.27438122034072876 -11.063693046569824 4.8654022216796875 1;0.1351589858531952 -11.051644325256348 4.8992695808410645 1;-0.00672739464789629 -11.043572425842285 4.919982433319092 1;1.138076901435852 -11.2814302444458 4.186152458190918 1;1.0650243759155273 -11.24449634552002 4.304361343383789 1;0.9803663492202759 -11.209714889526367 4.41504430770874 1;0.539585292339325 -11.099020957946777 4.760288715362549 1;0.6629486083984375 -11.121952056884766 4.690074443817139 1;0.7784051299095154 -11.148159980773926 4.608785629272461 1;-1.4474619626998901 -11.65208911895752 2.864736557006836 1;-1.3744094371795654 -11.689021110534668 2.7465271949768066 1;-1.2897541522979736 -11.723804473876953 2.635849714279175 1;-1.5566039085388184 -11.573322296142578 3.118731737136841 1;-1.5916131734848022 -11.532269477844238 3.252009391784668 1;-1.6128674745559692 -11.490618705749512 3.387800693511963 1;-1.4430100917816162 -11.249726295471191 4.185112476348877 1;-1.369164228439331 -11.214597702026367 4.3033833503723145 1;-1.2837638854980469 -11.181902885437012 4.414130687713623 1;-0.5747419595718384 -11.053265571594238 4.86507511138916 1;-0.43529194593429565 -11.044638633728027 4.899046897888184 1;-0.2932634949684143 -11.040053367614746 4.919872760772705 1;1.2472214698791504 -11.360194206237793 3.9321515560150146 1;1.282233476638794 -11.401247024536133 3.7988686561584473 1;1.3034850358963013 -11.44289493560791 3.663074493408203 1;-1.5538647174835205 -11.325791358947754 3.931025981903076 1;-1.589774489402771 -11.365973472595215 3.7977190017700195 1;-1.6119427680969238 -11.407088279724121 3.6619112491607666 1;-0.8406563401222229 -11.08206844329834 4.759744644165039 1;-0.964493989944458 -11.101962089538574 4.689431190490723 1;-1.08049738407135 -11.125326156616211 4.608043193817139 1;-0.8489677309989929 -11.834492683410645 2.2905921936035156 1;-0.9723337292671204 -11.811563491821289 2.360809087753296 1;-1.087792992591858 -11.785355567932129 2.442103385925293 1;1.2444822788238525 -11.607726097106934 3.119852066040039 1;1.280392050743103 -11.567541122436523 3.2531564235687256 1;1.3025603294372559 -11.5264253616333 3.3889639377593994 1;0.5312739014625549 -11.851442337036133 2.291144371032715 1;0.6551088690757751 -11.831549644470215 2.3614604473114014 1;0.7711122035980225 -11.808186531066895 2.4428484439849854 1;-0.5837636590003967 -11.869819641113281 2.1854679584503174 1;-0.44453874230384827 -11.881867408752441 2.1516003608703613 1;-0.30265235900878906 -11.88994026184082 2.130890369415283 1;1.133630394935608 -11.683788299560547 2.8657736778259277 1;1.059779167175293 -11.718917846679688 2.7475056648254395 1;0.9743787050247192 -11.75161075592041 2.6367580890655518 1;0.2653649151325226 -11.880247116088867 2.1858084201812744 1;0.12591485679149628 -11.888872146606445 2.1518256664276123 1;-0.016113584861159325 -11.893458366394043 2.131002902984619 1;1.1953803300857544 -11.646599769592285 2.9903056621551514 1;0.400920569896698 -11.867722511291504 2.232417583465576 1;-0.7190084457397461 -11.85396957397461 2.2319726943969727 1;-1.5083703994750977 -11.61339282989502 2.989220142364502 1;-1.5047601461410522 -11.286917686462402 4.060575008392334 1;-0.7103003263473511 -11.065788269042969 4.8184685707092285 1;0.40962597727775574 -11.079544067382812 4.818902492523193 1;1.1989879608154297 -11.320125579833984 4.0616607666015625 1;1.310440182685852 -11.48475170135498 3.5260233879089355 1;0.8779759407043457 -11.78149127960205 2.5347886085510254 1;-0.1594097763299942 -11.893860816955566 2.123852014541626 1;-1.1940348148345947 -11.756044387817383 2.5339577198028564 1;-1.61982262134552 -11.448761940002441 3.5248520374298096 1;-1.1873583793640137 -11.152021408081055 4.5161004066467285 1;-0.14996998012065887 -11.039649963378906 4.927023410797119 1;0.8846497535705566 -11.177473068237305 4.516933917999268 1]';
figure(1)
clf;
hold on;
eye_draw(eye);
plot3([eye_pos(1)], [eye_pos(2)], [eye_pos(3)], 'bx');
trans_cornea_centre = eye_matrix * eye.pos_cornea(1:3);
plot3([trans_cornea_centre(1)], [trans_cornea_centre(2)], [trans_cornea_centre(3)], 'gx');
trans_pupil_centre = eye_matrix * eye.pos_pupil(1:3);
plot3([trans_pupil_centre(1)], [trans_pupil_centre(2)], [trans_pupil_centre(3)], 'rx');
pupil_circle = eye_get_pupil(eye);
pupil_circle = [pupil_circle pupil_circle(:,1)];
plot3(pupil_circle(1,:), pupil_circle(2,:), pupil_circle(3,:), 'm-');
eye_target_short = 2 * eye_radius * eye_target / norm(eye_target);
plot3([eye_pos(1) eye_target_short(1)], [eye_pos(2) eye_target_short(2)], [eye_pos(3) eye_target_short(3)], 'b--');

plot3(camera.trans(1,4), camera.trans(2,4), camera.trans(3,4), 'k*');

up=[0 5 0 1]';
across=[10 0 0 1]';
in=[0 0 -5 1]';
trans_up = camera.trans*up;
trans_across = camera.trans*across;
trans_in = camera.trans*in;
plot3([camera.trans(1,4) trans_up(1)], [camera.trans(2,4) trans_up(2)], [camera.trans(3,4) trans_up(3)], 'k-');
plot3([camera.trans(1,4) trans_across(1)], [camera.trans(2,4) trans_across(2)], [camera.trans(3,4) trans_across(3)], 'k-');
plot3([camera.trans(1,4) trans_in(1)], [camera.trans(2,4) trans_in(2)], [camera.trans(3,4) trans_in(3)], 'k:');

light_draw(light0);
if ~isempty(cr0)
    plot3(cr0(1), cr0(2), cr0(3), 'xr');
end
light_draw(light1);
if ~isempty(cr1)
    plot3(cr1(1), cr1(2), cr1(3), 'xr');
end
light_draw(light2);
if ~isempty(cr2)
    plot3(cr2(1), cr2(2), cr2(3), 'xr');
end
light_draw(light3);
if ~isempty(cr3)
    plot3(cr3(1), cr3(2), cr3(3), 'xr');
end

hold off;
axis equal;
xlim auto;
ylim auto;
zlim auto;
view(45, 2*eye_radius);

figure(2);
clf;
I = imread('output/frames/frame_0_left.png');
imshow(I);
hold on;
pupil_refracted_vertices = zeros(4,0);
for i=1:size(pupil_vertices, 2)
    img=eye_find_refraction(eye, camera.trans(:,4), pupil_vertices(:,i));
    if ~isempty(img)
        pupil_refracted_vertices(:,end+1)=img;
    end
end
pupil_points = camera_project(camera, pupil_refracted_vertices);
pupil_points = pupil_points(:, convhull(pupil_points(1,:)', pupil_points(2,:)'));
plot(camera.resolution(1)/2 + pupil_points(1,:), camera.resolution(2)/2 - pupil_points(2,:), '-m', 'LineWidth', 1.5);
points=[(1/2 + pupil_points(1,:)/camera.resolution(1)); (1/2 - pupil_points(2,:)/camera.resolution(2))];
n=size(points(1,:), 2);
fprintf('[');
for i=1:n-1
	fprintf('[%f, %f], ', points(1,i), points(2,i));
end
fprintf('[%f, %f]]', points(1,n), points(2,n));
fprintf('\n');

if ~isempty(cr0)
    pcr = camera_project(camera, cr0);
    plot(camera.resolution(1)/2 + pcr(1), camera.resolution(2)/2 - pcr(2), 'xr', 'LineWidth', 1.5, 'MarkerSize', 15);
end
if ~isempty(cr1)
    pcr = camera_project(camera, cr1);
    plot(camera.resolution(1)/2 + pcr(1), camera.resolution(2)/2 - pcr(2), 'xr', 'LineWidth', 1.5, 'MarkerSize', 15);
end
if ~isempty(cr2)
    pcr = camera_project(camera, cr2);
    plot(camera.resolution(1)/2 + pcr(1), camera.resolution(2)/2 - pcr(2), 'xr', 'LineWidth', 1.5, 'MarkerSize', 15);
end
if ~isempty(cr3)
    pcr = camera_project(camera, cr3);
    plot(camera.resolution(1)/2 + pcr(1), camera.resolution(2)/2 - pcr(2), 'xr', 'LineWidth', 1.5, 'MarkerSize', 15);
end
hold off;