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

## Programmes utilisés

Windows 2012 R2

Powershell 5.1 pour utiliser les modules SQL **voir lesquels** https://www.microsoft.com/en-us/download/details.aspx?id=54616

Veeam Backup & Restore 9.5 Update 3a (1922) https://download2.veeam.com/VeeamBackup&Replication_9.5.0.1922.Update3a.iso

Pour une infrastructure virtuelle avec vSphere 6.7 :
Veeam Backup & Restore 9.5 Update 4n (2866) https://download2.veeam.com/VeeamBackup&Replication_9.5.4.2866.Update4b_.iso
