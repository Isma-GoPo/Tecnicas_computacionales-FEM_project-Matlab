function F = Vector_Ft(XY,CargasL,Param)

% Ensamblado del vector de carga
% ==============================

%NNpS=size(CargasL,2)/3; % Numero de nodos por segmento

%gdlx=1:2:2*NNpS-1; % gdl locales del segmento en x
%gdly=2:2:2*NNpS;   % gdl locales del segmento en y

nNod = size(XY, 2);
F = zeros(2*nNod,1);

% Evaluar coordenadas locales y pesos de los puntos de Gauss en el contorno

[etaG,wG] = pgauss(1,1,Param.NPGL);



% Evaluar funciones de forma y sus derivadas en los puntos anteriores

for iseg = 1:size(CargasL, 1)
    % 1. Nodos del segmento (3 nodos por ser cuadrático)
    nodosseg = CargasL(iseg, 1:3); % [Vértice1, Vértice2, NodoMedio]
    
    % 2. Cargas en X (columnas 4, 5, 6) y en Y (columnas 7, 8, 9)
    ty_nodos = CargasL(iseg, 4:6); 
    tx_nodos = CargasL(iseg, 7:9);
    
    XYseg = XY(:, nodosseg); 
    Fe = zeros(6, 1); % 3 nodos * 2 GDL = 6
    
    for ig = 1:length(wG)
        % IMPORTANTE: Grado 2 para cuadrático
        [N, dN] = shape_f_1d(etaG(ig), 2, 1); 
        
        % Jacobiano de línea (ds)
        % dN es (1x3), XYseg' es (3x2) -> dr_deta es (1x2)
        dr_deta = dN * XYseg'; 
        ds = -norm(dr_deta); 
        
        % Interpolación de la carga en el punto de Gauss
        tx_g = N * tx_nodos';
        ty_g = N * ty_nodos';
        
        % Integración de la fuerza elemental
        for i = 1:3
            Fe(2*i-1) = Fe(2*i-1) + N(i) * tx_g * ds * wG(ig);
            Fe(2*i)   = Fe(2*i)   + N(i) * ty_g * ds * wG(ig);
        end
    end
    
    % 3. Ensamblado global con el orden correcto
    for i = 1:3
        idx_global_x = 2*nodosseg(i) - 1;
        idx_global_y = 2*nodosseg(i);
        F(idx_global_x) = F(idx_global_x) + Fe(2*i-1);
        F(idx_global_y) = F(idx_global_y) + Fe(2*i);
    end
end