function Ja = Eval_Jacobiana(XYe,PsiEtaPt,Param)

Tipo = Param.Tipo;
Lados = Param.Lados;

[~,dNpsi,dNeta] = shape_f_2d(PsiEtaPt,Tipo,Lados,1);  

Ja = [dNpsi*XYe(:,1) , dNpsi*XYe(:,2); ...
      dNeta*XYe(:,1) , dNeta*XYe(:,2)];