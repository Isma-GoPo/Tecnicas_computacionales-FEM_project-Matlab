function Ja = Eval_Jacobiana(XYe,xiEtaPt,Tipologia)

grado_polinomio = Tipologia.grado_polinomio;
Nlados = Tipologia.Nlados;

[~,dNxi,dNeta] = shape_f_2d(xiEtaPt,grado_polinomio,Nlados,1);  

Ja = [dNxi*XYe(:,1) , dNxi*XYe(:,2); ...
      dNeta*XYe(:,1) , dNeta*XYe(:,2)];