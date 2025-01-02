-- 1. Nom des lieux qui finissent par 'um'
SELECT nom_lieu from lieu where nom_lieu LIKE '%um'

-- 2. Nombre de personnages par lieu (trié dans l'ordre décroissant)
SELECT COUNT(nom_personnage) as n,nom_lieu FROM personnage
INNER JOIN lieu on personnage.id_lieu = lieu.id_lieu 
GROUP BY nom_lieu
ORDER BY n DESC

-- 3. Nom des personnages + spécialité + adresse et lieu d'habitation, triés par lieu puis par nom
-- de personnage.
SELECT nom_personnage,adresse_personnage,nom_lieu,nom_specialite from personnage
INNER JOIN lieu on personnage.id_lieu = lieu.id_lieu 
INNER JOIN specialite on personnage.id_specialite = specialite.id_specialite
ORDER BY nom_lieu,nom_personnage

-- 4. Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de
-- personnages décroissant).
select specialite.nom_specialite, count(id_personnage) as n FROM specialite
inner join personnage on specialite.id_specialite = personnage.id_specialite
group by specialite.nom_specialite
order by n DESC

-- 5. Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées
-- au format jj/mm/aaaa).
SELECT nom_bataille,DATE_FORMAT(bataille.date_bataille,'%d,%M,%Y') as date,nom_lieu from bataille
inner join lieu on bataille.id_lieu = lieu.id_lieu
order by date DESC

-- 6. Nom des potions + coût de réalisation de la potion (trié par coût décroissant)
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

-- 7. Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'
SELECT ingredient.nom_ingredient,nom_potion, ingredient.cout_ingredient, qte from ingredient
INNER JOIN composer on ingredient.id_ingredient = composer.id_ingredient
inner join potion on composer.id_potion = potion.id_potion
where potion.id_potion = 3

-- nom_ingredient 	nom_potion 	cout_ingredient 	qte 	
-- Bave de crapaud 	Santé 	16.5 	78
-- Huile de roche 	Santé 	30 	3
-- Edelweiss 	Santé 	80 	1

-- 8. Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village
-- gaulois'
SELECT MAX(prendre_casque.qte) as qtemax, nom_personnage
FROM prendre_casque
INNER JOIN personnage ON prendre_casque.id_personnage = personnage.id_personnage
WHERE id_bataille = 1
GROUP BY nom_personnage

-- 12 	Abraracourcix
-- 21 	Astérix
-- 60 	Obélix

-- 9. Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur
-- au plus petit)

SELECT dose_boire,nom_personnage from boire
INNER JOIN personnage on boire.id_personnage = personnage.id_personnage
ORDER BY dose_boire DESC

--  dose_boire Décroissant 1 	nom_personnage 	
-- 38 	Obélix
-- 20 	Maestria
-- 20 	Agecanonix
-- 14 	Avoranfix
-- 12 	Agecanonix
-- 12 	Vanendfaillevesix
-- 12 	Gueuselambix
-- 9 	Abraracourcix
-- 8 	Septantesix
-- 7 	Acidcloridrix
-- 7 	Ordralfabétix
-- 6 	Assurancetourix
-- 5 	Agecanonix
-- 5 	Pneumatix
-- 5 	Septantesix
-- 3 	Cétautomatix
-- 3 	Changélédix
-- 3 	Choucroutgarnix
-- 3 	Falbala
-- 3 	Moralélastix
-- 2 	Astérix
-- 2 	Assurancetourix
-- 2 	Agecanonix
-- 2 	Panoramix
-- 2 	Zérozérosix

-- 10. Nom de la bataille où le nombre de casques pris a été le plus important.
SELECT nom_bataille, MAX(prendre_casque.qte) AS max_qte
FROM prendre_casque
INNER JOIN bataille ON prendre_casque.id_bataille = bataille.id_bataille
GROUP BY nom_bataille
ORDER BY max_qte DESC
LIMIT 1;

-- MAX(prendre_casque.qte) : Cela permet de sélectionner le nombre maximum de casques pris pour chaque bataille
-- GROUP BY nom_bataille : Grouper les résultats par nom de bataille, afin d'obtenir le nombre de casques pris pour chaque bataille
-- ORDER BY max_qte DESC :Trier les résultats par le nombre maximum de casques pris, en ordre décroissant
-- LIMIT 1 : Cette clause permet de ne récupérer que la première ligne 

-- 11. Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par
-- nombre décroissant)
SELECT nom_type_casque, sum(cout_casque) from casque 
INNER JOIN type_casque on casque.id_type_casque = type_casque.id_type_casque
GROUP BY nom_type_casque
--  nom_type_casque 	sum(cout_casque) 	
-- Autre 	3114
-- Grec 	3558
-- Normand 	14020
-- Romain 	2413

-- 12. Nom des potions dont un des ingrédients est le poisson frais.
SELECT potion.nom_potion from composer 
INNER JOIN potion on composer.id_potion = potion.id_potion
WHERE id_ingredient= 24 
--  nom_potion 	
-- Magique
-- Intelligence

-- 13. Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois.
SELECT max(personnage.id_personnage) as maxPersonnages,lieu.nom_lieu 
FROM lieu
INNER JOIN personnage ON lieu.id_lieu = personnage.id_lieu 
WHERE lieu.id_lieu !=1
GROUP BY lieu.nom_lieu
ORDER BY maxPersonnages DESC

 maxPersonnages Décroissant 1 	nom_lieu 	
45 	Rotomagus
44 	Condate
41 	Nicae
40 	Lugdunum
39 	Lutèce
37 	Massilia
33 	Alesia
32 	Forêt des Carnutes
31 	Gergovie
22 	Gesocribate
20 	Village belge

-- 14. Nom des personnages qui n'ont jamais bu aucune potion.
SELECT nom_personnage from boire 
left join personnage on boire.id_personnage = personnage.id_personnage
WHERE dose_boire IS NULL

-- 15. Nom du / des personnages qui n'ont pas le droit de boire de la potion 'Magique'.
SELECT nom_personnage from autoriser_boire 
INNER JOIN personnage on personnage.id_personnage = autoriser_boire.id_personnage 
WHERE autoriser_boire.id_potion <>1

--  nom_personnage 	
-- Agecanonix
-- Panoramix
-- Arrièreboutix
-- Agecanonix
-- Pneumatix
-- Zérozérosix
-- Acidcloridrix
-- Agecanonix
-- Vanendfaillevesix
-- Gueuselambix
-- Panoramix
-- Maestria
-- Bainpublix
-- Septantesix
-- Obélix
-- Avoranfix
-- Agecanonix
-- Goudurix
-- Septantesix
-- Assurancetourix
-- Bonemine
-- Falbala
-- Acidcloridrix
-- Moralélastix
-- Acidcloridrix