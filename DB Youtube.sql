-- Table des utilisateurs
CREATE TABLE Utilisateurs (
    utilisateur_id INT PRIMARY KEY,
    nom_utilisateur VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    mot_de_passe_hache VARCHAR(255) NOT NULL,
    url_photo_profil VARCHAR(255),
    biographie CLOB, -- CLOB est un gros bloc de texte
    est_verifie NUMBER(1) DEFAULT 0, -- Booléen par default qui est faux (0)
    cree_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des rôles
CREATE TABLE Roles (
    role_id INT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE
);

-- Table des rôles des utilisateurs
CREATE TABLE RolesUtilisateurs (
    role_utilisateur_id INT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    role_id INT NOT NULL,
    assigne_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id) ON DELETE CASCADE
);

-- Table des vidéos
CREATE TABLE Videos (
    video_id INT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    titre VARCHAR(255) NOT NULL,
    description CLOB,
    url_video VARCHAR(255) NOT NULL,
    url_miniature VARCHAR(255),
    duree INT NOT NULL,
    vues INT DEFAULT 0,
    likes INT DEFAULT 0,
    dislikes INT DEFAULT 0,
    est_publique NUMBER(1) DEFAULT 1,
    categorie_id INT,
    cree_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE,
    FOREIGN KEY (categorie_id) REFERENCES Categories(categorie_id)
);

-- Table pour la recherche
CREATE TABLE Recherche (
    recherche_id INT PRIMARY KEY, -- Identifiant unique pour chaque entrée
    type_contenu VARCHAR(50) NOT NULL, -- Type du contenu (ex: 'video')
    contenu_id INT NOT NULL, -- ID de l'objet associé (video_id, utilisateur_id, etc.)
    mot_cle VARCHAR(255) NOT NULL, -- Mot-clé ou terme associé
    cree_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Date d'ajout de cet index
    FOREIGN KEY (contenu_id) REFERENCES Videos(video_id) ON DELETE CASCADE
);

-- Table de l'historique des recherches
CREATE TABLE HistoriqueRecherches (
    historique_id INT PRIMARY KEY, -- Identifiant unique pour chaque recherche
    utilisateur_id INT NOT NULL, -- L'utilisateur qui a effectué la recherche
    requete VARCHAR(255) NOT NULL, -- Texte de la requête
    resultat_nombre INT DEFAULT 0, -- Nombre de résultats retournés pour cette recherche
    cree_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Date de la recherche
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE
);

-- Table des commentaires
CREATE TABLE Commentaires (
    commentaire_id INT PRIMARY KEY,
    video_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    commentaire_parent_id INT,
    contenu CLOB NOT NULL,
    likes INT DEFAULT 0,
    dislikes INT DEFAULT 0,
    cree_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id) ON DELETE CASCADE,
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE,
    FOREIGN KEY (commentaire_parent_id) REFERENCES Commentaires(commentaire_id) ON DELETE CASCADE
);

-- Table des likes/dislikes pour vidéos et commentaires
CREATE TABLE Likes (
    like_id INT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    video_id INT,
    commentaire_id INT,
    est_like NUMBER(1) NOT NULL,
    cree_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id) ON DELETE CASCADE,
    FOREIGN KEY (commentaire_id) REFERENCES Commentaires(commentaire_id) ON DELETE CASCADE
);

-- Table des playlists
CREATE TABLE Playlists (
    playlist_id INT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    nom VARCHAR(100) NOT NULL,
    description CLOB,
    est_publique NUMBER(1) DEFAULT 1,
    cree_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE
);

CREATE TABLE VideosPlaylists (
    video_playlist_id INT PRIMARY KEY,
    playlist_id INT NOT NULL,
    video_id INT NOT NULL,
    ajoute_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (playlist_id) REFERENCES Playlists(playlist_id) ON DELETE CASCADE,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id) ON DELETE CASCADE
);

-- Table des abonnements
CREATE TABLE Abonnements (
    abonnement_id INT PRIMARY KEY,
    abonne_id INT NOT NULL,
    abonnement_a_id INT NOT NULL,
    cree_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (abonne_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE,
    FOREIGN KEY (abonnement_a_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE
);

-- Table de l'historique
CREATE TABLE HistoriqueVisionnage (
    historique_id INT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    video_id INT NOT NULL,
    visionne_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id) ON DELETE CASCADE
);

-- Table des catégories
CREATE TABLE Categories (
    categorie_id INT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE
);

-- Table des tags
CREATE TABLE Tags (
    tag_id INT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE TagsVideos (
    tag_video_id INT PRIMARY KEY,
    video_id INT NOT NULL,
    tag_id INT NOT NULL,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES Tags(tag_id) ON DELETE CASCADE
);

-- Table des signalements (rapports)
CREATE TABLE Signalements (
    signalement_id INT PRIMARY KEY,
    signale_par INT NOT NULL,
    video_id INT,
    commentaire_id INT,
    raison CLOB NOT NULL,
    cree_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (signale_par) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id) ON DELETE CASCADE,
    FOREIGN KEY (commentaire_id) REFERENCES Commentaires(commentaire_id) ON DELETE CASCADE
);

-- Table des notifications
CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    type VARCHAR(50) NOT NULL,
    message CLOB NOT NULL,
    est_lu NUMBER(1) DEFAULT 0,
    cree_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE
);

-- Table des sessions d'utilisateurs
CREATE TABLE SessionsUtilisateurs (
    session_id INT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    jeton_session VARCHAR(255) NOT NULL,
    cree_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expire_a TIMESTAMP NOT NULL,
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE
);

-- Table des statistiques des vidéos
CREATE TABLE StatistiquesVideos (
    statistique_id INT PRIMARY KEY,
    video_id INT NOT NULL,
    date DATE NOT NULL,
    vues INT DEFAULT 0,
    likes INT DEFAULT 0,
    dislikes INT DEFAULT 0,
    commentaires INT DEFAULT 0,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id) ON DELETE CASCADE
);

-- Table des paramètres utilisateurs
CREATE TABLE ParametresUtilisateurs (
    parametre_id INT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    nom_parametre VARCHAR(100) NOT NULL,
    valeur_parametre VARCHAR(255),
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE
);

-- Table des lives
CREATE TABLE Lives (
    live_id INT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    titre VARCHAR(255) NOT NULL,
    description CLOB,
    url_live VARCHAR(255) NOT NULL,
    est_actif NUMBER(1) DEFAULT 1,
    commence_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    termine_a TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE
);

-- Table des messages de live
CREATE TABLE MessagesLive (
    message_id INT PRIMARY KEY,
    live_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    contenu CLOB NOT NULL,
    envoye_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (live_id) REFERENCES Lives(live_id) ON DELETE CASCADE,
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE
);

-- Table des partages
CREATE TABLE Partages (
    partage_id INT PRIMARY KEY,
    video_id INT NOT NULL,
    partage_par INT NOT NULL,
    partage_avec_email VARCHAR(100),
    partage_avec_utilisateur_id INT,
    message CLOB,
    cree_a TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id) ON DELETE CASCADE,
    FOREIGN KEY (partage_par) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE,
    FOREIGN KEY (partage_avec_utilisateur_id) REFERENCES Utilisateurs(utilisateur_id) ON DELETE CASCADE
);


-- Creation des différents Rôles 

INSERT INTO Roles (role_id, nom) VALUES (1, 'Admin');
INSERT INTO Roles (role_id, nom) VALUES (2, 'Moderateur');
INSERT INTO Roles (role_id, nom) VALUES (3, 'Createur');
INSERT INTO Roles (role_id, nom) VALUES (4, 'Utilisateur');
INSERT INTO Roles (role_id, nom) VALUES (5, 'Invite');
INSERT INTO Roles (role_id, nom) VALUES (6, 'SuperviseurLive');
INSERT INTO Roles (role_id, nom) VALUES (7, 'Annonceur');


-- Nous allons maintenant passer au vues et au droits 

-- Vue des vidéos publiques (invités et utilisateurs standards)
CREATE VIEW Vue_Videos_Visibles AS
SELECT Videos.video_id, Videos.titre, Videos.description, Videos.vues, Utilisateurs.nom_utilisateur AS auteur
FROM Videos, Utilisateurs
WHERE Videos.utilisateur_id = Utilisateurs.utilisateur_id
  AND Videos.est_publique = 1;

-- Vue des commentaires sur les vidéos
CREATE VIEW Vue_Commentaires_Visibles AS
SELECT Commentaires.commentaire_id, Commentaires.video_id, Commentaires.contenu, Utilisateurs.nom_utilisateur AS auteur, Commentaires.cree_a
FROM Commentaires, Utilisateurs
WHERE Commentaires.utilisateur_id = Utilisateurs.utilisateur_id;

CREATE VIEW explorer_musique AS
SELECT
    Videos.titre,
    SUM(StatistiquesVideos.likes) AS Calcul
    FROM Videos, StatistiquesVideos, Categories
    WHERE Videos.categorie_id = Categories.categorie_id and Videos.video_id = StatistiquesVideos.video_id and Categories.nom = 'Musique'
    GROUP BY Videos.titre
    ORDER BY Calcul DESC
    fetch first 50 rows

CREATE VIEW explorer_Films_et_series AS
SELECT
    Videos.titre,
    SUM(StatistiquesVideos.likes) AS Calcul
    FROM Videos, StatistiquesVideos, Categories
    WHERE Videos.categorie_id = Categories.categorie_id and Videos.video_id = StatistiquesVideos.video_id and (Categories.nom = 'Films' OR Categories.nom = 'Séries')
    GROUP BY Videos.titre
    ORDER BY Calcul DESC
    fetch first 50 rows

CREATE VIEW explorer_Jeux_videos AS
SELECT
    Videos.titre,
    SUM(StatistiquesVideos.likes) AS Calcul
    FROM Videos, StatistiquesVideos, Categories
    WHERE Videos.categorie_id = Categories.categorie_id and Videos.video_id = StatistiquesVideos.video_id and Categories.nom = 'Jeux_Videos'
    GROUP BY Videos.titre
    ORDER BY Calcul DESC
    fetch first 50 rows

CREATE VIEW explorer_Tendances AS
SELECT
    Videos.titre,
    SUM(StatistiquesVideos.likes) AS Calcul
    FROM Videos, StatistiquesVideos, Categories
    WHERE Videos.categorie_id = Categories.categorie_id and Videos.video_id = StatistiquesVideos.video_id and Categories.nom = 'Tendances'
    GROUP BY Videos.titre
    ORDER BY Calcul DESC
    fetch first 50 rows;

CREATE VIEW explorer_Actualites AS
SELECT
    Videos.titre,
    SUM(StatistiquesVideos.likes) AS Calcul
    FROM Videos, StatistiquesVideos, Categories
    WHERE Videos.categorie_id = Categories.categorie_id and Videos.video_id = StatistiquesVideos.video_id and Categories.nom = 'Actualités'
    GROUP BY Videos.titre
    ORDER BY Calcul DESC
    fetch first 50 rows;

CREATE VIEW explorer_Sports AS
SELECT
    Videos.titre,
    SUM(StatistiquesVideos.likes) AS Calcul
    FROM Videos, StatistiquesVideos, Categories
    WHERE Videos.categorie_id = Categories.categorie_id and Videos.video_id = StatistiquesVideos.video_id and Categories.nom = 'Sports'
    GROUP BY Videos.titre
    ORDER BY Calcul DESC
    fetch first 50 rows;

CREATE VIEW explorer_Savoir_et_Culture AS
SELECT
    Videos.titre,
    SUM(StatistiquesVideos.likes) AS Calcul
    FROM Videos, StatistiquesVideos, Categories
    WHERE Videos.categorie_id = Categories.categorie_id and Videos.video_id = StatistiquesVideos.video_id and Categories.nom = 'Savoir_et_Culture'
    GROUP BY Videos.titre
    ORDER BY Calcul DESC
    fetch first 50 rows;

CREATE VIEW explorer_Mode_et_Beaute AS
SELECT
    Videos.titre,
    SUM(StatistiquesVideos.likes) AS Calcul
    FROM Videos, StatistiquesVideos, Categories
    WHERE Videos.categorie_id = Categories.categorie_id and Videos.video_id = StatistiquesVideos.video_id and Categories.nom = 'Mode_et_Beaute'
    GROUP BY Videos.titre
    ORDER BY Calcul DESC
    fetch first 50 rows;

CREATE VIEW explorer_Podcast AS
SELECT
    Videos.titre,
    SUM(StatistiquesVideos.likes) AS Calcul
    FROM Videos, StatistiquesVideos, Categories
    WHERE Videos.categorie_id = Categories.categorie_id and Videos.video_id = StatistiquesVideos.video_id and Categories.nom = 'Podcast'
    GROUP BY Videos.titre
    ORDER BY Calcul DESC
    fetch first 50 rows;



-- Vue des signalements propres
CREATE VIEW Vue_Signalements_Propres AS
SELECT 
    signalement_id,
    raison,
    cree_a,
    video_id,
    commentaire_id
FROM 
    Signalements
WHERE 
    signale_par = (SELECT utilisateur_id FROM Utilisateurs WHERE nom_utilisateur = CURRENT_USER);


-- Vue des commentaires sur les vidéos propres d'un créateur
CREATE VIEW Vue_Commentaires_Propres AS
SELECT Commentaires.commentaire_id, Commentaires.video_id, Commentaires.contenu, Commentaires.cree_a
FROM Commentaires, Videos
WHERE Commentaires.video_id = Videos.video_id
  AND Videos.utilisateur_id = Commentaires.utilisateur_id;

-- Vue des vidéos propres d'un créateur
CREATE VIEW Vue_Videos_Propres AS
SELECT Videos.video_id, Videos.titre, Videos.description, Videos.cree_a
FROM Videos
WHERE Videos.utilisateur_id = (SELECT Utilisateurs.utilisateur_id FROM Utilisateurs WHERE Utilisateurs.nom_utilisateur = CURRENT_USER);

-- Vue des likes sur les vidéos (utilisateur standard et créateur)
CREATE VIEW Vue_Likes_Videos AS
SELECT Likes.like_id, Likes.video_id, Likes.utilisateur_id, Likes.est_like, Likes.cree_a
FROM Likes, Videos
WHERE Likes.video_id = Videos.video_id;

-- Vue des abonnements (utilisateur standard)
CREATE VIEW Vue_Abonnements AS
SELECT Abonnements.abonne_id, Abonnements.abonnement_a_id, Utilisateurs.nom_utilisateur AS abonne_a, Abonnements.cree_a
FROM Abonnements, Utilisateurs
WHERE Abonnements.abonnement_a_id = Utilisateurs.utilisateur_id;


-- Vue des propres recherches
CREATE VIEW Vue_Historique_Recherches_Personnelles AS
SELECT h.historique_id, h.requete, h.resultat_nombre, h.cree_a
FROM HistoriqueRecherches h
WHERE h.utilisateur_id = (SELECT utilisateur_id FROM Utilisateurs WHERE nom_utilisateur = CURRENT_USER);


-- Vue des vidéos et commentaires signalés (modérateurs)
CREATE VIEW Vue_Contenus_Signales AS
SELECT 'Video' AS type, Videos.video_id AS contenu_id, Videos.titre AS contenu, Signalements.raison, Signalements.cree_a
FROM Signalements, Videos
WHERE Signalements.video_id = Videos.video_id
UNION ALL
SELECT 'Commentaire', Commentaires.commentaire_id, Commentaires.contenu, Signalements.raison, Signalements.cree_a
FROM Signalements, Commentaires
WHERE Signalements.commentaire_id = Commentaires.commentaire_id;

-- Vue des lives actifs (tous les utilisateurs)
CREATE VIEW Vue_Lives_Visibles AS
SELECT Lives.live_id, Lives.titre, Lives.description, Utilisateurs.nom_utilisateur AS diffuse_par, Lives.commence_a
FROM Lives, Utilisateurs
WHERE Lives.utilisateur_id = Utilisateurs.utilisateur_id
  AND Lives.est_actif = 1;

-- Vue des messages dans les lives (superviseur de live)
CREATE VIEW Vue_Messages_Lives AS
SELECT MessagesLive.message_id, MessagesLive.live_id, MessagesLive.contenu, Utilisateurs.nom_utilisateur AS auteur, MessagesLive.envoye_a
FROM MessagesLive, Utilisateurs
WHERE MessagesLive.utilisateur_id = Utilisateurs.utilisateur_id;

-- Gestion des droits avec GRANT
-- Droits pour les invités
GRANT SELECT ON Vue_Videos_Visibles TO Invite;
GRANT SELECT ON Vue_Commentaires_Visibles TO Invite;
GRANT SELECT ON Vue_Lives_Visibles TO Invite;
GRANT INSERT ON Recherches TO Invite;

-- Droits pour les utilisateurs standards
GRANT SELECT, UPDATE, INSERT, DELETE ON Vue_Likes_Videos TO Utilisateur;
GRANT SELECT, UPDATE,INSERT, DELETE ON Vue_Commentaires_Visibles TO Utilisateur;
GRANT SELECT, INSERT, DELETE ON Vue_Abonnements TO Utilisateur;
GRANT SELECT,INSERT ON Vue_Messages_Lives TO Utilisateur;
GRANT SELECT ON Vue_Videos_Visibles TO Utilisateur;
GRANT SELECT ON Vue_Lives_Visibles TO Utilisateur;
GRANT INSERT ON Recherches TO Utilisateur;
GRANT SELECT, DELETE ON Vue_Historique_Recherches_Personnelles TO Utilisateur;
GRANT SELECT,INSERT ON Vue_Signalements_Propres TO Utilisateur;

-- Droits pour les modérateurs
GRANT SELECT, DELETE ON Vue_Contenus_Signales TO Moderateur;
GRANT SELECT,DELETE ON Videos TO Moderateur;
GRANT SELECT,DELETE ON Commentaires TO Moderateur;
GRANT SELECT,DELETE ON Lives TO Moderateur;
GRANT SELECT,DELETE ON Utilisateurs TO Moderateur;

-- Droits pour les créateurs de contenu
GRANT SELECT, INSERT ON Videos TO Createur;
GRANT SELECT, INSERT ON Lives TO Createur;
GRANT DELETE ON Vue_Commentaires_Propres TO Createur;
GRANT UPDATE,DELETE ON Vue_Videos_Propres TO Createur;
GRANT SELECT,UPDATE, INSERT, DELETE ON Vue_Likes_Videos TO Createur;
GRANT SELECT, UPDATE, INSERT, DELETE ON Vue_Commentaires_Visibles TO Createur;
GRANT INSERT ON Recherches TO Createur;
GRANT SELECT, DELETE ON Vue_Historique_Recherches_Personnelles TO Createur;
GRANT SELECT,INSERT ON Vue_Signalements_Propres TO Createur;

-- Droits pour les superviseurs de live
GRANT SELECT, DELETE ON Vue_Messages_Lives TO SuperviseurLive;
GRANT SELECT ON Vue_Lives_Visibles TO SuperviseurLive;

-- Droits pour les annonceurs
GRANT INSERT ON Annonces TO Annonceur;

-- Droits pour les administrateurs
GRANT ALL PRIVILEGES ON ALL TABLES TO Admin;

