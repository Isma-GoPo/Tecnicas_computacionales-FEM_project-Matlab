function [TR]=evalTR2D(Tipologia)
%======================================================================
% Evaluacion de matrix TR para extrapolación de derivadas en puntos
% de integración de elementos 2D a nodos del elemento
%======================================================================
% Input
%   Tipologia       Tipologiaetros
%     .Nlados       Numero de Nlados del elemento
%     .grado_polinomio        grado_polinomio de elemento (1=lineal, 2=cuadratico)
%     .Npuntos_integracion        Numero de puntos de Gauss del elemento
%
% Output
%   TR          Matriz de transformacion SIG(nodos)=TR·SIG(GaussPoints)
%======================================================================

Dimensiones=2;
Nnodos_por_elemento  = Tipologia.Nnodos_por_elemento;
grado_polinomio  = Tipologia.grado_polinomio;
Nlados = Tipologia.Nlados;
Npuntos_integracion  = Tipologia.Npuntos_integracion;

[CoorG,WT]=pgauss(Dimensiones,Nlados,Npuntos_integracion);
[CoorN]=LocalCoorNodos2D(Nlados,grado_polinomio);
XG=CoorG(:,1); YG=CoorG(:,2); %coordenadas de Puntos de Gauss
XN=CoorN(:,1); YN=CoorN(:,2); %coordenadas de nodos del elemento

if Nnodos_por_elemento==Npuntos_integracion
    N=shape_f_2d(CoorG,grado_polinomio,Nlados);
    TR=inv(N);
    return
end

if (grado_polinomio~=2) && (grado_polinomio~=1)
   error(['Subrutina no preparada para grado ' num2str(grado_polinomio)]);
end

PolDegree=grado_polinomio-1;

switch PolDegree
    case 0 %Constante
        for gp=1:Npuntos_integracion
            PG(gp,:)=1;
        end
        for n=1:Nnodos_por_elemento
            PN(n,:)=1;
        end
    case 1 %lineal
        for gp=1:Npuntos_integracion
            PG(gp,:)=[1 XG(gp) YG(gp)];
        end
        for n=1:Nnodos_por_elemento
            PN(n,:)=[1 XN(n) YN(n)];
        end
    case 2 %cuadratico
        for gp=1:Npuntos_integracion
            PG(gp,:)=[1 XG(gp) YG(gp) XG(gp)^2 XG(gp)*YG(gp) YG(gp)^2];
        end
        for n=1:Nnodos_por_elemento
            PN(n,:)=[1 XN(n) YN(n) XN(n)^2 XN(n)*YN(n) YN(n)^2];
        end
end   

A=zeros(size(PG,2),size(PG,2));
for gp=1:Npuntos_integracion
    A=A+PG(gp,:)'*PG(gp,:);
end
A=inv(A);
TR=PN*A*PG';

