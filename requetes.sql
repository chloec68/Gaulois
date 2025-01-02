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

-- 7. Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'
SELECT ingredient.nom_ingredient,nom_potion, ingredient.cout_ingredient, qte from ingredient
INNER JOIN composer on ingredient.id_ingredient = composer.id_ingredient
inner join potion on composer.id_potion = potion.id_potion
where potion.id_potion = 3

-- 8. Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village
-- gaulois'
SELECT MAX(prendre_casque.qte) as qtemax, nom_personnage
FROM prendre_casque
INNER JOIN personnage ON prendre_casque.id_personnage = personnage.id_personnage
WHERE id_bataille = 1
GROUP BY nom_personnage

-- 9. Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur
-- au plus petit)

SELECT dose_boire,nom_personnage from boire
INNER JOIN personnage on boire.id_personnage = personnage.id_personnage
ORDER BY dose_boire DESC

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

-- 12. Nom des potions dont un des ingrédients est le poisson frais.
SELECT potion.nom_potion from composer 
INNER JOIN potion on composer.id_potion = potion.id_potion
WHERE id_ingredient= 24 

-- 13. Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois.
SELECT max(personnage.id_personnage) as maxPersonnages,lieu.nom_lieu 
FROM lieu
INNER JOIN personnage ON lieu.id_lieu = personnage.id_lieu 
WHERE lieu.id_lieu !=1
GROUP BY lieu.nom_lieu
ORDER BY maxPersonnages DESC

-- 14. Nom des personnages qui n'ont jamais bu aucune potion.
SELECT nom_personnage from boire 
left join personnage on boire.id_personnage = personnage.id_personnage
WHERE dose_boire IS NULL

-- 15. Nom du / des personnages qui n'ont pas le droit de boire de la potion 'Magique'.
SELECT nom_personnage FROM personnage
LEFT JOIN autoriser_boire ON personnage.id_personnage = autoriser_boire.id_personnage
AND autoriser_boire.id_potion = 1
WHERE autoriser_boire.id_personnage IS NULL;


-- A. Ajoutez le personnage suivant : Champdeblix, agriculteur résidant à la ferme Hantassion de
-- Rotomagus.
INSERT INTO personnage (nom_personnage,adresse_personnage,id_lieu,id_specialite)
VALUES ('Champdeblix','ferme Hantassion','6',12)

-- B. Autorisez Bonemine à boire de la potion magique, elle est jalouse d'Iélosubmarine...
INSERT INTO autoriser_boire(id_potion, id_personnage)
VALUES ('1','12')

-- C. Supprimez les casques grecs qui n'ont jamais été pris lors d'une bataille.
DELETE from casque 
WHERE id_casque = 2

DELETE FROM type_casque 
WHERE nom_type_casque = 'Grec'

--D. Modifiez l'adresse de Zérozérosix : il a été mis en prison à Condate.
UPDATE personnage 
SET adresse_personnage = 'prison', id_lieu = 9
WHERE id_personnage = 23 

-- E. La potion 'Soupe' ne doit plus contenir de persil. 
DELETE from composer 
WHERE id_potion = 9 AND id_ingredient = 19

-- F. Obélix s'est trompé : ce sont 42 casques Weisenau, et non Ostrogoths, qu'il a pris lors de la bataille 'Attaque
-- de la banque postale'. Corrigez son erreur ! 
UPDATE prendre_casque 
SET id_casque = 10, qte=42
WHERE id_personnage = 5 AND id_bataille = 9