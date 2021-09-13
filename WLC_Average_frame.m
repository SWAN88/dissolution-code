% load spectra_stack
load laser_snapshot2

frame_number = 1;

all_spectra = zeros(2048, frame_number);

for frame_to_average = 1:frame_number
    all_spectra(:, frame_to_average) = spectra_stack(:,2,frame_to_average);
    spectra_sum = sum(all_spectra, 2);
end

spectra_average = spectra_sum / frame_number;
white_corrected = spectra_average ./ transpose(raw);


wav = spectra_stack(:,1,1);
ev = 2 * pi * 3 * 1e8 ./ wav * 6.582 * 1e-16 * 1e9;

%% Fit

%find initial guesses
[ymax, idx] =  max(white_corrected); %find height and position of peak
peakpos = ev(idx);

if min(white_corrected) > 0
    ymin = min(white_corrected);
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
% lambda = 600;
% fo.Exclude = ev > 1240 ./ lambda;

c = fit(ev, white_corrected, ft, fo); 

lorentzian_fitting = c.y0+(2*c.A/pi).*(c.w./(4*(ev-c.x0).^2+c.w.^2)); %reconstruct

maxfit = max(lorentzian_fitting);
Eres = round((1240/c.x0),3);
FWHM = round(1240/(c.x0 - c.w/2) - 1240/(c.x0 + c.w/2),3);
SNR = maxfit./std(white_corrected-lorentzian_fitting);

params = [maxfit, Eres, FWHM, SNR];

%% plot
figure(7)
p = plot(wav, white_corrected, wav, lorentzian_fitting);
p(1).Color = 'r'; p(1).LineWidth = 1;
p(2).Color = 'k'; p(2).LineWidth = 1;
% p(3).Color = 'k'; p(3).LineWidth = 1;

xlim([400 800])
set(gca,'Fontsize',20);
xlabel('Wavelength (nm)');
ylabel('Intensity (a.u.)')
legend('White Light Correction','Fit', 'Location', 'northwest')
box on
title(['Frame = ' num2str(frame_number) ' Eres = ' num2str(Eres) ' nm Imax = ' num2str(maxfit)...
    ' FWHM = ' num2str(FWHM), ' nm SNR = ' num2str(SNR)])
