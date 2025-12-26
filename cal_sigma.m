function [sigma,sigmaN]=cal_sigma(Tipologia,Topologia,DB,Sol)
                     
Nnodos = Tipologia.Nnodos;
Nelementos  = Tipologia.Nelementos;
Nnodos_por_elemento = Tipologia.Nnodos_por_elemento;
Npuntos_integracion = Tipologia.Npuntos_integracion;

% Inicializa Variables
% ====================
sigmaG=zeros(3,Npuntos_integracion,Nelementos);  %tensiones en ptos de Gauss
sigma =zeros(3,Nnodos_por_elemento,Nelementos);  %tensiones en nodos de cada elemento
sigmaN=zeros(3,Nnodos);      %tensiones promediadas en nodos de la malla
Sole=zeros(2*Nnodos_por_elemento,1);

% Tensiones en puntos de Gauss
% ============================
for iElem=1:Tipologia.Nelementos
    Ne=Topologia(:,iElem);  %Nodos del elemento
    Sole(1:2:2*Nnodos_por_elemento-1)=Sol(2*Ne-1);
    Sole(2:2:2*Nnodos_por_elemento)=Sol(2*Ne);
    for i_punto_integracion = 1:Tipologia.Npuntos_integracion
        DBe=DB(:,:,i_punto_integracion,iElem);  
        sigmaG(:,i_punto_integracion,iElem)=DBe*Sole;    
    end    
end

% Extrapola tensiones a nodos del elemento
% ========================================
[TR]=evalTR2D(Tipologia);
for iElem=1:Nelementos
    sigma(:,:,iElem)=(TR*sigmaG(:,:,iElem)')';
end


% Calculo de tensiones en nodos (promediado)
% ==========================================
sigmaN = EvalSigmaN(Nnodos,Nelementos,Topologia,sigma,sigmaN);


