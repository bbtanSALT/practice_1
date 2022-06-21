data hw1;
infile "C:\Users\jenny\Documents\junior\縱向\longanal110sp1.dat";
input id m0 m3 m6 m9 m12 indicator;
run;

*1(a)
mu1 = mu + tau1 以此類推 設tau1 = 0
因為program1是對照組

H0:mu1 = mu2 = mu3
Ha:mu_i neq mu_j, i neq j
   or at least two mu differ;
*1(b);
*proc reg不接受類別型變數
所以在使用之前，要自己先設定dummy variable;
proc sgplot data = hw1t;
by indicator;
histogram y1;
run;
data hw1a;
set hw1;
x2 = (indicator = 2);
x3 = (indicator = 3);
run;
proc reg data = hw1a;
model m0 = x2 x3;
run;

proc reg data = hw1;
model m0 = indicator;
run;

*1(c);
proc glm data = hw1;
class indicator(ref = first);
model m0 = indicator/solution;
run;


*2(b);
proc glm data = hw1;
class indicator(ref = first);
model m12 = indicator/ solution;
run;

data hw1b;
set hw1;
diff = m12 - m0;
run;

*3(b);
proc glm data = hw1b;
class indicator(ref = first);
model diff = indicator/solution;
run;

*4;
proc corr data = hw1 cov;
by indicator;
var m0--m12;
run;

proc sgscatter data = hw1;
matrix m0--m12/ group = indicator;
run;

*5;
proc sort data = hw1;
by id indicator;
proc transpose data = hw1 prefix = y out = hw1t;
by id indicator;
var m0--m12;
run;
data hw1t;
set hw1t;
time = input(compress(_NAME_, 'm'), 2.);
run;

proc sgplot data = hw1t;
vline time/ response = y1 group = indicator 
			stat = mean markers;
run;
