close all;

% Teslam Model 3SR
% definput = {'1900','0.23', '2.22', '420', '239', '220',...
% '9','18000', '0.578', '7*10^-3', '0', '1.1'};

%VW Golf 7
definput = {'1291','0.27', '2.19', '340', '110','216',...
    '14.662, 7.897, 5.196,  3.946, 3.156, 2.620','6000', '0.578', '7*10^-3', '0', '1.1'};


prompt = {'Masse [kg]','c_w','Stirnfläche [m^2]','Drehmoment [Nm]','Leistung [kW]',...
    'Höchstgeschw. [km/h]', 'Übersetzung', 'max Drehzahl [1/min]', 'Raddurchmesser [m]',...
    'Rollwiderstand', 'Steigung [%]', 'Drehmassenzuschlagsfaktor' };

dlgtitle = 'Inputs';
dims = [1 50];
answer = inputdlg(prompt,dlgtitle,dims,definput);

masse = str2num(answer{1});
c_w = str2num(answer{2});
stirnflaeche = str2num(answer{3});
drehmoment_max = str2num(answer{4});
leistung = str2num(answer{5});
v_max = str2num(answer{6})/3.6;
gaenge = cellfun(@str2num, strsplit(answer{7}, ', '));
max_drehzahl = str2num(answer{8})/60;
raddurchmesser = str2num(answer{9});

rollwiderstand = str2num(answer{10});
steigung = str2num(answer{11});
drehmassenzuschlagsfaktor = str2num(answer{12});

luftdichte = 1.2041; %kg/m^3
deltaT = 0.01;
distanz = 0;
g = 9.81;
zeit = 0;
f_gewicht = masse*g;
a = 0;
v = 0;
drehzahl = 0;
drehmoment_faktor = 1;

%Normiertes Array: Drehmoment (Zeile 2) über Drehzahl (Zeile 1)
drehmomentkurven_array = [0, 0.2381, 0.4048, 0.7381, 1.0;0.3947, 0.3947, 1.0, 1.0, 0.6842];

zeitschritt_array = [];
beschleunigungs_array = [];
geschwindigkeits_array = [];
positions_array = [];
drehzahl_array = [];

momentaner_gang = 1;
uebersetzung = gaenge(momentaner_gang);

while distanz < 402

    zeit = zeit + deltaT;

    if drehzahl > max_drehzahl
        momentaner_gang = momentaner_gang + 1;
        uebersetzung = gaenge(momentaner_gang);
    end

    drehzahl = v/(pi*raddurchmesser)*uebersetzung;

    if length(gaenge) > 2
        drehmoment_faktor = interp1(drehmomentkurven_array(1,:), drehmomentkurven_array(2,:), drehzahl/max_drehzahl);
    end

    drehmoment = min(drehmoment_faktor*drehmoment_max, leistung*1000/(2*pi*drehzahl));
    
    f_antrieb = min(2*drehmoment*uebersetzung/raddurchmesser, 0.9*f_gewicht);
    f_luft = 0.5 * c_w * stirnflaeche * luftdichte * v^2;
    f_reib = 50;
    f_roll = rollwiderstand * f_gewicht;
    f_steigung = steigung*f_gewicht;

    if v >= v_max
        a = 0;
    else
        a = (f_antrieb - (f_luft + f_reib + f_steigung + f_roll))/(drehmassenzuschlagsfaktor * masse);
    end

    v = v + a*deltaT;
    distanz = distanz + v*deltaT;

    zeitschritt_array(end+1) = zeit;
    beschleunigungs_array(end+1) = a;
    geschwindigkeits_array(end+1) = v*3.6;
    positions_array(end+1) = distanz;
    drehzahl_array(end+1) = drehzahl;

end

figure;
plot(zeitschritt_array, beschleunigungs_array);
figure;
plot(zeitschritt_array, geschwindigkeits_array);
figure;
plot(zeitschritt_array, positions_array)
figure;
plot(zeitschritt_array, drehzahl_array)

null_auf_hundert = zeitschritt_array(find(geschwindigkeits_array>=100,1));
null_auf_zweihundert = zeitschritt_array(find(geschwindigkeits_array>=200,1));

