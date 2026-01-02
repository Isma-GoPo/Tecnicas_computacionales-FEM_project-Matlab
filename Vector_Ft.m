function F = Vector_Ft(XY,CargasL,Tipologia)

% Ensamblado del vector de carga
% ==============================

NNodos_por_segmento=size(CargasL,2)/3; % Numero de nodos por segmento

%gdlx=1:2:2*NNpS-1; % gdl locales del segmento en x
%gdly=2:2:2*NNpS;   % gdl locales del segmento en y

NNodos = size(XY, 2);
F = zeros(2*NNodos,1);

% Evaluar coordenadas locales y pesos de los puntos de Gauss en el contorno

[Coordenadas,Pesos] = pgauss(1,1,Tipologia.NPGL);



% Evaluar funciones de forma y sus derivadas en los puntos anteriores

for segmento_i = 1:size(CargasL, 1)
    % 1. Nodos del segmento (3 nodos por ser cuadrático)
    nodos_segmento = CargasL(segmento_i, 1:NNodos_por_segmento); % [Vértice1, Vértice2, NodoMedio]
    
    % 2. Cargas en X (columnas 4, 5, 6) y en Y (columnas 7, 8, 9)
    ty_nodos = CargasL(segmento_i, NNodos_por_segmento+1:NNodos_por_segmento*2); 
    tx_nodos = CargasL(segmento_i, NNodos_por_segmento*2+1:NNodos_por_segmento*3);
    
    XYsegmento = XY(:, nodos_segmento); 
    Fe = zeros(6, 1); % 3 nodos * 2 GDL = 6
    
    for i_punto_integracion = 1:length(Pesos)
        % IMPORTANTE: Grado 2 para cuadrático
        [N, dN] = shape_f_1d(Coordenadas(i_punto_integracion), 2, 1); 
        
        % Jacobiano de línea (ds)
        % dN es (1x3), XYsegmento' es (3x2) -> dr_deta es (1x2)
        dr_deta = dN * XYsegmento'; 
        ds = -norm(dr_deta); 
        
        % Interpolación de la carga en el punto de Gauss
        tx_global = N * tx_nodos';
        ty_global = N * ty_nodos';
        
        % Integración de la fuerza elemental
        for i = 1:3
            Fe(2*i-1) = Fe(2*i-1) + N(i) * tx_global * ds * Pesos(i_punto_integracion);
            Fe(2*i)   = Fe(2*i)   + N(i) * ty_global * ds * Pesos(i_punto_integracion);
        end
    end
    
    % 3. Ensamblado global con el orden correcto
    for i = 1:3
        idx_global_x = 2*nodos_segmento(i) - 1;
        idx_global_y = 2*nodos_segmento(i);
        F(idx_global_x) = F(idx_global_x) + Fe(2*i-1);
        F(idx_global_y) = F(idx_global_y) + Fe(2*i);
    end
end