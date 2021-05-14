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
    im4=imread(filename2, frame_number);
    
    params = stackfit(ak2, ak3, im4, img_z, plot_data.Value, frame_number);
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

function params = stackfit(ak2, ak3, im4, img_z, plotdata, frame_number)
% generate spectrum
corrected = (im4(ak2-9:ak2+10,:)-1*im4(ak3-9:ak3+10,:))./1;
corrected = (sum(corrected))';

raw = im4(ak2-9:ak2+10,:);
raw = sum(raw);

[~,xcc] = find(img_z == max(max(img_z(:,100:end))));
xcc = xcc(1);
pixels = 1:2048;

% enter params
% = 0.24;
%slope = 100.8;

intercept = 0.24;
slope = 160.8;

wav = ((pixels+xcc)*intercept+slope)';
ev = 2*pi*3*1e8./wav*6.582*1e-16*1e9;

%% Fit

%find initial guesses
[ymax, idx] =  max(corrected); %find height and position of peak
peakpos = ev(idx);
if min(corrected) > 0
    ymin = min(corrected);
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

% to exclude fitting points below lambda
lambda = 600;
fo.Exclude = ev > 1240 ./ lambda;

c = fit(ev, corrected, ft, fo); %fit without filter

%filter
%evmax = ev(idx);
%filter = 2.5 - abs((ev - evmax)/0.2);
%filter(filter > 1) = 1;
%filter(filter < 0) = 0;
%c = fit(ev,filter.*corrected,ft,fo); %fit with filter

yy = c.y0+(2*c.A/pi).*(c.w./(4*(ev-c.x0).^2+c.w.^2)); %reconstruct

maxfit = round(max(yy));
%maxspec = round(max(corrected));
Eres = round((1240/c.x0),3);
FWHM = round(1240/(c.x0 - c.w/2) - 1240/(c.x0 + c.w/2),3);
SNR = round(maxfit./std(corrected-yy));


params = [maxfit, Eres, FWHM, SNR];
spectrum = [wav, corrected, yy];

%% plot
if plotdata == 1
    p = plot(wav, raw, wav, corrected, wav, yy);
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
