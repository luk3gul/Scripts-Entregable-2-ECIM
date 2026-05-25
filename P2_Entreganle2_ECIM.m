clear; clc; close all;

%% P2 Placas
%% Datos del problema
a = 4;          % m, lado en direccion x
b = 3;          % m, lado en direccion y
t = 0.12;       % m, espesor

E = 30e6;       % kN/m^2
nu = 0.20;      % coef. de Poisson
q0 = 8;         % kN/m^2

% Numero maximo de terminos impares
Nmax = 31;

%% Rigidez flexional
D = E*t^3/(12*(1 - nu^2));

fprintf('\n========== P2 - PLACA POR NAVIER ==========\n');
fprintf('D = %.3f kN*m\n', D);

%% Primer termino
m = 1;
n = 1;

q11 = 16*q0/(pi^2*m*n);
W11 = q11/(D*((m^2*pi^2/a^2) + (n^2*pi^2/b^2))^2);

fprintf('\nPrimer termino:\n');
fprintf('q11 = %.6f kN/m^2\n', q11);
fprintf('W11 = %.9f m = %.6f mm\n', W11, W11*1000);

%% Convergencia de la flecha en el centro
x_c = a/2;
y_c = b/2;

N_list = [1 3 5 7 9 11 15 21 31];
w_centro = zeros(length(N_list),1);

for k = 1:length(N_list)
    N = N_list(k);
    w_tmp = 0;

    for m = 1:2:N
        for n = 1:2:N
            qmn = 16*q0/(pi^2*m*n);
            Wmn = qmn/(D*((m^2*pi^2/a^2) + (n^2*pi^2/b^2))^2);
            w_tmp = w_tmp + Wmn*sin(m*pi*x_c/a)*sin(n*pi*y_c/b);
        end
    end

    w_centro(k) = w_tmp;
end

tabla_conv = table(N_list', w_centro, w_centro*1000, ...
    'VariableNames', {'N', 'w_centro_m', 'w_centro_mm'});

disp(' ');
disp('Convergencia de la flecha en el centro:');
disp(tabla_conv);

%% Calculo de la flecha en toda la placa
nx = 121;
ny = 121;
[x, y] = meshgrid(linspace(0, a, nx), linspace(0, b, ny));

w = zeros(size(x));
Mx = zeros(size(x));
My = zeros(size(x));

for m = 1:2:Nmax
    for n = 1:2:Nmax
        qmn = 16*q0/(pi^2*m*n);
        alfa = m*pi/a;
        beta = n*pi/b;

        Wmn = qmn/(D*(alfa^2 + beta^2)^2);
        modo = sin(alfa*x).*sin(beta*y);

        w = w + Wmn*modo;

        % Momentos flectores
        Mx = Mx + D*(alfa^2 + nu*beta^2)*Wmn*modo;
        My = My + D*(beta^2 + nu*alfa^2)*Wmn*modo;
    end
end

%% Punto de flecha maxima
[wmax, idx] = max(w(:));
[fila, col] = ind2sub(size(w), idx);
xmax = x(fila,col);
ymax = y(fila,col);

fprintf('\nResultado con Nmax = %d:\n', Nmax);
fprintf('wmax = %.9f m = %.6f mm\n', wmax, wmax*1000);
fprintf('Punto de flecha maxima: x = %.3f m, y = %.3f m\n', xmax, ymax);

%% Momentos y tensiones maximas
[Mxmax, idxMx] = max(abs(Mx(:)));
[filaMx, colMx] = ind2sub(size(Mx), idxMx);

[Mymax, idxMy] = max(abs(My(:)));
[filaMy, colMy] = ind2sub(size(My), idxMy);

sigma_x_max = 6*Mxmax/t^2;
sigma_y_max = 6*Mymax/t^2;

fprintf('\nMomentos y tensiones maximas:\n');
fprintf('Mxmax = %.6f kN*m/m en x = %.3f m, y = %.3f m\n', ...
    Mxmax, x(filaMx,colMx), y(filaMx,colMx));
fprintf('Mymax = %.6f kN*m/m en x = %.3f m, y = %.3f m\n', ...
    Mymax, x(filaMy,colMy), y(filaMy,colMy));
fprintf('sigma_x_max = %.6f MPa\n', sigma_x_max/1000);
fprintf('sigma_y_max = %.6f MPa\n', sigma_y_max/1000);

%% Graficos
figure;
contourf(x, y, w*1000, 25);
colorbar;
grid on;
hold on;
plot(xmax, ymax, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
hold off;
xlabel('x (m)');
ylabel('y (m)');
title('Mapa de flechas w(x,y) [mm]');

figure;
surf(x, y, w*1000, 'EdgeColor', 'none');
colorbar;
grid on;
xlabel('x (m)');
ylabel('y (m)');
zlabel('w (mm)');
title('Flecha de la placa por metodo de Navier');

figure;
plot(N_list, w_centro*1000, '-o', 'LineWidth', 1.5);
grid on;
xlabel('N maximo de la serie');
ylabel('Flecha en el centro (mm)');
title('Convergencia de la flecha en el centro');
