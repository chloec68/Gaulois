#------------------------------------------------------------
#        Script MySQL.
#------------------------------------------------------------


#------------------------------------------------------------
# Table: lieu
#------------------------------------------------------------

CREATE TABLE lieu(
        id_lieu  Int  Auto_increment  NOT NULL ,
        nom_lieu Varchar (255) NOT NULL
	,CONSTRAINT lieu_PK PRIMARY KEY (id_lieu)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: bataille
#------------------------------------------------------------

CREATE TABLE bataille(
        id_bataille   Int  Auto_increment  NOT NULL ,
        nom_bataille  Varchar (255) NOT NULL ,
        date_bataille Date NOT NULL ,
        id_lieu       Int NOT NULL
	,CONSTRAINT bataille_PK PRIMARY KEY (id_bataille)

	,CONSTRAINT bataille_lieu_FK FOREIGN KEY (id_lieu) REFERENCES lieu(id_lieu)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: specialite
#------------------------------------------------------------

CREATE TABLE specialite(
        id_specialite  Int  Auto_increment  NOT NULL ,
        nom_specialite Varchar (255) NOT NULL
	,CONSTRAINT specialite_PK PRIMARY KEY (id_specialite)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: personnage
#------------------------------------------------------------

CREATE TABLE personnage(
        id_personnage      Int  Auto_increment  NOT NULL ,
        nom_pesonnage      Varchar (100) NOT NULL ,
        adresse_personnage Varchar (255) NOT NULL ,
        image_personnage   Varchar (255) NOT NULL ,
        id_lieu            Int NOT NULL ,
        id_specialite      Int NOT NULL
	,CONSTRAINT personnage_PK PRIMARY KEY (id_personnage)

	,CONSTRAINT personnage_lieu_FK FOREIGN KEY (id_lieu) REFERENCES lieu(id_lieu)
	,CONSTRAINT personnage_specialite0_FK FOREIGN KEY (id_specialite) REFERENCES specialite(id_specialite)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: type_casque
#------------------------------------------------------------

CREATE TABLE type_casque(
        id_type_casque  Int  Auto_increment  NOT NULL ,
        nom_type_casque Varchar (50) NOT NULL
	,CONSTRAINT type_casque_PK PRIMARY KEY (id_type_casque)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: casque
#------------------------------------------------------------

CREATE TABLE casque(
        id_casque      Int  Auto_increment  NOT NULL ,
        nom_casque     Varchar (50) NOT NULL ,
        cout_casque    Int NOT NULL ,
        id_type_casque Int NOT NULL
	,CONSTRAINT casque_PK PRIMARY KEY (id_casque)

	,CONSTRAINT casque_type_casque_FK FOREIGN KEY (id_type_casque) REFERENCES type_casque(id_type_casque)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: potion
#------------------------------------------------------------

CREATE TABLE potion(
        id_potion  Int  Auto_increment  NOT NULL ,
        nom_potion Varchar (50) NOT NULL
	,CONSTRAINT potion_PK PRIMARY KEY (id_potion)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: ingredient
#------------------------------------------------------------

CREATE TABLE ingredient(
        id_ingredient   Int  Auto_increment  NOT NULL ,
        nom_ingredient  Varchar (100) NOT NULL ,
        cout_ingredient Int NOT NULL
	,CONSTRAINT ingredient_PK PRIMARY KEY (id_ingredient)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: prendre_casque
#------------------------------------------------------------

CREATE TABLE prendre_casque(
        id_personnage Int NOT NULL ,
        id_casque     Int NOT NULL ,
        id_bataille   Int NOT NULL ,
        qte           Int NOT NULL
	,CONSTRAINT prendre_casque_PK PRIMARY KEY (id_personnage,id_casque,id_bataille)

	,CONSTRAINT prendre_casque_personnage_FK FOREIGN KEY (id_personnage) REFERENCES personnage(id_personnage)
	,CONSTRAINT prendre_casque_casque0_FK FOREIGN KEY (id_casque) REFERENCES casque(id_casque)
	,CONSTRAINT prendre_casque_bataille1_FK FOREIGN KEY (id_bataille) REFERENCES bataille(id_bataille)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: autoriser_boire
#------------------------------------------------------------

CREATE TABLE autoriser_boire(
        id_potion     Int NOT NULL ,
        id_personnage Int NOT NULL
	,CONSTRAINT autoriser_boire_PK PRIMARY KEY (id_potion,id_personnage)

	,CONSTRAINT autoriser_boire_potion_FK FOREIGN KEY (id_potion) REFERENCES potion(id_potion)
	,CONSTRAINT autoriser_boire_personnage0_FK FOREIGN KEY (id_personnage) REFERENCES personnage(id_personnage)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: composer
#------------------------------------------------------------

CREATE TABLE composer(
        id_ingredient Int NOT NULL ,
        id_potion     Int NOT NULL ,
        qte           Int NOT NULL
	,CONSTRAINT composer_PK PRIMARY KEY (id_ingredient,id_potion)

	,CONSTRAINT composer_ingredient_FK FOREIGN KEY (id_ingredient) REFERENCES ingredient(id_ingredient)
	,CONSTRAINT composer_potion0_FK FOREIGN KEY (id_potion) REFERENCES potion(id_potion)
)ENGINE=InnoDB;


#------------------------------------------------------------
# Table: boire
#------------------------------------------------------------

CREATE TABLE boire(
        id_personnage Int NOT NULL ,
        id_potion     Int NOT NULL ,
        date_boire    Date NOT NULL ,
        dose_boire    Int NOT NULL
	,CONSTRAINT boire_PK PRIMARY KEY (id_personnage,id_potion)

	,CONSTRAINT boire_personnage_FK FOREIGN KEY (id_personnage) REFERENCES personnage(id_personnage)
	,CONSTRAINT boire_potion0_FK FOREIGN KEY (id_potion) REFERENCES potion(id_potion)
)ENGINE=InnoDB;

