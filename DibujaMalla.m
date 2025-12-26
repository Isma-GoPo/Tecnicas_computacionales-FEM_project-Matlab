function DibujaMalla(XY,Top,Param)
clf
axis equal
% Evaluar reordenamiento de la numeración de los nodos
switch Param.NNpe
    case 3
        Reord=[1,2,3];
    case 4
        Reord=[1,2,3,4];
    case 6
        Reord=[1,4,2,5,3,6];
    case 8
        Reord=[1,5,2,6,3,7,4,8];
end

Top=Top(Reord,:);

% Obtención de escalas de dibujo
% ------------------------------
Xmin = min(XY(1,:));
Xmax = max(XY(1,:));
Ymin = min(XY(2,:));
Ymax = max(XY(2,:));

Xplot=[(Xmin-(Xmax-Xmin)/8), (Xmax+(Xmax-Xmin)/8) ];
Yplot=[(Ymin-(Ymax-Ymin)/8), (Ymax+(Ymax-Ymin)/8) ];

% Dibujo de la malla
% ------------------
axis([Xplot Yplot]);
hold on
title('Malla')

for i=1:Param.Nel
    Ne = Top(:,i)
    XYe = XY(:,Ne)
    H = fill(XYe(1,:), XYe(2,:), 'g')
    
    if Param.Nel<100
        XYc=sum(XYe,2)/NNpE;
        h=text(XYc(1),XYc(2),num2str(i));  set(h,'Color',[0,0,1]);
    end
end
    
% Numeración de nodos
% -------------------
if Param.Nel<100
    for i= 1:Param.Nnod
        text(XY(1,i),XY(2,i),num2str(i));
    end
end

hold off

grid on
