eye_pos = [0.0, 0.0, 0.0];
eye_target = [-55.0, -5000.0, -1500.0];
eye_radius = 12.0;
cornea_centre = [-0.016783643513917923, -5.577363014221191, 0.04836755618453026];
cornea_radius = 7.922206814944914;
iris_radius = 4.770825802016765;
pupil_centre = [-0.12642410397529602, -11.493285179138184, -3.447974920272827];
pupil_radius = 1.5;

eye_matrix = [[-0.999939501285553, -0.003160460153594613, 0.010535504668951035];[0.01099933497607708, -0.2873145639896393, 0.9577731490135193];[0.0, 0.957831084728241, 0.2873319387435913]];
eye = eye_make(cornea_radius, eye_matrix);
eye.pos_cornea = [cornea_centre(1) -cornea_centre(3) cornea_centre(2) 1]';
eye.depth_cornea = cornea_radius - sqrt(cornea_radius^2 - iris_radius^2);
eye.n_cornea = 1.336;
eye.pos_apex = eye.pos_cornea + [0 0 -cornea_radius 0]';
eye.pos_pupil = [eye_matrix \ pupil_centre' ; 1];
eye.across_pupil = [pupil_radius 0 0 0]';
eye.up_pupil = [0 pupil_radius 0 0]';

camera_pos = [10.0, -50.0, -30.0];
camera_target = [0.0, -12.0, 0.0];

camera_matrix = [[0.9670745730400085, 0.15443545579910278, 0.20227834582328796];[0.2544933259487152, -0.5868546962738037, -0.7686576843261719];[0.0, 0.7948278188705444, -0.6068350076675415]];
camera = camera_make();
camera.trans = [camera_matrix camera_pos' ; 0 0 0 1];
camera.rest_trans = camera.trans;
camera.focal_length = 321.89514164974605;
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

pupil_vertices = [ 0.265032559633255 -11.915494918823242 -2.0257418155670166 1;0.12558786571025848 -11.923823356628418 -1.991684079170227 1;-0.016437893733382225 -11.928227424621582 -1.9708024263381958 1;1.1332175731658936 -11.724991798400879 -2.707468271255493 1;1.059382438659668 -11.759086608886719 -2.5888891220092773 1;0.9739981293678284 -11.790810585021973 -2.4778497219085693 1;0.5309334993362427 -11.887615203857422 -2.1313459873199463 1;0.654760479927063 -11.868338584899902 -2.2018415927886963 1;0.7707557678222656 -11.845687866210938 -2.2834386825561523 1;-1.4435917139053345 -11.30245590209961 -4.030352592468262 1;-1.369759202003479 -11.268363952636719 -4.148929119110107 1;-1.2843722105026245 -11.236639022827148 -4.259963512420654 1;-1.55441415309906 -11.37629508972168 -3.775604248046875 1;-1.590305209159851 -11.41530990600586 -3.641948938369751 1;-1.6124573945999146 -11.45523738861084 -3.505782127380371 1;-1.4478747844696045 -11.69326400756836 -2.706503391265869 1;-1.3748061656951904 -11.729166030883789 -2.5879805088043213 1;-1.2901374101638794 -11.762981414794922 -2.4770026206970215 1;-0.5840933322906494 -11.905065536499023 -2.025425672531128 1;-0.44486573338508606 -11.916818618774414 -1.991466999053955 1;-0.30297666788101196 -11.92470932006836 -1.9707005023956299 1;1.244037389755249 -11.651152610778809 -2.96221661567688 1;1.2799310684204102 -11.612135887145996 -3.095869302749634 1;1.3020832538604736 -11.572208404541016 -3.2320334911346436 1;-1.5570487976074219 -11.616719245910645 -2.961176872253418 1;-1.5920741558074951 -11.576830863952637 -3.0948026180267334 1;-1.6133445501327515 -11.536368370056152 -3.2309534549713135 1;-0.8493081331253052 -11.870658874511719 -2.130831241607666 1;-0.9726821184158325 -11.84834098815918 -2.201233148574829 1;-1.0881494283676147 -11.822842597961426 -2.2827417850494385 1;-0.8413049578666687 -11.139823913574219 -4.606461524963379 1;-0.9651345610618591 -11.159103393554688 -4.535968780517578 1;-1.0811299085617065 -11.181758880615234 -4.454371452331543 1;1.2466720342636108 -11.410728454589844 -3.776638984680176 1;1.2817027568817139 -11.450615882873535 -3.643010377883911 1;1.3029731512069702 -11.49107837677002 -3.5068624019622803 1;0.538939356803894 -11.156786918640137 -4.606978893280029 1;0.6623079776763916 -11.179104804992676 -4.536569118499756 1;0.7777779698371887 -11.20460319519043 -4.455055236816406 1;-0.5754039883613586 -11.1119384765625 -4.712068557739258 1;-0.4359593093395233 -11.103608131408691 -4.746129035949707 1;-0.29393622279167175 -11.099204063415527 -4.767007827758789 1;1.137497901916504 -11.334181785583496 -4.031304359436035 1;1.0644292831420898 -11.298280715942383 -4.149827003479004 1;0.9797606468200684 -11.26446533203125 -4.260799407958984 1;0.2737218737602234 -11.12237548828125 -4.7123847007751465 1;0.13449697196483612 -11.110620498657227 -4.746340751647949 1;-0.007394773885607719 -11.102727890014648 -4.7671098709106445 1;1.198425054550171 -11.371789932250977 -3.9064910411834717 1;0.40897199511528015 -11.137821197509766 -4.6657538414001465 1;-0.7109543085098267 -11.124055862426758 -4.665338516235352 1;-1.5053282976150513 -11.338555335998535 -3.905493974685669 1;-1.5087991952896118 -11.655656814575195 -2.831327438354492 1;-0.7193434238433838 -11.889622688293457 -2.072056293487549 1;0.4005882143974304 -11.903380393981934 -2.072471857070923 1;1.1949515342712402 -11.688892364501953 -2.8323323726654053 1;1.3099497556686401 -11.531734466552734 -3.3694491386413574 1;0.8840306401252747 -11.233113288879395 -4.362959384918213 1;-0.15064272284507751 -11.098865509033203 -4.774174690246582 1;-1.1879801750183105 -11.207649230957031 -4.362198352813721 1;-1.6203185319900513 -11.495712280273438 -3.368363618850708 1;-1.1944047212600708 -11.794333457946777 -2.374842643737793 1;-0.1597340852022171 -11.928568840026855 -1.9636354446411133 1;0.8776034116744995 -11.819799423217773 -2.375614643096924 1]';
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
I = imread('output/frames/frame_1_right.png');
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