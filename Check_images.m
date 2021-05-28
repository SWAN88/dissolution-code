part_y_pixel = round(part_y_pixel);
rounded_part_y_pixel = part_y_pixel;

%% GUI left bottom
img_z = pos(part_y_pixel-9:part_y_pixel+10,:);
% subplot(3,2,5);
% imagesc(img_z);

%img_z = img_z == max(img_z(:));

%% GUI right bottom

%spec_z = (a_trous_transformed_spec(rounded_part_y_pixel-9:rounded_part_y_pixel+10,:)-1*a_trous_transformed_spec(bg_y_pixel-9:bg_y_pixel+10,:))./1; 
% what are "-1*"and "./1"? unnecessary?

spec_z = a_trous_transformed_spec(rounded_part_y_pixel-9:rounded_part_y_pixel+10,:)-a_trous_transformed_spec(bg_y_pixel-9:bg_y_pixel+10,:); %subtract BG

%unnecessary part? Without these lines, code worked
%spec_z = spec_z/max(sum(spec_z)); %Array indices must be positive integers or logical values.
% [s_x,s_y] = find(spec_z == max(spec_z(:)));
% rounded_part_y_pixel = rounded_part_y_pixel+s_x - 10;
% spec_z = (a_trous_transformed_spec(rounded_part_y_pixel-9:rounded_part_y_pixel+10,:)-1*a_trous_transformed_spec(bg_y_pixel-9:bg_y_pixel+10,:))./1;
%spec_z_norm = (spec(rounded_part_y_pixel-9:rounded_part_y_pixel+10,:)-1*spec(bg_y_pixel-9:bg_y_pixel+10,:))./1;
% max_rec = max(sum(spec_z_norm));
% spec_z = spec_z/max(sum(spec_z));

subplot(3,2,6);
imagesc(spec_z);
