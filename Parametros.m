% Parámetros del problema
% ===========================================
Param.Nnod = size(XY,2);
Param.Nel  = size(Top,2);
Param.NNpe = size(Top,1);
Param.NCl  = size(CargasL,1);
Param.NRX  = size(RestX,2);   % nº de restricciones en X
Param.NRY  = size(RestY,2);   % nº de restricciones en Y

% Determina número de lados del elemento (Lados)
% Tipo de elemento, lineal o cuadrático (Tipo)
% y número puntos integración en elemento (NPGe)
switch Param.NNpe
    case {3} %Triángulo lineal
        Param.Lados = 3;  Param.Tipo = 1;  Param.NPGe = 1;  Param.NPGL  = 1;
    case {6} %Triángulo Cuadrático
        Param.Lados = 3;  Param.Tipo = 2;  Param.NPGe = 4;  Param.NPGL  = 2;
    case {4} %Cuadriláteros Lineales
        Param.Lados = 4;  Param.Tipo = 1;  Param.NPGe = 4;  Param.NPGL  = 2;
    case {8} %Cuadriláteros Cuadráticos
        Param.Lados = 4;  Param.Tipo = 2;  Param.NPGe = 4;  Param.NPGL  = 2;
end

