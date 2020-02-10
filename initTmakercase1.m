H1C1initT=0;
H1C2initT=0;
H2C1initT=0;
H2C2initT=0;
H2C3initT=0;
Ttank1=10;%50
Ttank2=10;
Ttank3=10;%50
Ttank4=10;
Ttank5=10;


for k=1:1:4
    eval(['u' num2str(k) '=0.1;']);
end


Mname='newsyscase1mod';

case1trimmer;
count=0;
letstart=0;
letend=0;

for k=1:length(op.states)
    for j=1:length(op.states(k).block)
        if op.states(k).block(j)=='/'
            if count==0
                count=1;
            elseif count==1
                letstart=j+1;
                count=2;
            else
                letend=j-1;
                break
            end
        end
    end
    count=0;
    name=op.states(k).block(letstart:letend);
    for h=1:length(name)
        if name(h)=='-'
            name(h)='_';
        end
    end
    eval([name 'initT=op.states(k).x;']);
 
end


Temperatures = cell(4,1);
for i=1:4
    eval(['Temperatures{' num2str(i) '}=''T' num2str(i) ''';']);
end
Controlsignals = cell(4,1);
for i=1:4
    eval(['Controlsignals{' num2str(i) '}=''u' num2str(i) ''';']);
end
case1lin
infvector=[Temperatures Controlsignals];