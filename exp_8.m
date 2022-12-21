clc
close all
clear all

%   Aim - Generation and analysis of 7,4 block code.
%   Generate prbs of length 64
%   4X7 G =    1101000
%              0110100
%              1110010
%              1010001
%   b = mod(u*G,2)
%   R = mod(b+e,2)
%   e is error i.e. prbs matrix of dimension of b(16X7)
%   S = mod(R*H',2)
%   for i=1:length(H), if H'(i)==S, therefore i = error bit

% **********************Generation of prbs and u**************************

a = randi([0 1], 1, 64);
x = zeros(16,4);
for i=0:15
    for j=1:4
        x(i+1,j) = a(4*i+j);
    end
end

%***********************Generator matrix and block code*******************

G = [1 1 0 1 0 0 0
     0 1 1 0 1 0 0
     1 1 1 0 0 1 0
     1 0 1 0 0 0 1];

b = mod(x*G, 2);

%*********************Transmission with error*****************************

e = randi([0 1], 16,7);
R = mod(b+e, 2);

%*********************H and S generation**********************************

H = zeros(3,7);
for i=1:4
    for j=1:3
        P(i,j) = G(i,j);
        H(j,i) = P(i,j);
    end
end

I = [1 0 0
     0 1 0
     0 0 1];

for i=1:3
    for j=5:7
        H(i,j) = I(i,j-4);
    end
end

S = mod(R*H', 2);

%*************************Error checking**********************************

H1 = H';
n = zeros(1,16);
A = zeros(1,16);
for j=1:16
    for i=1:length(H)
        for k=1:3
            if H1(i,k)==S(j,k)
                n(j)=n(j)+1;
            end
        end
        if n(j)==3
            A(j) = i;
        elseif A(j)==0
            A(j) = 0;
            n(j) = 0;
        end
    end
end

%***********************Error correction**********************************

Rc = R;
for i=1:16
    for j=1:7
        if A(i)==j
            if Rc(i,j)==0
                Rc(i,j) = 1;
            else
                Rc(i,j) = 0;
            end
        end
    end
end

%***************************R=1011000*************************************

R1 = [1 0 1 1 0 0 0];
disp("Recieved code: ");
display(R1);
S1 = mod(R1*H1, 2);
n1 = zeros(1,16);
for i=1:length(H)
    for k=1:3
         if H1(i,k)==S1(1,k)
             n1=n1+1;
         end
     end
     if n1==3
         if R1(1,i)==0
             R1(1,i)=1;
             A1 = i;
         else
             R1(1,i)=0;
         end
     else
         n1 = 0;
     end
end

disp("H transpose is: ");
display(H1);
disp("S is: ");
display(S1);
disp("Error is at bit no. ");
display(A1);
disp("Corrected code: ");
display(R1);

%*************************END OF PROGRAM**********************************