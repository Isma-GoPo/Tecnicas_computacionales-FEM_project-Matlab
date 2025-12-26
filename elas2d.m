clear all
close all
%warning off
f=figure; set(f,'color','w');

%% Carga de datos. Definición del modelo de elementos finitos
% ===========================================================
% Coordenadas nodales
% x y
load XY;      XY   = XY' ;    XY=XY(1:2,:);%tomamos 2 primeras coords.
% Conectividad de elementos (topologia)
% i j k [l m n o p]
load Top;     Top  = Top';
% Restricciones de desplazamiento en x
% i ux
load RestX;   RestX= RestX';
% Restricciones de desplazamiento en y
% i uy
load RestY;   RestY= RestY';
% Cargas superficiales (presion y tension tangente)
% i j [k] pi pj [pk] ti tj [tk]
load CargasL;

% Definicion del tipo de problema y propiedades materiales
% ========================================================
% PlaneState=0 para deformación plana; PlaneState=1 para tensión plana
PlaneState= 1; 
% Modulo de Young
E= 2.1e11; 
% Coeficiente de Poisson
nu= 0.3; 
% Matriz de elasticidad
D=Matriz_D(E,nu,PlaneState);

% Parámetros del problema
% =======================
Parametros;

% Dibujo de la malla
% ==================
DibujaMalla(XY,Top,Param);
pause;

%% Cálculo de matrices de elemento y ensamblado
% =============================================
 
% Matriz K
% ========
[K,DB]=Matriz_K(XY,Top,D,Param); 

% Dibujo de matriz K
% ==================
clf;               spy(K);      title('Matriz K Original');   pause;
clf; r=symrcm(K);  spy(K(r,r)); title('Matriz K Reordenada'); pause;

% Carga aplicada en el contorno
% =============================
Ft=Vector_Ft(XY,CargasL,Param);

% Vector F
% ========
F=Ft;

%% Aplicación de restricciones y resolucion
% =========================================
gdl=1:2*Param.Nnod; %Todos los grados de libertad
gdlR=[2*RestX(1,:)-1,2*RestY(1,:)]; %GDL restringidos
gdlDummy=gdl;
gdlDummy(gdlR)=-1; %Marca con -1 los GDLR
gdlL=find(gdlDummy>0); %Grados de libertad Libres

Sol = zeros(2*Param.Nnod,1);   Sol(gdlR) = [RestX(2,:),RestY(2,:)];
KLL = K(gdlL,gdlL);            KLR       = K(gdlL,gdlR);
FLL = F(gdlL);

Sol(gdlL)= KLL\(FLL-KLR*Sol(gdlR));

%% Calculo de tensiones
% =====================
[sigma,sigmaN]=cal_sigma(Param,Top,DB,Sol);

%% Dibujo de resultados
% =====================

% Dibujo deformada
% ================
d_deformada(XY,Top,Sol,Param);
pause;

% Dibujo de la solución  nodal
% ============================
gdlx=1:2:(2*Param.Nnod-1);
gdly=2:2:2*Param.Nnod;
% Desplazamientos en x
clf
title('Desplazamiento x');
d_sol3d(XY,Top,Sol(gdlx),Param);  view(-37.5,30)
pause;

% Desplazamientos en y
clf
title('Desplazamiento y');
d_sol3d(XY,Top,Sol(gdly),Param);  view(-37.5,30)
pause;

% Dibujo de resultados de elemento (Tension)
% ==========================================
clf
title('Tension sigma x')
d_sole3d(XY,Top,squeeze(sigma(1,:,:)),Param);
view(-37.5,30);
pause;

clf
title('Tension sigma y')
d_sole3d(XY,Top,squeeze(sigma(2,:,:)),Param);
view(-37.5,30);
pause;

clf
title('Tension tau xy')
d_sole3d(XY,Top,squeeze(sigma(3,:,:)),Param);
view(-37.5,30);
pause;

% Dibujo de resultados alisados
% =============================
clf
title('Tension sigma x (promediada)')
d_sol3d(XY,Top,sigmaN(1,:)',Param);
view(-37.5,30);
pause;

clf
title('Tension sigma y (promediada)')
d_sol3d(XY,Top,sigmaN(2,:)',Param);
view(-37.5,30);
pause;

clf;
title('Tension tau xy (promediada)')
d_sol3d(XY,Top,sigmaN(3,:)',Param);
view(-37.5,30);
pause;


