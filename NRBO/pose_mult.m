function P = pose_mult(P1,P2)
    d_x =1;
    d_y =2;
    d_z =3;
    d_u0=4;
    d_u1=5;
    d_u2=6;
    d_u3=7;
    %% quaternion_mult
    %p1:0.801858,0.476144,-0.240866,0.268876;p2:1.000000,0.000000,0.000000,0.000000;pr:0.801858,0.476144,-0.240866,0.268876

   dot = P1(d_u1,1) * P2(d_u1,1) + P1(d_u2,1) * P2(d_u2,1) + P1(d_u3,1) * P2(d_u3,1);
   P(d_u0,1) = P1(d_u0,1) * P2(d_u0,1) - dot;
   P(d_u1,1) = P1(d_u0,1) * P2(d_u1,1)  + P1(d_u1,1)  * P2(d_u0,1) + P1(d_u2,1)  * P2(d_u3,1)  - P1(d_u3,1) * P2(d_u2,1);
   P(d_u2,1) = P1(d_u0,1) * P2(d_u2,1) + P1(d_u2,1)  * P2(d_u0,1) +P1(d_u3,1)  * P2(d_u1,1)- P1(d_u1,1) * P2(d_u3,1);
   P(d_u3,1) = P1(d_u0,1) * P2(d_u3,1) + P1(d_u3,1)  * P2(d_u0,1) +P1(d_u1,1)  * P2(d_u2,1)- P1(d_u2,1) * P2(d_u1,1);
   if P(d_u0,1) < 0.0
      P(d_u0,1) = -P(d_u0,1);
      P(d_u1,1) = -P(d_u1,1);
      P(d_u2,1) = -P(d_u2,1);
      P(d_u3,1) = -P(d_u3,1);
   end

   %% quaternion_cartesian_rotation
   %p1:0.801858,0.476144,-0.240866,0.268876;p:0.183424,-0.072539,0.384362;pr:0.133481,-0.335423,0.237307
   u0 = -P(d_u1,1) * P2(d_x,1) - P(d_u2,1) * P2(d_y,1) - P(d_u3,1) * P2(d_z,1);
   u1 = P(d_u0,1) * P2(d_x,1) + P(d_u2,1) * P2(d_z,1) - P(d_u3,1) * P2(d_y,1);
   u2 = P(d_u0,1) * P2(d_y,1) - P(d_u1,1) * P2(d_z,1) + P(d_u3,1) * P2(d_x,1);
   u3 = P(d_u0,1) * P2(d_z,1) + P(d_u1,1) * P2(d_y,1) - P(d_u2,1) * P2(d_x,1);
   
   inv_u0 = P(d_u0,1); inv_u1 = -P(d_u1,1); inv_u2 = -P(d_u2,1); inv_u3 = -P(d_u3,1);
   
   P(d_x,1) = u0 * inv_u1 + u1 * inv_u0 + u2 * inv_u3 - u3 * inv_u2;
   P(d_y,1) = u0 * inv_u2 + u2 * inv_u0 + u3 * inv_u1 - u1 * inv_u3;
   P(d_z,1) = u0 * inv_u3 + u3 * inv_u0 + u1 * inv_u2 - u2 * inv_u1;

    %% math_lib_cartesian_add
    %p1:0.130764,-0.773736,1.824383;pr:0.264244,-1.109160,2.061690
   P(d_x,1) = P(d_x,1)+P1(d_x,1);
   P(d_y,1) = P(d_y,1)+P1(d_y,1);
   P(d_z,1) = P(d_z,1)+P1(d_z,1);
end