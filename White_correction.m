load laser_snapshot2

% generate spectrum
% extract 20 pixels on x-axis
bg_free = spec(rounded_part_y_pixel-9:rounded_part_y_pixel+10,:)-spec(bg_y_pixel-9:bg_y_pixel+10,:);
bg_free = (sum(bg_free))';

Raw = spec(rounded_part_y_pixel-9:rounded_part_y_pixel+10,:);
Raw = sum(Raw);

white_corrected = bg_free ./ transpose(raw);

[~,part_x_pixel] = find(img_z == max(max(img_z(:,100:end))));
part_x_pixel = part_x_pixel(1);
pixels = 1:2048;

% enter params
intercept = 0.24;
slope = 160.8;

wav = ((pixels + part_x_pixel) * intercept + slope)';
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
lambda = 600;
fo.Exclude = ev > 1240 ./ lambda;

c = fit(ev, white_corrected, ft, fo); 

lorentzian_fitting = c.y0+(2*c.A/pi).*(c.w./(4*(ev-c.x0).^2+c.w.^2)); %reconstruct

maxfit = max(lorentzian_fitting);
Eres = round((1240/c.x0),3);
FWHM = round(1240/(c.x0 - c.w/2) - 1240/(c.x0 + c.w/2),3);
SNR = maxfit./std(white_corrected-lorentzian_fitting);

params = [maxfit, Eres, FWHM, SNR];
% spectra = [wav, bg_free, lorentzian_fitting];

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
title([' Eres = ' num2str(Eres) ' nm Imax = ' num2str(maxfit)...
    ' FWHM = ' num2str(FWHM), ' nm SNR = ' num2str(SNR)])
