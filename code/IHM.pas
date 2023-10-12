unit IHM;

interface 

uses  crt, sysutils, TypeSdl, sdl, sdl_ttf,sdl_image, sdl_mixer,math;
  
// affiche le score lors du jeu
procedure AfficheScore (v:Vaisseau);

// procedure déplacant tous les projectiles d'une case 
procedure deplacementProjSdl(var it : Item; var tRefMouvement : TSystemTime);

// initialise la SDL
procedure initSdl(var it : item; var ship : vaisseau; var tab : tabTaille);

//cloture la SDL
procedure quitterSdl();

// affiche un objet
procedure afficheSdl(it : item; ship : vaisseau; objet : string{monstre, bombe, missile ou vaisseau}; indice : integer{indice dans tabItem // si vaisseau mettre 0});

// désaffiche un objet
procedure cacheSdl(it : item; ship : vaisseau; objet : string{monstre, bombe, missile ou vaisseau}; indice : integer{indice dans tabItem // si vaisseau mettre 0});

// déplace un objet
procedure deplacementSdl(var it : item; var ship : vaisseau; objet : string{monstre, bombe, missile ou vaisseau}; direction : char; distance, indice : integer{indice dans tabItem // si vaisseau mettre 0});

// initiale la musique
procedure initMusic(var son : music);

// gère le volume de la musique
procedure volumeMusique(modif:integer; var son : music);

// mise en pause de la musique
procedure pauseMusique(var son : music);

// lance la musique 
procedure lancerMusique(indice : integer; var son : music);

// coupe la musique
procedure finMusique(var son : music);

// permet d'écrire du texte sur l'écran
procedure ecrire(texte : String; x,y,taille, rouge, vert, bleu : integer);

// affiche les explosions entre les items 
procedure explosionItem(var explo : dataExplo); //initialiser avec avancement := 1 et explosionEnCours := true pour lancer une explosion

// gère toutes le explosions 
Procedure exploGeneral(var explo : tabExplo);

// nimation de fin de partie 
procedure ecranGameOver;

//fonction qui vérifie si des coordonnées catésiennes sont dans un rectangle
function clicRectangle(pos1X, pos1Y, pos2X, pos2Y, clicX, clicY : integer): boolean;

//fonction qui vérifie si des coordonnées catésiennes sont dans un cercle
function clicCercle(oX, oY, rayon, clicX, clicY : integer): boolean;

//retourne les coordonnées catésiennes de la souris après un clic
procedure lectureBoutonSouris(var x, y : longint);

// affiche les coeurs représentant les vies dans le jeu 
procedure afficheVie(ship : vaisseau);

// affichage des minis vaisseaux dans le menu
procedure affichageMini(tab : tabTaille; dataShip : dataVaisseau; i : integer);

//affichage du volume 
procedure afficheVolume(son : music; i : integer);	

// affiche la barre de vie des monstres dans le mode Duval 
procedure barreVie(vieActuelle,VieMax : integer);





implementation 




// affiche le score
procedure AfficheScore (v:Vaisseau);

var score : String;
coordx, coordy, taille, rouge, vert, bleu : Integer;
destination : TSDL_RECT;

begin
		
coordx:=dimensionX - 300;
coordy:=10;

destination.x := coordx;
destination.y := coordy;



taille:=80;
rouge:= 255;
vert:= 255;
bleu:= 255; 
score:= intToStr (v.score);

SDL_BlitSurface(cacheScore,NIL,window,@destination);
ecrire (score,coordx,coordy,taille,rouge,vert,bleu);
SDL_Flip(window);


end;




//Procedure déplacant tous les projectiles d'une case
procedure deplacementProjSdl(var it : Item; var tRefMouvement : TSystemTime);

var i : 0..100;
	tMesure : TSystemTime;
	ship : vaisseau;		//utilisation d'une variable non initialisée inutile dans notre cas pour éviter d'avoir à l'appeller dans la procédure
	
const	distance = 20;

begin
	
	DateTimeToSystemTime(Now,tMesure); //La c'est l'instruction qui enregistre le moment dans tMesure
	
	//Si le temps entre 2 mouvements est atteint alors  
	if (diffTemps(tMesure, tRefMouvement)) > deltaMouvement then
	begin
		
		//Bombes
		for i in it.bombe do 
		begin
			//Effacement à la position précedente
			cacheSdl(it,ship,'bombe',i);
			
			//Si la bombe ne sort pas des limites, changement de ses coordonnées 
			if it.tabItem[i].y < dimensionY - 50 then
			begin
				deplacementSdl(it,ship,'bombe','b',trunc((distance/deltaMouvement)*diffTemps(tMesure, tRefMouvement)),i);
			end
			
			//Sinon, disparition de la bombe
			else
			begin
				it.tabItem[i].param := 0;
				it.bombe := it.bombe - [i];
				it.vide := it.vide + [i];
			end;
		end;
		
		
		//Missile
		for i in it.missile do 
		begin
			//Effacement à la position précedente
			cacheSdl(it,ship,'missile',i);
			
			//Si le missile ne sort pas des limites, changement de ses coordonnées 
			if it.tabItem[i].y > 150 then
			begin
				deplacementSdl(it,ship,'missile','h',trunc((distance/deltaMouvement)*diffTemps(tMesure, tRefMouvement)),i);
			end
			
			//Sinon, disparition du missile
			else 
			begin
				it.tabItem[i].param := 0;
				it.missile := it.missile - [i];
				it.vide := it.vide + [i];
			end;
			
			
		end;
		
		//Réinitialisation de tRef
		DateTimeToSystemTime(Now,tRefMouvement);
		
		sdl_flip(window);
	end;
end;




procedure initSdl(var it : item; var ship : vaisseau; var tab : tabTaille);
var i : integer;
	str : string;
	pimage : pchar;
	rectangle : tsdl_rect;
	fichier : text;
	

begin
	
	
	//Chargement de la bibliothèque
	SDL_Init(SDL_INIT_VIDEO);	
	
	
//Ouverture du fichier référence	
	assign(fichier, 'ressources/images/liste.txt');
	reset(fichier);
	
	
//Chargement des nombres d'items	
	readln(fichier,totalMonstres);
	rangMonstres := 0;
	
	readln(fichier,totalBombes);
	rangBombes := rangMonstres + totalMonstres;
	
	readln(fichier,totalMissiles);
	rangMissiles := rangBombes + totalBombes;
	
	readln(fichier,totalVaisseaux);
	rangVaisseaux := rangMissiles + totalMissiles;
	
	readln(fichier, totalDivers);
	rangDivers := rangVaisseaux + totalVaisseaux;
	
	readln(fichier);
	readln(fichier);


//Chargement des images	
	//Chargement des images de monstre :
	for i := 1 to totalMonstres do
	begin
		str := 'ressources/images/monstres/monstre' + intToStr(i) + '.png';
		pimage := StrAlloc(length(str)+1);
		strPCopy(pimage, str);
		
		image[i] := IMG_Load(pimage);
	end;
	
	
	//Chargement des images de bombe :
	for i := 1 to totalBombes do
	begin
		str := 'ressources/images/bombes/bombe' + intToStr(i) + '.png';
		pimage := StrAlloc(length(str)+1);
		strPCopy(pimage, str);
		
		image[i + rangBombes] := IMG_Load(pimage);
	end;	
	
	
	//Chargement des images de bombe :
	for i := 1 to totalmissiles do
	begin
		str := 'ressources/images/missiles/missile' + intToStr(i) + '.png';
		pimage := StrAlloc(length(str)+1);
		strPCopy(pimage, str);
		
		image[i + rangMissiles] := IMG_Load(pimage);
	end;	
	
	
	//Chargement des images de vaisseau :
	for i := 1 to totalVaisseaux do
	begin
		str := 'ressources/images/vaisseaux/vaisseau' + intToStr(i) + '.png';
		pimage := StrAlloc(length(str)+1);
		strPCopy(pimage, str);
		
		image[i + rangVaisseaux] := IMG_Load(pimage);
	end;	
	
	
	//Chargement des images diverses :
	for i := 1 to totalDivers do
	begin
		str := 'ressources/images/divers/divers' + intToStr(i) + '.png';
		pimage := StrAlloc(length(str)+1);
		strPCopy(pimage, str);
		
		image[i + rangDivers] := IMG_Load(pimage);
	end;	
	

//Associations images-caches	
	//Association monstre-taille
	for i := rangMonstres + 1 to totalMonstres do
	begin
		read(fichier, tab[i]['x']);
		readln(fichier, tab[i]['y']);
	end;
	readln(fichier);
	readln(fichier);

	
	//Association bombe-taille
	for i := rangBombes + 1 to totalBombes + rangBombes do
	begin
		read(fichier, tab[i]['x']);
		readln(fichier, tab[i]['y']);
	end;
	readln(fichier);
	readln(fichier);
	
	
	//Association missile-taille
	for i := rangMissiles + 1 to totalMissiles + rangMissiles do
	begin
		read(fichier, tab[i]['x']);
		readln(fichier, tab[i]['y']);
	end;
	readln(fichier);
	readln(fichier);
	

	//Association vaisseau-taille
	for i := rangVaisseaux + 1 to totalVaisseaux + rangVaisseaux do
	begin
		read(fichier, tab[i]['x']);
		readln(fichier, tab[i]['y']);
	end;
	readln(fichier);
	readln(fichier);
	

	//Association divers-taille
	for i := rangDivers + 1 to totalDivers + rangDivers do
	begin
		read(fichier, tab[i]['x']);
		readln(fichier, tab[i]['y']);
	end;
	readln(fichier);
	readln(fichier);



//Chargement des caches
	//Monstre-cache
	for i := rangMonstres + 1 to totalMonstres do
	begin
		str := 'ressources/images/caches/cacheMonstre' + intToStr(i - rangMonstres) + '.png';
		pimage := StrAlloc(length(str)+1);
		strPCopy(pimage, str);
		
		cache[i] := IMG_Load(pimage);
	end;

	
	//Bombe-cache
	for i := rangBombes + 1 to totalBombes + rangBombes do
	begin
		str := 'ressources/images/caches/cacheBombe' + intToStr(i - rangBombes) + '.png';
		pimage := StrAlloc(length(str)+1);
		strPCopy(pimage, str);
		
		cache[i] := IMG_Load(pimage);
	end;

	
	//Missile-cache
	for i := rangMissiles + 1 to totalMissiles + rangMissiles do
	begin
		str := 'ressources/images/caches/cacheMissile' + intToStr(i - rangMissiles) + '.png';
		pimage := StrAlloc(length(str)+1);
		strPCopy(pimage, str);
		
		cache[i] := IMG_Load(pimage);
	end;
	

	//Vaisseau-cache
	for i := rangVaisseaux + 1 to totalVaisseaux + rangVaisseaux do
	begin
		str := 'ressources/images/caches/cacheVaisseau' + intToStr(i - rangVaisseaux) + '.png';
		pimage := StrAlloc(length(str)+1);
		strPCopy(pimage, str);
		
		cache[i] := IMG_Load(pimage);
	end;
	

	//Divers-cache
	for i := rangDivers + 1 to totalDivers + rangDivers do
	begin
		str := 'ressources/images/caches/cacheDivers' + intToStr(i - rangDivers) + '.png';
		pimage := StrAlloc(length(str)+1);
		strPCopy(pimage, str);
		if fileExists(str) then
			cache[i] := IMG_Load(pimage);
	end;
	
	
	cachescore:= img_load('ressources/images/caches/500x100.png');

	
//Association monstres-bombes
	for i := 1 to totalMonstres do
	begin
		readln(fichier, lienMonstres[i]);
	end;
	readln(fichier);
	readln(fichier);
	

//Association vaisseaux-missiles
	for i := 1 to totalVaisseaux do
		readln(fichier, lienVaisseaux[i]);




//Initialisation de la fenêtre
	window := SDL_SetVideoMode(0, 0, 32, SDL_FULLSCREEN);
	sdl_getcliprect(window,@rectangle);
	dimensionX := rectangle.w;
	dimensionY := rectangle.h;


//Fermeture du fichier
close(fichier);
end;




procedure quitterSdl();
var i : integer;

begin
	{vider la memoire correspondant aux images et a la fenetre}
	for i := 1 to 100 do
	begin
		SDL_FreeSurface(image[i]);
		SDL_FreeSurface(cache[i]);
	end;

	SDL_FreeSurface(cacheScore);
	SDL_FreeSurface(window);
	{decharger les bibliotheques}
	SDL_Quit();

	
end;




procedure afficheSdl(it : item; ship : vaisseau; objet : string{monstre, bombe, missile ou vaisseau}; indice : integer{indice dans tabItem // si vaisseau mettre 0});
var
	destination : TSDL_RECT;

begin
	case objet of
		'monstre':
			begin
				//position du monstre
				destination.x := it.tabItem[indice].x;
				destination.y := it.tabItem[indice].y;
				//affichage de l'image correspondante dans le tableau image
				SDL_BlitSurface(image[it.tabItem[indice].param + rangMonstres],NIL,window,@destination);
			end;

		'bombe':
			begin
				//position de la bombe
				destination.x := it.tabItem[indice].x;
				destination.y := it.tabItem[indice].y;
				//affichage de l'image correspondante dans le tableau image
				SDL_BlitSurface(image[it.tabItem[indice].param + rangBombes],NIL,window,@destination);
			end;	

			
		'missile':
			begin
				//position du missile
				destination.x := it.tabItem[indice].x;
				destination.y := it.tabItem[indice].y;
				//affichage de l'image correspondante dans le tableau image
				SDL_BlitSurface(image[it.tabItem[indice].param + rangMissiles],NIL,window,@destination);
			end;
		
		'vaisseau':
			begin
				//position du vaissseau
				destination.x := ship.pos.x;
				destination.y := ship.pos.y;
				//affichage de l'image correspondante dans le tableau image
				SDL_BlitSurface(image[ship.pos.param + rangVaisseaux],NIL,window,@destination);

			end;
			
	end;
end;




procedure cacheSdl(it : item; ship : vaisseau; objet : string{monstre, bombe, missile ou vaisseau}; indice : integer{indice dans tabItem // si vaisseau mettre 0});
var destination : TSDL_RECT;

begin
	case objet of
		'monstre':
			begin
				//position du monstre
				destination.x := it.tabItem[indice].x;
				destination.y := it.tabItem[indice].y;
				//affichage de l'image correspondante dans le tableau cache
				SDL_BlitSurface(cache[it.tabItem[indice].param + rangMonstres],NIL,window,@destination);
			end;

		'bombe':
			begin
				//position de la bombe
				destination.x := it.tabItem[indice].x;
				destination.y := it.tabItem[indice].y;
				//affichage de l'image correspondante dans le tableau cache
				SDL_BlitSurface(cache[it.tabItem[indice].param + rangBombes],NIL,window,@destination);
			end;
			
		'missile':
			begin
				//position du missile
				destination.x := it.tabItem[indice].x;
				destination.y := it.tabItem[indice].y;
				//affichage de l'image correspondante dans le tableau cache
				SDL_BlitSurface(cache[it.tabItem[indice].param + rangMissiles],NIL,window,@destination);
			end;
		
		'vaisseau':
			begin
				//position du vaissseau
				destination.x := ship.pos.x;
				destination.y := ship.pos.y;
				//affichage de l'image correspondante dans le tableau cache
				SDL_BlitSurface(cache[ship.pos.param + rangVaisseaux],NIL,window,@destination);
			end;
			
	end;
end;




procedure deplacementSdl(var it : item; var ship : vaisseau; objet : string{'monstre', 'bombe', 'missile' ou 'vaisseau'}; direction : char{h, b, g ou d}; distance, indice : integer{indice dans tabItem // si vaisseau mettre 0});

begin
	cacheSdl(it,ship,objet,indice);		//on efface l'image précédente
	
	if objet <> 'vaisseau' then			//cas d'un item
		case direction of
			'h' : it.tabItem[indice].y := it.tabItem[indice].y - distance;
			'b' : it.tabItem[indice].y := it.tabItem[indice].y + distance;
			'd' : it.tabItem[indice].x := it.tabItem[indice].x + distance;
			'g' : it.tabItem[indice].x := it.tabItem[indice].x - distance;
		end;
	
	if objet = 'vaisseau' then			//cas d'un vaisseau
		case direction of
			'h' : ship.pos.y := ship.pos.y - distance;
			'b' : ship.pos.y := ship.pos.y + distance;
			'd' : ship.pos.x := ship.pos.x + distance;
			'g' : ship.pos.x := ship.pos.x - distance;
		end;
	
	afficheSdl(it,ship,objet,indice);	//on affiche l'objet à son nouvel emplacement
			
end;



procedure initMusic(var son : music);
var i: integer;
	fichier : text;
begin
	//Initialisation des paramètres de musique
	son.pause := false;
	son.volume := 50;
	assign(fichier,'ressources/musique/repertoire.txt');
	reset(fichier);
	for i := 1 to max_musique do	
		readln(fichier,son.nom[i]);
	close(fichier);
end;




procedure volumeMusique(modif : integer; var son: music);
begin
	//Aumentation ou diminution du volume
	son.volume := son.volume + modif;
	MIX_VolumeMusic(son.volume);	
	//Actualisation
	if MIX_OpenAudio(22050 , audio_s16 ,2 ,4096 ) <> 0 then halt;
end;




procedure pauseMusique(var son : music);		//mise en pause de la musique
begin
	son.pause := true;
	Mix_PauseMusic;
end;




procedure lancerMusique(indice : integer; var son : music);
var fichier : text;
	str, nom : string;
	pointer : pchar;
	i : integer;
	
begin
	if not son.pause then		//Si l'on n'est pas en pause, lancement de la musique demandée
	begin
		SDL_Init(SDL_INIT_AUDIO);
		assign(fichier,'ressources/musique/repertoire.txt');
		reset(fichier);
		for i := 1 to indice - 1 do
			readln(fichier);
		readln(fichier,nom);
		str := 'ressources/musique/' + nom + '.wav';
		if MIX_OpenAudio(22050 , audio_s16 ,2 ,4096 ) <> 0 then halt;	
		pointer := StrAlloc(length(str)+1);
		strPCopy(pointer, str);
		son.musique := MIX_LOADMUS(pointer);
		
		MIX_VolumeMusic(son.volume);
		MIX_PlayMusic(son.musique ,  -1);
		close(fichier);
	end
	else 						//Si l'on est en pause, sortie de pause
	begin
		Mix_ResumeMusic;
		son.pause := false;
	end;
end;




procedure finMusique(var son : music);	//Arrêt de l'audio
begin	
	Mix_CloseAudio;
end;




procedure ecrire(texte : String; x,y,taille, rouge, vert, bleu : integer);
var position : TSDL_Rect;
	police : pTTF_Font;
	zonetexte : PSDL_Surface;
	ptxt : pChar;
	couleur : PSDL_Color;

begin
	ttf_INIT;
	
	new(couleur);
	
	//choix de la couleur
	couleur ^.r := rouge;  
	couleur ^.g := vert;
	couleur ^.b := bleu;
	
	//Choix fichier de police
	police := TTF_OPENFONT('ressources/police/game.ttf',taille );
	
	
	//affectation du pointer et affichage
	ptxt:= StrAlloc(length(texte)+1);
	StrPCopy(ptxt ,texte);
	
	zonetexte := TTF_RENDERTEXT_BLENDED(police , ptxt ,couleur ^);
	
	position.x := x;
	position.y := y;
	
	SDL_BlitSurface(zonetexte , NIL , window ,@position );
	
	//Déchargement
	DISPOSE(couleur);
	strDispose(ptxt);
	
	TTF_CloseFont(police);
	
	TTF_Quit ();
	SDL_FreeSurface(zonetexte);


end;




procedure explosionItem(var explo : dataExplo); //initialiser avec avancement := 1 et explosionEnCours := true pour lancer une explosion
var direction : TSDL_Rect;
	tMesure : tSystemTime;

begin
	if explo.enCours then
	begin
		//position de l'explosion
		direction.x := explo.x;
		direction.y := explo.y;
		
		DateTimeToSystemTime(Now,tMesure);
		
		//Si le temps minimal requis entre 2 images est atteint affichage de l'image suivante
		if (explo.avancement < 9) and (diffTemps(tMesure,explo.time) > 100) then
		begin
			if explo.avancement > 1 then
				SDL_BlitSurface(cache[rangDivers + explo.avancement - 1],NIL,window,@direction);
			SDL_BlitSurface(image[rangDivers + explo.avancement],NIL,window,@direction);
			DateTimeToSystemTime(Now,explo.time);			//réinitialisation du temps de référence
			explo.avancement := explo.avancement + 1;		//incrementation du compteur d'image
		end;
		
		if (explo.avancement = 9) and (diffTemps(tMesure,explo.time) > 100) then
		begin
			//fin de l'explosion, réinitialisation des paramètres
			explo.avancement := 1;
			explo.enCours := false;
			SDL_BlitSurface(cache[rangDivers + 8],NIL,window,@direction);
		end;
	end;
end;




Procedure exploGeneral(var explo : tabExplo);		//effectue toutes les explosions
var i : integer;
begin
	for i := 1 to MAXEXPLO do
		explosionItem(explo[i]);
end;




procedure ecranGameOver;	//animation de game over
var i : integer;
	dir : TSDL_Rect;
begin
	SDL_FillRect(window, NIL, 0);
	
	for i := 0 to 8 do
	begin
		if i > 0 then
		dir.x := (dimensionX div 2) - (1400 div 2) ;
		dir.y := (dimensionY div 2) - (1050 div 2) ;
		sdl_blitSurface(cache[rangDivers + 9 + i], NIL, window, @dir);
		
		dir.x := (dimensionX div 2) - (1400 div 2) ;
		dir.y := (dimensionY div 2) - (1050 div 2) ;
		sdl_blitSurface(image[rangDivers + 10 + i], NIL, window, @dir);
		sdl_flip(window);
		delay(50);
	end;
	delay(1000);
	
end;




function clicRectangle(pos1X, pos1Y, pos2X, pos2Y, clicX, clicY : integer): boolean;	//fonction qui vérifie si des coordonnées catésiennes sont dans un rectangle
begin
	clicRectangle := false;
	if (pos1X < clicX) and (clicX < pos2X) then
		if (pos1Y < clicY) and (clicY < pos2Y) then
			clicRectangle := true;
end;




function clicCercle(oX, oY, rayon, clicX, clicY : integer): boolean;	//fonction qui vérifie si des coordonnées catésiennes sont dans un cercle
begin
	clicCercle := false;
	if (((oX - clicX)*(oX - clicX))+((oY - clicY)*(oY - clicY))) <= (rayon*rayon) then
		clicCercle := true;
end;




procedure lectureBoutonSouris(var x, y : longint {si rien de cliqué retourne (-1,-1)}); 	//retourne les coordonnées catésiennes de la souris après un clic
var event : TSDL_event;
begin
	x := -1;
	y := -1;
	sdl_pollEvent(@event);
	if event.type_ = SDL_mouseButtonDown then 
		sdl_getMouseState(x, y);
end;


	

procedure afficheVie(ship : vaisseau);		
var i : integer;
	position : tsdl_rect;
begin
	position.y := 14;
	//affichage des coeurs pleins
	for i := 1 to ship.pos.nbVie do
	begin
		position.x := 100 * i;
		sdl_BlitSurface(image[9 + rangDivers], nil, window, @position);
	end;
	//Affichage des coeurs vides
	for i := 3 downto ship.pos.nbVie+1 do
	begin
		position.x := 100 * i;
		sdl_BlitSurface(cache[9 + rangDivers], nil, window, @position);
	end;
end;




procedure affichageMini(tab : tabTaille; dataShip : dataVaisseau; i : integer);
var positionMissile, positionVaisseau : Tsdl_rect;
begin
	if i = 1 then	//si grand ecran
	begin
		//affichage des petits vaisseau et missile sélectionnés dans le menu
		positionMissile.x := 1700 - (tab[dataShip.munition + rangDivers + 44]['x'] div 2);
		positionMissile.y := 755 - (tab[dataShip.munition + rangDivers + 44]['y'] div 2);
		positionVaisseau.x := 1600 - (tab[dataShip.numero + rangDivers + 34]['x'] div 2);
		positionVaisseau.y := 755 - (tab[dataShip.numero + rangDivers + 34]['y'] div 2);
		sdl_blitsurface(image[dataShip.numero + 34 + rangDivers],nil,window,@positionVaisseau);
		sdl_blitsurface(image[dataShip.munition + 44 + rangDivers],nil,window,@positionMissile);
	end
	else	//si petit ecran
	begin
		//affichage des petits vaisseau et missile sélectionnés dans le menu
		positionMissile.x := 1135 - (tab[dataShip.munition + rangDivers + 44]['x'] div 2);
		positionMissile.y := 505 - (tab[dataShip.munition + rangDivers + 44]['y'] div 2);
		positionVaisseau.x := 1065 - (tab[dataShip.numero + rangDivers + 34]['x'] div 2);
		positionVaisseau.y := 505 - (tab[dataShip.numero + rangDivers + 34]['y'] div 2);
		sdl_blitsurface(image[dataShip.numero + 34 + rangDivers],nil,window,@positionVaisseau);
		sdl_blitsurface(image[dataShip.munition + 44 + rangDivers],nil,window,@positionMissile);
	end;
end;




procedure afficheVolume(son : music; i : integer);	//affichage du volume 
var str : string;
begin
	str := 'Volume : ' + intToStr(son.volume);
	if i = 1 then
		ecrire(str, 740, 920, 40, 0,0,0)
	else 
		ecrire(str, 495,615, 25, 0,0,0);
	
end;


	

procedure barreVie(vieActuelle,VieMax : integer);
var i : integer;
	position,p : tsdl_rect;
begin
	//affichage de la barre de vie pleine
	position.x := (dimensionX div 2) - 251;
	position.y := 30;
	sdl_blitsurface(cache[rangDivers + 38],nil,window,@position);
	
	//Si le total de vies est inférieur au maximum de vies totales
	if vieActuelle < VieMax then
	begin
		//on elève une proportion de la barre égale à la proportion de vie perdue
		for i := 492 downto trunc(492*(vieActuelle/VieMax)) do
			if i >= 0 then
			begin
				p.x := (dimensionX div 2) + 246 - (492 - i);
				p.y := 34;
				sdl_blitsurface(cache[rangDivers + 39],nil,window,@p);
			end;		
		sdl_blitsurface(cache[rangDivers + 37],nil,window,@position);
	end;
end;

	
END.
