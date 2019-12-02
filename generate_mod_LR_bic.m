function generate_mod_LR_bic(input_path, up_scale, need_bic)

scale = up_scale;
%% set parameters
% comment the unnecessary line
% input_path = inputpath;
save_mod_path = strcat(input_path, '_mod_x', num2str(scale));
save_LR_path = strcat(input_path, '_LR_x', num2str(scale));

if need_bic 
    save_bic_path = strcat(input_path, '_bic_x', num2str(scale));
    if exist('save_bic_path', 'var')
        if exist(save_bic_path, 'dir')
            disp(['It will cover ', save_bic_path]);
        else
            mkdir(save_bic_path);
        end
    end
end

if exist('save_mod_path', 'var')
    if exist(save_mod_path, 'dir')
        disp(['It will cover ', save_mod_path]);
    else
        mkdir(save_mod_path);
    end
end
if exist('save_LR_path', 'var')
    if exist(save_LR_path, 'dir')
        disp(['It will cover ', save_LR_path]);
    else
        mkdir(save_LR_path);
    end
end


filepaths = dir(fullfile(input_path,'*.*'));
parfor i = 1 : length(filepaths)
    [~,imname,ext] = fileparts(filepaths(i).name);
    if isempty(imname)
        disp('Ignore . folder.');
    elseif strcmp(imname, '.')
        disp('Ignore .. folder.');
    else
        str_rlt = sprintf('Procesiing the %s%s\n', imname, ext);
        fprintf(str_rlt);
        % read image
        img = imread(fullfile(input_path, [imname, ext]));
        if size(img)==3
            img = img(:,:,1:3);
        end
        % modcrop
        img = modcrop(img, up_scale);
        imwrite(img, fullfile(save_mod_path, [imname, '.png']));
        % bic_down_load
        im_LR = imresize(img, 1/up_scale, 'bicubic');
        imwrite(im_LR, fullfile(save_LR_path, [imname, '_LRx', num2str(up_scale), '.png']));
        % bic_up_scale
        if need_bic
            im_B = imresize(img, up_scale, 'bicubic');
            imwrite(im_B, fullfile(save_bic_path, [imname, '_bic_x', num2str(up_scale), '.png']));
        end
    end
end
end

%% modcrop
function imgs = modcrop(imgs, modulo)
if size(imgs,3)==1
    sz = size(imgs);
    sz = sz - mod(sz, modulo);
    imgs = imgs(1:sz(1), 1:sz(2));
else
    tmpsz = size(imgs);
    sz = tmpsz(1:2);
    sz = sz - mod(sz, modulo);
    imgs = imgs(1:sz(1), 1:sz(2),:);
end
end
