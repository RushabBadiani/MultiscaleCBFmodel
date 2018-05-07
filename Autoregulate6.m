function    [QbA6,QfA6,QtA6] = Autoregulate6(q0,Qt)
% Note that it has been hard-coded into the equation that Pin = 50 mmHg,
% Pic = 10 mmHg and Pv = 6 mmHg
    QbA6  = zeros(1,6);
for k       = 1:6
    myfun   = @(q) (((45 - 6 - (1.88*(Qt/q0(k)))*q) / q)*( ((0.21/(Qt/q0(k))) + (1.435/(Qt/q0(k)))*tanh( ((-2*3)/(1.435)) *(q -(q0(k)))/(q0(k))))*(45 - 2*10 + (1.88*(Qt/q0(k)))*q) + (.21/(Qt/q0(k)))*(2*45-2*10-(q0(k)*5.03)) +2*(12/(Qt/q0(k))))^2 - 4*5.03*(Qt/q0(k))*((12/(Qt/q0(k)))^2));                  % parameter
    fun     = @(q) myfun(q);    % function of x alone
    qA      = fzero(fun,q0(k));
    QbA6(k) = qA;
end
QtA6 = sum(QbA6); % Total flow out of Autoregulated model
QfA6 = QbA6 ./ QtA6; % Normalised flow rate out of Auto regulated model
end