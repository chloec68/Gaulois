-- CORRECTION 
-- > mettre toutes les clauses SQL en MAJ pour meilleure lisibilité 
-- > mettre un nom approprié à tous les ALIAS 
-- > 2. : le GROUP BY doit toujours être réalisé sur une clé primaire/étrangère (>id.lieu dans cet exemple au lieu de nom_lieu), sinon la requête 
-- est juste à condition que tous les noms de village soient différents, sinon risque de fusion en cas de doublon 
-- > corriger toutes les requêtes qui utilisent GROUP BY 
-- > 8.,10.,13. : il ne faut pas utiliser MAX, ni LIMIT (en raison des ex aequo) -> ALL 
-- > 9. : un gaulois peut boire plusieurs fois, il faut donc additionner les doses bues ; qui dit fonction d'aggrégation 
-- (COUNT, SUM, MAX, MIN, AVG) dit "GROUP BY"
-- > 14. C'est juste, mais utiliser clause NOT IN + sous requête pour parvenir au même résultat  


-- 1. Nom des lieux qui finissent par 'um'
SELECT nom_lieu FROM lieu WHERE nom_lieu LIKE '%um'

-- 2. Nombre de personnages par lieu (trié dans l'ordre décroissant)
SELECT COUNT(nom_personnage) AS nbMaxPersonnages,nom_lieu FROM personnage
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu 
GROUP BY id_lieu
ORDER BY nbMaxPersonnages DESC

-- 3. Nom des personnages + spécialité + adresse et lieu d'habitation, triés par lieu puis par nom
-- de personnage.
SELECT nom_personnage,adresse_personnage,nom_lieu,nom_specialite FROM personnage
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu 
INNER JOIN specialite ON personnage.id_specialite = specialite.id_specialite
ORDER BY nom_lieu,nom_personnage

-- 4. Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de
-- personnages décroissant).
SELECT specialite.nom_specialite, count(id_personnage) AS nbPersonnages FROM specialite
INNER JOIN personnage ON specialite.id_specialite = personnage.id_specialite
GROUP BY specialite.id_specialite
ORDER BY nbPersonnages DESC

-- 5. Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées
-- au format jj/mm/aaaa).
SELECT nom_bataille,DATE_FORMAT(bataille.date_bataille,'%d,%M,%Y') AS date,nom_lieu FROM bataille
INNER JOIN lieu ON bataille.id_lieu = lieu.id_lieu
ORDER BY date DESC

-- 6. Nom des potions + coût de réalisation de la potion (trié par coût décroissant)
SELECT nom_potion,SUM(ingredient.cout_ingredient*composer.qte) AS coutTotalIngredients FROM composer 
INNER JOIN potion ON composer.id_potion = potion.id_potion 
INNER JOIN ingredient ON composer.id_ingredient = ingredient.id_ingredient
GROUP BY id_potion

-- 7. Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'
SELECT ingredient.nom_ingredient,nom_potion, ingredient.cout_ingredient, qte FROM ingredient
INNER JOIN composer ON ingredient.id_ingredient = composer.id_ingredient
INNER JOIN potion ON composer.id_potion = potion.id_potion
WHERE potion.id_potion = 3

-- 8. Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village
-- gaulois'

SELECT personnage.nom_personnage, bataille.nom_bataille,SUM(prendre_casque.qte) 
FROM personnage 
JOIN prendre_casque ON personnage.id_personnage = prendre_casque.id_personnage
JOIN bataille ON prendre_casque.id_bataille = bataille.id_bataille
WHERE bataille.id_bataille = 1 
GROUP BY personnage.id_personnage, personnage.nom_personnage
HAVING SUM(prendre_casque.qte) >= ALL (
    SELECT SUM(pc.qte)
    FROM prendre_casque pc
    JOIN bataille b ON pc.id_bataille = b.id_bataille
    WHERE b.id_bataille = 1
    GROUP BY pc.id_personnage
);

-- La sous-requête retourne, pour chaque personnage, la somme des quantités de casques pris dans la bataille du village gaulois 
-- La requête principale calcule la somme des casques pris par chaque perso dans la bataille du village gaulois, puis elle filtre 
-- pour ne retenir que les personnes dont la somme des casques pris est égale ou supérieure à celle des autres personnages 

-- L'utilisation de l'alias est essentielle pour que la requête fonctionne : il faut distinguer les tables de la requête principale et de la sous-requête, car même s'il s'agit de la même table, il s'agit d'instances différentes de cette table:
-- dans une requête, lorsque l'on fait plusieurs fois références à une même table, on utilise un alias différent et chaque 
-- référence est alors considérée comme une instance de la table (même si touts les instances se référent à la même table).

-- en l'espèce, la sous-requête fait référence à la même table, mais dans un "contexte" différent, c'est à dire pour une 
-- utilisation différente : 

-- dans la requête principale : utilisation de prendre_casque pour récupérer les personnages ayant pris un ou des casques dans la bataille et la sommes/le nombre total des casques qu'ils ont pris puis fonction de filtrage de la sous-requête et comparaison des résultats 
-- dans la sous-requête : utilisation de la table prendre_casque pour obtenir la somme des casque pris 


-- 9. Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur
-- au plus petit)

SELECT SUM(dose_boire) AS totalDosesBues, nom_personnage
FROM boire
INNER JOIN personnage ON boire.id_personnage = personnage.id_personnage
GROUP BY personnage.id_personnage
ORDER BY totalDosesBues DESC

-- 10. Nom de la bataille où le nombre de casques pris a été le plus important.

SELECT SUM(qte),nom_bataille
FROM prendre_casque 
INNER JOIN bataille ON prendre_casque.id_bataille = bataille.id_bataille
GROUP BY prendre_casque.id_bataille
HAVING SUM(qte) > ALL (
    SELECT SUM(qte) as totalCasquePris
    FROM prendre_casque pc
    INNER JOIN bataille b ON pc.id_bataille = b.id_bataille
    GROUP BY pc.id_bataille,pc.qte
    )
LIMIT 1

-- Résultat sans LIMIT 1 : "Bataille du village gaulois 101" + "Anniversaire d'Obélix 76"

-- 11. Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par
-- nombre décroissant)
SELECT nom_type_casque, sum(cout_casque) FROM casque 
INNER JOIN type_casque ON casque.id_type_casque = type_casque.id_type_casque
GROUP BY id_type_casque

-- 12. Nom des potions dont un des ingrédients est le poisson frais.
SELECT potion.nom_potion FROM composer 
INNER JOIN potion ON composer.id_potion = potion.id_potion
WHERE id_ingredient= 24 

-- 13. Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois.
SELECT MAX(personnage.id_personnage) AS nbMaxPersonnages,lieu.nom_lieu 
FROM lieu
INNER JOIN personnage ON lieu.id_lieu = personnage.id_lieu 
WHERE lieu.id_lieu !=1
GROUP BY lieu.id_lieu
ORDER BY nbMaxPersonnages DESC

-- proposition sans MAX, ni LIMIT avec ALL + sous-requête (FAUX)
 SELECT COUNT(p.id_personnage),l.nom_lieu 
    FROM personnage p
    INNER JOIN lieu l ON l.id_lieu = p.id_lieu
    GROUP BY l.id_lieu
    HAVING COUNT(p.id_personnage) > ALL(
    SELECT COUNT(p2.id_personnage)
    FROM personnage p2
    INNER JOIN lieu l2 ON l2.id_lieu = p2.id_lieu
    GROUP BY l2.id_lieu
)

-- 14. Nom des personnages qui n'ont jamais bu aucune potion.
SELECT nom_personnage
FROM personnage p
LEFT JOIN boire b ON p.id_personnage = b.id_personnage
WHERE b.id_personnage IS NULL;

-- ALTERNATIVE AVEC CLAUSE NOT IN + sous requête 

SELECT nom_personnage 
FROM personnage
WHERE id_personnage NOT IN (
    SELECT id_personnage
    FROM boire
    WHERE dose_boire > 0
)

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
DELETE FROM casque 
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