function [TR]=evalTR2D(Param)
%======================================================================
% Evaluacion de matrix TR para extrapolación de derivadas en puntos
% de integración de elementos 2D a nodos del elemento
%======================================================================
% Input
%   Param       Parametros
%     .Lados       Numero de lados del elemento
%     .Tipo        Tipo de elemento (1=lineal, 2=cuadratico)
%     .NPGe        Numero de puntos de Gauss del elemento
%
% Output
%   TR          Matriz de transformacion SIG(nodos)=TR·SIG(GaussPoints)
%======================================================================

Dimensiones=2;
NNpe  = Param.NNpe;
Tipo  = Param.Tipo;
Lados = Param.Lados;
NPGe  = Param.NPGe;

[CoorG,WT]=pgauss(Dimensiones,Lados,NPGe);
[CoorN]=LocalCoorNodos2D(Lados,Tipo);
XG=CoorG(:,1); YG=CoorG(:,2); %coordenadas de Puntos de Gauss
XN=CoorN(:,1); YN=CoorN(:,2); %coordenadas de nodos del elemento

if NNpe==NPGe
    N=shape_f_2d(CoorG,Tipo,Lados);
    TR=inv(N);
    return
end

if (Tipo~=2) && (Tipo~=1)
   error(['Subrutina no preparada para grado ' num2str(Tipo)]);
end

PolDegree=Tipo-1;

switch PolDegree
    case 0 %Constante
        for gp=1:NPGe
            PG(gp,:)=1;
        end
        for n=1:NNpe
            PN(n,:)=1;
        end
    case 1 %lineal
        for gp=1:NPGe
            PG(gp,:)=[1 XG(gp) YG(gp)];
        end
        for n=1:NNpe
            PN(n,:)=[1 XN(n) YN(n)];
        end
    case 2 %cuadratico
        for gp=1:NPGe
            PG(gp,:)=[1 XG(gp) YG(gp) XG(gp)^2 XG(gp)*YG(gp) YG(gp)^2];
        end
        for n=1:NNpe
            PN(n,:)=[1 XN(n) YN(n) XN(n)^2 XN(n)*YN(n) YN(n)^2];
        end
end   

A=zeros(size(PG,2),size(PG,2));
for gp=1:NPGe
    A=A+PG(gp,:)'*PG(gp,:);
end
A=inv(A);
TR=PN*A*PG';

