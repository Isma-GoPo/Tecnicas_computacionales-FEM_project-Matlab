function [Coord]=LocalCoorNodos2D(Lados,Tipo)


switch Lados
    case 3  %Trianglulos
        Coord=[...
            0,1,0;...
            0,0,1];
        if Tipo==2
            Coord2=[...
                0.5, 0.5, 0.0;...
                0.0, 0.5, 0.5];
            Coord=[Coord , Coord2];
        end
    case 4  %Cuadriláteros
        Coord=[...
            -1, +1, +1, -1;...
            -1, -1, +1, +1];
        if Tipo==2
            Coord2=[...
                +0, 1, 0, -1;...
                -1, 0, 1,  0];
            Coord=[Coord , Coord2];
        end
    otherwise
        error(['No preparado para elementos de ' num2str(Lados) ' lados']);
end

Coord=Coord';

if (Tipo~=1)&&(Tipo~=2)
    error(['Subrutina no preparada para elementos de grado ' num2str(Tipo)]);
end
