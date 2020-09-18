clc; clear; close all
%% Initializing
% Mechanical Properties for Tantalum
E = 186e9; %Young's modulus
sigma_y = 900e6;  %Yield strength
alpha = 24.37e-6; %Thermal diffusivity
rho = 131e-9; %Electrical resistivity
h_conv = 20000; %Convection Coefficient
l = 250  ; % Needle length
D = 60;
width = 10;
hight_h = 20;
hight_c = 60;
% e = 12e-3; % Actuation volatage;
T_amb = 310; % Body temprature
%% Calculation
Ah = width*hight_h; % Hot arm area
Ac = width*hight_c; % Cold arm area
Ph = 2*(hight_h+width);
Pc = 2*(hight_c+width);
y_bar = (Ah*0.5*hight_c+Ac*(D+0.5*hight_h))/(Ac+Ah);
Ic = (1/12)*width*hight_c^3; % Cold arm Second moment of area
Ih = (1/12)*width*hight_h^3; % Hot arm Second moment of area
dh = y_bar-0.5*hight_h;
dc = 0.5*hight_h+D-y_bar;
I = Ih+Ah*dh^2+Ic+Ac*dc^2; % Second moment of area
deltaT = sigma_y/(E*alpha); % Difference between cold and hot temp
Rh = rho*l/Ah*10^6;
Rc = rho*l/Ac*10^6;
%% Max allowed e
for e = 0:0.000001:1
    Th = (Ah/(h_conv*Ph*rho*l^2))*((Ac/(Ah+Ac))^2)*e^2*10^6+T_amb;
    Tc = (Ac/(h_conv*Pc*rho*l^2))*((Ah/(Ah+Ac))^2)*e^2*10^6+T_amb;
    deltaTA = Th-Tc;
    if deltaTA >= deltaT
        break
    end
end
w = ((D*alpha*Ah*(e^2))/(2*h_conv*rho*I))...
    *((Ah*(Ac/(Ah+Ac))^2)/Ph-(Ac*(Ah/(Ah+Ac))^2)/Pc);
%% Print
fprintf('Actuator Voltage is: %f\n',e)
fprintf('Difference between cold and hot temp is: %f\n',deltaT)
fprintf('Rh is: %f\n',Rh)
fprintf('Rc is: %f\n',Rc)
fprintf('Th is: %f\n',Th)
fprintf('Tc is: %f\n',Tc)
fprintf('deltaTA is: %f\n',deltaTA)
fprintf('w is: %f\n',w);