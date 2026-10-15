%% T12B-14绝对精度正向运动学模型
%% abs_err:6组(x,y,z,alfa,belta,gamma)
%% x(1):gamma_1->abs_err(6,1)
%% x(2):x_2->abs_err(7,1)
%% x(3):y_2->abs_err(8,1)
%% x(4):belta_2->abs_err(11,1)
%% x(5):z_3->abs_err(15,1)
%% x(6):alfa_3->abs_err(16,1)
%% x(7):belta_3->abs_err(17,1)
%% x(8):alfa_4->abs_err(21,1)
%% x(9):x_5->abs_err(25,1)
%% x(10):belta_5->abs_err(29,1)

function P= T12B_14(x, q1,q2,q3,q4,q5,q6,model_param, abs_err, trans_to_tool)
    %%P = eye(4,4);
    %%a = zeros(3,3);

    q33 = q2+q3;
    DA3 = x(1);%% abs_err(6,1);  %%gamma_1
    DB2 = abs_err(12,1);
    DC2 = abs_err(18,1);
    DD1 = abs_err(24,1);
    DE2 = abs_err(30,1);
    DF1 = abs_err(36,1);

    S1 = sin (q1 - DA3);
    C1 = cos (q1 - DA3);
    S2 = sin (q2 - DB2);
    C2 = cos (q2 - DB2);
    S4 = sin (q4 - DD1);
    C4 = cos (q4 - DD1);
    S5 = sin (q5 - DE2);
    C5 = cos (q5 - DE2);
    S6 = sin (q6 - DF1);
    C6 = cos (q6 - DF1);
    S23 = sin (q2 - DB2 - q33 + DC2);
    C23 = cos (q2 - DB2 - q33 + DC2);

    SDA1 = sin(abs_err(4,1)); %% sin_alfa_1
    SDA2 = sin(abs_err(5,1)); %% sin_beta_1

    SDB1 = sin(abs_err(10,1));%%sin_alfa_2
    SDB3 = sin(x(4));%% sin(abs_err(11,1));

    SDC1 = sin(x(6)); %%sin(abs_err(16,1));
    SDC3 = sin(x(7));

    SDD2 = sin(abs_err(22,1));
    SDD3 = sin(abs_err(23,1));

    SDE1 = sin(abs_err(28,1));
    SDE3 = sin(x(10));%%sin(abs_err(29,1));

    SDF2 = sin(abs_err(34,1));
    SDF3 = sin(abs_err(35,1));

    CDA1 = cos(abs_err(4,1));%% cos_alfa_1
    CDA2 = cos(abs_err(5,1));%% cos_belta_1

    CDB1 = cos(abs_err(10,1));%% cos_alfa_2
    CDB3 = cos(x(4));%%cos(abs_err(11,1)); %% cos_belta_2

    CDC1 = cos(x(6));%%cos(abs_err(16,1));
    CDC3 = cos(x(7));%% abs_err(17,1)

    CDD2 = cos(abs_err(22,1));
    CDD3 = cos(abs_err(23,1));

    CDE1 = cos(abs_err(28,1));
    CDE3 = cos(x(10));%%cos(abs_err(29,1));

    CDF2 = cos(abs_err(34,1));
    CDF3 = cos(abs_err(35,1));

    EOFFSA1 = abs_err(1,1);%% x1
    EOFFSA2 = abs_err(2,1);
    EOFFSA3 = abs_err(3,1);

    EOFFSB1 = x(2);%%abs_err(7,1);%% x2
    EOFFSB2 = x(3);%%abs_err(8,1);
    EOFFSB3 = abs_err(9,1);

    EOFFSC1 = abs_err(13,1);%% x3
    EOFFSC2 = abs_err(14,1);
    EOFFSC3 = x(5); %% abs_err(15,1);

    EOFFSD1 = abs_err(19,1);
    EOFFSD2 = abs_err(20,1);
    EOFFSD3 = x(8);%%abs_err(21,1);
    EOFFSE1 = x(9);%%abs_err(25,1);
    EOFFSE2 = abs_err(26,1);
    EOFFSE3 = abs_err(27,1);
    EOFFSF1 = abs_err(31,1);
    EOFFSF2 = abs_err(32,1);
    EOFFSF3 = abs_err(33,1);

    H_OF_F = 0;
    O_OF_J_2 = model_param(1,1);%% 0.185
    L_OF_L_A = model_param(2,1);%% 0.6
    O_OF_U_A = model_param(3,1);%% 0.2
    L_OF_W = model_param(5,1);%% 0.105
    L_OF_H = 0;
    L_OF_T = model_param(4,1); %% 0.65

    z_1 = CDA1;
    z_2 = SDA1;
    z_3 = CDA2;
    z_4 = SDA2;
    z_5 = C1;
    z_6 = S1;
    z_7 = CDB1;
    z_8 = SDB1;
    z_9 = CDB3;
    z_10 = SDB3;
    z_11 = C2;
    z_12 = S2;
    z_13 = CDC1;
    z_14 = SDC1;
    z_15 = CDC3;
    z_16 = SDC3;
    z_17 = C23;
    z_18 = S23;
    z_19 = z_3 * z_5;
    z_20 = z_4 * z_5;
    z_21 = z_3 * z_6;
    z_22 = z_4 * z_6;
    z_23 = z_1 * z_6 + z_2 * z_20;
    z_24 = z_2 * z_6 - z_1 * z_20;
    z_25 = z_1 * z_5 - z_2 * z_22;
    z_26 = z_1 * z_22 + z_2 * z_5;
    z_27 = z_2 * z_3;
    z_28 = z_1 * z_3;
    z_29 = z_9 * z_11;
    z_30 = z_10 * z_11;
    z_31 = z_9 * z_12;
    z_32 = z_10 * z_12;
    z_33 = z_4 * z_8 - z_7 * z_21;
    z_34 = z_7 * z_25 - z_8 * z_27;
    z_35 = z_7 * z_26 + z_8 * z_28;
    z_36 = z_4 * z_7 + z_8 * z_21;
    z_37 = -z_7 * z_27 - z_8 * z_25;
    z_38 = z_7 * z_28 - z_8 * z_26;
    z_39 = z_19 * z_29 + z_30 * z_33 - z_12 * z_36;
    z_40 = z_23 * z_29 + z_30 * z_34 - z_12 * z_37;
    z_41 = z_24 * z_29 + z_30 * z_35 - z_12 * z_38;
    z_42 = z_9 * z_33 - z_10 * z_19;
    z_43 = z_9 * z_34 - z_10 * z_23;
    z_44 = z_9 * z_35 - z_10 * z_24;
    z_45 = z_11 * z_36 + z_19 * z_31 + z_32 * z_33;
    z_46 = z_11 * z_37 + z_23 * z_31 + z_32 * z_34;
    z_47 = z_11 * z_38 + z_24 * z_31 + z_32 * z_35;
    z_48 = z_15 * z_17;
    z_49 = z_16 * z_17;
    z_50 = z_15 * z_18;
    z_51 = z_16 * z_18;
    z_52 = z_13 * z_42 + z_14 * z_45;
    z_53 = z_13 * z_43 + z_14 * z_46;
    z_54 = z_13 * z_44 + z_14 * z_47;
    z_55 = z_13 * z_45 - z_14 * z_42;
    z_56 = z_13 * z_46 - z_14 * z_43;
    z_57 = z_13 * z_47 - z_14 * z_44;
    z_58 = z_18 * z_55 + z_39 * z_48 + z_49 * z_52;
    z_59 = z_18 * z_56 + z_40 * z_48 + z_49 * z_53;
    z_60 = z_18 * z_57 + z_41 * z_48 + z_49 * z_54;
    z_61 = z_15 * z_52 - z_16 * z_39;
    z_62 = z_15 * z_53 - z_16 * z_40;
    z_63 = z_15 * z_54 - z_16 * z_41;
    z_64 = z_17 * z_55 - z_39 * z_50 - z_51 * z_52;
    z_65 = z_17 * z_56 - z_40 * z_50 - z_51 * z_53;
    z_66 = z_17 * z_57 - z_41 * z_50 - z_51 * z_54;
    z_67 = CDD2;
    z_68 = SDD2;
    z_69 = CDD3;
    z_70 = SDD3;
    z_71 = C4;
    z_72 = S4;
    z_73 = z_70 * z_71;
    z_74 = z_69 * z_71;
    z_75 = z_70 * z_72;
    z_76 = z_69 * z_72;
    z_77 = z_58 * z_67 - z_64 * z_68;
    z_78 = z_59 * z_67 - z_65 * z_68;
    z_79 = z_60 * z_67 - z_66 * z_68;
    z_80 = z_58 * z_68 + z_64 * z_67;
    z_81 = z_59 * z_68 + z_65 * z_67;
    z_82 = z_60 * z_68 + z_66 * z_67;
    z_83 = z_61 * z_70 + z_69 * z_77;
    z_84 = z_62 * z_70 + z_69 * z_78;
    z_85 = z_63 * z_70 + z_69 * z_79;
    z_86 = z_61 * z_74 + z_72 * z_80 - z_73 * z_77;
    z_87 = z_62 * z_74 + z_72 * z_81 - z_73 * z_78;
    z_88 = z_63 * z_74 + z_72 * z_82 - z_73 * z_79;
    z_89 = z_71 * z_80 + z_75 * z_77 - z_61 * z_76;
    z_90 = z_71 * z_81 + z_75 * z_78 - z_62 * z_76;
    z_91 = z_71 * z_82 + z_75 * z_79 - z_63 * z_76;
    z_92 = CDE1;
    z_93 = SDE1;
    z_94 = CDE3;
    z_95 = SDE3;
    z_96 = C5;
    z_97 = S5;
    z_98 = CDF2;
    z_99 = SDF2;
    z_100 = CDF3;
    z_101 = SDF3;
    z_102 = C6;
    z_103 = S6;
    z_104 = z_94 * z_96;
    z_105 = z_95 * z_96;
    z_106 = z_94 * z_97;
    z_107 = z_95 * z_97;
    z_108 = z_86 * z_92 + z_89 * z_93;
    z_109 = z_87 * z_92 + z_90 * z_93;
    z_110 = z_88 * z_92 + z_91 * z_93;
    z_111 = z_89 * z_92 - z_86 * z_93;
    z_112 = z_90 * z_92 - z_87 * z_93;
    z_113 = z_91 * z_92 - z_88 * z_93;
    z_114 = z_83 * z_104 + z_105 * z_108 - z_97 * z_111;
    z_115 = z_84 * z_104 + z_105 * z_109 - z_97 * z_112;
    z_116 = z_85 * z_104 + z_105 * z_110 - z_97 * z_113;
    z_117 = z_94 * z_108 - z_83 * z_95;
    z_118 = z_94 * z_109 - z_84 * z_95;
    z_119 = z_94 * z_110 - z_85 * z_95;
    z_120 = z_83 * z_106 + z_96 * z_111 + z_107 * z_108;
    z_121 = z_84 * z_106 + z_96 * z_112 + z_107 * z_109;
    z_122 = z_85 * z_106 + z_96 * z_113 + z_107 * z_110;
    z_123 = z_101 * z_102;
    z_124 = z_100 * z_102;
    z_125 = z_101 * z_103;
    z_126 = z_100 * z_103;
    z_127 = z_98 * z_114 - z_99 * z_120;
    z_128 = z_98 * z_115 - z_99 * z_121;
    z_129 = z_98 * z_116 - z_99 * z_122;
    z_130 = z_98 * z_120 + z_99 * z_114;
    z_131 = z_98 * z_121 + z_99 * z_115;
    z_132 = z_98 * z_122 + z_99 * z_116;
    z_133 = z_100 * z_127 + z_101 * z_117;
    z_134 = z_100 * z_128 + z_101 * z_118;
    z_135 = z_100 * z_129 + z_101 * z_119;
    z_136 = z_103 * z_130 + z_117 * z_124 - z_123 * z_127;
    z_137 = z_103 * z_131 + z_118 * z_124 - z_123 * z_128;
    z_138 = z_103 * z_132 + z_119 * z_124 - z_123 * z_129;
    z_139 = z_102 * z_130 + z_125 * z_127 - z_117 * z_126;
    z_140 = z_102 * z_131 + z_125 * z_128 - z_118 * z_126;
    z_141 = z_102 * z_132 + z_125 * z_129 - z_119 * z_126;

    P(1,4) = (EOFFSA1 + EOFFSC1 * z_39 + EOFFSC2 * z_42 + EOFFSD2 * z_61 + EOFFSE2 * ...
    z_86 + EOFFSE3 * z_89 + EOFFSF1 * z_114 + EOFFSF2 * z_117 + EOFFSF3 * z_120 + ...
    L_OF_W * z_133 + (EOFFSB1 + O_OF_J_2) * z_19 + (EOFFSB3 + H_OF_F) * z_4 + (EOFFSC3 + ...
    L_OF_L_A) * z_45 + (EOFFSD1 + L_OF_H) * z_58 + (EOFFSD3 + O_OF_U_A) * z_64 + ( ...
    EOFFSE1 + L_OF_T) * z_83 - EOFFSB2 * z_21);

    P(2,4) = (EOFFSA2 + EOFFSB2 * z_25 + EOFFSC1 * z_40 + EOFFSC2 * z_43 + EOFFSD2 * ...
    z_62 + EOFFSE2 * z_87 + EOFFSE3 * z_90 + EOFFSF1 * z_115 + EOFFSF2 * z_118 + ...
    EOFFSF3 * z_121 + L_OF_W * z_134 + (EOFFSB1 + O_OF_J_2) * z_23 + (EOFFSC3 + L_OF_L_A) * ...
    z_46 + (EOFFSD1 + L_OF_H) * z_59 + (EOFFSD3 + O_OF_U_A) * z_65 + (EOFFSE1 + L_OF_T) * ...
    z_84 - (EOFFSB3 + H_OF_F) * z_27);

    P(3,4) = (EOFFSA3 + EOFFSB2 * z_26 + EOFFSC1 * z_41 + EOFFSC2 * z_44 + EOFFSD2 * ...
    z_63 + EOFFSE2 * z_88 + EOFFSE3 * z_91 + EOFFSF1 * z_116 + EOFFSF2 * z_119 + ...
    EOFFSF3 * z_122 + L_OF_W * z_135 + (EOFFSB1 + O_OF_J_2) * z_24 + (EOFFSB3 + H_OF_F) * ...
    z_28 + (EOFFSC3 + L_OF_L_A) * z_47 + (EOFFSD1 + L_OF_H) * z_60 + (EOFFSD3 + O_OF_U_A) * ...
    z_66 + (EOFFSE1 + L_OF_T) * z_85);

    a(1,1) = z_133;
    a(1,2) = z_136;
    a(1,3) = z_139;

    a(2,1) = z_134;
    a(2,2) = z_137;
    a(2,3) = z_140;

    a(3,1) = z_135;
    a(3,2) = z_138;
    a(3,3) = z_141;

    %% 6轴坐标系绕y轴旋转90°得到工具坐标系
    a =a*roty(90);

    for i=1:3
        P(1,i)=a(1,i);    
        P(2,i)=a(2,i); 
        P(3,i)=a(3,i); 
    end
    
    P=P*trans_to_tool;
end