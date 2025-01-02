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
