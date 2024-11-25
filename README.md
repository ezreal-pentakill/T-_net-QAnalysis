# T-_net-QAnalysis
Analysis of T &amp; π network based on Q
对于一个Oscillator来说，具有π和T两种结构，程序对两种结构对电路impedance的Q值敏感度进行了对比
对于π网络和T网络的区别理论推导：假设T型网络的三个阻抗分别为 Z1, Z2, Z3，π型网络三个参数分别为Za, Zb, Zc（等效电路）,可以用网络等效来实现T π网络对于三端口的阻抗等效
Za = (Z1*Z2+Z2*Z3+Z1*Z3)/Z2; Zb = (Z1*Z2+Z2*Z3+Z1*Z3)/Z1; Zc = (Z1*Z2+Z2*Z3+Z1*Z3)/Z3;
附上T型π型网络图

等效电路之后，transistor的工作条件（Bias)也相同，对于T型和π型网络而言，都存在唯一解（I1_real, I1_imag, I2_real, I2_imag)，带入可得P_out
T型网络的电流电压关系：
V1+(Z1+Z3)*I1+Z3*I2=0;  V2+(Z2+Z3)*I2+Z3*I1=0
采用矩阵的手段（注意粉色这里的I 和 V 都是复数，两个复数的乘积取实部包含实部相乘和虚部相乘）
![matrix_I](https://github.com/user-attachments/assets/4f1ce768-4070-4baa-8f98-8b7ddd80a14e)
求得I1 I2之后，P_loss,1=(|I1|^2/2)*X1/Q1, P_loss,2=(|I2|^2/2)*X2/Q2, P_loss,3=(|I1+I2|^2/2)*X3/Q3
P_out=P_add-∑P_loss,i

