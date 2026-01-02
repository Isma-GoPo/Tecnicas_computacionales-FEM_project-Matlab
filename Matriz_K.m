function [K,DB]=Matriz_K(XY,Topologia,D,Tipologia)
% Cálculo de matrices de elemento y ensamblado
% ============================================

Nnodos = Tipologia.Nnodos;
Nelementos  = Tipologia.Nelementos;
Nnodos_por_elemento = Tipologia.Nnodos_por_elemento;
Nlados= Tipologia.Nlados;
Npuntos_integracion = Tipologia.Npuntos_integracion;
grado_polinomio = Tipologia.grado_polinomio;

K=sparse((2*Nnodos),(2*Nnodos)); 
% Las sparse son matrices donde se guarda las coordenadas x, y, con el valor. 
%   Están hechas para matrices muy vacías -> Cuando hay muchos ceros, estos
%   no se registran. 
DB=zeros(3,2*Nnodos_por_elemento,Npuntos_integracion,Nelementos);

% Coordenadas locales y pesos de los puntos de Gauss
Dimensiones=2;
[XYG, W] = pgauss(Dimensiones,Nlados,Npuntos_integracion); 
% Funciones de forma y sus derivadas en los puntos de Gauss
[N,dNxi,dNeta] = shape_f_2d(XYG,grado_polinomio,Nlados,1);

gdlx=1:2:(2*Nnodos_por_elemento-1); %gdl locales del elemento en x
gdly=2:2:2*Nnodos_por_elemento;     %gdl locales del elemento en y

% Lazo para todos los elementos
% -----------------------------
for i_elemento=1:Tipologia.Nelementos
    Ne=Topologia(:,i_elemento);  %Nodos del elemento
    XYe=XY(:,Ne)';
    Ke=zeros(2*Nnodos_por_elemento,2*Nnodos_por_elemento);
    % Lazo en Puntos de Gauss
    for i_punto_integracion = 1:Tipologia.Npuntos_integracion
        % Matriz Jacobiana
        Jacobiano = MatrizJacobiana(dNxi,dNeta,XYe,i_punto_integracion);
        InvJacobiano=inv(Jacobiano);
        % Matriz de Derivadas de N respecto de las coordenadas locales
        dNlocal = [dNxi(i_punto_integracion,:); dNeta(i_punto_integracion,:)];        
        % Matriz B
        dNglobal = InvJacobiano*dNlocal;
        B=zeros(3,2*Nnodos_por_elemento);
        B(1,gdlx)=dNglobal(1,:);
        B(2,gdly)=dNglobal(2,:);
        B(3,gdlx)=dNglobal(2,:);
        B(3,gdly)=dNglobal(1,:);
        % Matriz D·B en cada punto de Gauss
        DB(:,:,i_punto_integracion,i_elemento)=D*B;
        % Matriz K de elemento (aportación de cada punto de Gauss)
        Ke = Ke + B'*D*B*det(Jacobiano)*W(i_punto_integracion);
    end
    Ke=(Ke+Ke')/2; % para que Ke sea perfectamente simetrica
    % grados de libertad globales en el elemento
    gdle(gdlx)=2*Ne-1;
    gdle(gdly)=2*Ne;   
    % Matriz K ensamblada
    K(gdle,gdle) = K(gdle,gdle) + Ke;
end



