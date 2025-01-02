-- Nom des lieux qui finissent par 'um'
SELECT nom_lieu from lieu where nom_lieu LIKE '%um'

-- Nombre de personnages par lieu (trié dans l'ordre décroissant)
SELECT COUNT(nom_personnage) as n,nom_lieu FROM personnage
INNER JOIN lieu on personnage.id_lieu = lieu.id_lieu 
GROUP BY nom_lieu
ORDER BY n DESC

-- Nom des personnages + spécialité + adresse et lieu d'habitation, triés par lieu puis par nom
-- de personnage.
SELECT nom_personnage,adresse_personnage,nom_lieu,nom_specialite from personnage
INNER JOIN lieu on personnage.id_lieu = lieu.id_lieu 
INNER JOIN specialite on personnage.id_specialite = specialite.id_specialite
ORDER BY nom_lieu,nom_personnage

-- Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de
-- personnages décroissant).
select specialite.nom_specialite, count(id_personnage) as n FROM specialite
inner join personnage on specialite.id_specialite = personnage.id_specialite
group by specialite.nom_specialite
order by n DESC

-- Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées
-- au format jj/mm/aaaa).
SELECT nom_bataille,DATE_FORMAT(bataille.date_bataille,'%d,%M,%Y') as date,nom_lieu from bataille
inner join lieu on bataille.id_lieu = lieu.id_lieu
order by date DESC

-- Nom des potions + coût de réalisation de la potion (trié par coût décroissant)
SELECT nom_potion,SUM(ingredient.cout_ingredient*composer.qte) as coutTotalIngredients from composer 
inner join potion on composer.id_potion = potion.id_potion 
inner join ingredient on composer.id_ingredient = ingredient.id_ingredient
group by nom_potion

-- nom_potion 	coutTotalIngredients 	
-- Assouplissement I 	200
-- Assouplissement II 	45.5
-- Coloration pour cheveux 	12
-- Envol 	45
-- Force 	47
-- Gigantisme 	10.5
-- Intelligence 	71
-- Invisibilité 	28
-- Magique 	240
-- Rajeunissement I 	120
-- Rajeunissement II 	86
-- Santé 	1457
-- Soupe 	34.5
-- Vitesse 	42

-- Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'
SELECT ingredient.nom_ingredient,nom_potion, ingredient.cout_ingredient, qte from ingredient
INNER JOIN composer on ingredient.id_ingredient = composer.id_ingredient
inner join potion on composer.id_potion = potion.id_potion
where potion.id_potion = 3

-- nom_ingredient 	nom_potion 	cout_ingredient 	qte 	
-- Bave de crapaud 	Santé 	16.5 	78
-- Huile de roche 	Santé 	30 	3
-- Edelweiss 	Santé 	80 	1

-- Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village
-- gaulois'

