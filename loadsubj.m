% raw = { 2; 3; 5; 6; 7; 8; 9; 10; 13; 14; 16; 17; 18; 
    raw = {20; 22; 23; 24; 25; 26; 27; 28; 29 };

drugmatched = {
    '24-2010-anest 20100420 134.003'		1		0		996		1		1		2.33	1		1
    '24-2010-anest 20100420 134.010'		2		493		895		40		1		1.95	1		1
    '24-2010-anest 20100420 134.015'		3		978		1103	37		1		3.44	1		1
    '24-2010-anest 20100420 134.028'		4		226		834		39		1		2.27	1		1
    '08-2010-anest 20100301 095.004'		1		0		1026	39		2		3.12	1		1
    '08-2010-anest 20100301 095.010'		2		482		1028	38		2		2.98	1		1
    '08-2010-anest 20100301 095.015'		3		947		1467	21		2		2.22	1		1
    '08-2010-anest 20100301 095.028'		4		266		950		39		2		2.76	1		1
};

eeg = {
    % Participant                         1.Level   2.Drug  3.RT   4.Hits   5.Behav 6.Hori 7.Alpha
    '02-2010-anest 20100210 135.003'		1		0		903		40		1		2.29	1		0
    '02-2010-anest 20100210 135.006'		2		204		675		39		1		2.16	1		0
    '02-2010-anest 20100210 135.014'		3		506		846		39		1		2.98	1		0
    '02-2010-anest- 20100210 16.003'		4		299		739		38		1		2.41	1		1
    '03-2010-anest 20100211 142.003'		1		0		630		37		2		2.76	2		1 % skipped by Jaco
    '03-2010-anest 20100211 142.008'		2		246		637		37		2		2.93	2		1
    '03-2010-anest 20100211 142.021'		3		689		945		3		2		3.24	2		1
    '03-2010-anest 20100211 142.026'		4		224		669		38		2		2.49	2		1
    '05-2010-anest 20100223 095.004'		1		0		855		37		1		2.73	1		1
    '05-2010-anest 20100223 095.009'		2		525		871		37		1		2.98	1		1
    '05-2010-anest 20100223 095.022'		3		1032	1172	33		1		3.36	1		1
    '05-2010-anest 20100223 095.027'		4		236		710		37		1		2.50	1		1
    '06-2010-anest 20100224 093.003'		1		0		1882	36		2		2.12	2		1
    '06-2010-anest 20100224 093.008'		2		878		1554	33		2		3.02	2		1
    '06-2010-anest 20100224 093.013'		3		1521	NaN		1		2		3.05	2		1
    '06-2010-anest 20100224 093.026'		4		483		1248	36		2		2.46	2		1
    '07-2010-anest 20100226 133.003'		1		0		808		35		2		3.98	2		1
    '07-2010-anest 20100226 133.008'		2		604		1371	9		2		2.87	2		1
    '07-2010-anest 20100226 133.021'		3		1437	2209	6		2		2.75	2		1
    '07-2010-anest 20100226 133.027'		4		351		873		37		2		2.58	2		1
    '08-2010-anest 20100301 095.004'		1		0		1026	39		2		3.12	1		1
    '08-2010-anest 20100301 095.010'		2		482		1028	38		2		2.98	1		1
    '08-2010-anest 20100301 095.015'		3		947		1467	21		2		2.22	1		1
    '08-2010-anest 20100301 095.028'		4		266		950		39		2		2.76	1		1
    '09-2010-anest 20100301 135.003'		1		0		1254	30		1		2.05	1		1
    '09-2010-anest 20100301 135.008'		2		331		951		36		1		2.00	1		1
    '09-2010-anest 20100301 135.021'		3		806		1102	34		1		2.86	1		1
    '09-2010-anest 20100301 135.026'		4		312		863		37		1		1.69	1		1
    '10-2010-anest 20100305 130.005'		1		0		795		38		2		4.45	2		1 % skipped by Jaco
    '10-2010-anest 20100305 130.010'		2		542		1047	5		2		4.80	2		1
    '10-2010-anest 20100305 130.015'		3		1149	NaN		0		2		3.88	2		1
    '10-2010-anest 20100305 130.028'		4		397		1063	35		2		3.29	2		1
    '13-2010-anest 20100322 132.003'		1		0		1317	NaN		1		2.22	1		1
    '13-2010-anest 20100322 132.008'		2		144		1147	NaN		1		2.26	1		1
    '13-2010-anest 20100322 132.013'		3		433		1083	35		1		2.59	1		1
    '13-2010-anest 20100322 132.026'		4		243		866		38		1		1.93	1		1
    '14-2010-anest 20100324 125.007'		1		0		1311	NaN		2		3.12	2		1
    '14-2010-anest 20100324 132.011'		2		529		1178	35		2		3.05	2		1
    '14-2010-anest 20100324 132.016'		3		1167	2217	12		2		2.93	2		1
    '14-2010-anest 20100324 132.031'		4		363		996		36		2		2.95	2		1
    '16-2010-anest 20100329 133.003'		1		0		734		38		0		4.46	1		1 % skipped by Jaco
    '16-2010-anest 20100329 133.008'		2		568		1059	40		0		3.98	1		1
    '16-2010-anest 20100329 133.014'		3		1281	814		39		0		2.95	1		1
    '16-2010-anest 20100329 133.027'		4		289		NaN		0		0		4.44	1		1
    '17-2010-anest 20100331 095.001'		1		0		1024	45		0		4.49	1		2 % skipped by Jaco
    '17-2010-anest 20100331 095.008'		2		245		992		37		0		4.22	1		1
    '17-2010-anest 20100331 095.021'		3		735		951		32		0		4.07	1		1
    '17-2010-anest 20100331 095.026'		4		267		NaN		0		0		4.69	1		1
    '18-2010-anest 20100331 140.003'		1		0		2304	NaN		1		2.46	1		1
    '18-2010-anest 20100331 140.009'		2		200		761		38		1		2.34	1		1
    '18-2010-anest 20100331 140.014'		3		555		1082	39		1		4.63	1		1
    '18-2010-anest 20100331 140.027'		4		197		804		39		1		2.54	1		1
    '20-2010-anest 20100414 131.004'		1		0		872		37		1		3.90	1		1
    '20-2010-anest 20100414 131.009'		2		385		746		37		1		3.29	1		1
    '20-2010-anest 20100414 131.022'		3		1018	813		39		1		3.93	1		1
    '20-2010-anest 20100414 131.027'		4		171		673		37		1		3.52	1		1
    '22-2010-anest 20100415 132.004'		1		0		1259	NaN		1		2.98	1		1 % only 8 hits
    '22-2010-anest 20100415 132.009'		2		482		1139	39		1		2.43	1		1
    '22-2010-anest 20100415 132.014'		3		1029	1140	35		1		2.32	1		1
    '22-2010-anest 20100415 154.003'		4		287		1190	39		1		2.83	1		1
    '23-2010-anest 20100420 094.003'		1		0		675		38		1		2.07	1		1
    '23-2010-anest 20100420 094.008'		2		723		744		37		1		2.60	1		1
    '23-2010-anest 20100420 094.022'		3		791		1059	35		1		2.38	1		1
    '23-2010-anest 20100420 094.027'		4		303		615		38		1		2.76	1		1
    '24-2010-anest 20100420 134.003'		1		0		996		NaN		1		2.33	1		1 % only 1 hit
    '24-2010-anest 20100420 134.010'		2		493		895		40		1		1.95	1		1
    '24-2010-anest 20100420 134.015'		3		978		1103	37		1		3.44	1		1
    '24-2010-anest 20100420 134.028'		4		226		834		39		1		2.27	1		1
    '25-2010-anest 20100422 133.003'		1		0		753		39		1		3.10	1		1
    '25-2010-anest 20100422 133.008'		2		NaN		826		39		1		3.02	1		1
    '25-2010-anest 20100422 133.021'		3		NaN		1018	40		1		3.10	1		1
    '25-2010-anest 20100422 133.026'		4		NaN		798		40		1		2.88	1		1
    '26-2010-anest 20100507 132.003'		1		0		1460	34		2		3.07	2		3
    '26-2010-anest 20100507 132.008'		2		272		1201	30		2		3.14	2		1
    '26-2010-anest 20100507 132.013'		3		749		1658	15		2		3.59	2		1
    '26-2010-anest 20100507 132.026'		4		207		1025	33		2		2.68	2		1
    '27-2010-anest 20100823 104.001'		1		0		1060	39		1		2.60	1		1
    '27-2010-anest 20100823 104.010'		2		712		892		38		1		2.60	1		1
    '27-2010-anest 20100823 104.023'		3		NaN		877		37		1		3.05	1		1
    '27-2010-anest 20100823 104.028'		4		395		761		40		1		2.00	1		1
    '28-2010-anest 20100824 092.004'		1		0		1007	40		1		2.71	1		1
    '28-2010-anest 20100824 092.011'		2		NaN		604		39		1		2.71	1		1
    '28-2010-anest 20100824 092.016'		3		795		605		38		1		2.83	1		1
    '28-2010-anest 20100824 092.029'		4		148		676		39		1		2.50	1		1
    '29-2010-anest 20100921 142.005'		1		0		822		39		1		2.00	1		1
    '29-2010-anest 20100921 142.010'		2		394		755		40		1		2.03	1		1
    '29-2010-anest 20100921 142.023'		3		NaN		907		38		1		2.79	1		1
    '29-2010-anest 20100921 142.028'		4		435		765		37		1		2.05	1		1
    };

fmri = {
    % Participant    1.Level    2.Drug      3.RT        4.Hits   %5.Group
    'sub01_run01'		1		0.000		1071.000	0.975		1
    'sub01_run02'		2		124.675		1100.000	1.000		1
    'sub01_run03'		3		448.980		987.000		1.000		1
    'sub01_run04'		4		220.575		930.000		1.000		1
    'sub02_run01'		1		0.000		1090.000	1.000		1
    'sub02_run02'		2		487.470		1142.000	0.975		1
    'sub02_run03'		3		269.185		1215.000	0.875		1
    'sub02_run04'		4		188.565		1013.000	1.000		1
    'sub03_run01'		1		0.000		1130.000	0.900		1
    'sub03_run02'		2		313.265		1277.000	1.000		1
    'sub03_run03'		3		943.960		1479.000	0.975		1
    'sub03_run04'		4		246.435		1121.000	1.000		1
    'sub04_run01'		1		0.000		1044.738	1.000		1
    'sub04_run02'		2		744.540		1078.959	1.000		1
    'sub04_run03'		3		407.495		1245.616	1.000		1
    'sub04_run04'		4		266.585		1141.965	1.000		1
    'sub05_run01'		1		0.000		1068.871	0.925		2
    'sub05_run02'		2		1037.440	1202.691	0.950		2
    'sub05_run03'		3		533.970		1135.768	0.400		2
    'sub05_run04'		4		276.730		1207.645	0.900		2
    'sub06_run01'		1		0.000		1101.288	0.925		1
    'sub06_run02'		2		236.185		1197.539	1.000		1
    'sub06_run03'		3		770.440		1445.595	0.850		1
    'sub06_run04'		4		247.710		1089.083	0.925		1
    'sub07_run01'		1		0.000		1207.018	0.850		1
    'sub07_run02'		2		490.045		1370.808	0.950		1
    'sub07_run03'		3		236.770		1524.076	0.925		1
    'sub07_run04'		4		135.660		1289.827	0.925		1
    'sub08_run01'		1		0.000		1197.914	0.600		1
    'sub08_run02'		2		99.365		1375.802	0.825		1
    'sub08_run03'		3		520.340		1267.238	0.925		1
    'sub08_run04'		4		327.530		1402.486	0.800		1
    'sub09_run01'		1		0.000		982.967		0.900		1
    'sub09_run02'		2		368.565		1079.254	0.975		1
    'sub09_run03'		3		1037.715	1285.880	0.850		1
    'sub09_run04'		4		381.380		979.318		1.000		1
    'sub10_run01'		1		0.000		1264.042	1.000		1
    'sub10_run02'		2		323.755		1245.638	1.000		1
    'sub10_run03'		3		1078.115	1281.533	1.000		1
    'sub10_run04'		4		233.735		1121.218	1.000		1
    'sub11_run01'		1		0.000		1277.486	0.975		2
    'sub11_run02'		2		426.205		1281.696	0.950		2
    'sub11_run03'		3		1619.640	1154.173	0.400		2
    'sub11_run04'		4		360.390		1196.002	0.950		2
    'sub12_run01'		1		0.000		1410.789	0.975		1
    'sub12_run02'		2		307.800		1181.403	1.000		1
    'sub12_run03'		3		475.905		1299.154	0.975		1
    'sub12_run04'		4		344.895		1303.542	1.000		1
    'sub13_run01'		1		0.000		845.581		1.000		1
    'sub13_run02'		2		131.750		881.111		1.000		1
    'sub13_run03'		3		620.800		1003.133	1.000		1
    'sub13_run04'		4		347.350		937.882		1.000		1
    'sub14_run01'		1		0.000		1016.000	1.000		2
    'sub14_run02'		2		394.020		1091.000	1.000		2
    'sub14_run03'		3		271.725		1534.000	0.400		2
    'sub14_run04'		4		105.790		1089.000	1.000		2
    'sub15_run01'		1		0.000		1608.000	0.400		1
    'sub15_run02'		2		157.750		1089.000	1.000		1
    'sub15_run03'		3		296.200		1091.000	1.000		1
    'sub15_run04'		4		187.050		1277.000	0.975		1
    'sub16_run01'		1		0.000		1043.000	1.000		1
    'sub16_run02'		2		108.600		1004.000	1.000		1
    'sub16_run03'		3		427.850		1071.000	1.000		1
    'sub16_run04'		4		393.300		977.000		1.000		1
    'sub17_run01'		1		0.000		1061.850	1.000		1
    'sub17_run02'		2		338.360		1009.614	1.000		1
    'sub17_run03'		3		909.359		1049.801	1.000		1
    'sub17_run04'		4		186.974		1017.202	1.000		1
    'sub18_run01'		1		0.000		1230.797	0.975		2
    'sub18_run02'		2		982.821		1191.324	0.975		2
    'sub18_run03'		3		407.151		1747.468	0.275		2
    'sub18_run04'		4		277.134		1173.805	1.000		2
    'sub19_run01'		1		0.000		999.490		0.975		1
    'sub19_run02'		2		913.971		1051.178	1.000		1
    'sub19_run03'		3		407.603		1428.921	0.875		1
    'sub19_run04'		4		263.150		1119.945	1.000		1
    'sub20_run01'		1		0.000		905.610		1.000		1
    'sub20_run02'		2		594.479		984.123		1.000		1
    'sub20_run03'		3		479.840		1012.426	1.000		1
    'sub20_run04'		4		375.251		1041.987	1.000		1
    'sub21_run01'		1		0.000		1022.177	1.000		2
    'sub21_run02'		2		275.603		1240.886	0.950		2
    'sub21_run03'		3		963.575		NaN   		0.000		2
    'sub21_run04'		4		255.426		1179.634	1.000		2
    'sub22_run01'		1		0.000		1031.589	1.000		1
    'sub22_run02'		2		349.382		894.699		1.000		1
    'sub22_run03'		3		442.300		972.715		1.000		1
    'sub22_run04'		4		265.674		861.083		1.000		1
    'sub23_run01'		1		0.000		1149.039	1.000		2
    'sub23_run02'		2		132.224		1242.752	0.975		2
    'sub23_run03'		3		562.238		1272.238	0.700		2
    'sub23_run04'		4		294.732		1327.789	0.875		2
    'sub24_run01'		1		0.000		967.166		1.000		1
    'sub24_run02'		2		122.817		923.156		1.000		1
    'sub24_run03'		3		525.818		1029.187	0.975		1
    'sub24_run04'		4		349.109		850.454		1.000		1
    };