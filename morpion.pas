{ALGORITHME morpion

type
	coordonnees = ENREGISTREMENT
		x, y : ENTIER
FIN

Type
     tableauPoints = TABLEAU[1..5] DE coordonnees

type
	joueur = ENREGISTREMENT
		points : tableauPoints
		nom : CHAINE
		symbole : CHAINE
		manchesGagnees : ENTIER
FIN

procedure deplacement(x, y : ENTIER)
//BUT : Se déplacer dans les cases du morpion
DEBUT
	gotoxy(x*2+1, y*2+1)
FIN

procedure affichageTerrain()
//BUT : Affiche le terrain
DEBUT
	ECRIRE(' | | ')
	ECRIRE('-----')
	ECRIRE(' | | ')
	ECRIRE('-----')
	ECRIRE(' | | ')
FIN

FONCTION selectionCase() : coordonnees
//BUT : Permet au joueur de sélectionner sa CAS
//SORTIE : La CAS sélectionnée
var
	keyPress : CARACTERE
	curseur : coordonnees
DEBUT
	curseur.x<-1
	curseur.y<-1
	deplacement(1,1)
	REPETER
			keyPress<-ReadKey
			CAS keyPress PARMI			
				#72 : SI curseur.y-1 >= 0 ALORS curseur.y<-curseur.y-1 //Up
				#75 : SI curseur.x-1 >= 0 ALORS curseur.x<-curseur.x-1 //Left
				#77 : SI curseur.x+1 <= 2 ALORS curseur.x<-curseur.x+1 //Right
				#80 : SI curseur.y+1 <= 2 ALORS curseur.y<-curseur.y+1 //Down
            FIN
		
		deplacement(curseur.x, curseur.y)

	JUSQU'A keyPress=#13
	selectionCase.x<-curseur.x
	selectionCase.y<-curseur.y
FIN

procedure write(texte : CHAINE ligne : ENTIER)
//BUT : Ecris du texte sur le côté
//ENTREE : Le texte et la ligne sur laquelle on veut qu'elle s'affiche
var
	i: ENTIER
DEBUT
	
	gotoxy(8, ligne)
	ECRIRE('                                       ')

	
	gotoxy(8,ligne)
	
	ECRIRE(texte)
FIN

FONCTION creationPoint(var tabPoints : tableauPoints tabPointsAdverse : tableauPoints nouveauPoint : coordonnees etat : CHAINE) : boolean
//BUT : Crée un point sur une CAS
//ENTREE : Les tableaux des points des deux joueurs, le point à créer et l'état du point, si c'est X ou O

var
	i : ENTIER
	create : boolean
DEBUT
	create<-VRAI
	
	//On vérifie si la CAS est déjà prise
	POUR i<-1 A length(tabPoints) FAIRE
	DEBUT
		SI (tabPoints[i].x = nouveauPoint.x) ET (tabPoints[i].y = nouveauPoint.y) ALORS
			create <- FAUX
	FIN
	
	POUR i<-1 A length(tabPoints) FAIRE
	DEBUT
		SI (tabPointsAdverse[i].x = nouveauPoint.x) ET (tabPointsAdverse[i].y = nouveauPoint.y) ALORS
			create <- FAUX
	FIN
	
	//Si la CAS n'est pas prise
	SI create ALORS
	DEBUT
		//On rajoute le prochain point dans le tableau qui est différent de -1
		POUR i<-1 A length(tabPoints) FAIRE
		DEBUT
			SI (tabPoints[i].x=-1) ALORS
			DEBUT
				tabPoints[i].x <- nouveauPoint.x
				tabPoints[i].y <- nouveauPoint.y
				deplacement(nouveauPoint.x, nouveauPoint.y)
				ECRIRE(etat)
				break
			FIN
		FIN
		creationPoint<-VRAI
	FIN
	SINON
	DEBUT
		write('Cette CAS est déjà prise !', 1)
		LIRE()
		creationPoint<-FAUX
	FIN
FIN

FONCTION ligne(tabPoints : tableauPoints) : boolean
//BUT : Détermine si 3 points sont alignée
//ENTREE : Un tableau de points
//SORTIE : Un booléen vrai si 3 points sont alignés
var
	i, j, k, alignes : ENTIER
DEBUT
	ligne<-FAUX
	
	//Colonnes
	POUR i<-1 A length(tabPoints) FAIRE
	DEBUT
		alignes<-0
		POUR j<-1 A length(tabPoints) FAIRE
		DEBUT
			SI (tabPoints[j].x = tabPoints[i].x) ET (tabPoints[j].x <> -1) ALORS
				alignes<-alignes+1
				SI alignes = 3 ALORS
					ligne<-VRAI
		FIN
	FIN
	
	//Lignes
	POUR i<-1 A length(tabPoints) FAIRE
	DEBUT
		alignes<-0
		POUR j<-1 A length(tabPoints) FAIRE
		DEBUT
			SI (tabPoints[j].y = tabPoints[i].y) ET (tabPoints[j].y <> -1) ALORS
				alignes<-alignes+1
				SI alignes = 3 ALORS
					ligne<-VRAI
		FIN
	FIN
	
	//Diagonales
	POUR i<-1 A length(tabPoints) FAIRE
	DEBUT
		alignes<-0
		POUR j<-1 A length(tabPoints) FAIRE
		DEBUT
			POUR k<-1 A length(tabPoints) FAIRE
			DEBUT
				SI 	(tabPoints[i].x <> tabPoints[j].x) ET (tabPoints[j].x <> tabPoints[k].x) ET (tabPoints[k].x <> tabPoints[i].x) ET
					(tabPoints[i].y <> tabPoints[j].y) ET (tabPoints[j].y <> tabPoints[k].y) ET (tabPoints[k].y <> tabPoints[i].y) ET
					(((tabPoints[i].x = 1) ET (tabPoints[i].y = 1)) or ((tabPoints[j].x = 1) ET (tabPoints[j].y = 1)) or ((tabPoints[k].x = 1) ET (tabPoints[k].y = 1))) ET
					(tabPoints[i].x <> -1) ET (tabPoints[j].x <> -1) ET (tabPoints[k].x <> -1) ET
					(i <> j) ET (j <> k) ET (k <> i) ALORS
						ligne<-VRAI
			FIN
		FIN
	FIN
FIN

procedure initalisation(var tabPoints : tableauPoints)
//BUT : Initialise tous les points à -1
var
	i : ENTIER
DEBUT
	POUR i<-1 A length(tabPoints) FAIRE
	DEBUT
		tabPoints[i].x:=-1
		tabPoints[i].y:=-1
	FIN
FIN

procedure choixNoms(var joueur1, joueur2 : joueur)
//BUT : Permet aux joueurs de choisir leurs noms
var
	erreur : CHAINE
DEBUT
	REPETER
		erreur:=''
		ECRIRE('Entrez le nom du joueur 1 : ')
		LIRE(joueur1.nom)
		ECRIRE('Entrez le nom du joueur 2 : ')
		LIRE(joueur2.nom)
		SI joueur1.nom = joueur2.nom ALORS
			erreur<-erreur+'Les deux noms sont identiques !' + Chr(13)
		SI joueur1.nom = '' ALORS
			erreur<-erreur+'Joueur 1 n''a pas entré son nom !' + Chr(13)
		SI joueur2.nom = '' ALORS
			erreur<-erreur+'Joueur 2 n''a pas entré son nom !' + Chr(13)
			
		ECRIRE(erreur)
	JUSQU'A erreur = ''
FIN

procedure randomSymboles(var joueur1, joueur2 : joueur)
//BUT : Donne un symbole aléatoire aux joueurs
DEBUT
	SI random(2)+1 = 1 ALORS
	DEBUT
		joueur1.symbole:='X'
		joueur2.symbole:='O'
	FIN
	SINON
	DEBUT
		joueur2.symbole:='X'
		joueur1.symbole:='O'
	FIN
	ECRIRE(joueur1.nom, ' joue ', joueur1.symbole)
	ECRIRE(joueur2.nom, ' joue ', joueur2.symbole)
FIN

procedure choixManches(var manches : ENTIER)
//BUT : Demande aux joueurs le nombre de manches qu'ils veulent
DEBUT
	ECRIRE('Entrez le nombre de manches que vous voulez faire : ')
	LIRE(manches)
FIN

var
	selection : coordonnees
	joueur1, joueur2 : joueur
	joueurCours, toursStr, manchesStr : CHAINE
	i, manches, tours : ENTIER
	fichierSorti : TextFile
	tempsDebut, tempsFin : TDateTime
DEBUT
	randomize
	clrscr
	
	assign(fichierSorti, 'morpion.txt')
	
	//Si morpion.txt n'existe pas, on le crée
	SI FileExists('morpion.txt') ALORS
		append(fichierSorti)
	SINON
		rewrite(fichierSorti)

	tempsDebut<-time
	
	//Préparation de la partie
	choixNoms(joueur1, joueur2)
	randomSymboles(joueur1, joueur2)
	choixManches(manches)
	joueur1.manchesGagnees<-0
	joueur2.manchesGagnees<-0
	
	ECRIRE('Appuyez sur Enter pour commencer la partie ...')
	LIRE()

	ECRIRE(fichierSorti, joueur1.nom + ' contre ' + joueur2.nom)
	ECRIRE(fichierSorti, '')
	
	//Partie
	POUR i<-1 A manches FAIRE
	DEBUT
		
		clrscr
	
		affichageTerrain
		
		tours<-0
		
		//Initialisation des points
		initalisation(joueur1.points)
		initalisation(joueur2.points)
	
		//Quel joueur commence en premier
		SI random(2)+1 = 1 ALORS
			joueurCours<-joueur1.nom
		SINON
			joueurCours<-joueur2.nom
		
		//Tour
		REPETER	
			tours<-tours+1
			str(tours, toursStr)
			write('Tour de ' + joueurCours + ' | ' + toursStr, 1)
			selection<-selectionCase()
		
			SI joueurCours = joueur1.nom ALORS
				DEBUT
				SI (creationPoint(joueur1.points, joueur2.points, selection, joueur1.symbole)) ALORS
					joueurCours<-joueur2.nom
				FIN
			SINON
				DEBUT
				SI (creationPoint(joueur2.points, joueur1.points, selection, joueur2.symbole)) ALORS
					joueurCours<-joueur1.nom
				FIN
		JUSQU'A (ligne(joueur1.points)) or (ligne(joueur2.points)) or (tours >= 9)

		//On rajoute des infos sur la manche dans le fichier texte
		str(i, manchesStr)
		ECRIRE(fichierSorti, '  Manche : ' + manchesStr)
		ECRIRE(fichierSorti, '  Tours : ' + toursStr)
		
		//On rajoute le joueur gagnant et on l'affiche à l'écran
		SI ligne(joueur1.points) ALORS
		DEBUT
			ECRIRE(fichierSorti, '  Joueur Gagnant : ' + joueur1.nom)
			ECRIRE(fichierSorti, '')
			SI manches > 1 ALORS write(joueur1.nom + ' gagne la manche.', 1)
			joueur1.manchesGagnees<-joueur1.manchesGagnees+1
		FIN
		SINON SI ligne(joueur2.points) ALORS
		DEBUT
			ECRIRE(fichierSorti, '  Joueur Gagnant : ' + joueur2.nom)
			ECRIRE(fichierSorti, '')
			SI manches > 1 ALORS write(joueur2.nom + ' gagne la manche.', 1)
			joueur2.manchesGagnees<-joueur2.manchesGagnees+1
		FIN
		SINON
		DEBUT
			ECRIRE(fichierSorti, '  Joueur Gagnant : EGALITE')	
			ECRIRE(fichierSorti, '')
			write('Egalité', 1)
		FIN
		
		SI i < manches ALORS
		DEBUT
			write('Appuyez sur Enter pour continuer ...', 2)
			LIRE()
		FIN
		
	FIN
		
	//On affiche le joueur gagnannt la partie et on l'ajoute dans le fichier texte
	SI joueur1.manchesGagnees > joueur2.manchesGagnees ALORS
	DEBUT
		write(joueur1.nom + ' gagne la partie !', 2)
		ECRIRE(fichierSorti, 'Vainqueur de la partie : ' + joueur1.nom)
	FIN
	SINON SI joueur2.manchesGagnees > joueur1.manchesGagnees ALORS
	DEBUT
		write(joueur2.nom + ' gagne la partie !', 2)
		ECRIRE(fichierSorti, 'Vainqueur de la partie : ' + joueur2.nom)
	FIN
	SINON
	DEBUT
		write('Egalité...', 2)
		ECRIRE(fichierSorti, 'Vainqueur de la partie : EGALITE')
	FIN

	tempsFin<-time
	
	//Calcul du temps de la partie et rajout dans le fichier texte
	ECRIRE(fichierSorti, 'Temps de la partie : ' + inttostr(secondsBetween(tempsDebut, tempsFin)) + ' secondes')
	ECRIRE(fichierSorti, '')
	ECRIRE(fichierSorti, '')
	
	close(fichierSorti)
	
	write('Appuyez sur Enter pour quitter ...', 3)
	LIRE()
FIN.}


program morpion;

uses crt, sysutils, DateUtils;

type
	coordonnees = record
		x, y : integer;
end;

Type
     tableauPoints = array[1..5] of coordonnees;

type
	joueur = record
		points : tableauPoints;
		nom : string;
		symbole : string;
		manchesGagnees : integer;
end;

procedure deplacement(x, y : integer);
//BUT : Se déplacer dans les cases du morpion
begin
	gotoxy(x*2+1, y*2+1);
end;

procedure affichageTerrain();
//BUT : Affiche le terrain
begin
	writeln(' | | ');
	writeln('-----');
	writeln(' | | ');
	writeln('-----');
	writeln(' | | ');
end;

function selectionCase() : coordonnees;
//BUT : Permet au joueur de sélectionner sa case
//SORTIE : La case sélectionnée
var
	keyPress : char;
	curseur : coordonnees;
begin
	curseur.x:=1;
	curseur.y:=1;
	deplacement(1,1);
	repeat
			keyPress:=ReadKey;
			case keyPress of				
				#72 : if curseur.y-1 >= 0 then curseur.y:=curseur.y-1; //Up;
				#75 : if curseur.x-1 >= 0 then curseur.x:=curseur.x-1; //Left;
				#77 : if curseur.x+1 <= 2 then curseur.x:=curseur.x+1; //Right;
				#80 : if curseur.y+1 <= 2 then curseur.y:=curseur.y+1; //Down;
            end;
		
		deplacement(curseur.x, curseur.y);

	until keyPress=#13;
	selectionCase.x:=curseur.x;
	selectionCase.y:=curseur.y;
end;

procedure ecrire(texte : string; ligne : integer);
//BUT : Ecris du texte sur le côté
//ENTREE : Le texte et la ligne sur laquelle on veut qu'elle s'affiche
var
	i: integer;
begin
	
	gotoxy(8, ligne);
	write('                                       ');

	
	gotoxy(8,ligne);
	
	write(texte);
end;

function creationPoint(var tabPoints : tableauPoints; tabPointsAdverse : tableauPoints; nouveauPoint : coordonnees; etat : string) : boolean;
//BUT : Crée un point sur une case
//ENTREE : Les tableaux des points des deux joueurs, le point à créer et l'état du point, si c'est X ou O

var
	i : integer;
	create : boolean;
begin
	create:=true;
	
	//On vérifie si la case est déjà prise
	for i:=1 to length(tabPoints) do
	begin
		if (tabPoints[i].x = nouveauPoint.x) and (tabPoints[i].y = nouveauPoint.y) then
			create := false;
	end;
	
	for i:=1 to length(tabPoints) do
	begin
		if (tabPointsAdverse[i].x = nouveauPoint.x) and (tabPointsAdverse[i].y = nouveauPoint.y) then
			create := false;
	end;
	
	//Si la case n'est pas prise
	if create then
	begin
		//On rajoute le prochain point dans le tableau qui est différent de -1
		for i:=1 to length(tabPoints) do
		begin
			if (tabPoints[i].x=-1) then
			begin
				tabPoints[i].x := nouveauPoint.x;
				tabPoints[i].y := nouveauPoint.y;
				deplacement(nouveauPoint.x, nouveauPoint.y);
				write(etat);
				break;
			end;
		end;
		creationPoint:=true;
	end
	else
	begin
		ecrire('Cette case est déjà prise !', 1);
		readln();
		creationPoint:=false;
	end;
end;

function ligne(tabPoints : tableauPoints) : boolean;
//BUT : Détermine si 3 points sont alignée
//ENTREE : Un tableau de points
//SORTIE : Un booléen vrai si 3 points sont alignés
var
	i, j, k, alignes : integer;
begin
	ligne:=false;
	
	//Colonnes
	for i:=1 to length(tabPoints) do
	begin
		alignes:=0;
		for j:=1 to length(tabPoints) do
		begin
			if (tabPoints[j].x = tabPoints[i].x) and (tabPoints[j].x <> -1) then
				alignes:=alignes+1;
				if alignes = 3 then
					ligne:=true;
		end;
	end;
	
	//Lignes
	for i:=1 to length(tabPoints) do
	begin
		alignes:=0;
		for j:=1 to length(tabPoints) do
		begin
			if (tabPoints[j].y = tabPoints[i].y) and (tabPoints[j].y <> -1) then
				alignes:=alignes+1;
				if alignes = 3 then
					ligne:=true;
		end;
	end;
	
	//Diagonales
	for i:=1 to length(tabPoints) do
	begin
		alignes:=0;
		for j:=1 to length(tabPoints) do
		begin
			for k:=1 to length(tabPoints) do
			begin
				if 	(tabPoints[i].x <> tabPoints[j].x) and (tabPoints[j].x <> tabPoints[k].x) and (tabPoints[k].x <> tabPoints[i].x) and
					(tabPoints[i].y <> tabPoints[j].y) and (tabPoints[j].y <> tabPoints[k].y) and (tabPoints[k].y <> tabPoints[i].y) and
					(((tabPoints[i].x = 1) and (tabPoints[i].y = 1)) or ((tabPoints[j].x = 1) and (tabPoints[j].y = 1)) or ((tabPoints[k].x = 1) and (tabPoints[k].y = 1))) and
					(tabPoints[i].x <> -1) and (tabPoints[j].x <> -1) and (tabPoints[k].x <> -1) and
					(i <> j) and (j <> k) and (k <> i) then
						ligne:=true;
			end;
		end;
	end;
end;

procedure initalisation(var tabPoints : tableauPoints);
//BUT : Initialise tous les points à -1
var
	i : integer;
begin
	for i:=1 to length(tabPoints) do
	begin
		tabPoints[i].x:=-1;
		tabPoints[i].y:=-1;
	end;
end;

procedure choixNoms(var joueur1, joueur2 : joueur);
//BUT : Permet aux joueurs de choisir leurs noms
var
	erreur : string;
begin
	repeat
		erreur:='';
		write('Entrez le nom du joueur 1 : ');
		readln(joueur1.nom);
		write('Entrez le nom du joueur 2 : ');
		readln(joueur2.nom);
		if joueur1.nom = joueur2.nom then
			erreur:=erreur+'Les deux noms sont identiques !' + Chr(13);
		if joueur1.nom = '' then
			erreur:=erreur+'Joueur 1 n''a pas entré son nom !' + Chr(13);
		if joueur2.nom = '' then
			erreur:=erreur+'Joueur 2 n''a pas entré son nom !' + Chr(13);
			
		writeln(erreur);
	until erreur = '';
end;

procedure randomSymboles(var joueur1, joueur2 : joueur);
//BUT : Donne un symbole aléatoire aux joueurs
begin
	if random(2)+1 = 1 then
	begin
		joueur1.symbole:='X';
		joueur2.symbole:='O';
	end
	else
	begin
		joueur2.symbole:='X';
		joueur1.symbole:='O';
	end;
	writeln(joueur1.nom, ' joue ', joueur1.symbole);
	writeln(joueur2.nom, ' joue ', joueur2.symbole);
end;

procedure choixManches(var manches : integer);
//BUT : Demande aux joueurs le nombre de manches qu'ils veulent
begin
	write('Entrez le nombre de manches que vous voulez faire : ');
	readln(manches);
end;

var
	selection : coordonnees;
	joueur1, joueur2 : joueur;
	joueurCours, toursStr, manchesStr : string;
	i, manches, tours : integer;
	fichierSorti : TextFile;
	tempsDebut, tempsFin : TDateTime;
begin
	randomize;
	clrscr;
	
	assign(fichierSorti, 'morpion.txt');
	
	//Si morpion.txt n'existe pas, on le crée
	if FileExists('morpion.txt') then
		append(fichierSorti)
	else
		rewrite(fichierSorti);

	tempsDebut:=time;
	
	//Préparation de la partie
	choixNoms(joueur1, joueur2);
	randomSymboles(joueur1, joueur2);
	choixManches(manches);
	joueur1.manchesGagnees:=0;
	joueur2.manchesGagnees:=0;
	
	writeln('Appuyez sur Enter pour commencer la partie ...');
	readln();

	writeln(fichierSorti, joueur1.nom + ' contre ' + joueur2.nom);
	writeln(fichierSorti, '');
	
	//Partie
	for i:=1 to manches do
	begin
		
		clrscr;
	
		affichageTerrain;
		
		tours:=0;
		
		//Initialisation des points
		initalisation(joueur1.points);
		initalisation(joueur2.points);
	
		//Quel joueur commence en premier
		if random(2)+1 = 1 then
			joueurCours:=joueur1.nom
		else
			joueurCours:=joueur2.nom;
		
		//Tour
		repeat	
			tours:=tours+1;
			str(tours, toursStr);
			ecrire('Tour de ' + joueurCours + ' | ' + toursStr, 1);
			selection:=selectionCase();
		
			if joueurCours = joueur1.nom then
				begin
				if (creationPoint(joueur1.points, joueur2.points, selection, joueur1.symbole)) then
					joueurCours:=joueur2.nom;
				end
			else
				begin
				if (creationPoint(joueur2.points, joueur1.points, selection, joueur2.symbole)) then
					joueurCours:=joueur1.nom;
				end;
		until (ligne(joueur1.points)) or (ligne(joueur2.points)) or (tours >= 9);

		//On rajoute des infos sur la manche dans le fichier texte
		str(i, manchesStr);
		writeln(fichierSorti, '  Manche : ' + manchesStr);
		writeln(fichierSorti, '  Tours : ' + toursStr);
		
		//On rajoute le joueur gagnant et on l'affiche à l'écran
		if ligne(joueur1.points) then
		begin
			writeln(fichierSorti, '  Joueur Gagnant : ' + joueur1.nom);
			writeln(fichierSorti, '');
			if manches > 1 then ecrire(joueur1.nom + ' gagne la manche.', 1);
			joueur1.manchesGagnees:=joueur1.manchesGagnees+1;
		end
		else if ligne(joueur2.points) then
		begin
			writeln(fichierSorti, '  Joueur Gagnant : ' + joueur2.nom);
			writeln(fichierSorti, '');
			if manches > 1 then ecrire(joueur2.nom + ' gagne la manche.', 1);
			joueur2.manchesGagnees:=joueur2.manchesGagnees+1;
		end
		else
		begin
			writeln(fichierSorti, '  Joueur Gagnant : EGALITE');	
			writeln(fichierSorti, '');
			ecrire('Egalité', 1);
		end;
		
		if i < manches then
		begin
			ecrire('Appuyez sur Enter pour continuer ...', 2);
			readln();
		end;
		
	end;
		
	//On affiche le joueur gagnannt la partie et on l'ajoute dans le fichier texte
	if joueur1.manchesGagnees > joueur2.manchesGagnees then
	begin
		ecrire(joueur1.nom + ' gagne la partie !', 2);
		writeln(fichierSorti, 'Vainqueur de la partie : ' + joueur1.nom);
	end
	else if joueur2.manchesGagnees > joueur1.manchesGagnees then
	begin
		ecrire(joueur2.nom + ' gagne la partie !', 2);
		writeln(fichierSorti, 'Vainqueur de la partie : ' + joueur2.nom);
	end
	else
	begin
		ecrire('Egalité...', 2);
		writeln(fichierSorti, 'Vainqueur de la partie : EGALITE');
	end;

	tempsFin:=time;
	
	//Calcul du temps de la partie et rajout dans le fichier texte
	writeln(fichierSorti, 'Temps de la partie : ' + inttostr(secondsBetween(tempsDebut, tempsFin)) + ' secondes');
	writeln(fichierSorti, '');
	writeln(fichierSorti, '');
	
	close(fichierSorti);
	
	ecrire('Appuyez sur Enter pour quitter ...', 3);
	readln();
end.