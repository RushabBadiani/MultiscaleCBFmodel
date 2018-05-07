function [Mu_vivo] = Viscosity(bb,xns)

H_ct = 0.45;     % Mu = Mu(Diameter, Hematocrit) - Initially we assume H 
                 % to be 0.45

bb = 2.*bb;                 
                 
Nn = length(xns);
Nu_H = zeros(Nn);
Cd = zeros(Nn);
Mu_vitro = zeros(Nn);
W_as = zeros(Nn);
W_peak = zeros(Nn);

% bb = 1000 * bb;
for i = 1:Nn
    for j = 1:Nn
        
    % Nu_H is the relative apparent viscosity of blood for a discharge
    % haematocrit of 0.45.
    if bb(i,j) > 0
        
    Nu_H(i,j) = 220*exp(-1.3*bb(i,j)*10^(3)) + 3.2 - 2.44*exp(-0.06 * (bb(i,j)*10^(3))^0.645);

    Cd(i,j) =  (-1 + 1/(1 + (10^(-11))*((bb(i,j)*10^(3))^12))) * (0.8 + exp(-0.075 * bb(i,j)*10^(3))) + 1/(1 + 10^(-11)*((bb(i,j)*10^(3))^12));

    Mu_plasma = 1.05*10^(-3); % 1.05 mPa s

    % Mu_vitro is the in-vitro blood viscosity 
    Mu_vitro(i,j) = Mu_plasma*(1+(Nu_H(i,j) - 1)*(((1-H_ct)^Cd(i,j) - 1)/((1-0.45)^Cd(i,j) - 1)));
    
    else
        
    end
    end
end

% D_eff can be found from the relations in Pries and Secomb 
E_Hct   = 1.18;         % Haematocrit dependent layer resistance
D_off   = 2.4;%*10^(-6);  % Threshold Diameter (m)
D_50    = 100;%*10^(-6);
D_crit  = 10.5;%*10^(-6);
E_amp   = 1.1;
E_width = 0.03;
E_peak  = 0.6;
W_max   = 2.6;%*10^(-6); 

Mu_vivo = zeros(Nn);

for i = 1:Nn
    for j = 1:Nn
        
    if bb(i,j)*10^(3) <= D_off
        W_as(i,j) = 0;
        elseif D_off < bb(i,j)*10^(3)
            W_as(i,j) = W_max * ( (bb(i,j)*10^(3) - D_off) / (bb(i,j)*10^(3) + D_50 - 2*D_off));
    else
    end

    if bb(i,j)*10^(3) <= D_off
        W_peak(i,j) = 0;
        elseif D_off < bb(i,j)*10^(3) &&  bb(i,j)*10^(3)<= D_crit
            W_peak(i,j) = E_amp * ((bb(i,j)*10^(3) - D_off) / (D_crit - D_off));
        elseif D_crit < bb(i,j)*10^(3)
            W_peak(i,j) = E_amp * exp(-E_width * (bb(i,j)*10^(3) - D_crit));
        else
    end
    
W_eff(i,j) = W_as(i,j) + W_peak(i,j)*(1 + H_ct*E_Hct);
D_eff(i,j) = bb(i,j)*10^(3) - 2*W_eff(i,j);

% Mu_vivo is the apparent in-vivo viscosity
        if bb(i,j)*10^(3) > 0
        Mu_vivo(i,j) = Mu_vitro(i,j) .* ((bb(i,j)*10^(3) ./ D_eff(i,j)))^4;
        else
        end
    end
end


