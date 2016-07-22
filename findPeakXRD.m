function [pks, proms,locs,widths,signal, score,score2] = findPeakXRD(x,y,confidenceFactor)
%good values for confidence facto seem to be around 0.25 and 0.5

%very basic background substraction
y = y - min(y);

%first denoise the data
yDen = wden(y,'sqtwolog','s','mln',4,'sym4');
%get an idea how much noise is there
noise = y - yDen;
[counts,centers] = hist(noise);

clear y;

g = fit(centers(:),counts(:),'gauss1');

threshold = g.c1*confidenceFactor; %that is the peak is higher than n*sigma of the noise

%substract background
clear counts
clear centers

[counts,centers] = hist(diff(yDen),100);
g = fit(centers(:),counts(:),'gauss1');

slopeThreshold = g.c1*0.25;

background = xrdbg(yDen,slopeThreshold,3000);

yDen = yDen-background;

%find peaks

[pks,locs,widths,proms] = findpeaks(yDen,x,'MinPeakProminence',threshold);

gauss = @(x,a,center,broadness) a*exp(-(x-center).^2/broadness^2);

signal=zeros(size(yDen));
%calculate the score
for i=1:length(pks)
    signal=signal+gauss(x,proms(i),locs(i),widths(i));
end

%figure;
%plot(x, signal);

score=sum(signal/max(signal))/sum((yDen/max(yDen)-signal/max(signal)).^2);

scoreVec2=yDen-signal;
score2=sum(scoreVec2(find(scoreVec2<0)));

end