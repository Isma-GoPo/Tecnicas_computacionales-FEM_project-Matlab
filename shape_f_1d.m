function [N,dN]=shape_f_1d(Coor,Grado,is_dN_calculated);
% funciones de forma
% y derivadas en un punto

%
% IMPORTANTE: en la numeración de nodos, los nodos 
% vértice son los primeros. Después de estos se numeran
% los nodos de mitad de lado.
%
% Coor       = coordenadas (X=xi e Y=eta)
% Grado      = Grado del elemento
% NladosElem = Núm de Nlados del elem (1, 3 ó 4)
% is_dN_calculated      = indicador de cálculo de dN 
%                 0    ==> no se calcula
%                 else ==> se calcula la derivada
% SALIDA
%   N        = Matriz de funciones de forma. Cada fila corresponde
%              a las funciones de forma en un punto de coord (x,y)
%   dNxi    = Derivada de matrices de funciones de forma respecto a xi



global N dN

if nargin==2
    is_dN_calculated=0;
end
    
X=Coor(:,1)';

% ELEMENTOS UNIDIMENSIONALES -------------      
   switch Grado
   case 1 %Elementos unidimensionales lineales
      N=[...
            (1/2).*(1-X);...
            (1/2).*(1+X)];
      if is_dN_calculated==0
         dN=0;
      else 
         dN=[...
               -0.5+0*X;...
                0.5+0*X];
      end  
     
   case 2 %Elementos unidimensionales cuadraticos
      N=[...
            (1/2).*X.*(X-1);...
            (1/2).*X.*(X+1);...
            1-X.^2];
          
      if is_dN_calculated==0
         dN=0;
      else 
         dN=[...
               X-0.5;...
               X+0.5;...
               -2.*X];
      end  
   
      otherwise %Elementos lineales de grado superior
      disp(['Grado polinómico ' num2str(Grado)...
            'No programado para elementos lineales']);
      error('parando');
      end
    
N=N';
dN=dN';
  
return;