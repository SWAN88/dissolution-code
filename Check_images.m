    ak1 = round(ak1);
    ak2 = ak1;% - 50;
    img_z = im2(ak1-9:ak1+10,:);
    subplot(3,2,5);imagesc(img_z);
    img_z = img_z==max(img_z(:));
    
    spec_z = (im5(ak2-9:ak2+10,:)-1*im5(ak3-9:ak3+10,:))./1;
    
 
    spec_z = spec_z/max(sum(spec_z));
    [s_x,s_y] = find(spec_z == max(spec_z(:)));
    ak2 = ak2+s_x - 10;
    spec_z = (im5(ak2-9:ak2+10,:)-1*im5(ak3-9:ak3+10,:))./1;
    spec_z_norm = (im4(ak2-9:ak2+10,:)-1*im4(ak3-9:ak3+10,:))./1;
    max_rec = max(sum(spec_z_norm));
    spec_z = spec_z/max(sum(spec_z));
    subplot(3,2,6);imagesc(spec_z);
    