function [sigma,sigmaN]=cal_sigma(Param,Top,DB,Sol)
                     
Nnod = Param.Nnod;
Nel  = Param.Nel;
NNpe = Param.NNpe;
NPGe = Param.NPGe;

% Inicializa Variables
% ====================
sigmaG=zeros(3,NPGe,Nel);  %tensiones en ptos de Gauss
sigma =zeros(3,NNpe,Nel);  %tensiones en nodos de cada elemento
sigmaN=zeros(3,Nnod);      %tensiones promediadas en nodos de la malla
Sole=zeros(2*NNpe,1);

% Tensiones en puntos de Gauss
% ============================
for iElem=1:Param.Nel
    Ne=Top(:,iElem);  %Nodos del elemento
    Sole(1:2:2*NNpe-1)=Sol(2*Ne-1);
    Sole(2:2:2*NNpe)=Sol(2*Ne);
    for PtG = 1:Param.NPGe
        DBe=DB(:,:,PtG,iElem);  
        sigmaG(:,PtG,iElem)=DBe*Sole;    
    end    
end

% Extrapola tensiones a nodos del elemento
% ========================================
[TR]=evalTR2D(Param);
for iElem=1:Nel
    sigma(:,:,iElem)=(TR*sigmaG(:,:,iElem)')';
end


% Calculo de tensiones en nodos (promediado)
% ==========================================
sigmaN = EvalSigmaN(Nnod,Nel,Top,sigma,sigmaN);


