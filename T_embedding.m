% 已知参数
I1R = 2.72e-3; I1I = 6.03e-3;
I2R = 1.18e-3; I2I = 8.42e-3;
V1R = 192.3e-3; V1I = 86.3e-3;
V2R = 83.2e-3; V2I = 200.3e-3;
Q1=30;Q2=30;Q3=50;
E1 = (I1R+I2R)/Q3-(I1I+I2I); 
E2 = (I1I+I2I)/Q3+(I1R+I2R);
E3 = (I1R+I2R)/Q3-(I1I+I2I);
E4 = (I1I+I2I)/Q3+(I1R+I2R);
% 矩阵 A
A = [  0,  I1R/Q1-I1I,  0, E1;
       0,  I1I/Q1+I1R,  0, E2;
      I2R,  0, I2R/Q2-I2I, E3;
      I2I,  0, I2I/Q2+I2R, E4];

% 右端向量 B
B = [V1R; V1I; V2R; V2I];

% 解方程 AX = B
X = A \ B;  % 或 X = inv(A) * B

% 结果
Rs = X(1);
X1 = X(2);
X2 = X(3);
X3 = X(4);

disp([Rs, X1, X2, X3]);