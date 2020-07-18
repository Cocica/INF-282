// Terceiro cenário do Trabalho 3 PO3 2020 UFV - 2020
// Aluno: Alisson de O. Xavier - 95665

execute {
  cplex.EpGap = 1E-9;
}

range Faz = 1..4;
range Cid = 1..16;
string nCid[Cid] = ...;
string nFaz[Faz] = ...;
int s[Faz] = ...;
int f[Cid] = ...;
int deo[Cid] = ...;
int df[Cid] = ...;
int da[Cid] = ...;

int c1 [Faz][Cid] = ...;
 
int c2 [Cid][Cid] = ...;
					
dvar boolean y[Cid];
dvar float+ x1[Faz][Cid];
dvar int+ xo[Cid][Cid];
dvar int+ xf[Cid][Cid];
dvar int+ xa[Cid][Cid];

dexpr float Cfixo = sum(j in Cid) f[j]*y[j];
dexpr float CFaz = sum (i in Faz,j in Cid) (0.02*c1[i][j]*x1[i][j]);
dexpr float CO = sum (j in Cid,k in Cid) (0.05*c2[j][k]*xo[j][k]);
dexpr float CF = sum (j in Cid,k in Cid) (0.05*c2[j][k]*xf[j][k]);
dexpr float CA = sum (j in Cid,k in Cid) (0.05*c2[j][k]*xa[j][k]);

dexpr float Ctot = Cfixo + CFaz + CO + CF + CA;


minimize Ctot;

subject to {
  
forall (j in Cid) sum(i in Faz) x1[i][j] <= 1200000*y[j];
forall (i in Faz) (sum(j in Cid) x1[i][j] <= s[i]);


forall (k in Cid) sum(j in Cid) xo[j][k] == deo[k];
forall (k in Cid) sum(j in Cid) xf[j][k] == df[k]; 
forall (k in Cid) sum(j in Cid) xa[j][k] == da[k]; 

forall (j in Cid) ( sum (i in Faz) x1[i][j] >= 40*sum(k in Cid)xo[j][k]+5*sum(k in Cid)xf[j][k]+20*sum(k in Cid)xa[j][k]);

forall (j in Cid,k in Cid)  xo[j][k] <= deo[k]*y[j];
forall (j in Cid,k in Cid)  xf[j][k] <= df[k]*y[j];
forall (j in Cid,k in Cid)  xa[j][k] <= da[k]*y[j];



}

execute DISPLAY {

function toFixed(v, width, prec) {
  var s = "";
  if (prec == 0)
    s = s + Opl.round(v);
  else {
    var m = Opl.pow(10,prec);
    s = s + Opl.round(m * v) / m;
    var idx = s.indexOf(".");
    if (idx >= 0 && idx+prec < s.length)
      s = s.substring(0,idx+prec+1);
    idx = s.indexOf(".");
    if (idx < 0) {
      s = s + ".";
      idx = s.length-1;
    }
    var N = s.length-1 - idx;
    for (var i=0; i<prec-N; i++)
      s = s + "0";
  }    
  while (s.length < width)
    s = " " + s;
    
  return (s);
}

function Pad( s, width ) {
  while (s.length < width)
    s = s + " ";
  return (s);
}

writeln("");

writeln("Custo de Transp. p/ UPMs:                  ", toFixed( CFaz, 12, 2 ));
writeln("Custo fixo UPMs:                           ", toFixed( Cfixo, 12, 2 ));
writeln("Custo de Transp. de óleo:                  ", toFixed( CO, 12, 2 ));
writeln("Custo de Transp. de farinha:               ", toFixed( CA, 12, 2 ));
writeln("Custo de Transp. de amido:                 ", toFixed( CF, 12, 2 ));
writeln("Custo TOTAL:                               ", toFixed( Ctot, 12, 2 ));
writeln("");
writeln("Cidades com UPMs:");
writeln("-----------------");
var i = 0;
var j = 0;
	
	for(i in Cid)
		if (y[i] == 1)
    	writeln( i, ".  ", nCid[i]);

    	
writeln("");
writeln("Quantidades transportadas das Fazendas p/ os UPMs:");
writeln("");
writeln("Origem                        Destino                         Qtde")
writeln("------------------------------------------------------------------")

for(i in Faz)
  for(j in Cid)
    if (x1[i][j] >= 0.001)
 		      writeln( Pad( nFaz[i], 30 ), Pad( nCid[j], 30 ), toFixed(x1[i][j], 6, 0 ));
writeln("------------------------------------------------------------------")

writeln("");
writeln("Demanda de óleo atendida por cada UPM:");
writeln("");
writeln("UPM                           Cidade Atendida                 Qtde")
writeln("------------------------------------------------------------------")
for(i in Cid)
  for(j in Cid)
    if (xo[i][j] >= 0.001)
      writeln( Pad( nCid[i], 30 ), Pad( nCid[j], 30 ), toFixed( xo[i][j], 6, 0 ));
writeln("------------------------------------------------------------------")

writeln("");
writeln("Demanda de farinha atendida por cada UPM:");
writeln("");
writeln("UPM                           Cidade Atendida                 Qtde")
writeln("------------------------------------------------------------------")
for(i in Cid)
  for(j in Cid)
    if (xf[i][j] >= 0.001)
      writeln( Pad( nCid[i], 30 ), Pad( nCid[j], 30 ), toFixed( xf[i][j], 6, 0 ));
writeln("------------------------------------------------------------------")

writeln("");
writeln("Demanda de amido atendida por cada UPM:");
writeln("");
writeln("UPM                           Cidade Atendida                 Qtde")
writeln("------------------------------------------------------------------")
for(i in Cid)
  for(j in Cid)
    if (xa[i][j] >= 0.001)
      writeln( Pad( nCid[i], 30 ), Pad( nCid[j], 30 ), toFixed( xa[i][j], 6, 0 ));
writeln("------------------------------------------------------------------")

}







 
























