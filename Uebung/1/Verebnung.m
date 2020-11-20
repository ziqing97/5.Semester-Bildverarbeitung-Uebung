%% Funktiong fuer Verebnung
function I_ver=Verebnung(I)
    % Histogramm
    hist=zeros(256,1);
    for i=1:256
        pixel=find(I==i-1);
        hist(i)=numel(pixel);
    end
    % kummulative Histogramm
    kumm=zeros(256,1);
    for i=1:256
        for j=1:i
            kumm(i)=kumm(i)+hist(j);
        end
    end
    kumm=kumm/numel(I);
    % Verebnung
    I_ver=I;
    for i=1:256
        I_ver(I==i-1)=kumm(i)*255;
    end
end