clear; clc; close all;

%% P1 Calculo plastico
%% Datos del problema
q = 8;          % kN/m, carga repartida en AB y BC
P = 12;         % kN, carga puntual en el extremo del voladizo

L_AB = 4;       % m
L_BC = 5;       % m
L_CD = 1.5;     % m

gamma = 1.3;    % coeficiente de seguridad

%% Neal-Simmonds
% H = grado de hiperestaticidad
% N = numero de posibles rotulas plasticas
H = 2;
N = 5;
m = N - H;

fprintf('\n========== P1 - CALCULO PLASTICO ==========\n');
fprintf('Num. de mecanismos indep.:\n');
fprintf('m = N - H = %d - %d = %d\n', N, H, m);

%% Mp necesario para cada mecanismo
% Mecanismo 1: Tramo AB
Mp_1 = q * L_AB^2 / 16;

% Mecanismo 2: Tramo BC
Mp_2 = q * L_BC^2 / 16;

% Mecanismo 3: Voladizo CD
Mp_3 = P * L_CD;

Mp = [Mp_1; Mp_2; Mp_3];
mecanismo = ["Mecanismo 1 - AB"; "Mecanismo 2 - BC"; "Mecanismo 3 - CD"];

%% Mecanismo critico
% Mayor Mp.
[Mp_objetivo, idx_critico] = max(Mp);
lambda = Mp_objetivo ./ Mp;

Mp_diseno = gamma * Mp_objetivo;

q_adm = q / gamma;
P_adm = P / gamma;

%% Resultados
T = table(mecanismo, Mp, lambda, ...
    'VariableNames', {'Mecanismo', 'Mp_kNm', 'lambda_i'});

disp(' ');
disp('Tabla de mecanismos:');
disp(T);

fprintf('Mecanismo critico: %s\n', mecanismo(idx_critico));
fprintf('Mp objetivo = %.2f kN*m\n', Mp_objetivo);
fprintf('Mp diseno = gamma * Mp objetivo = %.2f kN*m\n', Mp_diseno);

fprintf('\nCargas equivalentes con factor de seguridad:\n');
fprintf('q_adm = %.2f kN/m\n', q_adm);
fprintf('P_adm = %.2f kN\n', P_adm);
