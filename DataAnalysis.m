function [PO, t_r, t_s, t_p] = DataAnalysis(out)

x_ss = mean(out.position(1000:1:end));
x_peak = max(out.position);
t_10percent = out.tout(abs(out.position - 0.1*x_ss) == min(abs(out.position - 0.1*x_ss)));
t_90percent = out.tout(abs(out.position - 0.9*x_ss) == min(abs(out.position - 0.9*x_ss)));
t_98percent = out.tout(abs(out.position - 0.98*x_ss) == min(abs(out.position - 0.98*x_ss)));

PO = (x_peak - x_ss)/x_ss;
t_r = t_90percent - t_10percent;
t_s = t_98percent;
t_p = out.tout(out.position == x_peak);

end