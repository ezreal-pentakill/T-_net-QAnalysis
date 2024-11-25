% T Constants
mu = 300e-4;         % Mobility (cm^2/Vs -> m^2/Vs)
Cox = 1e-3;          % Oxide capacitance (F/m^2)
W = 10e-6;           % Channel width (m)
L = 1e-6;            % Channel length (m)
VT = 0.6;            % Threshold voltage (V)
VDD = 1.2;           % Drain-source voltage (V)

% Impedances (in ohms)
Z1 = 5 + 1j*2;  % Base impedance for Gate-Drain + Gate-Source
Z2 = 3 + 1j*5;       % Drain-Source connection
Z3 = 7 - 1j*3;       % Shared impedance between Gate-Source and Drain-Source
Z1_base = Z1;

% Fixed Gate voltage (VG = 0.6V)
VG = 0.6;              % Gate voltage (V)
V1 = VG; % Voltage at gate (fixed VG)
V2 = VDD; % Voltage at drain (constant VDD)

% Impedance values
X1 = imag(Z1);  % Imaginary part of Z1_base
X2 = imag(Z2);            % Imaginary part of Z2
X3 = imag(Z3);            % Imaginary part of Z3


% Scan Q1 from 0 to 1000 (vectorized)
Q1_scan = 0:1:1000;       % Q1 values to scan
Q1 = Q1_scan(:);          % Ensure Q1 is a column vector

% Modify Z1 with Q1 (matrix form to match Q1_scan)
Z1 = transpose(real(Z1_base) + 1j * (Q1*real(Z1_base)));  % Modify Z1 based on Q1

I1 = zeros(1, 1001);  % Current at gate (I1)
I2 = zeros(1, 1001);  % Current at drain (I2)
for i = 1:1001
    A = [Z1(1,i) + Z3, Z3; 
    Z3, Z2 + Z3];
    
    % Right-hand side vector
    B = -[V1; V2];
    
    % Solve for I1 and I2 using matrix inverse (or direct division)
    I = A \ B;  % Solve for currents I1 and I2
    
    % Extract currents
    I1 = I(1, :);  % Current at gate (I1)
    I2 = I(2, :);  % Current at drain (I2)
  
end



% Calculate MOSFET ID (only in saturation)
VGS = VG;  % Gate-Source voltage (fixed VG)
ID = zeros(size(VGS)); % Initialize drain current array

% Calculate ID in saturation region
VGS_VT = VGS - VT; % VGS - VT
ID(VGS_VT > 0) = 0.5 * mu * Cox * (W / L) * VGS_VT(VGS_VT > 0).^2;

% Calculate Padd
Padd = -0.5 * real(V1 .* conj(I1) + V2 .* conj(I2)); 

% Compute power for each Q1 using vectorized operations
P_total = Padd - 0.5 * abs(I1).^2 * X1 ./ Q1' - 0.5 * abs(I2).^2 * X2 / 1000 - 0.5 * abs(I1 + I2).^2 * X3 / 1000;

% Plot the results
figure;
plot(Q1_scan, P_total, 'r', 'LineWidth', 2);
grid on;
xlabel('Q1 (Quality Factor)');
ylabel('Total Power P (W)');
title('Total Power vs Q1');