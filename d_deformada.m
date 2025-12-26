function d_deformada(XY,Topologia,Sol,Tipologia)

clf
axis equal
switch Tipologia.Nnodos_por_elemento
    case 3
        Reord=[1,2,3];
    case 4
        Reord=[1,2,3,4];
    case 6
        Reord=[1,4,2,5,3,6];
    case 8
        Reord=[1,5,2,6,3,7,4,8];
end

% Obtención de escalas de dibujo
% ------------------------------
Xmin=min(XY(1:1,:));
Xmax=max(XY(1:1,:));
Ymin=min(XY(2:2,:));
Ymax=max(XY(2:2,:));
Xplot=[(Xmin-(Xmax-Xmin)/8) (Xmax+(Xmax-Xmin)/8) ];
Yplot=[(Ymin-(Ymax-Ymin)/8) (Ymax+(Ymax-Ymin)/8) ];

% Dibujo de la malla deformada y no deformada
% -------------------------------------------
axis([Xplot Yplot]);
hold on
title('Deformada')
DimMax=max([Xmax-Xmin,Ymax-Ymin]);
DespMax=max(abs(Sol));
Factor=0.04*DimMax/DespMax;
for i_elemento= 1:Tipologia.Nelementos
    Ne=Topologia(Reord,i_elemento);  %Nodos del elemento   
    Xe= XY(1,Ne)'+Sol(2*Ne-1)*Factor;
    Ye= XY(2,Ne)'+Sol(2*Ne)*Factor;
    fill(Xe,Ye,'b');
    plot([XY(1,Ne) XY(1,Ne(1))]',[XY(2,Ne) XY(2,Ne(1))]',':r')    
end
