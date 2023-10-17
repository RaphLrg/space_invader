unit Mixte;

interface

uses crt, sysutils, TypeSdl, sdl, sdl_image, sdl_ttf, sdl_mixer ,math, Traitement, IHM ;

// calcul le score quand une bombe est détruite 
procedure CalculScoreBombe (var v:Vaisseau);

// calcul le score quand un monstre est touché ou tué 
procedure CalculScoreMonstre (monstre: Integer; it:Item;var v:Vaisseau ); 

// détermine si il y a contact entre un missile et une bombe
procedure ContactMissileBombe (var it:Item; var tab:tabTaille;var v:Vaisseau; var boom1, boom2, boom3, boom4, boom5 : dataExplo );

// détermine si il y a contact entre le vaisseau et une bombe, modifie le nombre de vies du vaisseau
procedure ContactVaisseauBombe(var it:Item; var v:Vaisseau; var tab:tabTaille; var tRefMouvement:TSystemTime; var mortV:boolean; var contactV : boolean);

//détermine si il y a contact entre un monstre et une bombe, modifie le score 
procedure ContactMissileMonstre(var it:Item; var tab:tabTaille; var v:Vaisseau;var boom, boom2, boom3, boom4, boom5 : dataExplo);

// regroupe les procédures de contact
procedure Contact (var it:Item; var v:Vaisseau; tab: tabTaille; var explo : tabExplo; var tRefMouvement:TSystemTime; var contactV : boolean);

//détermine si le joueur a perdu
function GameOver (var it:Item; var v:Vaisseau; tab:tabTaille; tRefMouvement:TSystemTime) : Boolean;

// gère les déplacements et les tirs du vaisseau
procedure gestionVaisseau(var ship : vaisseau; var it : item; tab : tabTaille; var dataShip : dataVaisseau);

// permet de sélectionner un vaisseau et un missile
procedure menuSkin(var ship : vaisseau ;var dataShip : dataVaisseau; tab : tabTaille; i : integer);

// affiche le score sur le menu
procedure afficheScoreMenu(i : integer);

// initialise les données nécessaires au déplacement des monstres en fonction des 4 niveaux de difficultés possibles 
procedure init_monstre(var it: item; ship : vaisseau ; var temps : tab_temps; choix : integer; var descente : integer; var mes_param_monstre : param_deplacement_monstre ; tab : tabTaille);

// gére le déplacement des monstres en fontion des 3 procédures de déplecement possible
procedure deplacement_monstre(var temps : tab_temps;var it : item; ship : vaisseau;var descente, choix : integer; tab : tabTaille;var mes_param_monstre : param_deplacement_monstre);

// gére les vagues de monstres en fontion des 3 procédures de déplecement possible
procedure vague(var it : item ;var ship : vaisseau ; tab : tabTaille ;var mes_param_monstre : param_deplacement_monstre;choix : integer ; var temps : tab_temps;var descente : integer);	

// permet de lancer une partie 
Procedure partie(it : item; ship : vaisseau; choix : integer; dataship : dataVaisseau; tab : tabTaille);

// gère le menu (affichage et sélection des fonctionnalités)
procedure menu () ;
	


implementation




// calcul le score quand une bombe est détruite
procedure CalculScoreBombe (var v:Vaisseau);

begin
v.score:=v.score+50;
AfficheScore (v)
end; 




// calcul le score quand un monstre est tué 
procedure CalculScoreMonstre (monstre: Integer; it:Item;var v:Vaisseau ); 

begin
if it.tabItem[monstre].nbvie=0 then
	v.score := v.score + 200
else v.score := v.score + 100;
AfficheScore (v);
end;	



procedure ContactMissileBombe (var it:Item; var tab:tabTaille;var v:Vaisseau; var boom1, boom2, boom3, boom4, boom5 : dataExplo );


var bomb,missil : Integer;
var toucheryH: boolean;
var toucheryB:boolean;
var toucherxG: boolean;
var toucherxD:boolean ;
var toucher, contac, conta : boolean;

// bomb, missil noms des objets dont on vérifit le contact
// i,j itérateurs 
// toucherxG renvoie vrai si il y un contact en x à gauche 
// toucherxD renvoie vrai si il y un contact en x à droite 
// toucheryH renvoie vrai si il y un contact en y en haut 
// toucheryB renvoie vrai si il y un contact en y en bas

begin
	
// On considère toutes les bombes et tous les missiles 
toucher:= False;
for bomb in it.bombe do 
	begin
	
	for missil in it.missile do 
		begin
// On vérifi le contact		
		Verification ( it, tab, bomb, missil, contac, toucheryH, toucheryB, toucherxG,toucherxD);
		Verification ( it, tab, missil, bomb, conta, toucheryH, toucheryB, toucherxG,toucherxD);
		if contac= True or conta = True then 
			toucher := True;
// Si il y a contact on génère le paramètres nécessaires aux explosions 
		if toucher then
			begin
			
			
			if boom1.enCours and not boom2.enCours then
				begin
					boom2.enCours := True;
					
					boom2.x := it.tabItem[bomb].x + (tab[it.tabItem[bomb].param + rangBombes]['x'] - 200) div 2;
					boom2.y := it.tabItem[bomb].y + (tab[it.tabItem[bomb].param + rangBombes]['y'] - 150) div 2;
				
					
				end
			else if boom2.enCours and boom1.enCours and not boom3.enCours then
				begin
					boom3.enCours := True;
					
					boom3.x := it.tabItem[bomb].x + (tab[it.tabItem[bomb].param + rangBombes]['x'] - 200) div 2;
					boom3.y := it.tabItem[bomb].y + (tab[it.tabItem[bomb].param + rangBombes]['y'] - 150) div 2;
				
					
				end
			else if boom1.enCours and boom2.enCours and boom3.enCours and not boom4.enCours then
				begin
					boom4.enCours := True;
					
					boom4.x := it.tabItem[bomb].x + (tab[it.tabItem[bomb].param + rangBombes]['x'] - 200) div 2;
					boom4.y := it.tabItem[bomb].y + (tab[it.tabItem[bomb].param + rangBombes]['y'] - 150) div 2;
					
					
				end
			else if boom1.enCours and boom2.enCours and boom3.enCours and boom4.enCours and not boom5.enCours then
				begin
					boom5.enCours := True;
					
					boom5.x := it.tabItem[bomb].x + (tab[it.tabItem[bomb].param + rangBombes]['x'] - 200) div 2;
					boom5.y := it.tabItem[bomb].y + (tab[it.tabItem[bomb].param + rangBombes]['y'] - 150) div 2;
					
					
				end
			else
				begin
			
			
					boom1.enCours := True;

					boom1.x := it.tabItem[bomb].x + (tab[it.tabItem[bomb].param + rangBombes]['x'] - 200) div 2;
					boom1.y := it.tabItem[bomb].y + (tab[it.tabItem[bomb].param + rangBombes]['y'] - 150) div 2;
				
				
				
				end;
// On exclut les objets touchés des ensembles et on rajoute les cases de tabItem ainsi libérées dans l'ensemble vide
// Ensuite, on cache les items détruits		
			it.bombe := it.bombe - [bomb];
			it.vide := it.vide + [bomb];
			it.missile := it.missile - [missil];
			it.vide := it.vide + [missil];
			cacheSdl(it,v,'bombe',bomb);
			cacheSdl(it,v,'missile',missil);
				
// On calcul le score 
			CalculScoreBombe (v);
			end;
		end;
	end;
end;


	
procedure ContactVaisseauBombe(var it:Item; var v:Vaisseau; var tab:tabTaille; var tRefMouvement:TSystemTime; var mortV:boolean; var contactV : boolean);

var bomb : Integer;
var toucheryH: boolean;
var toucheryB:boolean;
var toucherxG: boolean;
var toucherxD:boolean ;
tMesure : TSystemTime;

// bomb nom e l'item dont on vérifi le contact avec le vaisseau
// toucherxG renvoie vrai si il y un contact en x à gauche 
// toucherxD renvoie vrai si il y un contact en x à droite 
// toucheryH renvoie vrai si il y un contact en y en haut 
 // toucheryB renvoie vrai si il y un contact en y en bas

begin

DateTimeToSystemTime(Now,tMesure); //La c'est l'instruction qui enregistre le moment dans tMesure
	
//Si le temps entre 2 mouvements est atteint alors  
if (diffTemps(tMesure, tRefMouvement)) > 100 then
	begin
	mortV:= False;
	for bomb in it.bombe do 
		begin
		
// On défini l'intégralité des cases utilisées par la bombe et le vaisseau				 
		VerificationVaisseau ( v, it, tab, bomb, contactV,toucheryH, toucheryB, toucherxG, toucherxD) ;
		if contactV = True then 
// Si le contact est vrai le vaisseau perd une vie et on retire la bombre de l'ensemble des bombes
			begin
			v.pos.nbVie	:= v.pos.nbVie-1;
			it.bombe := it.bombe - [bomb];
			it.vide := it.vide + [bomb];
			cacheSdl(it,v,'bombe',bomb);
			if v.pos.nbVie <=0 then
				mortV:=True;
// Si le vaisseau n'a plus de vie mortV devient True 
						
			end;	
		end;		
	end;
	DateTimeToSystemTime(Now,tRefMouvement);
end;
	



procedure ContactMissileMonstre(var it:Item; var tab:tabTaille; var v:Vaisseau;var boom, boom2, boom3, boom4, boom5 : dataExplo);

var monstr,missil : Integer;
var toucheryH: boolean;
var toucheryB:boolean;
var toucherxG: boolean;
var toucherxD:boolean ;
var contact : boolean;

// monstr,missil items dont on vérifit le contact
// toucherxG renvoie vrai si il y un contact en x à gauche 
// toucherxD renvoie vrai si il y un contact en x à droite 
// toucheryH renvoie vrai si il y un contact en y en haut 
// toucheryB renvoie vrai si il y un contact en y en bas

begin
// On considère tous les missiles et toutes les bombes 

for monstr in it.monstre do 
	begin
	
	for missil in it.missile do 
		begin
// On vérifi si il y a contact 
		Verification ( it, tab, monstr, missil, contact, toucheryH, toucheryB, toucherxG,toucherxD);
		if contact = True then
			begin

// Quand il y a contact on génère les paramètres nécessaires à explosion si le monstre n'a plus de vie 

			it.tabItem[monstr].nbVie := it.tabItem[monstr].nbVie -1;
			CalculScoreMonstre(monstr,it,v);
				
			if it.tabItem[monstr].nbVie = 0 then
				begin
					
					
				if boom.enCours and not boom2.enCours then
					begin
						boom2.enCours := true;
						
						boom2.x := it.tabItem[monstr].x + (tab[it.tabItem[monstr].param + rangMonstres]['x'] - 200) div 2;
						boom2.y := it.tabItem[monstr].y + (tab[it.tabItem[monstr].param + rangMonstres]['y'] - 150) div 2;


					end
				else if boom.enCours and boom2.enCours and not boom3.enCours then
					begin
						boom3.enCours := true;
						
						boom3.x := it.tabItem[monstr].x + (tab[it.tabItem[monstr].param + rangMonstres]['x'] - 200) div 2;
						boom3.y := it.tabItem[monstr].y + (tab[it.tabItem[monstr].param + rangMonstres]['y'] - 150) div 2;


					end
				else if boom.enCours and boom2.enCours and boom3.enCours and not boom4.enCours then
					begin
						boom4.enCours := true;
						
						boom4.x := it.tabItem[monstr].x + (tab[it.tabItem[monstr].param + rangMonstres]['x'] - 200) div 2;
						boom4.y := it.tabItem[monstr].y + (tab[it.tabItem[monstr].param + rangMonstres]['y'] - 150) div 2;


					end
				else if boom.enCours and boom2.enCours and boom3.enCours and boom4.enCours and not boom5.enCours then
					begin
						boom5.enCours := true;
						
						boom5.x := it.tabItem[monstr].x + (tab[it.tabItem[monstr].param + rangMonstres]['x'] - 200) div 2;
						boom5.y := it.tabItem[monstr].y + (tab[it.tabItem[monstr].param + rangMonstres]['y'] - 150) div 2;


					end
				else	
					begin
				

						boom.enCours:=True;

						boom.x := it.tabItem[monstr].x + (tab[it.tabItem[monstr].param + rangMonstres]['x'] - 200) div 2;
						boom.y := it.tabItem[monstr].y + (tab[it.tabItem[monstr].param + rangMonstres]['y'] - 150) div 2;


					end;	



//Si le monstre n'a plus de vie on le retire de l'ensemble et on le cache
				it.monstre := it.monstre - [monstr];
				it.vide := it.vide + [monstr];
				cacheSdl(it,v,'monstre',monstr);
				end;

// 	On retire également le missile et on le cache 
			it.missile := it.missile - [missil];
			it.vide := it.vide + [missil];
			cacheSdl(it,v,'missile',missil);
					
			end;
		end;
	end;		
end;		




procedure Contact (var it:Item; var v:Vaisseau; tab: tabTaille; var explo : tabExplo; var tRefMouvement:TSystemTime; var contactV : boolean);
var mortV:boolean;

begin;
	ContactVaisseauBombe(it, v, tab, tRefMouvement, mortV, contactV);
	ContactMissileMonstre(it, tab, v, explo[1], explo[2], explo[6], explo[7], explo[8] );
	ContactMissileBombe (it, tab,  v, explo[3], explo[4], explo[5], explo[10], explo[9] );
	
end;	




function GameOver (var it:Item; var v:Vaisseau; tab:tabTaille; tRefMouvement:TSystemTime) : Boolean;

var finJ:boolean; 
var mortV, contactV:boolean;

begin
ContactVaisseauMonstre(it,v, tab,finJ);
ContactVaisseauBombe(it,v,tab, tRefMouvement, mortV, contactV);
if ((finJ=True) or (mortV= True)) then 
	GameOver:=True 
else GameOver:=False;
end;




procedure gestionVaisseau(var ship : vaisseau; var it : item; tab : tabTaille; var dataShip : dataVaisseau);

const deltadeplacement = 20;

var event: TSDL_Event;
	key:TSDL_KeyboardEvent;
	tRef, tMesureR, tMesureL: TSystemTime;
	distance : integer;

begin

	SDL_PollEvent(@event);		//prise d'événements
	key := event.key;
	dataShip.tir := false;
	distance := round(((dimensionX - tab[ship.pos.param + rangVaisseaux]['x'])/100)*1.5);		//calcul de la distance parcourue à un déplacement en fonction de la largeur de l'écran
	
	case key.keysym.sym of
	
		SDLK_SPACE : // espace
			if not dataShip.tir then
				dataShip.tir := true
			else 
				dataShip.tir := false;
				
			
			
		SDLK_Right : //droite;	
			if not dataShip.right then
				begin
					DateTimeToSystemTime(Now,dataShip.tRight);
					dataShip.right := true
				end
			else 
				dataShip.right := false;



		SDLK_Left : //gauche
			if not dataShip.left then
				begin
					DateTimeToSystemTime(Now,dataShip.tLeft);
					dataShip.left := true
				end
			else
				dataShip.left := false;
			
	end;

	DateTimeToSystemTime(Now,tRef);																											//Tir quand le temps minimum est écoulé et 'espace' pressé
	if (diffTemps(tRef,dataShip.tTir) > 250) and  dataShip.tir then
		generationMissile(it, ship, tab, dataShip);
	
	
	DateTimeToSystemTime(Now,tMesureR);
	if (ship.pos.x <= (dimensionX - tab[ship.pos.param + rangVaisseaux]['x'] - distance div 2)) and dataShip.right and (diffTemps(tMesureR,dataShip.tRight) > deltadeplacement) then			//déplacement a droite quand le temps minimum est écoulé et '->' pressé
	begin
		deplacementSdl(it,ship,'vaisseau','d',trunc((distance/deltadeplacement)*diffTemps(tMesureR,dataShip.tRight)),0);
		DateTimeToSystemTime(Now,dataShip.tRight);
		sdl_flip(window);
	end;
	
	
	DateTimeToSystemTime(Now,tMesureL);																										//déplacement a gauche quand le temps minimum est écoulé et '<-' pressé
	if (ship.pos.x >= (0 + distance div 2)) and dataShip.left and (diffTemps(tMesureL,dataShip.tLeft) > deltadeplacement) then
	begin
		deplacementSdl(it,ship,'vaisseau','g',trunc((distance/deltadeplacement)*diffTemps(tMesureR,dataShip.tLeft)),0);
		DateTimeToSystemTime(Now,dataShip.tLeft);
		sdl_flip(window);
	end;
	
end;


	
	
procedure menuSkin(var ship : vaisseau ;var dataShip : dataVaisseau; tab : tabTaille; i : integer);

var event: TSDL_Event;
	key:TSDL_KeyboardEvent;
	etage, rangMain, delai : integer;
	selectionner, cacher, v, m : boolean;
	posMain,posLeft,posRight,posM, posV,p : tsdl_rect;
	tInterne, tExterne, tAction : TSystemTime;
	fenetre : PSDL_SURFACE;


begin
	//initialisation des variables du menu
	p.x := 0;
	p.y := 0;
	fenetre := sdl_setvideomode(0,0,32,sdl_fullscreen);
	sdl_blitsurface(cache[rangdivers + 45],nil,fenetre,@p);
	sdl_flip(fenetre);
	DateTimeToSystemTime(Now,tInterne);
	DateTimeToSystemTime(Now,tAction);
	
	rangMain := 16000;
	
	dataShip.numero := 0;
	dataShip.munition := 0;
	
	etage := 0;
	cacher := false;
	selectionner := false;
	delai := 0;
	m := false;
	v := false;
	
	repeat 
		SDL_PollEvent(@event);	//prise d'événements
		selectionner := false;
		key := event.key;
	
		DateTimeToSystemTime(Now,tExterne);
		
		if (event.type_ = SDL_Keydown) and (diffTemps(tExterne, tAction) > 150 + delai) then	//Si le délai entre 2 actions est rempli et qu'une touche est enfoncée
			case key.keysym.sym of	//modification des paramètres en fonction de la touche appuyée
			
			SDLK_UP : 
				begin
					
					etage := (etage + 1) mod 2;
					sdl_blitsurface(cache[rangdivers + 45],nil,fenetre,@p);
					DateTimeToSystemTime(Now,tAction);
					cacher := false;
					DateTimeToSystemTime(Now,tInterne);
					delai := 150;
				end;
				
			SDLK_DOWN : 
				begin

					etage := (etage + 1) mod 2;
					sdl_blitsurface(cache[rangdivers + 45],nil,fenetre,@p);
					DateTimeToSystemTime(Now,tAction);
					cacher := false;
					DateTimeToSystemTime(Now,tInterne);
					delai := 150;
				end;	
				
			SDLK_RIGHT :
				begin

					rangMain := rangMain + 1;
					sdl_blitsurface(cache[rangdivers + 45],nil,fenetre,@p);
					DateTimeToSystemTime(Now,tAction);
					cacher := false;
					DateTimeToSystemTime(Now,tInterne);
					delai := 0;
				end;
			
			SDLK_LEFT :
				begin	

					rangMain := rangMain - 1;
					sdl_blitsurface(cache[rangdivers + 45],nil,fenetre,@p);
					DateTimeToSystemTime(Now,tAction);
					cacher := false;
					DateTimeToSystemTime(Now,tInterne);
					delai := 0;
				end;
				
			SDLK_SPACE :
				begin

					if etage = 0 then
						begin
							dataShip.numero := (rangMain mod (totalVaisseaux -3)) + 1;
							v := true;
						end;
					if etage = 1 then
						begin
							dataShip.munition := (rangMain mod (totalMissiles -3)) + 1;
							m := true;
						end;
						
					sdl_blitsurface(cache[rangdivers + 45],nil,fenetre,@p);
					DateTimeToSystemTime(Now,tAction);
					cacher := false;
					DateTimeToSystemTime(Now,tInterne);
					delai := 0;
				end;
			
			SDLK_E :
				selectionner := true;
			end;
			
			
		

		
		
		DateTimeToSystemTime(Now,tExterne);
		
		if diffTemps(tExterne,tInterne) > 300 then		//clignotemment de l'objet au 1er plan
		begin
		cacher :=  not cacher;
		DateTimeToSystemTime(Now,tInterne);
		end;
		
		
		//affichage du menu en fonction des paramètres actuels
		if etage = 0 then
		begin
			posMain.x := dimensionX div 2 - tab[(rangMain mod (totalVaisseaux -3)) + rangVaisseaux + 1]['x'] div 2;
			posMain.y := (dimensionY div 3)* 2 - tab[(rangMain mod (totalVaisseaux -3)) + rangVaisseaux + 1]['y'] div 2;
			
			posLeft.x := dimensionX div 4 - tab[((rangMain - 1) mod (totalVaisseaux -3)) + rangVaisseaux + 1]['x'] div 2;
			posLeft.y := dimensionY div 3 - tab[((rangMain - 1) mod (totalVaisseaux -3)) + rangVaisseaux + 1]['y'] div 2;
			
			posRight.x := (dimensionX div 4)*3 - tab[((rangMain + 1) mod (totalVaisseaux -3)) + rangVaisseaux + 1]['x'] div 2;
			posRight.y := dimensionY div 3 - tab[((rangMain + 1) mod (totalVaisseaux -3)) + rangVaisseaux + 1]['y'] div 2;
			
			
			if not cacher then
				sdl_blitSurface(image[(rangMain mod (totalVaisseaux -3)) + rangVaisseaux + 1],NIL,fenetre,@posMain)
			else
				sdl_blitSurface(cache[(rangMain mod (totalVaisseaux -3)) + rangVaisseaux + 1],NIL,fenetre,@posMain);
				
			sdl_blitSurface(image[((rangMain - 1) mod (totalVaisseaux -3) ) + rangVaisseaux + 1],NIL,fenetre,@posLeft);
			sdl_blitSurface(image[((rangMain + 1) mod (totalVaisseaux -3)) + rangVaisseaux + 1],NIL,fenetre,@posRight);
		end;
		
		if etage = 1 then
		begin	
			posMain.x := dimensionX div 2 - tab[(rangMain mod (totalMissiles -3)) + rangMissiles + 1]['x'] div 2;
			posMain.y := (dimensionY div 3)* 2 - tab[(rangMain mod (totalMissiles -3)) + rangMissiles + 1]['y'] div 2;
			
			posLeft.x := dimensionX div 4 - tab[((rangMain - 1) mod (totalMissiles -3)) + rangMissiles + 1]['x'] div 2;
			posLeft.y := dimensionY div 3 - tab[((rangMain - 1) mod (totalMissiles -3)) + rangMissiles + 1]['y'] div 2;
			
			posRight.x := (dimensionX div 4)*3 - tab[((rangMain + 1) mod (totalMissiles -3)) + rangMissiles + 1]['x'] div 2;
			posRight.y := dimensionY div 3 - tab[((rangMain + 1) mod (totalMissiles -3)) + rangMissiles + 1]['y'] div 2;
			
			
			if not cacher then
				sdl_blitSurface(image[(rangMain mod (totalMissiles -3)) + rangMissiles + 1],NIL,fenetre,@posMain)
			else
				sdl_blitSurface(cache[(rangMain mod (totalMissiles -3)) + rangMissiles + 1],NIL,fenetre,@posMain);
				
			sdl_blitSurface(image[((rangMain - 1) mod (totalMissiles -3)) + rangMissiles + 1],NIL,fenetre,@posLeft);
			sdl_blitSurface(image[((rangMain + 1) mod (totalMissiles -3)) + rangMissiles + 1],NIL,fenetre,@posRight);
		end;
		
		//affichage en bas à droite du vaisseau sélectionné
		if dataShip.numero <> 0 then
			begin
				
				posV.x := dimensionX - 220 - tab[(dataShip.numero) + rangVaisseaux]['y'] div 2;
				posV.y := dimensionY - tab[(dataShip.numero) + rangVaisseaux]['y'];
				sdl_blitSurface(image[dataShip.numero + rangVaisseaux],NIL,fenetre,@posV);
			end;
		
		//affichage en bas à droite du missile sélectionné
		if dataShip.munition <> 0 then
			begin
				posM.x := dimensionX - 30 - tab[(dataShip.munition) + rangMissiles]['y'] div 2;;
				posM.y := dimensionY - 20 - tab[(dataShip.munition) + rangMissiles]['y'];;
				sdl_blitSurface(image[dataShip.munition  + rangMissiles],NIL,fenetre,@posM);
			end;
		
		//Affichage des indications d'usage du menu
		if (dataShip.numero <> 0) and (dataShip.munition <> 0) then
			if i = 1 then
				ecrire('Pour entrer cette selection tapez ''e''',dimensionX div 2 - 450,(dimensionY div 3)* 2 + 120,50,6,8,12)
			else
				ecrire('Pour entrer cette selection tapez ''e''',dimensionX div 2 - 300,(dimensionY div 3)* 2 + 80,35,6,8,12);
		
		if i = 1 then
		begin
			ecrire('Utilisez les fleches ''Droite'', ''Gauche'', ''Haut'' et ''Bas''',dimensionX div 2 - 670,50,50,6,8,12);
			ecrire('Puis ''Espace'' pour selectionner',dimensionX div 2 - 470,150,50,6,8,12);
		end
		else
		begin
			ecrire('Utilisez les fleches ''Droite'', ''Gauche'', ''Haut'' et ''Bas''',dimensionX div 2 - 440,35,35,6,8,12);
			ecrire('Puis ''Espace'' pour selectionner',dimensionX div 2 - 315,100,35,6,8,12);
		end;
		
		sdl_flip(fenetre);	
	until selectionner and m and v;
	
	
	ship.pos.param := dataShip.numero;
	sdl_freesurface(fenetre);
end;




procedure afficheScoreMenu(i : integer);
var fichier : text;
	highscore, lastscore : longint;
	xhigh, xlast : integer;

begin
	if not fileExists('ressources/scores.txt') then
		enregistreScore(0);
	//lecture des scores dans le fichier
	assign(fichier,'ressources/scores.txt');
	reset(fichier);
	readln(fichier,highscore);
	readln(fichier,lastscore);
	
	//si les scores sont trop grands pour être affichés alors ont leur donne la valeur maximale affichable
	if highscore > 999999 then
		highscore := 999999;
		
	if lastscore > 999999 then
		lastscore := 999999;
	
	if i = 1 then		//cas grand écran
	begin
		//centrage du score sur l'écran (dessiné dans le menu)
		if lastscore < 10 then
			xlast := 270
		else if lastscore < 100 then
			xlast := 256
		else if lastscore < 1000 then
			xlast := 242
		else if lastscore < 10000 then
			xlast := 228
		else if lastscore < 100000 then
			xlast := 214
		else
			xlast := 200;
			
		//centrage du score sur l'écran (dessiné dans le menu)
		if highscore < 10 then
			xhigh := 270
		else if highscore < 100 then
			xhigh := 256
		else if highscore < 1000 then
			xhigh := 242
		else if highscore < 10000 then
			xhigh := 228
		else if highscore < 100000 then
			xhigh := 214
		else	
			xhigh := 200;
		
		//écriture du score
		ecrire(intToStr(highscore),xhigh,700,45,0,0,0);
		ecrire(intToStr(lastscore),xlast,800,45,0,0,0);
	end;
		
	if i = 2 then				//cas petit écran
	begin	
		//centrage du score sur l'écran (dessiné dans le menu)
		if lastscore < 10 then
			xlast := 180
		else if lastscore < 100 then
			xlast := 171
		else if lastscore < 1000 then
			xlast := 161
		else if lastscore < 10000 then
			xlast := 152
		else if lastscore < 100000 then
			xlast := 143
		else
			xlast := 133;
			
		//centrage du score sur l'écran (dessiné dans le menu)
		if highscore < 10 then
			xhigh := 180
		else if highscore < 100 then
			xhigh := 171
		else if highscore < 1000 then
			xhigh := 161
		else if highscore < 10000 then
			xhigh := 152
		else if highscore < 100000 then
			xhigh := 143
		else	
			xhigh := 133;
			
		//écriture du score
		ecrire(intToStr(highscore),xhigh,467,30,0,0,0);
		ecrire(intToStr(lastscore),xlast,535,30,0,0,0);
	end;
	//fermeture du fichier
	close(fichier);
end;


procedure init_monstre_1(var it : item;ship : vaisseau;var mes_param_monstre : param_deplacement_monstre;tab : tabTaille);
			function nb_monstre : position;								// renvoie le nb de monstre en x et en y possible suivant les constantes d'affichage
				begin
				nb_monstre.x := trunc(mes_param_monstre.gamma_x*(DimensionX/mes_param_monstre.Distance_x));
				nb_monstre.y := trunc(mes_param_monstre.gamma_y*(DimensionY/mes_param_monstre.Distance_y));
				end;
				
var x,a,dispo : integer;
	proba,seuil2,seuil3 : real;
begin
		//nouvelle vague de monstre 1
	mes_param_monstre.nb_vague := mes_param_monstre.nb_vague + 1 ;
	
		// les monstre se déplacent initialement tous vers la droite :
	it.direction := 1;
	
	randomize;
	
for x := 1 to nb_monstre.x do
	begin
			//on recupere une case vide
		dispo := case_dispo(it);
		
			//on utilise la fonction de répartition des monstre
		proba := random;
		seuil2 := 0.7 + 0.3*exp(-0.25*mes_param_monstre.nb_vague);
		seuil3 := 0.2 + 0.2*exp(-    mes_param_monstre.nb_vague) ;

		
		if (proba<seuil2) then
			begin
			it.tabItem[dispo].param := 5; 
			it.tabItem[dispo].nbVie := 1;
			end
		else if (proba<seuil3+seuil2) then
			begin
			a:=random(2);
			case a of
				0 : a := 3;
				1 : a := 9;
			end;
			it.tabItem[dispo].param := a; 
			it.tabItem[dispo].nbVie := 2;
			end
		else
			begin
			it.tabItem[dispo].param := 2; 
			it.tabItem[dispo].nbVie := 3;
			end;
			
			
		it.tabItem[dispo].x := mes_param_monstre.marge + (x-1)*mes_param_monstre.Distance_x + ((mes_param_monstre.Distance_x - tab[it.tabItem[dispo].param + rangMonstres,'x']) div 2);
		it.tabItem[dispo].y := mes_param_monstre.marge + ((mes_param_monstre.Distance_y - tab[it.tabItem[dispo].param + rangMonstres,'y']) div 2);
		
	
			//on l'affiche
		afficheSdl(it, ship, 'monstre', dispo);
		end
end;






procedure init_monstre_2(var it : item;ship : vaisseau;mes_param_monstre : param_deplacement_monstre ; tab : tabTaille);
			function nb_monstre : position;						
				begin
				nb_monstre.x := trunc(mes_param_monstre.gamma_x*(DimensionX/mes_param_monstre.Distance_x));
				nb_monstre.y := trunc(mes_param_monstre.gamma_y*(DimensionY/mes_param_monstre.Distance_y));
				end;
			
var x,dispo : integer;
begin

	randomize;
	for x := 1 to nb_monstre.x do
		begin
			dispo := case_dispo(it);
			
			it.tabItem[dispo].dir := 1;
			it.tabItem[dispo].descente := 0;
			
			it.tabItem[dispo].param := 5; 
			it.tabItem[dispo].nbVie := 1;
			
			
			it.tabItem[dispo].x := mes_param_monstre.marge + (x-1)*mes_param_monstre.Distance_x + ((mes_param_monstre.Distance_x - tab[it.tabItem[dispo].param + rangMonstres,'x']) div 2);
			it.tabItem[dispo].y := mes_param_monstre.marge + ((mes_param_monstre.Distance_y - tab[it.tabItem[dispo].param + rangMonstres,'y']) div 2);
			
			afficheSdl(it,ship,'monstre',dispo);
		end
end;



procedure init_monstre_4(var it : item;ship : vaisseau;var mes_param_monstre : param_deplacement_monstre;tab : tabTaille);

var i,dispo: integer;

begin
		

		//creation des particules constituant les bord
for i := 1 to 64 do
		//murs horizontaux
	begin
	mes_param_monstre.dudu[i].x := (mes_param_monstre.marge div 2) + (i-1)*((DimensionX - mes_param_monstre.marge) div 63);
	mes_param_monstre.dudu[i].y := (mes_param_monstre.marge );
	mes_param_monstre.dudu[i].charge := 1;
	
	mes_param_monstre.dudu[i+64].x := (mes_param_monstre.marge div 2) + (i-1)*((DimensionX - mes_param_monstre.marge) div 63);
	mes_param_monstre.dudu[i+64].y := (mes_param_monstre.marge ) + (DimensionX div 3);
	mes_param_monstre.dudu[i+64].charge := 1;

	end;
	
for i := 1 to 32 do
	begin
		//murs verticaux
	mes_param_monstre.dudu[i+128].x := (mes_param_monstre.marge div 2);
	mes_param_monstre.dudu[i+128].y := (mes_param_monstre.marge ) + i*((DimensionX div 3)div 37);
	mes_param_monstre.dudu[i+128].charge := 1;
							 
	mes_param_monstre.dudu[i+160].x := dimensionX - (mes_param_monstre.marge div 2);
	mes_param_monstre.dudu[i+160].y := (mes_param_monstre.marge) + i*((DimensionX div 3)div 37);
	mes_param_monstre.dudu[i+160].charge := 1;

	end;
	
		//ajout de 4 particules dans les 4 coins de l'écran 
	mes_param_monstre.dudu[193].x := (mes_param_monstre.marge div 2);
	mes_param_monstre.dudu[193].y := (mes_param_monstre.marge );
	mes_param_monstre.dudu[193].charge := 15;
	
	mes_param_monstre.dudu[194].x := (mes_param_monstre.marge div 2) + (DimensionX - mes_param_monstre.marge) ;
	mes_param_monstre.dudu[194].y := (mes_param_monstre.marge );
	mes_param_monstre.dudu[194].charge := 15;
						   
	mes_param_monstre.dudu[195].x := (mes_param_monstre.marge div 2);
	mes_param_monstre.dudu[195].y := (mes_param_monstre.marge ) + (DimensionX div 3);
	mes_param_monstre.dudu[195].charge := 15;
						             
	mes_param_monstre.dudu[196].x := (mes_param_monstre.marge div 2) + (DimensionX - mes_param_monstre.marge) ;
	mes_param_monstre.dudu[196].y := (mes_param_monstre.marge ) + (DimensionX div 3);
	mes_param_monstre.dudu[196].charge := 15;

	

	
			//creation du monstre initial
			
				//nombre de monstres
		mes_param_monstre.nbdudu := 1;
		
		dispo := case_dispo(it);
			//position
		mes_param_monstre.mdudu[1].x := 400;
		mes_param_monstre.mdudu[1].y := 400;
		
			//vitesse
		mes_param_monstre.mdudu[1].vx := 0;
		mes_param_monstre.mdudu[1].vy := 0;
		
			//charge
		mes_param_monstre.mdudu[1].charge :=4;
		
			//it
		it.tabItem[dispo].param := 1; 
		it.tabItem[dispo].nbVie := 1;
		
			//position qui lui est associé dans tab_item
		mes_param_monstre.mdudu[1].num_tab := dispo;
		
		it.tabItem[dispo].x := trunc(mes_param_monstre.mdudu[1].x) - (tab[it.tabItem[i].param + rangMonstres,'x'] div 2);
		it.tabItem[dispo].y := trunc(mes_param_monstre.mdudu[1].y) - (tab[it.tabItem[i].param + rangMonstres,'y'] div 2);
		
			//on l'affiche
		afficheSDL(it,ship,'monstre',dispo);
		sdl_flip(window);

end;




procedure init_monstre(var it: item; ship : vaisseau ; var temps : tab_temps; choix : integer; var descente: integer; var mes_param_monstre : param_deplacement_monstre ; tab : tabTaille);


begin
		//initialisation des constantes
		
			//distances entre 2 monstres
	mes_param_monstre.Distance_x	:= 200;	
	mes_param_monstre.Distance_y	:= 200;
	
			// proportion de l'ecran occupée par des monstres
	mes_param_monstre.gamma_x		:= 0.9;
	mes_param_monstre.gamma_y		:= 0.2;
									
	mes_param_monstre.marge			:= 100;	//marge horizontale
	mes_param_monstre.marge_up		:= 100;	//marge en haut
									
	mes_param_monstre.deltaMonstre 	:= 100;	//temps entre chaque déplacement de monstre
	mes_param_monstre.vitesseMonstre:= 40;	//en pixel/sec
	mes_param_monstre.marge_descente:= 200;	//de combien les monstres descendent	
	
			//nombre de vague initialisé a 0
	mes_param_monstre.nb_vague := 0;
	
		
	descente := 0;
	
		//initialisation des ensembles
	it.vide := [0..100];
	it.monstre := [];
	it.bombe := [];
	it.missile := [];
	
		//initialisation des monstres en fonction du mode choisis
case choix of 
	1 : init_monstre_1(it,ship,mes_param_monstre,tab);
	2 : init_monstre_2(it,ship,mes_param_monstre,tab);
	3 : init_monstre_2(it,ship,mes_param_monstre,tab);
	4 : init_monstre_4(it,ship,mes_param_monstre,tab);
end;
end;

procedure deplacement_monstre_1(var temps : tab_temps;var it : item; tab : tabTaille; ship : vaisseau;var descente : integer;mes_param_monstre : param_deplacement_monstre);
var si_marge : boolean;
	i : integer;
	tMesure:TSystemTime;
	t : integer;
	
begin
	si_marge := false;
	DateTimeToSystemTime(Now,tMesure);

	if (mes_param_monstre.deltaMonstre - diffTemps(tMesure, temps.tRef)) < 0 then		//si l'intervale de temps d'affichage des monstres est dépassé alors
		begin
			//temps passé depuis le dernier déplacement
			// en général egale à mes_param_monstre.deltaMonstre
			//mais l'utilisation de t à la place permet d'afficher les monstres plus loin si jamais l'exécution est trop lente (partage d'écran notemment)
		t := diffTemps(tMesure, temps.tRef);
		temps.tRef := tMesure;
		
				//si les monstres ne déscendent pas ou ont finit de descendre :
		if (descente=0) or(descente > (mes_param_monstre.marge_descente div 2)) then
		
				begin
				descente := 0;			//remise a 0 si on a finit de descendre 
				
										//on cherche si un monstre dépasse dans la marge
				for i in it.monstre do
					if (it.direction= 1)and(it.tabItem[i].x  + mes_param_monstre.Distance_x -  ((mes_param_monstre.Distance_x -Tab[it.tabItem[i].param]['x']) div 2) >DimensionX - mes_param_monstre.marge) 
					or (it.direction=-1)and(it.tabItem[i].x  -  ((mes_param_monstre.Distance_x - Tab[it.tabItem[i].param]['x']) div 2)  <  mes_param_monstre.marge) then si_marge := true;
						
					
										//si un monstre est dans la marge on de déplace vers le bas et on change de direction
				if si_marge then 
					begin
					it.direction := -it.direction;
					
						//on definit la distance déja descendu
					descente := descente + trunc(mes_param_monstre.vitesseMonstre*t/1000);
					
						//on raffiche chaque monstre à sa nouvelle position
					for i in it.monstre do 
						begin
						cacheSdl(it, ship, 'monstre', i);
						it.tabItem[i].y := it.tabItem[i].y + it.direction*trunc(mes_param_monstre.vitesseMonstre*t/1000);
						afficheSdl(it, ship, 'monstre', i);
						end;
				end
				
										//sinon on se deplace dans la direction de déplacement :
				else for i in it.monstre do 
					begin
					cacheSdl(it,ship,'monstre',i);
					it.tabItem[i].x := it.tabItem[i].x + it.direction*trunc(mes_param_monstre.vitesseMonstre*t/1000);
					afficheSdl(it,ship,'monstre',i);
					end;
				end
				
		else 			//si les monstre son entrain de descendre ils continues de descendre
				begin
				descente := descente + trunc(mes_param_monstre.vitesseMonstre*t/1000);
				for i in it.monstre do 
					begin
					cacheSdl(it,ship,'monstre',i);
					it.tabItem[i].y := it.tabItem[i].y + trunc(mes_param_monstre.vitesseMonstre*t/1000);
					afficheSdl(it,ship,'monstre',i);
					end;
				end
			
	end

end;


		//procédure globalement similaire à la précédente deplacement_monstre_
		// si ce n'est que cette fois les monstres sont trétais indépendament les uns des autres plutot que par bloc
procedure deplacement_monstre_2(var temps : tab_temps;var it : item;Taille_image : tabTaille; ship : vaisseau;var descente : integer;mes_param_monstre : param_deplacement_monstre);
var si_marge : boolean;
	i : integer;
	tMesure:TSystemTime;
	t : real;
begin

DateTimeToSystemTime(Now,tMesure);

if (mes_param_monstre.deltaMonstre - diffTemps(tMesure, temps.tRef)) < 0 then
	begin
	t := diffTemps(tMesure, temps.tRef);
	temps.tRef := tMesure;
	
	for i in it.monstre do
		begin
		si_marge := false;
		
		if (it.tabItem[i].descente=0)or(it.tabItem[i].descente>mes_param_monstre.marge_descente) then
		
				begin
				it.tabItem[i].descente := 0;			//remise a 0 si on a dépassé 
				
										//on cherche si un monstre dépasse dans la marge
				
					if (it.tabItem[i].dir= 1)and(it.tabItem[i].x  + mes_param_monstre.Distance_x -  ((mes_param_monstre.Distance_x -Taille_image[it.tabItem[i].param]['x']) div 2) >DimensionX - mes_param_monstre.marge) 
					or (it.tabItem[i].dir=-1)and(it.tabItem[i].x  -  ((mes_param_monstre.Distance_x - Taille_image[it.tabItem[i].param]['x']) div 2)  <  mes_param_monstre.marge)then si_marge := true;
					
					
										//si un monstre est dans la marge on de déplace vers le bas et on change de direction
				if si_marge then 
					begin
					it.tabItem[i].dir := -it.tabItem[i].dir;
					it.tabItem[i].descente := it.tabItem[i].descente + trunc(mes_param_monstre.vitesseMonstre*t/1000);
					
					cacheSdl(it,ship,'monstre',i);
					it.tabItem[i].y := it.tabItem[i].y + it.tabItem[i].dir*trunc(mes_param_monstre.vitesseMonstre*t/1000);
					afficheSdl(it,ship,'monstre',i);
					
				end
				
										//sinon on se deplace daans la direction
				else 
					begin
					cacheSdl(it,ship,'monstre',i);
					it.tabItem[i].x := it.tabItem[i].x + it.tabItem[i].dir*trunc(mes_param_monstre.vitesseMonstre*t/1000);
					afficheSdl(it,ship,'monstre',i);
					end;
				end
				
		else 
				begin
				it.tabItem[i].descente := it.tabItem[i].descente + trunc(mes_param_monstre.vitesseMonstre*t/1000);
				
				cacheSdl(it,ship,'monstre',i);
				it.tabItem[i].y := it.tabItem[i].y + trunc(mes_param_monstre.vitesseMonstre*t/1000);
				afficheSdl(it,ship,'monstre',i);
				
				end
				
				
		end;		//for i in it.monstre
	end;		//if delta t
end;



		//procédure de déplacement la plus complexe, détaillée dans le compte rendu
procedure deplacement_monstre_4(var temps : tab_temps;var it : item;tab : tabTaille; ship : vaisseau;var descente : integer;var mes_param_monstre : param_deplacement_monstre);

function somme_forces_x(mes_param_monstre : param_deplacement_monstre ; n : integer) : real;
var i : integer;
	d : real;
begin
somme_forces_x := 0;
for i := 1 to 196 do
	begin
			//distance monstre / particule du bord
	d := 50 + sqrt(sqr(mes_param_monstre.dudu[i].x - mes_param_monstre.mdudu[n].x)+sqr(mes_param_monstre.dudu[i].y - mes_param_monstre.mdudu[n].y));
	
			//calcul de la force selon l'axe x
	somme_forces_x := somme_forces_x + 2*mes_param_monstre.dudu[i].charge * mes_param_monstre.mdudu[n].charge *  (mes_param_monstre.mdudu[n].x - mes_param_monstre.dudu[i].x)/(d*d*d);
	
	end;
	
for i := 1 to mes_param_monstre.nbdudu do
	if (i <> n)and(mes_param_monstre.mdudu[i].num_tab in it.monstre) then
		begin
				//distance monstre / autre monstre
		d := 50 + sqrt(sqr(mes_param_monstre.mdudu[i].x - mes_param_monstre.mdudu[n].x)+sqr(mes_param_monstre.mdudu[i].y - mes_param_monstre.mdudu[n].y));
		
		somme_forces_x := somme_forces_x + 2*mes_param_monstre.mdudu[i].charge * mes_param_monstre.mdudu[n].charge *  (mes_param_monstre.mdudu[n].x - mes_param_monstre.mdudu[i].x)/(d*d*d);
		
		end;
end;

		//idem mais pour l'axe y
function somme_forces_y(mes_param_monstre : param_deplacement_monstre ; n : integer) : real;
var i : integer;
	d : real;
begin
somme_forces_y := 0;
for i := 1 to 196 do
	begin
	
	d := 50 + sqrt(sqr(mes_param_monstre.dudu[i].x - mes_param_monstre.mdudu[n].x)+sqr(mes_param_monstre.dudu[i].y - mes_param_monstre.mdudu[n].y));
	
	somme_forces_y := somme_forces_y + 2*mes_param_monstre.dudu[i].charge * mes_param_monstre.mdudu[n].charge *  (mes_param_monstre.mdudu[n].y - mes_param_monstre.dudu[i].y)/(d*d*d);
	
	end;

for i := 1 to mes_param_monstre.nbdudu do
	if (i <> n)and(mes_param_monstre.mdudu[i].num_tab in it.monstre) then
		begin
		d := 50 + sqrt(sqr(mes_param_monstre.mdudu[i].x - mes_param_monstre.mdudu[n].x)+sqr(mes_param_monstre.mdudu[i].y - mes_param_monstre.mdudu[n].y));
		
		somme_forces_y := somme_forces_y + 2*mes_param_monstre.mdudu[i].charge * mes_param_monstre.mdudu[n].charge *  (mes_param_monstre.mdudu[n].y - mes_param_monstre.mdudu[i].y)/(d*d*d);
		
		end;
end;


var 
	tRef:TSystemTime;
	dt : real;

	i,n : integer;
	frottement : real;
	
begin

DateTimeToSystemTime(Now,tRef);

		// si l'ensemble monstre est non vide ET que le temps passé depuis l'affichage de la nouvelle vague est > à  500 ms
if 	(it.monstre<>[])and(diffTemps(TRef,temps.vitesse) > 500) then

	begin

		dt := diffTemps(tRef,temps.tRef);

		DateTimeToSystemTime(Now,temps.tRef);
		DateTimeToSystemTime(Now,temps.attente);
		
		frottement := 0.0001;
			
		//pour tout les monstres 
for i := 1 to mes_param_monstre.nbdudu do
		
		//si ils sont encore en vie
if mes_param_monstre.mdudu[i].num_tab in it.monstre then
	begin
				//effet de rebond sur le mur où la vitesse est inversée
		if  (mes_param_monstre.mdudu[i].x< (mes_param_monstre.marge div 2) + 50)and(mes_param_monstre.mdudu[i].vx<0) or
			 (mes_param_monstre.mdudu[i].x> dimensionX - (mes_param_monstre.marge div 2) - 50)and(mes_param_monstre.mdudu[i].vx>0)  then	mes_param_monstre.mdudu[i].vx :=-mes_param_monstre.mdudu[i].vx;
		if (mes_param_monstre.mdudu[i].y<(mes_param_monstre.marge +50))and(mes_param_monstre.mdudu[i].vy<0) or
			(mes_param_monstre.mdudu[i].y> (mes_param_monstre.marge ) + (DimensionX div 3) - 50)and(mes_param_monstre.mdudu[i].vy>0) then mes_param_monstre.mdudu[i].vy := -mes_param_monstre.mdudu[i].vy;
				
				//partie equation différentielle
			//position
		mes_param_monstre.mdudu[i].x := mes_param_monstre.mdudu[i].x + dt * mes_param_monstre.mdudu[i].vx;
		mes_param_monstre.mdudu[i].y := mes_param_monstre.mdudu[i].y + dt * mes_param_monstre.mdudu[i].vy;
			//vitesse           
		mes_param_monstre.mdudu[i].vx := mes_param_monstre.mdudu[i].vx + dt * (somme_forces_x(mes_param_monstre,i)  - frottement*sqr(mes_param_monstre.mdudu[i].vx)*(mes_param_monstre.mdudu[i].vx)*sqr(mes_param_monstre.mdudu[i].vx));
		mes_param_monstre.mdudu[i].vy := mes_param_monstre.mdudu[i].vy + dt * (somme_forces_y(mes_param_monstre,i)  - frottement*sqr(mes_param_monstre.mdudu[i].vy)*(mes_param_monstre.mdudu[i].vy)*sqr(mes_param_monstre.mdudu[i].vy));
				//(les derniers termes sont les forces de frottement)

	end;

	//réactualisation de l'affichage des monstres
if ((mes_param_monstre.deltaMonstre div 10) - diffTemps(tRef, temps.vague)) < 0 then
	begin
		
		DateTimeToSystemTime(Now,temps.vague);
		
		for i := 1 to mes_param_monstre.nbdudu do
		
			if mes_param_monstre.mdudu[i].num_tab  in  it.monstre then
				
				begin
				n := mes_param_monstre.mdudu[i].num_tab;
				cacheSdl(it,ship,'monstre',n);
			
				it.tabItem[n].x := trunc(mes_param_monstre.mdudu[i].x) - (tab[it.tabItem[n].param + rangMonstres,'x'] div 2);
				it.tabItem[n].y := trunc(mes_param_monstre.mdudu[i].y) - (tab[it.tabItem[n].param + rangMonstres,'y'] div 2);
				
				afficheSdl(it,ship,'monstre',n);

				end;

	end
end
end;



procedure deplacement_monstre(var temps : tab_temps;var it : item; ship : vaisseau;var descente, choix : integer; tab : tabTaille;var mes_param_monstre : param_deplacement_monstre);
begin
	case choix of 
		1 : deplacement_monstre_1( temps ,it,tab,ship,descente,mes_param_monstre);
		2 : deplacement_monstre_2( temps ,it,tab,ship,descente,mes_param_monstre);
		3 : deplacement_monstre_2( temps ,it,tab,ship,descente,mes_param_monstre);
		4 : deplacement_monstre_4( temps ,it,tab,ship,descente,mes_param_monstre);
	end;
end;

procedure vague_1(var it : item ; ship : vaisseau ; tab : tabTaille ;var mes_param_monstre : param_deplacement_monstre; var temps : tab_temps;var descente : integer);

var tRef : TSystemTime;

Begin
	DateTimeToSystemTime(Now,tRef);

		//cas ou il n'y a plus de monstres :
	if (it.monstre = []) then
		if (diffTemps(TRef,temps.Attente) > 5000) then
			DateTimeToSystemTime(Now,temps.Attente)
		else if (diffTemps(TRef,temps.Attente) > 1200) then
			init_monstre_1(it,ship,mes_param_monstre,tab);
			
		//acceleration des monstres

	if diffTemps(TRef,temps.Vague) > 2000 then 
		begin
		if mes_param_monstre.vitesseMonstre < 100 then
			mes_param_monstre.vitesseMonstre:= 2 + mes_param_monstre.vitesseMonstre;	//en pixel/sec
		DateTimeToSystemTime(Now,temps.Vague)
		end;


			
		//cas ou on fait apparaitre une nouvelle vague
	if  
	(descente + trunc(mes_param_monstre.vitesseMonstre*mes_param_monstre.deltaMonstre/1000) > (mes_param_monstre.marge_descente div 2)) 
	and(it.direction= 1)then 
		begin
		init_monstre_1(it,ship,mes_param_monstre,tab);
		descente:=0
		end

end;



procedure vague_2(var it : item ; ship : vaisseau ; tab : tabTaille ;var mes_param_monstre : param_deplacement_monstre; var temps : tab_temps);
var i,a,dispo : integer;
	verif : boolean;
	tRef : TSystemTime;
	proba,seuil2,seuil3,seuil4,seuil5 : real;
Begin

	DateTimeToSystemTime(Now,tRef);

		//accélération des monstres toutes les 2 sec
	if diffTemps(TRef,temps.Vague) > 2000 then 
		begin
		if mes_param_monstre.vitesseMonstre < 150 then
			mes_param_monstre.vitesseMonstre:= 4 + mes_param_monstre.vitesseMonstre;	//en pixel/sec
		DateTimeToSystemTime(Now,temps.Vague)
		end;
	
	verif := false;
	for i in it.monstre do 
		if not verif then
			if (it.tabItem[i].x < mes_param_monstre.marge + mes_param_monstre.Distance_x + ((mes_param_monstre.Distance_x - tab[it.tabItem[i].param + rangMonstres, 'x']) div 2))
			and(it.tabItem[i].y < mes_param_monstre.marge + mes_param_monstre.Distance_y ) then
				verif := true;
	
		//si il n'y a pas de monstre à coté			
	if not verif then 
	begin
	
		if (it.monstre = [])and (diffTemps(TRef,temps.Attente) > 2000) then
			DateTimeToSystemTime(Now,temps.Attente)
			
			
		else if (diffTemps(TRef,temps.Attente) > 1000) and (diffTemps(TRef,temps.apparition) > 1000*mes_param_monstre.Distance_x/mes_param_monstre.vitesseMonstre) then
		
		begin
		
		DateTimeToSystemTime(Now,temps.apparition);
		mes_param_monstre.nb_vague := mes_param_monstre.nb_vague + 1 ;
		dispo := case_dispo(it);
		
		it.tabItem[dispo].dir := 1;
		it.tabItem[dispo].descente := 0;
		
		
				//fonction de répartition aléatoire
		randomize;
		proba := random;
		
		seuil2 := 0.6 + 0.3*exp(-0.1*mes_param_monstre.nb_vague);
		seuil3 := 0.2 + 0.2*exp(-    mes_param_monstre.nb_vague) ;
		seuil4 := 0.1 + 0.1*exp(-    mes_param_monstre.nb_vague) ;
		seuil5 := 0.05+0.05*exp(-    mes_param_monstre.nb_vague) ;


		
		if (proba<seuil2) then
			begin
			it.tabItem[dispo].param := 5; 
			it.tabItem[dispo].nbVie := 1;
			end
		else if (proba<seuil2+seuil3) then
			begin
			a:=random(2);
			case a of
				0 : a := 3;
				1 : a := 6;
			end;
			it.tabItem[dispo].param := a; 
			it.tabItem[dispo].nbVie := 2;
			end
		else if (proba<seuil2+seuil3+seuil4) then
			begin
			a:=random(2);
			case a of
				0 : a := 2;
				1 : a := 4;
			end;
			it.tabItem[dispo].param := a; 
			it.tabItem[dispo].nbVie := 3;
			end
		else if (proba<seuil2+seuil3+seuil4+seuil5) then
			begin
			it.tabItem[dispo].param := 12; 
			it.tabItem[dispo].nbVie := 4;
			end
		else
			begin
			it.tabItem[dispo].param := 11; 
			it.tabItem[dispo].nbVie := 5;
			end;
				
			

		
		it.tabItem[dispo].x := mes_param_monstre.marge + ((mes_param_monstre.Distance_x - tab[it.tabItem[dispo].param + rangMonstres,'x']) div 2);
		it.tabItem[dispo].y := mes_param_monstre.marge + ((mes_param_monstre.Distance_y - tab[it.tabItem[dispo].param + rangMonstres,'y']) div 2);
		
		afficheSdl(it,ship,'monstre',dispo)
		end;
		end;
end;




procedure vague_3(var it : item ; ship : vaisseau ; tab : tabTaille ;var mes_param_monstre : param_deplacement_monstre; var temps : tab_temps);
var i,a,dispo : integer;
	verif : boolean;
	tRef : TSystemTime;
	proba,seuil2,seuil3,seuil4,seuil5,seuil6 : real;
Begin

	DateTimeToSystemTime(Now,tRef);


	if diffTemps(TRef,temps.Vague) > 2000 then 
		begin
		if mes_param_monstre.vitesseMonstre < 100 then
			mes_param_monstre.vitesseMonstre:= 4 + mes_param_monstre.vitesseMonstre;	//en pixel/sec
		DateTimeToSystemTime(Now,temps.Vague);
		end;
	
	
	verif := false;
	for i in it.monstre do 
		if not verif then
			if (it.tabItem[i].x < mes_param_monstre.marge + mes_param_monstre.Distance_x + ((mes_param_monstre.Distance_x - tab[it.tabItem[i].param + rangMonstres, 'x']) div 2))
			and(it.tabItem[i].y < mes_param_monstre.marge + mes_param_monstre.Distance_y ) then
				verif := true;
				
	if not verif then 
	begin
	
	
		if (it.monstre = [])and (diffTemps(TRef,temps.Attente) > 2000) then
			DateTimeToSystemTime(Now,temps.Attente)
			
			
		else if (diffTemps(TRef,temps.Attente) > 1000) and (diffTemps(TRef,temps.apparition) > 1000*mes_param_monstre.Distance_x/mes_param_monstre.vitesseMonstre) then
		
		begin
		
		DateTimeToSystemTime(Now,temps.apparition);
		
		mes_param_monstre.nb_vague := mes_param_monstre.nb_vague + 1 ;
		dispo := case_dispo(it);
		it.tabItem[dispo].dir := 1;
		it.tabItem[dispo].descente := 0;		

		randomize;
		proba := random;
		
		seuil2 := 0.25 + 0.1*exp(-0.05*mes_param_monstre.nb_vague);
		seuil3 := 0.25 *(1 + exp(-    mes_param_monstre.nb_vague)) ;
		seuil4 := 0.15*(1 + exp(-    mes_param_monstre.nb_vague)) ;
		seuil5 := 0.15*(1 + exp(-    mes_param_monstre.nb_vague)) ;
		seuil6 := 0.10*(1 + exp(-    mes_param_monstre.nb_vague)) ;

		
		if (proba<seuil2) then
			begin
			it.tabItem[dispo].param := 5; 
			it.tabItem[dispo].nbVie := 1;
			end
		else if (proba<seuil2+seuil3) then
			begin
			a:=random(2);
			case a of
				0 : a := 3;
				1 : a := 6;
			end;
			it.tabItem[dispo].param := a; 
			it.tabItem[dispo].nbVie := 2;
			end
		else if (proba<seuil2+seuil3+seuil4) then
			begin
			a:=random(2);
			case a of
				0 : a := 2;
				1 : a := 7;
			end;
			it.tabItem[dispo].param := a; 
			it.tabItem[dispo].nbVie := 3;
			end
		else if (proba<seuil2+seuil3+seuil4+seuil5) then
			begin
			it.tabItem[dispo].param := 8; 
			it.tabItem[dispo].nbVie := 4;
			end
		else if (proba<seuil2+seuil3+seuil4+seuil5+seuil6) then
			begin
			it.tabItem[dispo].param := 11; 
			it.tabItem[dispo].nbVie := 5;
			end
		else
			begin
			it.tabItem[dispo].param := 10; 
			it.tabItem[dispo].nbVie := 10;
			end;

		
		it.tabItem[dispo].x := mes_param_monstre.marge + ((mes_param_monstre.Distance_x - tab[it.tabItem[dispo].param + rangMonstres,'x']) div 2);
		it.tabItem[dispo].y := mes_param_monstre.marge + ((mes_param_monstre.Distance_y - tab[it.tabItem[dispo].param + rangMonstres,'y']) div 2);
		

		afficheSdl(it,ship,'monstre',dispo)
		end;
	end;
end;






procedure vague_4(var it : item ;var ship : vaisseau ; tab : tabTaille ;var mes_param_monstre : param_deplacement_monstre; var temps : tab_temps);
var dispo,i,j : integer;
	tRef : TSystemTime;
	d : real;
	test : boolean;
Begin

DateTimeToSystemTime(Now,tRef);
randomize;
	
	//si il n'y a plus aucun monstre
if ( it.monstre = [] ) and (diffTemps(TRef,temps.attente) > 1000)then
	begin
		DateTimeToSystemTime(Now,temps.vague);
		DateTimeToSystemTime(Now,temps.tRef);
		DateTimeToSystemTime(Now,temps.vitesse);
		mes_param_monstre.nb_vague := mes_param_monstre.nb_vague +1;
		mes_param_monstre.nbdudu := ((mes_param_monstre.nb_vague)div 3)+1;
		
		//on gagne une vie
	if (ship.pos.nbVie < 3) then
		ship.pos.nbVie := ship.pos.nbVie + 1;
		

		//création de chaque nouveau monstre
	for i := 1 to mes_param_monstre.nbdudu do
		begin
		
		dispo := case_dispo(it);
		
		
	
			//position
		if i = 1 then
			begin	
			mes_param_monstre.mdudu[i].x := mes_param_monstre.marge + 100 + random(dimensionX - 2 * (mes_param_monstre.marge+100));
			mes_param_monstre.mdudu[i].y := mes_param_monstre.marge + 100 + random((DimensionX div 3) - 200);

			end
		else
			repeat
			test := true;
			mes_param_monstre.mdudu[i].x := mes_param_monstre.marge + 100 + random(dimensionX - 2 * (mes_param_monstre.marge+100));
			mes_param_monstre.mdudu[i].y := mes_param_monstre.marge + 100 + random((DimensionX div 3) - 200);

			for j := 1 to i - 1 do
				begin
				d := sqrt(sqr(mes_param_monstre.mdudu[i].x - mes_param_monstre.mdudu[j].x)+sqr(mes_param_monstre.mdudu[i].y - mes_param_monstre.mdudu[j].y));
				if d<100 then test := false			//test de distantion social , et oui c'est pour tout le monte pareil
				end;
			until test;
			

		
			//vitesse
		mes_param_monstre.mdudu[i].vx := 0;
		mes_param_monstre.mdudu[i].vy := 0;
			//charge
		mes_param_monstre.mdudu[i].charge := 4;
			//it
		it.tabItem[dispo].param := 1; 
		it.tabItem[dispo].nbVie := (mes_param_monstre.nb_vague +1);
		
		mes_param_monstre.mdudu[i].num_tab := dispo;
				
		it.tabItem[dispo].x := trunc(mes_param_monstre.mdudu[i].x) - (tab[it.tabItem[dispo].param + rangMonstres,'x'] div 2);
		it.tabItem[dispo].y := trunc(mes_param_monstre.mdudu[i].y) - (tab[it.tabItem[dispo].param + rangMonstres,'y'] div 2);
		
		afficheSDL(it,ship,'monstre',dispo);
	end;
	

	end;
end;

procedure vague(var it : item ;var ship : vaisseau ; tab : tabTaille ; var mes_param_monstre : param_deplacement_monstre;choix : integer; var temps : tab_temps; var descente : integer);
begin
	case choix of 
		1 : vague_1(it, ship, tab, mes_param_monstre, temps,descente);
		2 : vague_2(it, ship, tab, mes_param_monstre, temps);
		3 : vague_3(it, ship, tab, mes_param_monstre, temps);
		4 : vague_4(it, ship, tab, mes_param_monstre, temps);
	end;
end;
Procedure partie(it : item; ship : vaisseau; choix : integer; dataship : dataVaisseau; tab : tabTaille);
var tRefMouvement, tTir, tRefImmunite, time : TSystemTime;
temps : tab_temps;
	descente, a, i, n : integer;
	x, y : longint;
	contactV: boolean;
	explo : tabExplo;
	dataBombe : dataTirBombe;
	mes_param_monstre : param_deplacement_monstre;
	position: tsdl_rect;


BEGIN 

	if choix = 4 then
		begin
			a := random(3);
			case a of
				0 : begin 
						ship.pos.param := 11;
						dataShip.numero := 11;
						dataShip.munition := 10;
					end;
				1 : begin 
						ship.pos.param := 12;
						dataShip.numero := 12;
						dataShip.munition := 11;
					end;
				2 : begin 
						ship.pos.param := 13;
						dataShip.numero := 13;
						dataShip.munition := 12;
					end;
			end;
		end;
	
	InitExplo(explo);
	DateTimeToSystemTime(Now,time);
	DateTimeToSystemTime(Now,tTir);
	DateTimeToSystemTime(Now,tRefMouvement);
	DateTimeToSystemTime(Now,tRefImmunite);
	case choix of
		1 : initTirBombes(1000,2000,dataBombe);
		2 : initTirBombes(750,1500,dataBombe);
		3 : initTirBombes(500,1000,dataBombe);
		4 : initTirBombes(1000,2000,dataBombe);
	end;
	SDL_FillRect(window, NIL, 0);
		
	InitVaisseau(tab, ship, dataShip);
	afficheSdl(it,ship,'vaisseau',0);
	
	
	position.x := 0;
	position.y := 0;
	
	ship.score := 0;
	affichescore(ship);
	
	init_monstre(it,ship,temps,choix, descente,mes_param_monstre,tab);
	sdl_blitsurface(cache[rangdivers + 44],nil,window,@position);
	ecrire('Appuyez sur ''Espace'' pour tirer',dimensionX div 2 - 320, 200, 40, 150, 150 ,150);
	ecrire('Utilisez les ''Fleches'' pour vous diriger',dimensionX div 2 - 390, 400, 40, 150, 150 ,150);
	ecrire('Soyez prudents, certains monstres ont plusieures vies',dimensionX div 2 - 530, 600, 40, 150, 150 ,150);
	ecrire('Cliquez pour jouer',dimensionX div 2 - 180, 800, 40, 150, 150 ,150);
	Sdl_flip(window);
	repeat
		lectureBoutonSouris(x,y);
	until x<>-1;
	

	SDL_FillRect(window, NIL, 0);
	afficheSdl(it,ship,'vaisseau', 0);

	for i in it.monstre do
		afficheSdl(it,ship,'monstre',i);

	affichescore(ship);
	Sdl_flip(window);
	delay(500);
	initTemps(temps);
	
	DateTimeToSystemTime(Now,dataBombe.time);
	
	repeat
		n := mes_param_monstre.nb_vague;
		deplacementProjSdl(it,tRefMouvement);
		gestionVaisseau(ship,it,tab,dataShip);
		
		if choix = 4  then
			barreVie(totalVieActuel(it),(mes_param_monstre.nb_vague + 1)*((mes_param_monstre.nb_vague div 3)+1));
		
		exploGeneral(explo);
		deplacement_monstre(temps, it, ship, descente, choix, tab,mes_param_monstre);
		Contact(it, ship, tab, explo, tRefImmunite, contactV);		
		
		vague(it, ship, tab, mes_param_monstre, choix, temps,descente);
		
		if (n <> mes_param_monstre.nb_vague) and (choix = 4) then
			DateTimeToSystemTime(Now,dataBombe.time);
		generationBombe(dataBombe,it,tab);
		afficheVie(ship);
		Sdl_flip(window);
	until GameOver(it, ship, tab, time);
	enregistreScore(ship.score);
	ecranGameOver();
	sdl_fillrect(window,nil,0);

	
END;

procedure menu () ;
	

var it : item;
	ship : vaisseau;
	tab : tabTaille;
	dataShip : dataVaisseau;
	x, y, x2, y2 : longint;
	fichier : text;
	p : tsdl_rect;
	rect : tsdl_rect;
	numero_musique, diff, cacher : Integer;
	window_menu : psdl_surface;
	son : music;
	
BEGIN
	randomize;
	initSdl(it,ship,tab);
	initMusic(son);
	
	window_menu := SDL_SetVideoMode(0, 0, 32, SDL_FULLSCREEN);
	sdl_getcliprect(window_menu,@rect);
	dimensionX := rect.w;
	dimensionY := rect.h;
	
	assign(fichier,'ressources/Selection Vaisseau.txt');
	
	p.x := 0;
	p.y := 0;
	
	numero_musique := 1;

	if fileExists('ressources/Selection Vaisseau.txt') then
		begin
			reset(fichier);
			readln(fichier, dataShip.numero);
			ship.pos.param := dataShip.numero;
			readln(fichier, dataShip.munition);
		end
	else
		begin
			ship.pos.param := 1;
			dataShip.numero := 1;
			dataShip.munition := 1;
		end;
	
	
// Choix de la resolution du menu en fonction de la taille de l'ecran
	if (rect.h >= 1080) and (rect.w >= 1920) then
	begin
		sdl_blitsurface(cache[rangDivers + 43],nil,window_menu,@p);
		ecrire('Voici les boutons pour lancer une partie', dimensionX div 2 - 400, 400, 40, 150, 150, 150);
		ecrire('Cliquez pour passer',dimensionX div 2 - 200, 600, 40, 150, 150 ,150);
		sdl_flip(window);
		repeat
			lectureBoutonSouris(x,y);
		until x<>-1;
		delay(100);
		
		sdl_blitsurface(cache[rangDivers + 42],nil,window_menu,@p);
		ecrire('Voici le bouton pour selectionner un vaisseau', dimensionX div 2 - 450, 400, 40, 150, 150, 150);
		ecrire('Cliquez pour passer',dimensionX div 2 - 200, 600, 40, 150, 150 ,150);
		sdl_flip(window);
		repeat
			lectureBoutonSouris(x,y);
		until x<>-1;
		delay(100);
		
		sdl_blitsurface(cache[rangDivers + 41],nil,window_menu,@p);
		ecrire('Voici le bouton pour quitter', dimensionX div 2 - 280, 400, 40, 150, 150, 150);
		ecrire('Cliquez pour passer',dimensionX div 2 - 200, 600, 40, 150, 150 ,150);
		sdl_flip(window);
		repeat
			lectureBoutonSouris(x,y);
		until x<>-1;
		delay(100);
		
		sdl_blitsurface(cache[rangDivers + 40],nil,window_menu,@p);
		ecrire('Voici les boutons de l''auto-radio', dimensionX div 2 - 330, 400, 40, 150, 150, 150);
		ecrire('Cliquez pour passer',dimensionX div 2 - 200, 600, 40, 150, 150 ,150);
		sdl_flip(window);
		repeat
			lectureBoutonSouris(x,y);
		until x<>-1;
		delay(100);
		
		sdl_blitsurface(cache[rangDivers + 46],nil,window_menu,@p);
		ecrire('Bon jeu!', dimensionX div 2 - 80, 400, 40, 150, 150, 150);
		sdl_flip(window);
		delay(500);
		
		sdl_blitsurface(image[rangDivers + 20],nil,window_menu,@p);
		affichageMini(tab, dataShip, 1);
		sdl_flip(window_menu);
		repeat
		begin
			lectureBoutonSouris(x,y);
			sdl_getMouseState(x2, y2);
			
	{boucle qui permet d'enfoncer le bouton si la souris est dessus}

			{partie moyenne}	
			if clicCercle(1300, 640, 55, x2, y2) then
				begin
				sdl_blitsurface(image[rangDivers + 34],nil,window_menu,@p);
				sdl_flip(window_menu);
				end
			{partie facile}		
			else if clicCercle(620, 360, 135, x2, y2) then
				begin
				sdl_blitsurface(image[rangDivers + 32],nil,window_menu,@p);
				sdl_flip(window_menu);
				end
			{partie dure}	
			else if clicCercle(1380, 255, 55, x2, y2) then
				begin
				sdl_blitsurface(image[rangDivers + 33],nil,window_menu,@p);
				sdl_flip(window_menu);
				end
			{musique précédente}	
			else if clicCercle(1335, 960, 30, x2, y2) then
				begin
				sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
				sdl_blitsurface(image[rangDivers + 28],nil,window_menu,@p);
				ecrire(son.nom[(numero_musique +3) mod max_musique +1],740,920,20,0,0,0);
				cacher := 1;
				sdl_flip(window_menu);
				end
			{musique suivante}	
			else if clicCercle(1460, 960, 30, x2, y2) then
				begin
				cacher := 2;
				sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
				sdl_blitsurface(image[rangDivers + 27],nil,window_menu,@p);
				ecrire(son.nom[(numero_musique) mod max_musique +1],740,920,20,0,0,0);
				sdl_flip(window_menu);
				end
			{musique + fort}	
			else if clicCercle(505, 890, 30, x2, y2) then
				begin
				cacher := 3;
				sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
				sdl_blitsurface(image[rangDivers + 31],nil,window_menu,@p);
				afficheVolume(son, 1);
				sdl_flip(window_menu);
				end
			{musique pause}	
			else if clicCercle(575, 960, 30, x2, y2) then
				begin
				cacher := 4;
				sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
				sdl_blitsurface(image[rangDivers + 26],nil,window_menu,@p);
				ecrire(son.nom[numero_musique],740,920,20,0,0,0);
				sdl_flip(window_menu);
				end
			{musique - fort}	
			else if clicCercle(505, 1030, 30, x2, y2) then
				begin
				cacher := 5;
				sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
				sdl_blitsurface(image[rangDivers + 30],nil,window_menu,@p);
				afficheVolume(son, 1);
				sdl_flip(window_menu);
				end
			{musique play}	
			else if clicCercle(435, 960, 30, x2, y2) then
				begin
				cacher := 6;
				sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
				sdl_blitsurface(image[rangDivers + 29],nil,window_menu,@p);
				ecrire(son.nom[numero_musique],740,920,20,0,0,0);
				sdl_flip(window_menu);
				end
			{partie spéciale}	
			else if clicCercle(1825, 960, 45, x2, y2) then
				begin
				sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
				sdl_blitsurface(image[rangDivers + 23],nil,window_menu,@p);
				ecrire('Vous avez rates les exams de dudu ?',740,880,21,0,0,0);
				ecrire('Vous souhaitez prendre votre revanche ?',740,920,21,0,0,0);
				ecrire('Tentez de vaincre dudu sur un autre terrain',740,960,21,0,0,0);
				sdl_flip(window_menu);
				end
			{exit}	
			else if clicRectangle(15, 920, 160, 1000, x2, y2) then
				begin
				sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
				sdl_blitsurface(image[rangDivers + 24],nil,window_menu,@p);
				ecrire('Sortir du jeu',740,920,30,0,0,0);
				sdl_flip(window_menu);
				end
			{menu skin}
			else if clicRectangle(1800, 735, 1900, 770, x2, y2) then
				begin
				sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
				sdl_blitsurface(image[rangDivers + 25],nil,window_menu,@p);
				ecrire('Selection des vaisseaux et munitions',740,920,21,0,0,0);
				sdl_flip(window_menu);
				end
			{aucun bouton}
			else
				begin
				if cacher = 1 then
					sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p)
				else if cacher = 2 then
					sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p)
				else if cacher = 3 then
					sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p)
				else if cacher = 4 then
					sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p)
				else if cacher = 5 then
					sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p)
				else if cacher = 6 then
					sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p)
				else
					sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
				sdl_flip(window_menu);
				end;
			
	{régit les actions liées au bouton sélectionné}

			{lancer partie facile}		
			if clicCercle(620, 360, 135, x, y) then
				begin
					partie(it, ship, 1, dataship, tab);
					sdl_blitsurface(image[rangDivers + 20],nil,window_menu,@p);
					affichageMini(tab, dataShip, 1);
					sdl_flip(window_menu);
				end;
				
			{lancer partie moyenne}	
			if clicCercle(1300, 640, 55, x, y) then
				begin
					partie(it, ship, 2, dataship, tab);
					sdl_blitsurface(image[rangDivers + 20],nil,window_menu,@p);
					affichageMini(tab, dataShip, 1);
					sdl_flip(window_menu);
				end;
				
			{lancer partie dure}		
			if clicCercle(1380, 255, 55, x, y) then
				begin
					partie(it, ship, 3, dataship, tab);
					sdl_blitsurface(image[rangDivers + 20],nil,window_menu,@p);
					affichageMini(tab, dataShip, 1);
					sdl_flip(window_menu);
				end;
		
			{lancer partie dudu}
			if clicCercle(1825, 960, 45, x, y) then
				begin
					partie(it, ship, 4, dataship, tab);
					sdl_blitsurface(image[rangDivers + 20],nil,window_menu,@p);
					affichageMini(tab, dataShip, 1);
					sdl_flip(window_menu);
				end;
			
			{musique précédente}	
			if clicCercle(1335, 960, 30, x, y) then
				begin
					finMusique(son);
					if numero_musique = 1 then
						numero_musique := max_musique
					else numero_musique:=numero_musique - 1;
						lancerMusique (numero_musique,son );
					sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
				end;
				
			{musique suivante}		
			if clicCercle(1460, 960, 30, x, y) then
				begin
					finMusique(son);
					if numero_musique = max_musique then
						numero_musique := 1
					else numero_musique:=numero_musique + 1;
						lancerMusique (numero_musique,son);
					sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
				end;
			
			{musique + forte}	
			if clicCercle(505, 890, 30, x, y) then
				begin
					if (son.volume < max_volume) then
						diff := 10
					else diff :=0;
					sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
					volumeMusique(diff, son);
				end;
				
			{musique - forte}
			if clicCercle(505, 1030, 30, x, y) then
				begin
					if (son.volume > 0 ) then
						diff := -10
					else diff :=0;
					sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
					volumeMusique(diff, son);
				end;
				
			{musique pause}
			if clicCercle(575, 960, 30, x, y) then
				begin
					pauseMusique(son);
					sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
				end;
			
			{musique play}
			if clicCercle(435, 960, 30, x, y) then
				begin
					lancerMusique(numero_musique, son);
					sdl_blitsurface(cache[rangDivers + 22],nil,window_menu,@p);
				end;
				
			{menu skin}
			if clicRectangle(1800, 735, 1900, 770, x, y) then
				begin
					menuSkin(ship, dataShip, tab,1);
					sdl_blitsurface(image[rangDivers + 20],nil,window_menu,@p);
					affichageMini(tab, dataShip, 1);
					sdl_flip(window_menu);
				end;
			

			afficheScoreMenu(1);	
		end;
	
		until clicRectangle(15, 920, 160, 1000, x, y); //bouton exit
	end 
	
	
	
	
	else 
	begin

		sdl_blitsurface(cache[rangDivers + 52],nil,window_menu,@p);
		ecrire('Voici les boutons pour lancer une partie', dimensionX div 2 - 250, 265, 25, 150, 150, 150);
		ecrire('Cliquez pour passer',dimensionX div 2 - 125, 400, 25, 150, 150 ,150);
		sdl_flip(window);
		repeat
			lectureBoutonSouris(x,y);
		until x<>-1;
		delay(100);
		
		sdl_blitsurface(cache[rangDivers + 51],nil,window_menu,@p);
		ecrire('Voici le bouton pour selectionner un vaisseau', dimensionX div 2 - 280, 265, 25, 150, 150, 150);
		ecrire('Cliquez pour passer',dimensionX div 2 - 125, 400, 25, 150, 150 ,150);
		sdl_flip(window);
		repeat
			lectureBoutonSouris(x,y);
		until x<>-1;
		delay(100);
		
		sdl_blitsurface(cache[rangDivers + 50],nil,window_menu,@p);
		ecrire('Voici le bouton pour quitter', dimensionX div 2 - 175, 265, 25, 150, 150, 150);
		ecrire('Cliquez pour passer',dimensionX div 2 - 125, 400, 25, 150, 150 ,150);
		sdl_flip(window);
		repeat
			lectureBoutonSouris(x,y);
		until x<>-1;
		delay(100);
		
		sdl_blitsurface(cache[rangDivers + 49],nil,window_menu,@p);
		ecrire('Voici les boutons de l''auto-radio', dimensionX div 2 - 205, 265, 25, 150, 150, 150);
		ecrire('Cliquez pour passer',dimensionX div 2 - 125, 400, 25, 150, 150 ,150);
		sdl_flip(window);
		repeat
			lectureBoutonSouris(x,y);
		until x<>-1;
		delay(100);
		
		sdl_blitsurface(cache[rangDivers + 23],nil,window_menu,@p);
		sdl_blitsurface(cache[rangDivers + 44],nil,window_menu,@p);
		ecrire('Bon jeu!', dimensionX div 2 - 50, 265, 25, 150, 150, 150);
		sdl_flip(window);
		delay(500);

		
		sdl_blitsurface(cache[rangDivers + 23],nil,window_menu,@p);
		affichageMini(tab, dataShip, 2);
		sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
		sdl_flip(window_menu);
		repeat
		
			lectureBoutonSouris(x,y);
			sdl_getMouseState(x2, y2);
			
	{boucle qui permet d'enfoncer le bouton si la souris est dessus}

			{partie moyenne}	
			if clicCercle(870, 425, 35, x2, y2) then
				begin
				sdl_blitsurface(cache[rangDivers + 47],nil,window_menu,@p);
				affichageMini(tab, dataShip, 2);
				sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
				sdl_flip(window_menu);
				end
			{partie facile}		
			else if clicCercle(410, 240, 90, x2, y2) then
				begin
				sdl_blitsurface(cache[rangDivers + 33],nil,window_menu,@p);
				affichageMini(tab, dataShip, 2);
				sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
				sdl_flip(window_menu);
				end
			{partie dure}	
			else if clicCercle(920, 170, 35, x2, y2) then
				begin
				sdl_blitsurface(cache[rangDivers + 34],nil,window_menu,@p);
				affichageMini(tab, dataShip, 2);
				sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
				sdl_flip(window_menu);
				end
			{musique précédente}	
			else if clicCercle(890, 640, 20, x2, y2) then
				begin
				sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
				sdl_blitsurface(cache[rangDivers + 28],nil,window_menu,@p);
				ecrire(son.nom[(numero_musique +3) mod max_musique +1],495,615,14,0,0,0);
				cacher := 1;
				affichageMini(tab, dataShip, 2);
				sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
				sdl_flip(window_menu);
				end
			{musique suivante}	
			else if clicCercle(970, 640, 20, x2, y2) then
				begin
				cacher := 2;
				sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
				sdl_blitsurface(cache[rangDivers + 29],nil,window_menu,@p);
				ecrire(son.nom[(numero_musique) mod max_musique +1],495,615,14,0,0,0);
				affichageMini(tab, dataShip, 2);
				sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
				sdl_flip(window_menu);
				end
			{musique + fort}	
			else if clicCercle(335, 595, 20, x2, y2) then
				begin
				cacher := 3;
				sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
				sdl_blitsurface(cache[rangDivers + 27],nil,window_menu,@p);
				afficheVolume(son, 2);
				affichageMini(tab, dataShip, 2);
				sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
				sdl_flip(window_menu);
				end
			{musique pause}	
			else if clicCercle(385, 640, 20, x2, y2) then
				begin
				cacher := 4;
				sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
				sdl_blitsurface(cache[rangDivers + 26],nil,window_menu,@p);
				ecrire(son.nom[numero_musique],495,615,14,0,0,0);
				affichageMini(tab, dataShip, 2);
				sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
				sdl_flip(window_menu);
				end
			{musique - fort}	
			else if clicCercle(335, 685, 20, x2, y2) then
				begin
				cacher := 5;
				sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
				sdl_blitsurface(cache[rangDivers + 25],nil,window_menu,@p);
				afficheVolume(son, 2);
				affichageMini(tab, dataShip, 2);
				sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
				sdl_flip(window_menu);
				end
			{musique play}	
			else if clicCercle(290, 640, 20, x2, y2) then
				begin
				cacher := 6;
				sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
				sdl_blitsurface(cache[rangDivers + 24],nil,window_menu,@p);
				ecrire(son.nom[numero_musique],495,615,14,0,0,0);
				affichageMini(tab, dataShip, 2);
				sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
				sdl_flip(window_menu);
				end
			{partie spéciale}	
			else if clicCercle(1230, 640, 40, x2, y2) then
				begin
				sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
				sdl_blitsurface(cache[rangDivers + 31],nil,window_menu,@p);
				ecrire('Vous avez rates les exams de dudu ?',495,585,14,0,0,0);
				ecrire('Vous souhaitez prendre votre revanche ?',495,615,14,0,0,0);
				ecrire('Tentez de vaincre dudu sur un autre terrain',495,645,14,0,0,0);
				affichageMini(tab, dataShip, 2);
				sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
				sdl_flip(window_menu);
				end
			{exit}	
			else if clicRectangle(5, 610, 110, 670, x2, y2) then
				begin
				sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
				sdl_blitsurface(cache[rangDivers + 30],nil,window_menu,@p);
				affichageMini(tab, dataShip, 2);
				sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
				ecrire('Sortir du jeu',495,615,20,0,0,0);
				sdl_flip(window_menu);
				end
			{menu skin}
			else if clicRectangle(1200, 490, 1270, 520, x2, y2) then
				begin
				sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
				sdl_blitsurface(cache[rangDivers + 32],nil,window_menu,@p);
				ecrire('Selection des vaisseaux et munitions',495,615,14,0,0,0);
				affichageMini(tab, dataShip, 2);
				sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
				sdl_flip(window_menu);
				end
			{aucun bouton}
			else
				begin
				if cacher = 1 then
					sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p)
				else if cacher = 2 then
					sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p)
				else if cacher = 3 then
					sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p)
				else if cacher = 4 then
					sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p)
				else if cacher = 5 then
					sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p)
				else if cacher = 6 then
					sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p)
				else
					sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
				sdl_flip(window_menu);
				end;
			
	{régit les actions liées au bouton sélectionné}

			{lancer partie facile}		
			if clicCercle(410, 240, 90, x, y) then
				begin
					partie(it, ship, 1, dataship, tab);
					sdl_blitsurface(cache[rangDivers + 23],nil,window_menu,@p);
					affichageMini(tab, dataShip, 2);
					sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
					sdl_flip(window_menu);
				end;
				
			{lancer partie moyenne}	
			if clicCercle(870, 425, 35, x, y) then
				begin
					partie(it, ship, 2, dataship, tab);
					sdl_blitsurface(cache[rangDivers + 23],nil,window_menu,@p);
					affichageMini(tab, dataShip, 2);
					sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
					sdl_flip(window_menu);
				end;
				
			{lancer partie dure}		
			if clicCercle(920, 170, 35, x, y) then
				begin
					partie(it, ship, 3, dataship, tab);
					sdl_blitsurface(cache[rangDivers + 23],nil,window_menu,@p);
					affichageMini(tab, dataShip, 2);
					sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
					sdl_flip(window_menu);
				end;
		
			{lancer partie dudu}
			if clicCercle(1230, 640, 40, x, y) then
				begin
					partie(it, ship, 4, dataship, tab);
					sdl_blitsurface(cache[rangDivers + 23],nil,window_menu,@p);
					affichageMini(tab, dataShip, 2);
					sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
					sdl_flip(window_menu);
				end;
			
			{musique précédente}	
			if clicCercle(890, 640, 20, x, y) then
				begin
					finMusique(son);
					if numero_musique = 1 then
						numero_musique := max_musique
					else numero_musique:=numero_musique - 1;
						lancerMusique (numero_musique,son );
					sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
				end;
				
			{musique suivante}		
			if clicCercle(970, 640, 20, x, y) then
				begin
					finMusique(son);
					if numero_musique = max_musique then
						numero_musique := 1
					else numero_musique:=numero_musique + 1;
						lancerMusique (numero_musique,son);
					sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
				end;
			
			{musique + forte}	
			if clicCercle(335, 595, 20, x, y) then
				begin
					if (son.volume < max_volume) then
						diff := 10
					else diff :=0;
					sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
					volumeMusique(diff, son);
				end;
				
			{musique - forte}
			if clicCercle(335, 685, 20, x, y) then
				begin
					if (son.volume > 0 ) then
						diff := -10
					else diff :=0;
					sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
					volumeMusique(diff, son);
				end;
				
			{musique pause}
			if clicCercle(385, 640, 20, x, y) then
				begin
					pauseMusique(son);
					sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
				end;
			
			{musique play}
			if clicCercle(290, 640, 20, x, y) then
				begin
					lancerMusique(numero_musique, son);
					sdl_blitsurface(cache[rangDivers + 48],nil,window_menu,@p);
				end;
				
			{menu skin}
			if clicRectangle(1200, 490, 1270, 520, x, y) then
				begin
					menuSkin(ship, dataShip, tab, 2 );
					sdl_fillrect(window,nil,0);
					sdl_blitsurface(cache[rangDivers + 23],nil,window_menu,@p);
					affichageMini(tab, dataShip, 2);
					sdl_blitsurface(cache[rangDivers + 53],nil,window_menu,@p);
					sdl_flip(window_menu);
				end;
			

			afficheScoreMenu(2);	
			sdl_flip(window_menu);
		until clicRectangle(5, 610, 110, 670, x, y); //bouton exit
	end;
	rewrite(fichier);
	writeln(fichier,dataShip.numero);
	writeln(fichier,dataShip.munition);
	close(fichier);
	sdl_freesurface (window_menu);
	quitterSdl;
	finMusique(son);
END;

END.


