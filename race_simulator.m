
close all;
masse = 0;
c_w = 0;
stirnflaeche = 0;
drehmoment = 0;
uebersetzung = 0;
raddurchmesser = 0;

rollwiderstand = 0;
steigung = 0;
drehmassenzuschlagsfaktor = 0;

deltaT = 0;

prompt = {'Masse [kg]','c_w','Stirnfläche [m^2]','Drehmoment [Nm]',...
    'Übersetzung', 'Raddruchmesser [m]', 'Rollwiderstand', 'Steigung [%]',...
 'Drehmassenzuschlagsfaktor' };
dlgtitle = 'Inputs';
dims = [1 50];
definput = {'2000','0.30', '2.5', '250', '12', '0.65', '7*10^-6', '0', '1.3'};
answer = inputdlg(prompt,dlgtitle,dims,definput);

masse = str2num(answer{1});
c_w = str2num(answer{2});
stirnflaeche = str2num(answer{3});
drehmoment = str2num(answer{4});
uebersetzung = str2num(answer{5});
raddurchmesser = str2num(answer{6});

rollwiderstand = str2num(answer{7});
steigung = str2num(answer{8});
drehmassenzuschlagsfaktor = str2num(answer{9});


zeitschritt_array = [0.1:0.1:0.5];
beschleunigungs_array = [1,1,1,1,1];
geschwindigkeits_array = [1,2,3,4,5];
positions_array = [rand(5,1)];

figure;
plot(zeitschritt_array, beschleunigungs_array);
figure;
plot(zeitschritt_array, geschwindigkeits_array);
figure;
plot(zeitschritt_array, positions_array)



