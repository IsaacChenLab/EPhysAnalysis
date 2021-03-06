function rez=BHVA3p_AnalyzeSessionActive (fn, pc, fff, col)

if nargin<3
    fff=[];
    col=[];
end
if nargin<2
    pc=[];
end
i=[];
try
    load (fn);
catch
    error ('file could not be loaded');
end
if ~(exist('events','var') && exist ('licks','var') && ~isempty(i))
    error ('the loaded session does not contain appropriate variables');
end

if strcmp(Proc,'TL') && nargin>1
   if strcmp(pc,'tone')
       events{i,2}=events{i,10};
       events{i,3}=events{i,11};
   elseif strcmp(pc,'light')
       events{i,2}=events{i,12};
       events{i,3}=events{i,13};
   end
elseif ~isempty(pc)
    if strcmpi(pc,'pre')
        ee=[];
        for x=1:length(events{i,2})
            f=find(events{i,4}<events{i,2}(x));
            if ~isempty(f) && events{i,4}(f(end))>events{i,2}(x)-3
                ee(end+1)=events{i,2}(x);
            end
        end
        events{i,2}=ee;
        ee=[];
        for x=1:length(events{i,3})
            f=find(events{i,4}<events{i,3}(x));
            if ~isempty(f) && events{i,4}(f(end))>events{i,3}(x)-3
                ee(end+1)=events{i,3}(x);
            end
        end
        events{i,3}=ee;
    elseif strcmpi(pc,'npre')
        ee=[];
        for x=1:length(events{i,2})
            f=find(events{i,4}<events{i,2}(x));
            if isempty(f) || events{i,4}(f(end))<events{i,2}(x)-3
                ee(end+1)=events{i,2}(x);
            end
        end
        events{i,2}=ee;
        ee=[];
        for x=1:length(events{i,3})
            f=find(events{i,4}<events{i,3}(x));
            if isempty(f) || events{i,4}(f(end))<events{i,3}(x)-3
                ee(end+1)=events{i,3}(x);
            end
        end
        events{i,3}=ee;
    elseif strcmpi(pc,'help')
        ee=[];
        for x=1:length(events{i,2})
            f=find(events{i,1}>events{i,2}(x)-.5 & events{i,1}<events{i,2}(x)+.5);
            if isempty(f)
                ee(end+1)=events{i,2}(x);
            end
        end
        events{i,2}=ee;
    end
end

try
EVENTS{1}=events{i,1};
catch
end
try
EVENTS{2}=events{i,2};
catch
end
try
EVENTS{3}=events{i,3};
catch
end
try
EVENTS{4}=events{i,4};
catch
end
try
LICKS=licks;
catch
end

f=diff(EVENTS{1});
ff=find(f>2);
EV=EVENTS{1}([1 ff+1]);
EVENTS{1}=EV;
rt=Rate(LICKS,10)/10;

f=figure;
plot (rt);
hold on;
[x1 ~]=ginput(1);
line([x1 x1],[min(rt) max(rt)]);
[x2 ~]=ginput(1);
close (f);
MX=round(10*max(x1,x2));
MN=round(10*min(x1,x2));

for i=1:4
    try
        ev=eval(['EVENTS{' num2str(i) '}']);
        EV=ev(ev<MX);
        EV=EV(EV>MN);
        eval (['EVENTS{' num2str(i) '}=EV;']);
    catch
    end
end

for i=1:4
    try
        eval (['ev' num2str(i) '=MC_smooth(XCorr (EVENTS{' num2str(i) '},LICKS,[-5 10],.1)'',0.5);']);
    catch
    end
end
try
    eval (['ev5=MC_smooth(XCorr (EVENTS{4},EVENTS{3},[-5 10],.1)'',0.5);']);
catch
end
mx=0;
for i=1:3
    try
        mx=max(mx,max(eval(['ev' num2str(i)])));
    catch
    end
end
if isempty(fff)
    figure
    col='b';
else
    figure(fff)
end

legend={'REWARD'; 'CSP'; 'CSM'; 'LAS'};
for i=1:4
    try
        subplot (2,2,i);
        hold on
        plot (-5:.1:10,eval(['ev' num2str(i)]),col);
        axis ([-5 10 0 mx]);
        title (legend{i});
        if i==4
            hold on;
            plot (-5:.1:10,ev5,'r');
        end
    catch
    end
end

% if exist('ev3','var')
%     subplot (2,2,4)
% else
%     subplot(2,2,3:4)
% end
% 
% plot (0:10:LICKS(end),rt);
% hold on
% line([x1*10 x1*10],[min(rt) max(rt)],'Color','r');
% line([x2*10 x2*10],[min(rt) max(rt)],'Color','r');
% axis ([0 LICKS(end) 0 max(rt)]);
% title ('Licking rate');

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



rez.cor=rez.ev2;
lp=sum(ev2(51:62));
blp=sum(ev2(41:50));
lm=sum(ev3(51:62));
blm=sum(ev3(41:50));
rez.percent_lp=lp/blp;
rez.percent_lm=lm/blm;
% lp=max(0,lp-blp);
% lm=max(0,lm-blm);
rez.dis=(lp-lm)/(lp+lm);
H=0;
F=0;
Ff=0;

for i=1:length(EVENTS{2})
    fl=find(LICKS<EVENTS{2}(i)+1);
    try if LICKS(fl(end))>EVENTS{2}(i)
        H=H+1;
        end
    catch
    end
end
H=H/length(EVENTS{2});
if H==1
    H=0.999999;
elseif H==0
    H=0.000001;
end

for i=1:length(EVENTS{3})
    fl=find(LICKS<EVENTS{3}(i)+1);
    ffl=find(LICKS<EVENTS{3}(i)+2);
    try if LICKS(fl(end))>EVENTS{3}(i)
        F=F+1;
        end
    catch
    end
    try if LICKS(ffl(end))>(EVENTS{3}(i)+1)
        Ff=Ff+1;
        end
    catch
    end
end
F=F/length(EVENTS{3});
if F==1
    F=0.999999;
elseif F==0
    F=0.000001;
end
Ff=Ff/length(EVENTS{3});
if Ff==1
    Ff=0.999999;
elseif Ff==0
    Ff=0.000001;
end

rez.lickp=lp;
rez.lickm=lm;
rez.blickp=blp;
rez.blickm=blm;
rez.dis=(lp-lm)/(lp+lm);
rez.dprime_an=norminv(H,0,1)-norminv(F,0,1);
rez.dprime_po=norminv(max(min(rez.cor,0.999999),0.000001),0,1)-norminv(Ff,0,1);
rez.false=Ff;
