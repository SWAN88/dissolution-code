%% generate spectrum
corrected = (spec(ak2-9:ak2+10,:)-1*spec(ak3-9:ak3+10,:))./1;
corrected = (sum(corrected))';

raw = spec(ak2-9:ak2+10,:);
raw = sum(raw);

[~,xcc] = find(img_z == max(max(img_z(:,100:end))));
xcc = xcc(1);
pixels = 1:2048;

% enter params
%intercept = 0.24;
%slope = 100.8;

%intercept = 0.24;
%slope = 150.8;

%feb 25
%intercept = 0.2355;
%slope = 152.4747;

intercept = 0.24;
slope = 160.8;

%July 14
%intercept = 0.22;
%slope = 200;

wav = ((pixels+xcc)*intercept+slope)'; %I know I mixed up the names but it works
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

% fit option parameters
ft = fittype('y0+(2*A/pi).*(w./(4*(x-x0).^2+w.^2))');
fo = fitoptions(ft);
fo.Startpoint = [ymax, 0.15, peakpos, ymin]; %height, FWHM, eres, offset(baseline)
fo.Lower = [0.1*ymax, 0.1, 1, -ymax];
fo.Upper = [2*ymax, 2, 3, ymax];
fo.Robust = 'LAR';
fo.MaxIter = 1e3;

lambda = 600;
fo.Exclude = ev > 1240 ./ lambda;

%fo.Exclude = ev > 2.48; %cutoff ~500nm
%fo.Exclude = ev > 2.066; %cutoff ~600nm
%fo.Exclude = ev > 1.9076; %cutoff ~650nm
%fo.Exclude = ev > 1.823; %cutoff ~680nm
%fo.Exclude = ev > 1.771; %cutoff ~700nm
%fo.Exclude = ev > 1.675; %cutoff ~740nm

fo.Robust = 'LAR';
fo.MaxIter = 1e3;

c = fit(ev, corrected, ft, fo); %fit without filter

%filter
%evmax = ev(idx);
%filter = 2.5 - abs((ev - evmax)/0.2);
%filter(filter > 1) = 1;
%filter(filter < 0) = 0;
%c = fit(ev,filter.*corrected,ft,fo); %fit with filter

yy = c.y0+(2*c.A/pi).*(c.w./(4*(ev-c.x0).^2+c.w.^2)); %reconstruct

maxfit = round(max(yy));
maxspec = round(max(corrected));
Eres = round(1240/c.x0);
FWHM = round(1240/(c.x0 - c.w/2) - 1240/(c.x0 + c.w/2));
SNR = round(maxfit./std(corrected-yy));

params = [maxfit, Eres, FWHM, SNR];
spectrum = [wav, corrected, yy];

%% plot
if plot_data.Value ==1
    f = figure;
    %plot(wav, filter*max(yy)); hold on %check filter
    
    p = plot(wav,raw, wav, corrected, wav, yy);
    p(1).Color = 'b'; p(1).LineWidth = 1;
    p(2).Color = 'r'; p(2).LineWidth = 1;
    p(3).Color = 'k'; p(3).LineWidth = 1;
    
    xlim([400 800])
    set(gca,'Fontsize',20);
    xlabel('Wavelength (nm)');
    ylabel('Intensity (a.u.)')
    legend('Raw data','Background free','Fit')
    set(gcf,'position',[100 100 1200 800 ])
    box on
    title(['Eres = ' num2str(Eres) ' nm Maxfit = ' num2str(maxfit)...
        ' FWHM = ' num2str(FWHM), ' nm SNR = ' num2str(SNR)])
end

