function  [QbAall,QfAall,QtAall] = AutoregulateALL(Qt,Nall,qLP,qRP,qLM,qRM,qLA,qRA)

    QbA_LPCA = zeros(Nall(1),1);
    QbA_RPCA = zeros(Nall(2),1);
    QbA_LMCA = zeros(Nall(3),1);
    QbA_RMCA = zeros(Nall(4),1);
    QbA_LACA = zeros(Nall(5),1);
    QbA_RACA = zeros(Nall(6),1);
    
    for a = 1:Nall(1)
    myfun   = @(q) (((45 - 6 - (1.88*(Qt/qLP(a)))*q) / q)*( ((0.21/(Qt/qLP(a))) + (1.435/(Qt/qLP(a)))*tanh( ((-2*3)/(1.435)) *(q -(qLP(a)))/(qLP(a))))*(45 - 2*10 + (1.88*(Qt/qLP(a)))*q) + (.21/(Qt/qLP(a)))*(2*45-2*10-(qLP(a)*5.03)) +2*(12/(Qt/qLP(a))))^2 - 4*5.03*(Qt/qLP(a))*((12/(Qt/qLP(a)))^2));                  % parameter
    fun     = @(q) myfun(q);    % function of x alone
    qA      = fzero(fun,qLP(a));
    QbA_LPCA(a) = qA;
    end
    
    for b = 1:Nall(2)
        myfun   = @(q) (((45 - 6 - (1.88*(Qt/qRP(b)))*q) / q)*( ((0.21/(Qt/qRP(b))) + (1.435/(Qt/qRP(b)))*tanh( ((-2*3)/(1.435)) *(q -(qRP(b)))/(qRP(b))))*(45 - 2*10 + (1.88*(Qt/qRP(b)))*q) + (.21/(Qt/qRP(b)))*(2*45-2*10-(qRP(b)*5.03)) +2*(12/(Qt/qRP(b))))^2 - 4*5.03*(Qt/qRP(b))*((12/(Qt/qRP(b)))^2));                  % parameter
        fun     = @(q) myfun(q);    % function of x alone
        qA      = fzero(fun,qRP(b));
        QbA_RPCA(b) = qA;
    end
    
    for c = 1:Nall(3)
        myfun   = @(q) (((45 - 6 - (1.88*(Qt/qLM(c)))*q) / q)*( ((0.21/(Qt/qLM(c))) + (1.435/(Qt/qLM(c)))*tanh( ((-2*3)/(1.435)) *(q -(qLM(c)))/(qLM(c))))*(45 - 2*10 + (1.88*(Qt/qLM(c)))*q) + (.21/(Qt/qLM(c)))*(2*45-2*10-(qLM(c)*5.03)) +2*(12/(Qt/qLM(c))))^2 - 4*5.03*(Qt/qLM(c))*((12/(Qt/qLM(c)))^2));                  % parameter
        fun     = @(q) myfun(q);    % function of x alone
        qA      = fzero(fun,qLM(c));
        QbA_LMCA(c) = qA;
    end
    
    for d = 1:Nall(4)
        myfun   = @(q) (((45 - 6 - (1.88*(Qt/qRM(d)))*q) / q)*( ((0.21/(Qt/qRM(d))) + (1.435/(Qt/qRM(d)))*tanh( ((-2*3)/(1.435)) *(q -(qRM(d)))/(qRM(d))))*(45 - 2*10 + (1.88*(Qt/qRM(d)))*q) + (.21/(Qt/qRM(d)))*(2*45-2*10-(qRM(d)*5.03)) +2*(12/(Qt/qRM(d))))^2 - 4*5.03*(Qt/qRM(d))*((12/(Qt/qRM(d)))^2));                  % parameter
        fun     = @(q) myfun(q);    % function of x alone
        qA      = fzero(fun,qRM(d));
        QbA_RMCA(d) = qA;
    end
    
    for e = 1:Nall(5)
        myfun   = @(q) (((45 - 6 - (1.88*(Qt/qLA(e)))*q) / q)*( ((0.21/(Qt/qLA(e))) + (1.435/(Qt/qLA(e)))*tanh( ((-2*3)/(1.435)) *(q -(qLA(e)))/(qLA(e))))*(45 - 2*10 + (1.88*(Qt/qLA(e)))*q) + (.21/(Qt/qLA(e)))*(2*45-2*10-(qLA(e)*5.03)) +2*(12/(Qt/qLA(e))))^2 - 4*5.03*(Qt/qLA(e))*((12/(Qt/qLA(e)))^2));                  % parameter
        fun     = @(q) myfun(q);    % function of x alone
        qA      = fzero(fun,qLA(e));
        QbA_LACA(e) = qA;
    end
    
    for f = 1:Nall(6)
        myfun   = @(q) (((45 - 6 - (1.88*(Qt/qRA(f)))*q) / q)*( ((0.21/(Qt/qRA(f))) + (1.435/(Qt/qRA(f)))*tanh( ((-2*3)/(1.435)) *(q -(qRA(f)))/(qRA(f))))*(45 - 2*10 + (1.88*(Qt/qRA(f)))*q) + (.21/(Qt/qRA(f)))*(2*45-2*10-(qRA(f)*5.03)) +2*(12/(Qt/qRA(f))))^2 - 4*5.03*(Qt/qRA(f))*((12/(Qt/qRA(f)))^2));                  % parameter
        fun     = @(q) myfun(q);    % function of x alone
        qA      = fzero(fun,qRA(f));
        QbA_RACA(f) = qA;
    end
    
    QbA_LPCA_tot = sum(QbA_LPCA);
    QbA_RPCA_tot = sum(QbA_RPCA);
    QbA_LMCA_tot = sum(QbA_LMCA);
    QbA_RMCA_tot = sum(QbA_RMCA);
    QbA_LACA_tot = sum(QbA_LACA);
    QbA_RACA_tot = sum(QbA_RACA);
    
QbAall = [QbA_LPCA_tot,QbA_RPCA_tot,QbA_LMCA_tot,QbA_RMCA_tot,QbA_LACA_tot,QbA_RACA_tot];  
QtAall = sum(QbAall); % Total flow out of Autoregulated model
QfAall = QbAall ./ QtAall; % Normalised flow rate out of Auto regulated model