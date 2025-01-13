function [a,b,c,d] = cubic_solve(t_in,t_out,x_in,x_out,dx_in,dx_out)

% Cubic interpolation between two points, returns the four coefficients of
% the cubic polynomial a*t^3 + b*t^2 + c*t + d,  by computing the inverse of the system's matrix
% representation X=A*T

% t_in - start abscissa 
% t_out - end abscissa
% x_in - start ordinate
% x_out - end ordinate
% dx_in - tangent slope at start point
% dx_out - tangent slope at end point

% a - coefficient for the third degree term of the resulting polynomial
% b - coefficient for the second degree term of the resulting polynomial
% c - coefficient for the first degree term of the resulting polynomial
% d - coefficient for the constant term of the resulting polynomial

eq1=[t_in^3 t_in^2 t_in 1];
eq2=[t_out^3 t_out^2 t_out 1];
eq3=[3*t_in^2 2*t_in 1 0];
eq4=[3*t_out^2 2*t_out 1 0];

alpha=[eq1;eq2;eq3;eq4];
beta=[x_in;x_out;dx_in;dx_out];

sol=alpha^(-1)*beta;

a=sol(1);
b=sol(2);
c=sol(3);
d=sol(4);

end
