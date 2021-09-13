% load spectra_stack

frame_number = 1;

all_spectra = zeros(2048, frame_number);

for frame_to_average = 1:frame_number
    all_spectra(:, frame_to_average) = spectra_stack(:,2,frame_to_average);
    spectra_sum = sum(all_spectra, 2);
end

spectra_average = spectra_sum / frame_number;

% figure(6)
% plot(spectra_stack(:,1,1), spectra_average)

% if plot_data.Value == 1
%     figure
%     set(gcf,'position',[100 100 1600 800])
% end
% 
% function defined in stackfit.m 
% params = stackfit(rounded_part_y_pixel, bg_y_pixel, spec, img_z, plot_data.Value, startframe);

wav = spectra_stack(:,1,1);
ev = 2 * pi * 3 * 1e8 ./ wav * 6.582 * 1e-16 * 1e9;

%% Fit

%find initial guesses
[ymax, idx] =  max(spectra_average); %find height and position of peak
peakpos = ev(idx);

if min(spectra_average) > 0
    ymin = min(spectra_average);
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
lambda = 650;
fo.Exclude = ev > 1240 ./ lambda;

c = fit(ev, spectra_average, ft, fo); 

lorentzian_fitting = c.y0+(2*c.A/pi).*(c.w./(4*(ev-c.x0).^2+c.w.^2)); %reconstruct

maxfit = max(lorentzian_fitting);
Eres = round((1240/c.x0),3);
FWHM = round(1240/(c.x0 - c.w/2) - 1240/(c.x0 + c.w/2),3);
SNR = maxfit./std(spectra_average-lorentzian_fitting);

params = [maxfit, Eres, FWHM, SNR];
% spectra = [wav, bg_free, lorentzian_fitting];

%% plot
figure(6)
p = plot(wav, spectra_average, wav, lorentzian_fitting);
p(1).Color = 'r'; p(1).LineWidth = 1;
p(2).Color = 'k'; p(2).LineWidth = 1;

xlim([400 800])
set(gca,'Fontsize',20);
xlabel('Wavelength (nm)');
ylabel('Intensity (a.u.)')
legend('Averaged spectra','Fit', 'Location', 'northwest')
box on
title(['Frame = ' num2str(frame_number) ' Eres = ' num2str(Eres) ' nm Imax = ' num2str(maxfit)...
    ' FWHM = ' num2str(FWHM), ' nm SNR = ' num2str(SNR)])
