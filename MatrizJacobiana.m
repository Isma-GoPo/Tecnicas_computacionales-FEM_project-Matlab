function [Ja]=MatrizJacobiana(dNpsi,dNeta,XYe,PtG)

DNpsi_i = dNpsi(PtG, :);
DNeta_i = dNeta(PtG, :);
Xe = XYe(:, 1);
Ye = XYe(:, 2);

Ja = [DNpsi_i*Xe, DNpsi_i*Ye;...
    DNeta_i*Xe, DNeta_i*Ye];

