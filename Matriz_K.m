function [K,DB]=Matriz_K(XY,Top,D,Param)
% Cálculo de matrices de elemento y ensamblado
% ============================================

Nnod = Param.Nnod;
Nel  = Param.Nel;
NNpe = Param.NNpe;
Lados= Param.Lados;
NPGe = Param.NPGe;
Tipo = Param.Tipo;

K=sparse((2*Nnod),(2*Nnod)); 
% Las sparse son matrices donde se guarda las coordenadas x, y, con el valor. 
%   Están hechas para matrices muy vacías -> Cuando hay muchos ceros, estos
%   no se registran. 
DB=zeros(3,2*NNpe,NPGe,Nel);

% Coordenadas locales y pesos de los puntos de Gauss
Dimensiones=2;
[XYG, W] = pgauss(Dimensiones,Lados,NPGe); 
% Funciones de forma y sus derivadas en los puntos de Gauss
[N,dNpsi,dNeta] = shape_f_2d(XYG,Tipo,Lados,1);

gdlx=1:2:(2*NNpe-1); %gdl locales del elemento en x
gdly=2:2:2*NNpe;     %gdl locales del elemento en y

% Lazo para todos los elementos
% -----------------------------
for iElm=1:Param.Nel
    Ne=Top(:,iElm);  %Nodos del elemento
    XYe=XY(:,Ne)';
    Ke=zeros(2*NNpe,2*NNpe);
    % Lazo en Puntos de Gauss
    for PtG = 1:Param.NPGe
        % Matriz Jacobiana
        Ja = MatrizJacobiana(dNpsi,dNeta,XYe,PtG);
        InvJa=inv(Ja);
        % Matriz de Derivadas de N respecto de las coordenadas locales
        dNloc = [dNpsi(PtG,:); dNeta(PtG,:)];        
        % Matriz B
        dNglo = InvJa*dNloc;
        B=zeros(3,2*NNpe);
        B(1,gdlx)=dNglo(1,:);
        B(2,gdly)=dNglo(2,:);
        B(3,gdlx)=dNglo(2,:);
        B(3,gdly)=dNglo(1,:);
        % Matriz D·B en cada punto de Gauss
        DB(:,:,PtG,iElm)=D*B;
        % Matriz K de elemento (aportación de cada punto de Gauss)
        Ke = Ke + B'*D*B*det(Ja)*W(PtG);
    end
    Ke=(Ke+Ke')/2; % para que Ke sea perfectamente simetrica
    % grados de libertad globales en el elemento
    gdle(gdlx)=2*Ne-1;
    gdle(gdly)=2*Ne;   
    % Matriz K ensamblada
    K(gdle,gdle) = K(gdle,gdle) + Ke;
end



