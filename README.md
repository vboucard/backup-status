# backup-status

## Description

Projet créé afin de mettre en place un site présentant l'état de sauvegardes Veeam, avec une mise à jour automatique.

## Aspect technique

Les sauvegardes sont générées via des scripts Powershell qui déclenchent des sauvegardes sur la version communautaire
de Veeam backup & restore (seul moyen de passer outre la limitation de 10 hôtes sauvegardés).

Le but final serait qu'à la fin de ces sauvegardes, un code Powershell soit déclenché afin de mettre à jour une base Mysql.

Un site web (en PHP ou Python, à voir) présenterait alors aux utilisateurs l'état des sauvegardes.
Un calendrier serait présent sur ce site afin de sélectionner une date.

## Fichiers du projet

_Diagramme1.dia_ pour le modèle physique de données
