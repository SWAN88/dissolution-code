%partnum = str2num(get(findobj(gcf,'Tag','partnum'),'String')); 
startframe = str2num(get(findobj(gcf,'Tag','sf'),'String')); %get the first frame
endframe = str2num(get(findobj(gcf,'Tag','ef'),'String')); %get the last fram

clear params_stack spectra_stack

if plot_data.Value ==1
    f = figure;
    set(gcf,'position',[100 100 1200 800])
end

params_stack = NaN(endframe, 4);
spectra_stack = NaN(2048,3,endframe);

for frame_number = startframe:endframe
    spec=imread(filename2, frame_number);
    
    params = stackfit(rounded_part_y_pixel, bg_y_pixel, spec, img_z, plot_data.Value, frame_number);
    params_stack(frame_number, :) = params;
    spectra_stack(:, :, frame_number) = spectrum;
    
    % Save Figure
    if save_figure.Value == 1
        if ~exist([filepath2 '\spectra'], 'dir') %check if dir doesnt exist
            mkdir([filepath2 '\spectra']) %make it if it doesent exist
        end
        if frame_number == startframe
            saveas(gcf,[filepath2, 'spectra\particle_', num2str(1), '_frame_', num2str(frame_number), '.png'])
        end
        
        if frame_number == endframe
            saveas(gcf,[filepath2, 'spectra\particle_', num2str(1), '_frame_', num2str(frame_number), '.png'])
        end
    end
end

function params = stackfit(rounded_part_y_pixel, bg_y_pixel, spec, img_z, plotdata, frame_number)
% generate spectrum
bg_free = (spec(rounded_part_y_pixel-9:rounded_part_y_pixel+10,:)-1*spec(bg_y_pixel-9:bg_y_pixel+10,:))./1;
bg_free = (sum(bg_free))';

raw = spec(rounded_part_y_pixel-9:rounded_part_y_pixel+10,:);
raw = sum(raw);

[~,part_x_pixel] = find(img_z == max(max(img_z(:,100:end))));
part_x_pixel = part_x_pixel(1);
pixels = 1:2048;

% enter params
% = 0.24;
%slope = 100.8;

intercept = 0.24;
slope = 160.8;

wav = ((pixels+part_x_pixel)*intercept+slope)';
ev = 2*pi*3*1e8./wav*6.582*1e-16*1e9;

%% Fit

%find initial guesses
[ymax, idx] =  max(bg_free); %find height and position of peak
peakpos = ev(idx);
if min(bg_free) > 0
    ymin = min(bg_free);
else
    ymin = 0;
end

ft = fittype('y0+(2*A/pi).*(w./(4*(x-x0).^2+w.^2))');
fo = fitoptions(ft);
fo.Startpoint = [ymax, 0.15, peakpos, ymin]; %height, FWHM, eres, offset(baseline)
fo.Lower = [0.1*ymax, 0.1, 1, -ymax];
fo.Upper = [2*ymax, 2, 3, ymax];
fo.Robust = 'LAR';
fo.MaxIter = 1e3;
fo.Display = 'Off';

% to exclude fitting points below lambda
lambda = 670;
fo.Exclude = ev > 1240 ./ lambda;

c = fit(ev, bg_free, ft, fo); %fit without filter

%filter
%evmax = ev(idx);
%filter = 2.5 - abs((ev - evmax)/0.2);
%filter(filter > 1) = 1;
%filter(filter < 0) = 0;
%c = fit(ev,filter.*bg_free,ft,fo); %fit with filter

lorentzian_fitting = c.y0+(2*c.A/pi).*(c.w./(4*(ev-c.x0).^2+c.w.^2)); %reconstruct

maxfit = round(max(lorentzian_fitting));
%maxspec = round(max(bg_free));
Eres = round((1240/c.x0),3);
FWHM = round(1240/(c.x0 - c.w/2) - 1240/(c.x0 + c.w/2),3);
SNR = round(maxfit./std(bg_free-lorentzian_fitting));


params = [maxfit, Eres, FWHM, SNR];
spectrum = [wav, bg_free, lorentzian_fitting];

%% plot
if plotdata == 1
    p = plot(wav, raw, wav, bg_free, wav, lorentzian_fitting);
    p(1).Color = 'b'; p(1).LineWidth = 1;
    p(2).Color = 'r'; p(2).LineWidth = 1;
    p(3).Color = 'k'; p(3).LineWidth = 1;
    
    xlim([400 800])
    set(gca,'Fontsize',20);
    xlabel('Wavelength (nm)');
    ylabel('Intensity (a.u.)')
    legend('Raw data','Background free','Fit')
    box on
    title(['Frame = ' num2str(frame_number) ' Eres = ' num2str(Eres) ' nm Maxfit = ' num2str(maxfit)...
        ' ** FWHM = ' num2str(FWHM), ' nm SNR = ' num2str(SNR)])
end
end
