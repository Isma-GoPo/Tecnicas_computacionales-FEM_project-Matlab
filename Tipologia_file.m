% Parámetros del problema
% ===========================================
Tipologia.Nnodos = size(XY,2);
Tipologia.Nelementos  = size(Topologia,2);
Tipologia.Nnodos_por_elemento = size(Topologia,1);
Tipologia.NCl  = size(CargasL,1);
Tipologia.NRX  = size(RestX,2);   % nº de restricciones en X
Tipologia.NRY  = size(RestY,2);   % nº de restricciones en Y

% Determina número de Nlados del elemento (Nlados)
% grado_polinomio de elemento, lineal o cuadrático (grado_polinomio)
% y número puntos integración en elemento (Npuntos_integracion)
switch Tipologia.Nnodos_por_elemento
    case {3} %Triángulo lineal
        Tipologia.Nlados = 3;  Tipologia.grado_polinomio = 1;  Tipologia.Npuntos_integracion = 1;  Tipologia.NPGL  = 1;
    case {6} %Triángulo Cuadrático
        Tipologia.Nlados = 3;  Tipologia.grado_polinomio = 2;  Tipologia.Npuntos_integracion = 4;  Tipologia.NPGL  = 2;
    case {4} %Cuadriláteros Lineales
        Tipologia.Nlados = 4;  Tipologia.grado_polinomio = 1;  Tipologia.Npuntos_integracion = 4;  Tipologia.NPGL  = 2;
    case {8} %Cuadriláteros Cuadráticos
        Tipologia.Nlados = 4;  Tipologia.grado_polinomio = 2;  Tipologia.Npuntos_integracion = 4;  Tipologia.NPGL  = 2;
end

