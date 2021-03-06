function rez=BHV_AnalyzeSessionActive (fn)

try
    load (fn);
catch
    error ('file could not be loaded');
end
if ~(exist('EVENTS','var') && exist ('LICKS','var'))
    error ('the loaded session does not contain appropriate variables');
end
for i=1:3
    try
        eval (['ev' num2str(i) '=MC_smooth(XCorr (EVENTS{' num2str(i) '},LICKS,[-5 10],.1)'',0.5);']);
    catch
    end
end
rt=Rate(LICKS,10)/10;
mx=0;
for i=1:3
    try
        mx=max(mx,max(eval(['ev' num2str(i)])));
    catch
    end
end
figure

legend={'REWARD'; 'CSP'; 'CSM'};
for i=1:3
    try
        subplot (2,2,i);
        plot (-5:.1:10,eval(['ev' num2str(i)]));
        axis ([-5 10 0 mx]);
        title (legend{i});
    catch
    end
end

if exist('ev3','var')
    subplot (2,2,4)
else
    subplot(2,2,3:4)
end

plot (0:10:LICKS(end),rt);
axis ([0 LICKS(end) 0 max(rt)]);
title ('Licking rate');

%%%% percent hits/miss
ev=[];
for i=1:length(EVENTS{1})
    if ~isempty(find(LICKS>EVENTS{1}(i) & LICKS<EVENTS{1}(i)+1))
        ev(end+1)=EVENTS{1}(i);
    end
end
EVENTS{1}=ev;
for i=2:3
    try
        ev=eval(['EVENTS{' num2str(i) '}']);
        n=0;
        for j=1:length(ev)
            if ~isempty (find(EVENTS{1}>ev(j) & EVENTS{1}<ev(j)+5))
                n=n+1;
            end
        end
        eval(['rez.ev' num2str(i) '=n/length(ev);']);
        eval (['n' num2str(i-1) '=n;']);
    catch
    end
end
rez.cor=(n1+n2)/(length(EVENTS{2})+length(EVENTS{3}));
lp=sum(ev2(51:76));
lm=sum(ev3(51:76));
rez.dis=(lp-lm)/(lp+lm);
