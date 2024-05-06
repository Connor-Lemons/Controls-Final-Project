function [w, mag, phase] = processPoint(inputData, freq)

A = load(inputData); 

w = freq;
t_period = 2*pi*(1/freq);

per_mult = zeros(1, floor(A.out.tout(end)/t_period));

for i = 1:floor(A.out.tout(end)/t_period)
    per_mult(i) = find(A.out.tout + 0.005 > round(t_period*i, 2) &...
        A.out.tout - 0.005 < round(t_period*i, 2));
end

time = A.out.tout(per_mult(end-1):per_mult(end));
input = A.out.input(per_mult(end-1):per_mult(end));
output = A.out.position(per_mult(end-1):per_mult(end));

t = time(output == max(output)) - time(input == max(input));
phase = (-t/t_period)*360;


outputMax = max(output);
outputMin = min(output);
inputMax = max(input);
inputMin = min(input);
mag = 20*log10((outputMax - outputMin)/(inputMax - inputMin));