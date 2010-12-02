clear all; close all;

syms R L K1 K2 J f
s=tf('s')

A=[[-R/L -K2/L 0];[K1/J -f/J 0 ];[0 1 0]]

B=[1;0;0]
C=[0 0 1]
g=C*inv(s*eye(size(A,1))- A)*B
%g=C*inv(s*eye(2)-A+B*k)*B