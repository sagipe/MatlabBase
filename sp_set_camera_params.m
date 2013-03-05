function sp_set_camera_params(camera)
%
%

    params = fieldnames(camera);
    for i=1:length(params)
        set(gca, params{i}, camera.(params{i}));
    end
