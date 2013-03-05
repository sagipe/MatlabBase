function camera = sp_get_camera_params()
%
%
% 

params = {'CameraPosition','CameraTarget','CameraViewAngle'};
param_values = get(gca,params);

for i=1:length(params)
    camera.(params{i}) = param_values{i};
end