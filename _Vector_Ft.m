function F=Vector_Ft(XY,CargasL,Param)

% Ensamblado del vector de carga
% ==============================

NNpS=size(CargasL,2)/3; % Numero de nodos por segmento

gdlx=1:2:2*NNpS-1; % gdl locales del segmento en x
gdly=2:2:2*NNpS;   % gdl locales del segmento en y

% Evaluar coordenadas locales y pesos de los puntos de Gauss en el contorno



% Evaluar funciones de forma y sus derivadas en los puntos anteriores


% Lazo para todas las condiciones de cargas en lados


% POR EL MOMENTO...
R = matriz derivadas dy/detha ...
y = SUM ( N * y_i )
dy/detha = SUM dN/detha * y_i