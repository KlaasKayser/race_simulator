close all;

prompt = {'Masse [kg]','c_w','Stirnfläche [m^2]','Drehmoment [Nm]','Leistung [kW]',...
    'Übersetzung', 'Raddurchmesser [m]', 'Rollwiderstand', 'Steigung [%]',...
 'Drehmassenzuschlagsfaktor' };
dlgtitle = 'Inputs';
dims = [1 50];
definput = {'1900','0.23', '2.22', '420', '239','9', '0.578', '7*10^-3', '0', '1.1'};
answer = inputdlg(prompt,dlgtitle,dims,definput);

masse = str2num(answer{1});
c_w = str2num(answer{2});
stirnflaeche = str2num(answer{3});
drehmoment_max = str2num(answer{4});
leistung = str2num(answer{5});
uebersetzung = str2num(answer{6});
raddurchmesser = str2num(answer{7});

rollwiderstand = str2num(answer{8});
steigung = str2num(answer{9});
drehmassenzuschlagsfaktor = str2num(answer{10});

luftdichte = 1.2041; %kg/m^3
deltaT = 0.01;
distanz = 0;
g = 9.81;
zeit = 0;
f_gewicht = masse*g;
a = 0;
v = 0;

zeitschritt_array = [];
beschleunigungs_array = [];
geschwindigkeits_array = [];
positions_array = [];


while distanz < 400

    zeit = zeit + deltaT;

    drehzahl = v/(pi*raddurchmesser)*uebersetzung;

    drehmoment = min(drehmoment_max, leistung*1000/(2*pi*drehzahl));
    
    f_antrieb = min(2*drehmoment*uebersetzung/raddurchmesser, 0.9*f_gewicht);
    f_luft = 0.5 * c_w * stirnflaeche * luftdichte * v^2;
    f_reib = 50;
    f_roll = rollwiderstand * f_gewicht;
    f_steigung = steigung*f_gewicht;
   
    a = (f_antrieb - (f_luft + f_reib + f_steigung + f_roll))/(drehmassenzuschlagsfaktor * masse);
    v = v + a*deltaT;
    distanz = distanz + v*deltaT;

    zeitschritt_array(end+1) = zeit;
    beschleunigungs_array(end+1) = a;
    geschwindigkeits_array(end+1) = v*3.6;
    positions_array(end+1) = distanz;

end

figure;
plot(zeitschritt_array, beschleunigungs_array);
figure;
plot(zeitschritt_array, geschwindigkeits_array);
figure;
plot(zeitschritt_array, positions_array)

null_auf_hundert = zeitschritt_array(find(geschwindigkeits_array>=100,1));
null_auf_zweihundert = zeitschritt_array(find(geschwindigkeits_array>=200,1));

