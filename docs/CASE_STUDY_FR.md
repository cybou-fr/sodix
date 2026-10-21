# Étude de cas — Sodix

**Projet personnel open source — Rust, outil CLI et intégration de primitives cryptographiques.**  
**État :** utilitaire expérimental, sans audit indépendant de sécurité.

## 1. Problème et objectif

Permettre d’utiliser des opérations de signature, de vérification, de chiffrement et de déchiffrement depuis un terminal ou un script, en réutilisant des bibliothèques existantes plutôt qu’en concevant un algorithme cryptographique nouveau.

## 2. Architecture retenue

- **Rust :** binaire système.
- **Clap :** commandes et alias courts utilisables en shell.
- **dryoc :** accès aux primitives Ed25519 et crypto_box de l’écosystème libsodium (Curve25519 / XSalsa20-Poly1305).
- **Entrées/sorties :** messages, fichiers et représentation hexadécimale des clés.

**Flux :** paramètres CLI → lecture ou génération de clés → opération cryptographique → sortie texte ou fichier.

[Code source](../src/main.rs) · [Dépendances](../Cargo.toml)

## 3. Réalisation observable

Le code Rust définit les sous-commandes, les opérations sur clés et l’interface d’exécution. Le README fournit des usages shell et Python, et un [script de démonstration](../test.sh) met en scène un échange chiffré Alice/Bob.

Ces exemples ne prouvent pas la sécurité de chaque flux ni une interopérabilité exhaustive.

## 4. Choix et compromis

| Décision | Bénéfice | Risque / limite |
| --- | --- | --- |
| Réutiliser dryoc | Ne pas réimplémenter la cryptographie | Qualité de l’intégration à vérifier |
| Valeurs hexadécimales | Simplicité de scripting | Exposition possible de clés en arguments ou logs |
| Fichiers de clés | Utilisation locale directe | Permissions, conservation et rotation à durcir |
| Alias courts | Ergonomie CLI | Besoin de tests d’erreurs et de sécurité |

## 5. Validation et limites

Aucun audit cryptographique indépendant n’est revendiqué. Un usage sensible exige une revue de la génération, des permissions de fichiers, de l’exposition des secrets, des messages d’erreur, des vecteurs de tests et de l’interopérabilité.

## 6. Compétences illustrées

Rust, outils système, ergonomie CLI et intégration de bibliothèques spécialisées. Ce petit utilitaire ne prétend pas démontrer à lui seul une architecture distribuée complexe.

[Retour au dépôt](../README.md)
