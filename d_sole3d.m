function d_sole3d(XY,Top,Sol,Param)
% Dibuja solucion en elementos

Nel  = Param.Nel;
NNpe = Param.NNpe;

if min(size(Sol))==1 %1 valor cte por elemento
   if size(Sol,2)==1
   Sol=Sol';
   end
   Sol=ones(NNpe,1)*Sol; %Asigna el valor a cada nodo del elem
end

switch Param.NNpe
    case 3
        Reord=[1,2,3];
        SubEls=[1,2,3]';
        SubElsNum=1;
    case 4
        Reord=[1,2,3,4];
        SubEls=[...
            1,2,4;...
            2,3,4]';
        SubElsNum=2;
    case 6
        Reord=[1,4,2,5,3,6];
        SubEls=[...
            1,2,6;...
            2,3,4;...
            4,5,6;...
            2,4,6]';
        SubElsNum=4;
    case 8
        Reord=[1,5,2,6,3,7,4,8];
        SubEls=[...
            1,2,8;...
            2,3,4;...
            4,5,6;...
            6,7,8;...
            2,4,8;...
            4,6,8]';
        SubElsNum=6;
end
Top=Top(Reord,:);
Sol=Sol(Reord,:);

colormap(jet)
axis equal
grid on

% Tamaño de dibujo de malla
% -------------------------
Xmin=min(XY(1,:));    Xmax=max(XY(1,:));
Ymin=min(XY(2,:));    Ymax=max(XY(2,:));
Xplot=[(Xmin-(Xmax-Xmin)/8) (Xmax+(Xmax-Xmin)/8) ];
Yplot=[(Ymin-(Ymax-Ymin)/8) (Ymax+(Ymax-Ymin)/8) ];

axis([Xplot Yplot]);


% Dibujo de Solución  nodal (3D)
% ------------------------------
hold on
for iElem=1:Nel
    Ne=Top(:,iElem);
    XYe=XY(:,Ne);
    Se=Sol(:,iElem);
    H=fill3(XYe(1,:),XYe(2,:),Se,Se);
    set(H,'FaceColor','None');
    XSube=XYe(1,:);   XSube=XSube(SubEls);
    YSube=XYe(2,:);   YSube=YSube(SubEls);
    if SubElsNum==1
        XSube=XSube';
        YSube=YSube';
    end
    SSube=Se(SubEls);
    for iSubEl=1:SubElsNum
        H=fill3(XSube(:,iSubEl),YSube(:,iSubEl),SSube(:,iSubEl),SSube(:,iSubEl));
        set(H,'EdgeColor','None');
    end
end

hold off
colorbar
axis normal
