eye_pos = [0.0, 0.0, 0.0];
eye_target = [200.0, -1000.0, 500.0];
eye_radius = 12.0;
cornea_centre = [-0.016783643513917923, -5.577363014221191, 0.04836755618453026];
cornea_radius = 7.922206814944914;
iris_radius = 4.770825802016765;
pupil_centre = [2.1130828857421875, -10.565413475036621, 5.28271484375];
pupil_radius = 2;

eye_matrix = [[-0.9805806279182434, -0.08633531630039215, -0.17609018087387085];[-0.196116104722023, 0.43167662620544434, 0.880450963973999];[0.0, 0.8978873491287231, -0.4402254819869995]];
eye = eye_make(cornea_radius, eye_matrix);
eye.pos_cornea = [cornea_centre(1) -cornea_centre(3) cornea_centre(2) 1]';
eye.depth_cornea = cornea_radius - sqrt(cornea_radius^2 - iris_radius^2);
eye.n_cornea = 1.336;
eye.pos_apex = eye.pos_cornea + [0 0 -cornea_radius 0]';
eye.pos_pupil = [eye_matrix \ pupil_centre' ; 1];
eye.across_pupil = [pupil_radius 0 0 0]';
eye.up_pupil = [0 pupil_radius 0 0]';

camera_pos = [0.0, -30.0, -10.0];
camera_target = [0.0, -12.0, 0.0];

camera_matrix = [[1.0, 0.0, 0.0];[0.0, -0.4856429696083069, -0.8741572499275208];[0.0, 0.8741573691368103, -0.4856429100036621]];
camera = camera_make();
camera.trans = [camera_matrix camera_pos' ; 0 0 0 1];
camera.rest_trans = camera.trans;
camera.focal_length = 193.1370849898476;
camera.resolution = [200 200];

light0 = light_make();
light0.pos = [[0.0, -50.0, -10.0] 1]';
cr0 = eye_find_cr(eye, light0, camera);

light1 = light_make();
light1.pos = [[30.0, -50.0, -15.0] 1]';
cr1 = eye_find_cr(eye, light1, camera);

light2 = light_make();
light2.pos = [[-30.0, -50.0, -15.0] 1]';
cr2 = eye_find_cr(eye, light2, camera);

light3 = light_make();
light3.pos = [[20.0, -30.0, 30.0] 1]';
cr3 = eye_find_cr(eye, light3, camera);

light4 = light_make();
light4.pos = [[-20.0, -30.0, 30.0] 1]';
cr4 = eye_find_cr(eye, light4, camera);

pupil_vertices = [ 2.453566789627075 -9.588869094848633 7.068417549133301 1;2.2671616077423096 -9.604202270507812 7.110513210296631 1;2.0789284706115723 -9.628227233886719 7.136203289031982 1;3.6692068576812744 -9.779253005981445 6.221894264221191 1;3.5587167739868164 -9.726176261901855 6.369298934936523 1;3.433994770050049 -9.680678367614746 6.507291316986084 1;2.813777208328247 -9.584372520446777 6.937557697296143 1;2.984025716781616 -9.59525203704834 6.850088119506836 1;3.1453278064727783 -9.614914894104004 6.748791217803955 1;0.45363548398017883 -11.250865936279297 4.5703935623168945 1;0.5641282200813293 -11.303940773010254 4.422994136810303 1;0.6888477206230164 -11.34943962097168 4.284999370574951 1;0.2787928879261017 -11.124475479125977 4.887170791625977 1;0.21616648137569427 -11.052409172058105 5.053420543670654 1;0.17121621966362 -10.975262641906738 5.2228169441223145 1;0.29275691509246826 -10.446213722229004 6.217752933502197 1;0.3744344711303711 -10.355175971984863 6.365391254425049 1;0.47217467427253723 -10.26573371887207 6.50365686416626 1;1.3427826166152954 -9.808279991149902 7.067063808441162 1;1.5209192037582397 -9.751605033874512 7.109610080718994 1;1.704092025756836 -9.702268600463867 7.135747909545898 1;3.844054937362671 -9.905645370483398 5.905117034912109 1;3.906683921813965 -9.97771167755127 5.738872528076172 1;3.951631546020508 -10.05486011505127 5.569473743438721 1;0.17981977760791779 -10.629454612731934 5.900627613067627 1;0.1496724784374237 -10.719847679138184 5.734275817871094 1;0.13781778514385223 -10.80821704864502 5.564809799194336 1;1.008213996887207 -9.941023826599121 6.935348987579346 1;0.8550894260406494 -10.01578140258789 6.847485542297363 1;0.7136050462722778 -10.095255851745605 6.745813369750977 1;1.309067964553833 -11.445751190185547 3.854722261428833 1;1.1388193368911743 -11.434869766235352 3.9421918392181396 1;0.9775146245956421 -11.415204048156738 4.043496608734131 1;3.9430253505706787 -10.400665283203125 4.891644477844238 1;3.973175287246704 -10.310273170471191 5.058006763458252 1;3.985029935836792 -10.221904754638672 5.227475166320801 1;3.1146230697631836 -11.089086532592773 3.8569414615631104 1;3.2677502632141113 -11.014328002929688 3.944810390472412 1;3.4092319011688232 -10.934853553771973 4.04647970199585 1;1.6692783832550049 -11.441254615783691 3.723862409591675 1;1.8556808233261108 -11.425922393798828 3.6817665100097656 1;2.0439138412475586 -11.401895523071289 3.6560845375061035 1;3.830082893371582 -10.583902359008789 4.574521541595459 1;3.7484052181243896 -10.67493724822998 4.426888465881348 1;3.650665044784546 -10.764378547668457 4.288628578186035 1;2.780056953430176 -11.221835136413574 3.725229263305664 1;2.6019177436828613 -11.278512001037598 3.682683229446411 1;2.418747663497925 -11.327853202819824 3.656545400619507 1;3.8951427936553955 -10.492176055908203 4.729959011077881 1;2.9515063762664795 -11.15847396850586 3.783529758453369 1;1.4864782094955444 -11.447871208190918 3.781731367111206 1;0.3582378029823303 -11.190834045410156 4.725641250610352 1;0.22769953310489655 -10.537940979003906 6.062310218811035 1;1.1713279485702515 -9.871638298034668 7.008760929107666 1;2.636364221572876 -9.58225154876709 7.0105485916137695 1;3.7646045684814453 -9.83928394317627 6.066644191741943 1;3.978034496307373 -10.136466026306152 5.39848518371582 1;3.5374224185943604 -10.851318359375 4.161303997039795 1;2.2321925163269043 -11.369197845458984 3.6474621295928955 1;0.8269281387329102 -11.386734962463379 4.157980442047119 1;0.14481320977210999 -10.893656730651855 5.393797397613525 1;0.585414707660675 -10.178791999816895 6.630984306335449 1;1.8906445503234863 -9.660923957824707 7.14483118057251 1;3.2959115505218506 -9.643383026123047 6.634310245513916 1]';
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
light_draw(light4);
if ~isempty(cr4)
    plot3(cr4(1), cr4(2), cr4(3), 'xr');
end

hold off;
axis equal;
xlim auto;
ylim auto;
zlim auto;
view(45, 2*eye_radius);

figure(2);
clf;
I = imread('example_200_-1000_500.png');
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

fprintf('(%f) ',(camera.resolution(1)/2 + pupil_points(1,:))); fprintf('\n');

plot(camera.resolution(1)/2 + pupil_points(1,:), camera.resolution(2)/2 - pupil_points(2,:), '-m', 'LineWidth', 1.5);
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
if ~isempty(cr4)
    pcr = camera_project(camera, cr4);
    plot(camera.resolution(1)/2 + pcr(1), camera.resolution(2)/2 - pcr(2), 'xr', 'LineWidth', 1.5, 'MarkerSize', 15);
end
hold off;