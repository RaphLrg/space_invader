unit TypeSdl;

interface

uses crt, sdl, sdl_image, sdl_ttf, sdl_mixer, sysutils;



{Définition:
Vaisseau = ce que le joueur contrôle
Monstre = ennemis à éliminer
Bombe = projectile des monstres
Missile = projectile du vaisseau 
Item = bombe + missile + monstre
Objet = Item + Vaisseau}



const
//Nombre d'explosions simultanées maximium qui peut s'afficher à l'écran
	MAXEXPLO = 10;
//Volume maximum de la musique 
	max_volume = 100;
//Nombre de musiques maximum 
	max_musique = 5;
//Temps mini entre lesquel les missiles et bombes peuvent se deplacer
    deltaMouvement = 15;




{Les images sont séparées en 5 catégories : Monstres, Missiles, Bombes, Vaisseaux, Divers.
La catégorie divers regroupe toutes les images qui ne correspondent pas au 4 catégories précédentes, on y trouve les images du menu, des explosions, par exemple.
Les images et leur cache correspondant sont stockés dans les deux tableux image et cache définis au-dessous, il y a un tableau d'image et un tableau de cache par catégorie.
total'Categorie' représentent le nombre total d'image en fonction de la catégorie.
rang'Categorie' seront utilisées pour définir le rang d'apparition de la première image appartenent à cette catégorie.
DimensionX, et DimensionY définissent la taille de la fenêtre.
lienMonstres et lienVaisseaux }


var window {pointeur qui correspond à la fenêtre de jeu}, cachescore {pointeur qui correspond à la surface utilisée pour cacher le score}: PSDL_SURFACE; 
	image , cache  : array [1..100] of PSDL_SURFACE; 
	totalMonstres, totalBombes, totalMissiles, totalVaisseaux, totalDivers, rangMonstres, rangBombes, rangMissiles, rangVaisseaux, rangDivers, dimensionX, dimensionY : integer;
	lienMonstres, lienVaisseaux : array [1..20] of integer;


type monEnsemble = set of 0..100;




// TYPES UTILISES POUR LA CARACTERISATION DES ITEMS	ET DU VAISSEAU



{Le type Position regourpe:
- Les coordonnées en x et en y de l'emplacement de l'objet (ils définissent le point en haut à gauche)
- param donne l'emplacement de l'objet au sein de sa catégorie 
- nbVie et utilisée pour les monstres et le vaisseau pour stocker le nombre de vie
- dir donne la direction de déplacement horizontale des monstres dans les niveaux 2 et 3 car chaque monstre à une direction de déplacement propre
- descente permet de gérer les déplacements verticaux des monstres dans les niveaux 2 et 3,
Au bout de chaque ligne les monstres effectuent un petiT déplecement vertical qui est géré par cette variable}

Type Position = record
	x, y, param, nbVie, dir, descente:Integer;
end;


{Le type Item regroupe tous les items présents sur l'écran de jeu à chaque instant dans un tableau.
Ce tableau ragroupe toutes les informations contenues dans Position défini précédemment.
Les ensemble donnent tous les indices de tabItem correspondant à la catégorie qu'ils définissent.
L'ensemble vide donne l'ensemble des cases de tabItem inocupées.}

Type Item = record 
	direction : integer;
// Utilisé uniquement dans le niveau 1 où tou les monstres se déplacent dans le même sens, donne la direction de déplacement.
	tabItem : array [0..100] of Position;
	monstre, bombe, missile, vide : monEnsemble;
end;


{Le type Vaisseau donne les informations liées au vaisseau.
Ils regroupent les informations de Position, plus le score du joueur.}
Type Vaisseau = record
	pos : Position;
	score : longint;								
end;


{regroupe la position de tous les items sur la fenêtre de jeu}
Type tabTaille = array[1..100] of array['x'..'y'] of integer; 

{Exemples d'utilisation: 
tab[it.tabItem[indiceItem].param + rang'Categorie' ]['x']  
tab[ship.pos.param + rangVaisseau ]['y']}





// TYPES LIES AU DEPLACEMENT DES MONSTRES 


{utilisé dans le niveau Duval}
type particule = record
	x,y,charge : real;
// donne l'emplacement de la particule et sa charge (négative ou positive)

	vx,vy : real;
// donne la vitesse de la particule en fonction selon x et selon y 

	num_tab : integer;
// donne le rang du monstre numéro n  dans  tab_item
end;


type param_deplacement_monstre = record
				//champs relatifs aux parametres d'affichages
		gamma_x		,
		gamma_y		:real;
		Distance_x	,
		Distance_y	,
		marge			,
		marge_up		,
		
				//temps entre 2 affichages des monstres
		deltaMonstre 	,
				//vitess des monstres en pixel/sec
		vitesseMonstre  ,
				//distance parcourue en descendant
		marge_descente   : integer;
		
			//variables relatives au mode 4 :
			
				//particules des mur, fixées
		dudu : array[1..196] of particule;
				//monstres qui se déplacent
		mdudu : array[1..15] of particule;
				//nombre de monstres
		nbdudu : integer;
		
				//nombre de vagues
		nb_vague : integer
	end;





// TYPE LIE A LA CARACTERISATION DU VAISSEAU



//Type regroupant les données complementaires sur un vaisseau
Type dataVaisseau =record
	tRight, tLeft, tTir : TSystemTime;
// tRight, tLeft sont des temps de déplacement
// tTir représente la cadence de tir max 
	left, right, tir : boolean;
// left, right, tir permettent de définir si le joueur a déplacé son vaisseau ou tiré un missile
	numero, munition : integer;
end;





//TYPE LIE AU TEMPS



{Ce type regroupe toute les variables qui ont un lien avec le temps, 
* utilisé dans les procédures de déplacement et de génération
* de vagues de monstres }

type tab_temps = record
	vitesse,TRef,Attente,vague,apparition : TSystemTime;
	nb_vie : array [1..10] of TSystemTime;
end;





// TYPES LIES A LA GESTION DES EXPLOSIONS 



//Type regroupe toutes les informations nécessaires à la caracterisation d'une explosion
Type dataExplo =record
	x, y, avancement : integer;
// x et y correspondent à la coordonées du centre de l'explosion
	enCours : boolean;
// est vrai si l'explosion est en cours 
	time : tSystemTime;
end;


//tableau des explosions qui regroupe toutes les explosions possibles du jeu
type tabExplo = array [1..MAXEXPLO] of dataExplo;





// TYP LIE A LA GESTION DES BOMBES 

//Type contenant les données pour la génération des bombes
Type dataTirBombe = record
	delta,mini,maxi:integer;
	time : TSystemTime;
end;





// TYPE LIE A LA GESTION DE LA MUSIQUE 



Type music = record
	volume : integer;
// correspond au volume de la musique
	nom : array [1..max_musique] of string;
// regroupe le nom de toutes les musiques du jeu
	musique : pmix_music;
	pause : boolean;
// permet de gérer lecture et pause 
end;





// PETITES FONCTIONS RECURRENTES 


function taille (ens : monEnsemble) : integer;
// donne la taille d'un ensemble 

function diffTemps(temps2, temps1 : TSystemTime {Temps1 - Temps2}):longint;
// donne une différence de temps 



implementation


// donne la taille d'un ensemble 
function taille (ens : monEnsemble) : integer;
var i : 0..100;
begin
taille := 0;
for i in ens do taille := taille + 1;
	
end;



// donne une différence de temps 
function diffTemps(temps2, temps1 : TSystemTime {Temps1 - Temps2}):longint;

begin
	diffTemps := (temps2.millisecond - temps1.millisecond) + 1000*(temps2.second - temps1.second) + 60000*(temps2.minute - temps1.minute) + 3600*1000*(temps2.hour - temps1.hour) + 3600*1000*24*(temps2.day - temps1.day); //  + 3600*1000*24*30*(temps2.month - temps1.month) + 3600*1000*24*12(temps2.year - temps1.year)
end;



END.

