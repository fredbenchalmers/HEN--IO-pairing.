%Tests the different input output pairings for the HEN with different
%controller tuning parameters (Lambdas) and derives the costs depending on
%deviation from the reference.
initTmakercase1; %Initiate the system;
Disinit; %Initiates the disturbances and referense shifts to be tested,
controls=Controlsignals;
toplot=0; %Turns plotting on or off
Dis1=0;
Dis2=0;
Dis3=0;
Dis4=0;
%Lambdas=[1 2];
Lambdas=[1 2 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 10 15];% controller tuning parameters
Index1=[3 4 1 2]; %Control configuration reccomended by RGA
Index2=[1 4 2 3];%Control configuration reccomended by Gramian based methods
Index3=[1 4 3 2]; %Control configuration reccomended by ILQIA




opt = tfestOptions('InitMethod','all');
Dsteptime=1000;
for h=1:length(Ds)
    eval(['D' num2str(h) '=0;']);
end




for k=1:3
    eval(['Index=Index' num2str(k) ';'])
    for i=1:length(Index)
        eval(['step' strjoin(controls(i)) '=0;'])
    end
    
    
    
    controls=Controlsignals;
    temps=Temperatures;
    close all
    Ts=zeros((size(Index)));
    stepstart=200;
    
    for i=1:length(Index)
        eval(['step' strjoin(controls(Index(i))) '=0.1;'])
        sim('newsyscase1modlmda');
        eval(['Tused' '=' strjoin(temps(i)) ';'])
        firsthalf=find(Tused.time>stepstart);
        firsthalf=firsthalf(1);
        
        TI=mean(Tused.data(floor(firsthalf/2):firsthalf));
        
        Tend=mean(Tused.data(firsthalf+(end-firsthalf)/2:end));
        K=1/((Tend-TI)/0.1);
        TIp=TI+(Tend-TI)*0.63;
        TIp2=TI+(Tend-TI)*0.01;
        if K<0
            Ttemp=find(Tused.data<TIp);
            Ttemp2=find(Tused.time(Ttemp)>stepstart);
            Ltemp=find(Tused.data<TIp2);
            Tused.time(Ltemp);
            Ltemp2=find(Tused.time(Ltemp)>stepstart);
        else
            Ttemp=find(Tused.data>TIp);
            Ttemp2=find(Tused.time(Ttemp)>stepstart);
            Ltemp=find(Tused.data>TIp2);
            Tused.time(Ltemp);
            Ltemp2=find(Tused.time(Ltemp)>stepstart);
        end
        
        L=Tused.time(Ltemp(Ltemp2(1)))-stepstart;
        if L<0.5
            L=0;
        end
        T=Tused.time(Ttemp(Ttemp2(1)))-stepstart-L;
        if T==0
            T=Tused.time(Ttemp(Ttemp2(1)))-stepstart;
        end
        
        Ts(i)=T;
        
        
        eval(['TheT' num2str(i) '=T;']);
        eval(['TheK' num2str(i) '=K;']);
        eval(['TheL' num2str(i) '=L;']);
        eval(['step' strjoin(controls(Index(i))) '=0;'])
    end
    endsak=length(Lambdas);
    cost=zeros(endsak,1);
    for g=1:endsak
        for i=1:length(Index)
            eval(['T=TheT' num2str(i) ';']);
            eval(['K=TheK' num2str(i) ';']);
            eval(['L=TheL' num2str(i) ';']);
            eval(['Is' num2str(i)  '=K/(L+T*Lambdas(g));']);
            eval(['Ks' num2str(i) '=K*T/(L+T*Lambdas(g));']);
        end
        IndexG=zeros(length(Index),1);
        for i=1:length(Index)
            IndexG(Index(i))=i;
        end
        
        for h=1:length(Ds)
            eval(['D' num2str(h) '=Ds(h);']);
            sim('newsyscase1modctrlflowmod');
            close()
            for i=1:length(Index)
                eval(['Tcostsak=T' num2str(i) ';']);
                if toplot
                    clf
                    h
                    plot(Tcostsak.signal1)
                    hold on
                    plot(Tcostsak.signal2)
                    pause
                end
                
                start2=find(Tcostsak.signal1.time>Dsteptime/2);
                
                for j=start2:length(Tcostsak.signal1.data)
                    if j==1
                        cost(g)=cost(g)+(Tcostsak.signal1.data(j)-Tcostsak.signal2.data(j))^2*Tcostsak.signal1.time(j);
                    else
                        cost(g)=cost(g)+(Tcostsak.signal1.data(j)-Tcostsak.signal2.data(j))^2*(Tcostsak.signal1.time(j)-Tcostsak.signal1.time(j-1));
                    end
                end
            end
            eval(['D' num2str(h) '=0;']);
        end
    end
    eval(['cost' num2str(k) '=cost;']);
end
%cost of all 3 methods
costAll=[cost1 cost2 cost3];