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

Za_base =  (  (Z1*Z2)+(Z1*Z3)+(Z2*Z3) ) / Z2;
Zb  = (  (Z1*Z2)+(Z1*Z3)+(Z2*Z3) ) / Z1;
Zc =  (  (Z1*Z2)+(Z1*Z3)+(Z2*Z3) ) / Z3;

% Fixed Gate voltage (VG = 0.6V)
VG = 0.6;              % Gate voltage (V)
V1 = VG; % Voltage at gate (fixed VG)
V2 = VDD; % Voltage at drain (constant VDD)

% Impedance values
Xa = imag(Za_base);  % Imaginary part of Z1_base
Xb = imag(Zb);            % Imaginary part of Z2
Xc = imag(Zc);            % Imaginary part of Z3


% Scan Q1 from 0 to 1000 (vectorized)
Q1_scan = 0:1:1000;       % Q1 values to scan
Q1 = Q1_scan(:);          % Ensure Q1 is a column vector

% Modify Z1 with Q1 (matrix form to match Q1_scan)
Za = transpose(real(Za_base) + 1j * (Q1*real(Za_base)));  % Modify Z1 based on Q1

I1 = zeros(1, 1001);  % Current at gate (I1)
I2 = zeros(1, 1001);  % Current at drain (I2)
for i = 1:1001
    I1(1,i) = (V2-V1)./Zc - V1./Za(1,i);
    I2(1,i) = (-V1)./Za(1,i) + (-V2)./Zb;
  
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
P_total = Padd - 0.5 * abs(I1).^2 * Xa ./ Q1' - 0.5 * abs(I2).^2 * Xb / 1000 - 0.5 * abs(I1 + I2).^2 * Xc / 1000;

% Plot the results
figure;
plot(Q1_scan, P_total, 'r', 'LineWidth', 2);
grid on;
xlabel('Q1 (Quality Factor)');
ylabel('Total Power P (W)');
title('Total Power vs Q1');