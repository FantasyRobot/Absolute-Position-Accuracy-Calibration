
function J = T12B_14_Jacobian(q)
    x=zeros(10, 1);
    delta_step = 0.0001;
    for i=1:10
        P0 = T12B_14_2(x, q);
        x(i,1) = delta_step;
        P1 = T12B_14_2(x, q);
        J(1,i)=(P1(1,4)-P0(1,4))/delta_step;
        J(2,i)=(P1(2,4)-P0(2,4))/delta_step;
        J(3,i)=(P1(3,4)-P0(3,4))/delta_step;
        x(i,1) = 0.0;
    end
end