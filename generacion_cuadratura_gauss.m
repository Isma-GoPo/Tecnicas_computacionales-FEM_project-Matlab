function [Coordenadas,Pesos]=generadora(n,Coordenadas_o,Pesos_o)
Coordenadas = zeros(n,2);
Pesos = zeros(n,1);
for i = 1:n;
    for j = 1:n;
        k = (i-1)*n + j;
        Coordenadas(k, 1) = Coordenadas_o(i);
        Coordenadas(k, 2) = Coordenadas_o(j);
        Pesos(k,1) = Pesos_o(i)*Pesos_o(j);
    end
end
end

n=5;

[Coordenadas_o, Pesos_o] = pgauss(1,1,n)


[Coordenadas, Pesos] = generadora(n, Coordenadas_o, Pesos_o)
