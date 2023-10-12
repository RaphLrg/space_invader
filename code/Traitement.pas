unit Traitement; 
   
interface

uses crt, sysutils, TypeSdl, sdl, sdl_image, sdl_mixer,math, sdl_ttf;
  

// vérifie si il y a contact entre les différents items
procedure Verification ( it:Item; tab:tabTaille; item1: integer; item2:integer ; var contact:boolean;var toucheryH: boolean;var toucheryB:boolean;var toucherxG: boolean;var toucherxD:boolean) ;

// vérifie si il y a contact prenant en compte le vaisseau
procedure VerificationVaisseau ( v:Vaisseau; it:Item; tab:tabTaille; item2:integer ; var contact:boolean; var toucheryH: boolean;var toucheryB:boolean;var toucherxG: boolean;var toucherxD:boolean) ;

// vérifit si les monstres ont atteints le vaisseau
procedure ContactVaisseauMonstre(var it:Item; var v:Vaisseau; var tab:tabTaille; var finJ:boolean);

//Donne aléatoirement l'indice d'un monstre du tableau
function monstreAlea(it : item): integer;

//Verifie qu'il ny a pas de monstre sous le monstre d'indice n
function champLibre(n : integer; it : item; tab : tabTaille): boolean;

//Génère une bombes toutes les 0.5 a 1 sec puis l'attribue a un monstre
procedure generationBombe(var data : dataTirBombe; var it : Item; tab : tabTaille);

//Création d'un  missile
procedure generationMissile(var it : Item; ship : vaisseau; tab : tabTaille; var dataShip : dataVaisseau);

//initialisation des variables d'explosion
procedure InitExplo(var explo : tabExplo);

//initialisation des variables de génération des bombes
procedure initTirBombes( mini, maxi : integer; var data : dataTirBombe);

// enregistre le score dans un fichier et modifie le high score au besoin
procedure enregistreScore(score : longint);

//calcul de la somme des vies possédées à un instant par tous les monstres existants
function totalVieActuel(it : item): integer;

// cherche une case dispo parmis les vide puis la retire de l'ens it.vide et l'ajoute a l'ens it.monstre
function case_dispo(var it : item) : integer;	

//initialisation de touts les temps au début d'une partie
procedure initTemps (var temps : tab_temps);

//initialisation des paramètres du vaisseau
procedure InitVaisseau(tab : tabTaille; var ship : vaisseau; var dataShip : dataVaisseau);





implementation




procedure Verification ( it:Item; tab:tabTaille; item1: integer; item2:integer ; var contact:boolean; var toucheryH: boolean;var toucheryB:boolean;var toucherxG: boolean;var toucherxD:boolean) ;

var minx1, maxx1, miny1, maxy1, minx2, maxx2, miny2, maxy2 :Integer;
var toucherx, touchery: boolean;

// toucherx et TRUE si il y a un une coordonée en x identique entre deux objets 
// touchery et TRUE si il y a un une coordonée en y identique entre deux objets
// toucherx et touchery doivent être vrais pour qu'il y est contact
// min--/ max-- représentent les coordonnés des 4 coins des items 1 et 2 

begin 	

toucherx := False;
touchery := False ;
toucherxG := False; // toucherxG renvoie vrai si il y un contact en x à gauche 
toucherxD := False; // toucherxD renvoie vrai si il y un contact en x à droite 
toucheryH := False;	// toucheryH renvoie vrai si il y un contact en y en haut 
toucheryB := False; // toucheryB renvoie vrai si il y un contact en y en bas

// On initialise les coordonées des deux items en x en fonction de leur catégorie

if item2 in it.monstre then 
begin
	minx2:= (it.tabItem[item2].x);
	maxx2 := (it.tabItem[item2].x + tab[it.tabItem[item2].param + rangMonstres]['x'] );
end
else if item2 in it.missile then 
begin
	minx2:= (it.tabItem[item2].x);
	maxx2 := (it.tabItem[item2].x + tab[it.tabItem[item2].param + rangMissiles]['x'] );
end
else if item2 in it.bombe then 
begin
	minx2:= (it.tabItem[item2].x);
	maxx2 := (it.tabItem[item2].x + tab[it.tabItem[item2].param + rangBombes]['x'] );
end;


if item1 in it.monstre then 
begin
	minx1:= (it.tabItem[item1].x);
	maxx1 := (it.tabItem[item1].x + tab[it.tabItem[item1].param + rangMonstres]['x'] );
end
else if item1 in it.missile then 
begin
	minx1:= (it.tabItem[item1].x);
	maxx1 := (it.tabItem[item1].x + tab[it.tabItem[item1].param + rangMissiles]['x'] );
end
else if item1 in it.bombe then 
begin
	minx1:= (it.tabItem[item1].x);
	maxx1 := (it.tabItem[item1].x + tab[it.tabItem[item1].param + rangBombes]['x'] );
end;

// On vérifit si il y a contact en x


if ((minx2<=maxx1) and (minx2>=minx1))  then
	toucherxG := True;
	
if ((maxx2<=maxx1) and (maxx2>=minx1))  then
	toucherxD := True;
		
if ((toucherxG= True) or (toucherxD= True)) then
	toucherx :=True	;	
			
// Si il y a contact en x on vérifie le contact en y
 
if toucherx= True then
 
	begin
// On initialise les coordonées des deux items en y en fonction de leur catégorie
	if item2 in it.monstre then 
	begin
		miny2:= (it.tabItem[item2].y);
		maxy2 := (it.tabItem[item2].y + tab[it.tabItem[item2].param + rangMonstres]['y'] );
	end
	else if item2 in it.missile then 
	begin
		miny2:= (it.tabItem[item2].y);
		maxy2 := (it.tabItem[item2].y + tab[it.tabItem[item2].param + rangMissiles]['y'] );
	end
	else if item2 in it.bombe then 
	begin
		miny2:= (it.tabItem[item2].y);
		maxy2 := (it.tabItem[item2].y + tab[it.tabItem[item2].param + rangBombes]['y'] );
	end;


	if item1 in it.monstre then 
	begin
		miny1:= (it.tabItem[item1].y);
		maxy1 := (it.tabItem[item1].y + tab[it.tabItem[item1].param + rangMonstres]['y'] );
	end
	else if item1 in it.missile then 
	begin
		miny1:= (it.tabItem[item1].y);
		maxy1 := (it.tabItem[item1].y + tab[it.tabItem[item1].param + rangMissiles]['y'] );
	end
	else if item1 in it.bombe then 
	begin
		miny1:= (it.tabItem[item1].y);
		maxy1 := (it.tabItem[item1].y + tab[it.tabItem[item1].param + rangBombes]['y'] );
	end;
	
// On vérifit le contact en y 
	
	if ((miny2<=maxy1) and (miny2>= miny1)) then
		toucheryH := True;	
	
	if ((maxy2<=maxy1) and (maxy2>= miny1)) then
		toucheryB:= True;
		
	if ((toucheryH= True) or (toucheryB= True)) then
	touchery :=True	;	
		
	end;
		
// Si il y a contact en x et en y alors il y a contact

if ((toucherx= True) and (touchery= True)) then
	contact :=True
else contact := False;

	
end;




procedure VerificationVaisseau ( v:Vaisseau; it:Item; tab:tabTaille; item2:integer ; var contact:boolean; var toucheryH: boolean;var toucheryB:boolean;var toucherxG: boolean;var toucherxD:boolean) ;

var minx1, maxx1, miny1, maxy1, minx2, maxx2, miny2, maxy2 :Integer;
var toucherx, touchery: boolean;

// toucherx et TRUE si il y a un une coordonée en x identique entre deux objets 
// touchery et TRUE si il y a un une coordonée en y identique entre deux objets
// toucherx et touchery doivent être vrais pour qu'il y est contact
// min--/ max-- représentent les coordonnés des 4 coins des items 1 et 2 

begin 	

toucherx := False;
touchery := False ;
toucherxG := False; // toucherxG renvoie vrai si il y un contact en x à gauche 
toucherxD := False; // toucherxD renvoie vrai si il y un contact en x à droite 
toucheryH := False;	// toucheryH renvoie vrai si il y un contact en y en haut 
toucheryB := False; // toucheryB renvoie vrai si il y un contact en y en bas

// On initialise les coordonées des deux objets en x 
	
minx1:= v.pos.x ;
maxx1:= (v.pos.x  + tab[v.pos.param + rangVaisseaux]['x']);

minx2:= it.tabItem[item2].x ;
maxx2 := (it.tabItem[item2].x + tab[it.tabItem[item2].param + rangBombes]['x']);

// On vérifie si il y a contact en x entre les deux objets

if ( ((minx2<maxx1) and (minx2>minx1)) or (minx2=minx1) or (minx2=maxx1) ) then
	toucherxG := True;
	
if ( ((maxx2<maxx1) and (maxx2> minx1)) or (maxx2=minx1) or (maxx2=maxx1) ) then
	toucherxD := True;
		
if ((toucherxG= True) or (toucherxD= True)) then
	toucherx :=True	;	
			
// Si il y a contact en x on vérifie le contact en y
 
if toucherx= True then
 
	begin
// On initialise les coordonées des deux objets en x 
		
	miny1:= v.pos.y ;
	maxy1:= (v.pos.y  + tab[v.pos.param + rangVaisseaux]['y']);

	miny2:= it.tabItem[item2].y ;
	maxy2:= (it.tabItem[item2].y + tab[it.tabItem[item2].param + rangBombes]['y']);
	
// On vérifie si il y a contact en x entre les deux objets
	if ( ((miny2<maxy1) and (miny2> miny1)) or (miny2=miny1) or (miny2=maxy1) ) then
		toucheryH := True;	
	
	if ( ( (maxy2<maxy1) and (maxy2> miny1) ) or (maxy2=miny1) or (maxy2=maxy1)) then
		toucheryB:= True;
		
	if ((toucheryH= True) or (toucheryB= True)) then
	touchery :=True	;	
		
	end;

// Si il y a contact en x et en y alors il y a contact
	
if ((toucherx= True) and (touchery= True)) then
	contact :=True
else contact := False;

	
end;




procedure ContactVaisseauMonstre(var it:Item; var v:Vaisseau; var tab:tabTaille; var finJ:boolean);

var monstr:Integer;
var contact : boolean;
var toucheryH: boolean;
var toucheryB:boolean;
var toucherxG: boolean;
var toucherxD:boolean ;

// monstr nom de l'objet dont on vérifit le contact avec le vaisseau
// contact devient vrai si il y contact 
// finJ vrai si les monstres ont atteints le vaisseau
// toucherxG renvoie vrai si il y un contact en x à gauche 
// toucherxD renvoie vrai si il y un contact en x à droite 
// toucheryH renvoie vrai si il y un contact en y en haut 
 // toucheryB renvoie vrai si il y un contact en y en bas


begin

finJ:= False;
for monstr in it.monstre do 
	begin
	VerificationVaisseau ( v, it, tab, monstr, contact,toucheryH, toucheryB, toucherxG, toucherxD) ;
	if ((toucheryH = True) xor (toucheryB = True)) then 
		finJ:= True 
	end; 
end;




//Donne aléatoirement l'indice d'un monstre du tableau
function monstreAlea(it : item): integer;
var i, j, nbMonstre : integer;

begin
	randomize;
	//tirage aléatoire de l'indice d'un monstre
	nbMonstre := trunc(random(taille(it.monstre)));
	i := 1;
	for j in it.monstre do		//on balaye les valeurs des indices de monstres 
	begin
		if i = nbMonstre then	//on en déduis l'indice correspondant au nombre tiré
		begin 
			nbMonstre := j;
			i := j;
		end;
		i := i + 1;
	end;
	if random < (1/taille(it.monstre)) then		
	begin
		i := high(it.monstre);
		while not(i in it.monstre) do
			i := i - 1;
		nbMonstre := i;
	end;
	monstreAlea := nbMonstre;
end;	




//Verifie qu'il ny a pas de monstre sous le monstre d'indice n
function champLibre(n : integer; it : item; tab : tabTaille): boolean;
var i : integer;


begin
	champLibre := true;
	
	for i in it.monstre do
	begin
		//vérification de la présence d'un monstre sous celui d'indice donné
		if ((( it.tabItem[n].x >= it.tabItem[i].x ) and ( it.tabItem[n].x <= it.tabItem[i].x + tab[it.tabItem[i].param + RangMonstres]['x'])) or (( it.tabItem[i].x >= it.tabItem[n].x ) and ( it.tabItem[i].x <= it.tabItem[n].x + tab[it.tabItem[n].param + RangMonstres]['x']))) and (it.tabItem[n].y < it.tabItem[i].y) then
			champLibre := false;
		
		if ( it.tabItem[n].x + tab[it.tabItem[n].param + RangMonstres]['x'] >= it.tabItem[i].x ) and ( it.tabItem[n].x + tab[it.tabItem[n].param + RangMonstres]['x'] <= it.tabItem[i].x + tab[it.tabItem[i].param + RangMonstres]['x']) and (it.tabItem[n].y < it.tabItem[i].y) then
			champLibre := false;
			
	end;
		
end;



//Génère une bombes toutes les 0.5 a 1 sec puis l'attribue a un monstre
//Penser à initialiser tRef et deltaTir avant la boucle
procedure generationBombe(var data : dataTirBombe; var it : Item; tab : tabTaille);

var j, nbMonstre : integer;
	tMesure : TSystemTime;
	
begin
	DateTimeToSystemTime(Now,tMesure); //La c'est l'instruction qui enregistre le moment dans tMesure
	j := 0;	
	
		
	//Si le temps entre 2 tirs prévu est atteint alors  
	if (diffTemps(tMesure, data.time) > data.delta) and (it.monstre <> []) then
	begin
	
		//On pioche un monstre qui n'a rien sous lui
		repeat
			nbMonstre := monstreAlea(it);
		until champLibre(nbMonstre, it, tab) and (nbMonstre in it.monstre);
			
			
		
		//Recherche d'un emplacement libre dans le tableau des items 
		while not (j in it.vide) do
			j := j + 1;
			
		
		//Création de la bombe (ajout dans l'ensemble des bombes et retrait de l'ensembles des places libres) puis initialisation des coordonnées de la bombe
		it.vide := it.vide - [j];
		it.bombe := it.bombe + [j];
		it.tabItem[j].param := lienMonstres[it.tabItem[nbMonstre].param];
		
		it.tabItem[j].x := (it.tabItem[nbMonstre].x) + (tab[it.tabItem[nbMonstre].param + rangMonstres]['x'] div 2) - (tab[it.tabItem[j].param + rangBombes]['x'] div 2);
		it.tabItem[j].y := it.tabItem[nbMonstre].y + tab[it.tabItem[nbMonstre].param + rangMonstres]['y'];
		
		//Choix aléatoire du délai avant le prochain tir
		data.delta := random(data.Maxi - data.Mini) + data.Mini;
		
		//Réinitialisation de tRef
		DateTimeToSystemTime(Now,data.time);
		
	end;
		
end;




procedure generationMissile(var it : Item; ship : vaisseau; tab : tabTaille; var dataShip : dataVaisseau);
var j : integer;


begin
	//Recherche d'un emplacement libre dans le tableau des items 
	j := 0;	
	while not (j in it.vide) do
		j := j + 1;
		

	//Création du missile (ajout dans l'ensemble des bombes et retrait de l'ensembles des places libres) puis initialisation des coordonnées de la bombe
	it.vide := it.vide - [j];
	it.missile := it.missile + [j];
	
	if (dataShip.munition < 1) or (dataShip.munition > TotalMissiles) then		//Soit une munition n'a pas été choisie et on en affecte une 
		it.tabItem[j].param := lienVaisseaux[ship.pos.param]
	else																		//Soit une munition a été à choisie et on l'affecte
		it.tabItem[j].param := dataShip.munition;
	it.tabItem[j].x := ship.pos.x + tab[ship.pos.param + rangVaisseaux]['x'] div 2 - tab[it.tabItem[j].param + rangMissiles]['x'] div 2;
	it.tabItem[j].y := ship.pos.y - tab[it.tabItem[j].param + rangMissiles]['y'];
	


	DateTimeToSystemTime(Now,dataShip.tTir);
end;


	
	
procedure InitExplo(var explo : tabExplo);	//initialisation des variables d'explosion
var i : integer;

begin
	for i := 1 to MAXEXPLO do
	begin
		explo[i].enCours := false;
		explo[i].avancement := 1;
		DateTimeToSystemTime(Now,explo[i].time);
	end;
end;




procedure initTirBombes( mini, maxi : integer; var data : dataTirBombe);		//initialisation des variables de génération des bombes

begin
	data.mini := mini;
	data.maxi := maxi;
	DateTimeToSystemTime(Now,data.time);
	data.delta := 0;
end;




procedure enregistreScore(score : longint);
var fichier : text;
	lecture : longint;

begin
	assign(fichier,'ressources/scores.txt');
	if not fileExists('ressources/scores.txt') then		//lecture des scores enregistrés dans un fichier
	begin
		rewrite(fichier);
		writeln(fichier,'0');
		writeln(fichier,'0');
	end;
	
	reset(fichier);
	readln(fichier, lecture);
	if lecture < score then		//écriture du score effectué en 1ère position s'il est supérieur au meilleur score enregistré
	begin
		rewrite(fichier);
		writeln(fichier, score);
		writeln(fichier, score);
	end
	else						//écriture du score effectué en 2eme position s'il est inférieur au meilleur score enregistré
	begin
		rewrite(fichier);
		writeln(fichier, lecture);
		writeln(fichier, score);		
	end;
	close(fichier);
end;




function totalVieActuel(it : item): integer;	//calcul de la somme des vies possédées à un instant par tous les monstres existants
var i : integer;

begin
	totalVieActuel := 0;
	for i in it.monstre do
			totalVieActuel := totalVieActuel + it.tabItem[i].nbVie;
end;




function case_dispo(var it : item) : integer;				
// cherche une case dispo parmis les vide, 
//la retire de l'ens it.vide et l'ajoute a l'ens it.monstre
		
begin
	case_dispo:=0;
					
	while not (case_dispo in it.vide) do case_dispo := case_dispo + 1;
					
	it.vide := it.vide - [case_dispo];
	it.monstre := it.monstre + [case_dispo];
end;




//initialisation de touts les temps au début d'une partie
procedure initTemps (var temps : tab_temps);
		
begin
	DateTimeToSystemTime(Now,temps.vitesse);
	DateTimeToSystemTime(Now,temps.Attente);
	DateTimeToSystemTime(Now,temps.Vague);
	DateTimeToSystemTime(Now,temps.tRef);
	DateTimeToSystemTime(Now,temps.apparition);	
end;




procedure InitVaisseau(tab : tabTaille; var ship : vaisseau; var dataShip : dataVaisseau);		//initialisation des paramètres du vaisseau

begin
	dataShip.tir := false;
	dataShip.left := false;
	dataShip.right := false;

	ship.pos.x := (dimensionX div 2) - tab[ship.pos.param + rangVaisseaux]['x'] div 2;
	ship.pos.y := dimensionY - tab[ship.pos.param + rangVaisseaux]['y'];
	ship.pos.nbVie := 3;
	DateTimeToSystemTime(Now,dataShip.tRight);
	DateTimeToSystemTime(Now,dataShip.tLeft);	
	DateTimeToSystemTime(Now,dataShip.tTir);
end;


END.

