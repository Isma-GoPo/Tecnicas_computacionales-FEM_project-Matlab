function d_sol3d(XY,Topologia,Sol,Tipologia)

Nelementos  = Tipologia.Nelementos;
Nnodos_por_elemento = Tipologia.Nnodos_por_elemento;

switch Nnodos_por_elemento
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
Topologia=Topologia(Reord,:);


colormap jet
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
for iElem=1:Nelementos
    Ne=Topologia(:,iElem);
    XYe=XY(:,Ne);
    Se=Sol(Ne);
    %fill3(XYe(1,:),XYe(2,:),Se,Se);
    H=fill3(XYe(1,:),XYe(2,:),Se,Se);
    set(H,'FaceColor','None');
    %set(H,'EdgeColor','None');
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

