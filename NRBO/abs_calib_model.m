function [P, R] = abs_calib_model(theta, joint_err)
   
   DA3 = joint_err(6,1);%mrp->attitude.gamma_1;
   DB2 = joint_err(12,1);%mrp->attitude.gamma_2;
   DC2 = joint_err(18,1);%mrp->attitude.gamma_3;
   DD1 = joint_err(24,1);%mrp->attitude.gamma_4;
   DE2 = joint_err(30,1);%mrp->attitude.gamma_5;
   DF1 = joint_err(36,1);%mrp->attitude.gamma_6;

   %% /* Sines and Cosines of robot joint angles */

   S1 = sin (theta(1,1) - DA3);
   C1 = cos (theta(1,1) - DA3);
   S2 = sin (theta(2,1) - DB2);
   C2 = cos (theta(2,1) - DB2);
   S4 = sin (theta(4,1) - DD1);
   C4 = cos (theta(4,1) - DD1);
   S5 = sin (theta(5,1) - DE2);
   C5 = cos (theta(5,1) - DE2);
   S6 = sin (theta(6,1) - DF1);
   C6 = cos (theta(6,1) - DF1);
   S23 = sin (theta(2,1) - DB2 - theta(3,1) + DC2);
   C23 = cos (theta(2,1) - DB2 - theta(3,1) + DC2);

   %% /* Sines and Cosines of robot joint attitude error angles */

   SDA1 = sin(joint_err(4,1));%mrp->attitude.sin_alfa_1;
   SDA2 = sin(joint_err(5,1));%mrp->attitude.sin_beta_1;

   SDB1 = sin(joint_err(10,1));%mrp->attitude.sin_alfa_2;
   SDB3 = sin(joint_err(11,1));%mrp->attitude.sin_beta_2;

   SDC1 = sin(joint_err(16,1));%mrp->attitude.sin_alfa_3;
   SDC3 = sin(joint_err(17,1));%mrp->attitude.sin_beta_3;

   SDD2 = sin(joint_err(22,1));%mrp->attitude.sin_alfa_4;
   SDD3 = sin(joint_err(23,1));%mrp->attitude.sin_beta_4;

   SDE1 = sin(joint_err(28,1));%mrp->attitude.sin_alfa_5;
   SDE3 = sin(joint_err(29,1));%mrp->attitude.sin_beta_5;

   SDF2 = sin(joint_err(34,1));%mrp->attitude.sin_alfa_6;
   SDF3 = sin(joint_err(35,1));%mrp->attitude.sin_beta_6;

   CDA1 = cos(joint_err(4,1));%mrp->attitude.cos_alfa_1;
   CDA2 = cos(joint_err(5,1));%mrp->attitude.cos_beta_1;

   CDB1 = cos(joint_err(10,1));%mrp->attitude.cos_alfa_2;
   CDB3 = cos(joint_err(11,1));%mrp->attitude.cos_beta_2;

   CDC1 = cos(joint_err(16,1));%mrp->attitude.cos_alfa_3;
   CDC3 = cos(joint_err(17,1));% mrp->attitude.cos_beta_3;

   CDD2 = cos(joint_err(22,1));%mrp->attitude.cos_alfa_4;
   CDD3 = cos(joint_err(23,1));%mrp->attitude.cos_beta_4;

   CDE1 = cos(joint_err(28,1));%mrp->attitude.cos_alfa_5;
   CDE3 = cos(joint_err(29,1));%mrp->attitude.cos_beta_5;

   CDF2 = cos(joint_err(34,1));%mrp->attitude.cos_alfa_6;
   CDF3 = cos(joint_err(35,1));%mrp->attitude.cos_beta_6;

   %% /* Robot joint offsets */
   EOFFSA1 = joint_err(1,1);%mrp->offset.joint1.x;
   EOFFSA2 = joint_err(2,1);%mrp->offset.joint1.y;
   EOFFSA3 = joint_err(3,1);%mrp->offset.joint1.z;
   EOFFSB1 = joint_err(7,1);%mrp->offset.joint2.x;
   EOFFSB2 = joint_err(8,1);%mrp->offset.joint2.y;
   EOFFSB3 = joint_err(9,1);%mrp->offset.joint2.z;
   EOFFSC1 = joint_err(13,1);%mrp->offset.joint3.x;
   EOFFSC2 = joint_err(14,1);%mrp->offset.joint3.y;
   EOFFSC3 = joint_err(15,1);%mrp->offset.joint3.z;
   EOFFSD1 = joint_err(19,1);%mrp->offset.joint4.x;
   EOFFSD2 = joint_err(20,1);%mrp->offset.joint4.y;
   EOFFSD3 = joint_err(21,1);%mrp->offset.joint4.z;
   EOFFSE1 = joint_err(25,1);%mrp->offset.joint5.x;
   EOFFSE2 = joint_err(26,1);%mrp->offset.joint5.y;
   EOFFSE3 = joint_err(27,1);%mrp->offset.joint5.z;
   EOFFSF1 = joint_err(31,1);%mrp->offset.joint6.x;
   EOFFSF2 = joint_err(32,1);%mrp->offset.joint6.y;
   EOFFSF3 = joint_err(33,1);%mrp->offset.joint6.z;

   H_OF_F = 0.615;%mrp->height_of_foot;
   H_OF_B = 0;%mrp->height_of_base;
   O_OF_J_2 = 0.1;%mrp->offset_of_joint2_x;
   L_OF_L_A = 0.705;%mrp->length_of_lower_arm;
   O_OF_U_A = 0.135;%mrp->offset_of_upper_arm;
   L_OF_W = 0.085;%mrp->length_of_wrist;
   L_OF_H = 0.3775;%mrp->length_of_housing_axis_4;
   L_OF_T = 0.3775;%mrp->length_of_tube_shaft;

   CP_BODY_CX = -0.25;%mrp->cp_body_c.x;
   CP_BODY_CY = -0.2;%mrp->cp_body_c.y;
   CP_BODY_CZ = 0.25;%mrp->cp_body_c.z;

   z(1) = CDA1;
   z(2) = SDA1;
   z(3) = CDA2;
   z(4) = SDA2;
   z(5) = C1;
   z(6) = S1;
   z(7) = CDB1;
   z(8) = SDB1;
   z(9) = CDB3;
   z(10) = SDB3;
   z(11) = C2;
   z(12) = S2;
   z(13) = CDC1;
   z(14) = SDC1;
   z(15) = CDC3;
   z(16) = SDC3;
   z(17) = C23;
   z(18) = S23;
   z(19) = z(3) * z(5);
   z(20) = z(4) * z(5);
   z(21) = z(3) * z(6);
   z(22) = z(4) * z(6);
   z(23) = z(1) * z(6) + z(2) * z(20);
   z(24) = z(2) * z(6) - z(1) * z(20);
   z(25) = z(1) * z(5) - z(2) * z(22);
   z(26) = z(1) * z(22) + z(2) * z(5);
   z(27) = z(2) * z(3);
   z(28) = z(1) * z(3);
   z(29) = z(9) * z(11);
   z(30) = z(10) * z(11);
   z(31) = z(9) * z(12);
   z(32) = z(10) * z(12);
   z(33) = z(4) * z(8) - z(7) * z(21);
   z(34) = z(7) * z(25) - z(8) * z(27);
   z(35) = z(7) * z(26) + z(8) * z(28);
   z(36) = z(4) * z(7) + z(8) * z(21);
   z(37) = -z(7) * z(27) - z(8) * z(25);
   z(38) = z(7) * z(28) - z(8) * z(26);
   z(39) = z(19) * z(29) + z(30) * z(33) - z(12) * z(36);
   z(40) = z(23) * z(29) + z(30) * z(34) - z(12) * z(37);
   z(41) = z(24) * z(29) + z(30) * z(35) - z(12) * z(38);
   z(42) = z(9) * z(33) - z(10) * z(19);
   z(43) = z(9) * z(34) - z(10) * z(23);
   z(44) = z(9) * z(35) - z(10) * z(24);
   z(45) = z(11) * z(36) + z(19) * z(31) + z(32) * z(33);
   z(46) = z(11) * z(37) + z(23) * z(31) + z(32) * z(34);
   z(47) = z(11) * z(38) + z(24) * z(31) + z(32) * z(35);
   z(48) = z(15) * z(17);
   z(49) = z(16) * z(17);
   z(50) = z(15) * z(18);
   z(51) = z(16) * z(18);
   z(52) = z(13) * z(42) + z(14) * z(45);
   z(53) = z(13) * z(43) + z(14) * z(46);
   z(54) = z(13) * z(44) + z(14) * z(47);
   z(55) = z(13) * z(45) - z(14) * z(42);
   z(56) = z(13) * z(46) - z(14) * z(43);
   z(57) = z(13) * z(47) - z(14) * z(44);
   z(58) = z(18) * z(55) + z(39) * z(48) + z(49) * z(52);
   z(59) = z(18) * z(56) + z(40) * z(48) + z(49) * z(53);
   z(60) = z(18) * z(57) + z(41) * z(48) + z(49) * z(54);
   z(61) = z(15) * z(52) - z(16) * z(39);
   z(62) = z(15) * z(53) - z(16) * z(40);
   z(63) = z(15) * z(54) - z(16) * z(41);
   z(64) = z(17) * z(55) - z(39) * z(50) - z(51) * z(52);
   z(65) = z(17) * z(56) - z(40) * z(50) - z(51) * z(53);
   z(66) = z(17) * z(57) - z(41) * z(50) - z(51) * z(54);
   z(67) = CDD2;
   z(68) = SDD2;
   z(69) = CDD3;
   z(70) = SDD3;
   z(71) = C4;
   z(72) = S4;
   z(73) = z(70) * z(71);
   z(74) = z(69) * z(71);
   z(75) = z(70) * z(72);
   z(76) = z(69) * z(72);
   z(77) = z(58) * z(67) - z(64) * z(68);
   z(78) = z(59) * z(67) - z(65) * z(68);
   z(79) = z(60) * z(67) - z(66) * z(68);
   z(80) = z(58) * z(68) + z(64) * z(67);
   z(81) = z(59) * z(68) + z(65) * z(67);
   z(82) = z(60) * z(68) + z(66) * z(67);
   z(83) = z(61) * z(70) + z(69) * z(77);
   z(84) = z(62) * z(70) + z(69) * z(78);
   z(85) = z(63) * z(70) + z(69) * z(79);
   z(86) = z(61) * z(74) + z(72) * z(80) - z(73) * z(77);
   z(87) = z(62) * z(74) + z(72) * z(81) - z(73) * z(78);
   z(88) = z(63) * z(74) + z(72) * z(82) - z(73) * z(79);
   z(89) = z(71) * z(80) + z(75) * z(77) - z(61) * z(76);
   z(90) = z(71) * z(81) + z(75) * z(78) - z(62) * z(76);
   z(91) = z(71) * z(82) + z(75) * z(79) - z(63) * z(76);
   z(92) = CDE1;
   z(93) = SDE1;
   z(94) = CDE3;
   z(95) = SDE3;
   z(96) = C5;
   z(97) = S5;
   z(98) = CDF2;
   z(99) = SDF2;
   z(100) = CDF3;
   z(101) = SDF3;
   z(102) = C6;
   z(103) = S6;
   z(104) = z(94) * z(96);
   z(105) = z(95) * z(96);
   z(106) = z(94) * z(97);
   z(107) = z(95) * z(97);
   z(108) = z(86) * z(92) + z(89) * z(93);
   z(109) = z(87) * z(92) + z(90) * z(93);
   z(110) = z(88) * z(92) + z(91) * z(93);
   z(111) = z(89) * z(92) - z(86) * z(93);
   z(112) = z(90) * z(92) - z(87) * z(93);
   z(113) = z(91) * z(92) - z(88) * z(93);
   z(114) = z(83) * z(104) + z(105) * z(108) - z(97) * z(111);
   z(115) = z(84) * z(104) + z(105) * z(109) - z(97) * z(112);
   z(116) = z(85) * z(104) + z(105) * z(110) - z(97) * z(113);
   z(117) = z(94) * z(108) - z(83) * z(95);
   z(118) = z(94) * z(109) - z(84) * z(95);
   z(119) = z(94) * z(110) - z(85) * z(95);
   z(120) = z(83) * z(106) + z(96) * z(111) + z(107) * z(108);
   z(121) = z(84) * z(106) + z(96) * z(112) + z(107) * z(109);
   z(122) = z(85) * z(106) + z(96) * z(113) + z(107) * z(110);
   z(123) = z(101) * z(102);
   z(124) = z(100) * z(102);
   z(125) = z(101) * z(103);
   z(126) = z(100) * z(103);
   z(127) = z(98) * z(114) - z(99) * z(120);
   z(128) = z(98) * z(115) - z(99) * z(121);
   z(129) = z(98) * z(116) - z(99) * z(122);
   z(130) = z(98) * z(120) + z(99) * z(114);
   z(131) = z(98) * z(121) + z(99) * z(115);
   z(132) = z(98) * z(122) + z(99) * z(116);
   z(133) = z(100) * z(127) + z(101) * z(117);
   z(134) = z(100) * z(128) + z(101) * z(118);
   z(135) = z(100) * z(129) + z(101) * z(119);
   z(136) = z(103) * z(130) + z(117) * z(124) - z(123) * z(127);
   z(137) = z(103) * z(131) + z(118) * z(124) - z(123) * z(128);
   z(138) = z(103) * z(132) + z(119) * z(124) - z(123) * z(129);
   z(139) = z(102) * z(130) + z(125) * z(127) - z(117) * z(126);
   z(140) = z(102) * z(131) + z(125) * z(128) - z(118) * z(126);
   z(141) = z(102) * z(132) + z(125) * z(129) - z(119) * z(126);

   %% /* Position of robot mounting interface */

   P(1,1) = (EOFFSA1 + EOFFSC1 * z(39) + EOFFSC2 * z(42) + EOFFSD2 * z(61) + EOFFSE2 * ...
      z(86) + EOFFSE3 * z(89) + EOFFSF1 * z(114) + EOFFSF2 * z(117) + EOFFSF3 * z(120) + ...
	   L_OF_W * z(133) + (EOFFSB1 + O_OF_J_2) * z(19) + (EOFFSB3 + H_OF_F + H_OF_B) * z(4) + (EOFFSC3 + ...
       L_OF_L_A) * z(45) + (EOFFSD1 + L_OF_H) * z(58) + (EOFFSD3 + O_OF_U_A) * z(64) + ( ...
	   EOFFSE1 + L_OF_T) * z(83) - EOFFSB2 * z(21));

   P(2,1) = (EOFFSA2 + EOFFSB2 * z(25) + EOFFSC1 * z(40) + EOFFSC2 * z(43) + EOFFSD2 * ...
      z(62) + EOFFSE2 * z(87) + EOFFSE3 * z(90) + EOFFSF1 * z(115) + EOFFSF2 * z(118) + ...
      EOFFSF3 * z(121) + L_OF_W * z(134) + (EOFFSB1 + O_OF_J_2) * z(23) + (EOFFSC3 + L_OF_L_A) * ...
      z(46) + (EOFFSD1 + L_OF_H) * z(59) + (EOFFSD3 + O_OF_U_A) * z(65) + (EOFFSE1 + L_OF_T) * ...
	   z(84) - (EOFFSB3 + H_OF_F + H_OF_B) * z(27));

   P(3,1) = (EOFFSA3 + EOFFSB2 * z(26) + EOFFSC1 * z(41) + EOFFSC2 * z(44) + EOFFSD2 * ...
      z(63) + EOFFSE2 * z(88) + EOFFSE3 * z(91) + EOFFSF1 * z(116) + EOFFSF2 * z(119) + ...
	   EOFFSF3 * z(122) + L_OF_W * z(135) + (EOFFSB1 + O_OF_J_2) * z(24) + (EOFFSB3 + H_OF_F + H_OF_B) * ...
      z(28) + (EOFFSC3 + L_OF_L_A) * z(47) + (EOFFSD1 + L_OF_H) * z(60) + (EOFFSD3 + O_OF_U_A) * ...
	   z(66) + (EOFFSE1 + L_OF_T) * z(85));
   
   %% 末端位姿四元数
   a(1,1) = z(133);
   a(1,2) = z(136);
   a(1,3) = z(139);

   a(2,1) = z(134);
   a(2,2) = z(137);
   a(2,3) = z(140);

   a(3,1) = z(135);
   a(3,2) = z(138);
   a(3,3) = z(141);
    
   trace = a(1,1) + a(2,2) + a(3,3);
   if trace > 0.0
      root = sqrt(trace + 1.0);                                
      u0   = 0.5 * root;
      root = 0.5 / root;                                        
      u1   = (a(3,2)-a(2,3)) * root;
      u2   = (a(1,3)-a(3,1)) * root;
      u3   = (a(2,1)-a(1,2)) * root;
   elseif a(1,1) >= a(2,2) && a(1,1) >= a(3,3)
      root = sqrt(1.0 + a(1,1) - (a(2,2) + a(3,3))); 
      u1   = 0.5 * root;
      root = 0.5 / root;                                      
      u2   = (a(1,2) + a(2,1)) * root;
      u3   = (a(3,1) + a(1,3)) * root;
      u0   = (a(3,2) -a(2,3)) * root;
   elseif a(2,2) >= a(3,3)
      root = sqrt(1.0 + a(2,2) - (a(3,3) + a(1,1)));
      u2   = 0.5 * root;
      root = 0.5 / root;                                         
      u3   = (a(2,3) + a(3,2)) * root;
      u1   = (a(1,2) + a(2,1)) * root;
      u0   = (a(1,3) - a(3,1)) * root;
    else
      root = sqrt(1.0 + a(3,3) - (a(1,1) + a(2,2))); 
      u3   = 0.5 * root;
      root = 0.5 / root;                                         
      u1   = (a(3,1) + a(1,3)) * root;
      u2   = (a(2,3) + a(3,2)) * root;
      u0   = (a(2,1) - a(1,2)) * root;
   end

	norm = sqrt(u0 * u0 + u1 * u1 + u2 * u2 + u3 * u3);

    u0 = u0/norm;
    u1 = u1/norm;
    u2 = u2/norm;
    u3 = u3/norm;
    
	if u0 < 0.0
		u0 = -u0;
		u1 = -u1;
		u2 = -u2;
		u3 = -u3;
    else
        u0 = u0;
		u1 = u1;
		u2 = u2;
		u3 = u3;
    end
    R = quat2rotm([u0 u1 u2 u3]);
    %R = quat2dcm([u0 u1 u2 u3])*quat2dcm([0.707107 0 0.707107 0]);
    %R = Quaternion([u0 u1 u2 u3])*Quaternion([0.707107 0 0.707107 0]);
end