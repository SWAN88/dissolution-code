    count = count + 1;
    ak11(count) = ak1;
    %ak31 = ak3;
    xcc_rec(count) = xcc;
    
    %figure(fh1);
    subplot(fh1)
    hold on;
    text(xcc_rec(count),ak11(count),num2str(count),'color','w');
    hold off;
    
    coordinates(count,:) = [xcc, ak1, ak3];

