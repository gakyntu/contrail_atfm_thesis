function [z1,z2,z3] = roots_poly3(a,b,c,d)

p=c/a-5*b^2./(9*a^2);
q=d/a-(b*c)/(3*a^2)+(2*b^3)/(27*a^3);
alpha=-0.5+0.5*sqrt(3)*j;

z1=nthroot(-0.5*q-sqrt(q.^2/4+p^3/27),3)+nthroot(-0.5*q+sqrt(q.^2/4+p^3/27),3);
z2=alpha*nthroot(-0.5*q-sqrt(q.^2/4+p^3/27),3)+alpha^2*nthroot(-0.5*q+sqrt(q.^2/4+p^3/27),3);
z3=alpha^2*nthroot(-0.5*q-sqrt(q.^2/4+p^3/27),3)+alpha*nthroot(-0.5*q+sqrt(q.^2/4+p^3/27),3);

end