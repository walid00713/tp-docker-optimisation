# TP Optimisation Docker

## 🎯 Objectif
L’objectif de ce TP est d’optimiser le `Dockerfile` d’une application Node.js afin de :
- Réduire la taille de l’image Docker
- Améliorer la reproductibilité et la sécurité
- Mettre en place de bonnes pratiques de conteneurisation
- Documenter les impacts de chaque optimisation

---

## 🏗️ Étapes d’optimisation

### 🔹 Baseline (Dockerfile initial)
- Utilisation de `node:latest`
- Copie directe de `node_modules` depuis l’hôte
- `npm install` après copie du projet complet
- Installation de nombreux paquets système
- Exposition de 3 ports (3000, 4000, 5000)
- Exécution en tant que `root`

👉 **Problèmes** : image lourde, non reproductible, manque de sécurité.

---

### 🔹 Étape 1 : Fixer version Node + nettoyage initial
- Passage de `node:latest` → `node:18`
- Suppression de la copie `node_modules`
- Exposition d’un seul port (3000)

---

### 🔹 Étape 2 : Optimiser le cache
- Séparation de `COPY package*.json` et `COPY . .`
- Permet d’éviter de réinstaller les dépendances à chaque modification du code

---

### 🔹 Étape 3 : Réduire la taille et sécuriser
- Passage à `node:18-alpine` (image plus légère)
- Utilisation de `npm ci --omit=dev` pour installer uniquement les dépendances de prod
- Définition de `NODE_ENV=production`
- Utilisation de l’utilisateur `node` (au lieu de root)

---

### 🔹 Étape 4 : Multi-stage build
- Étape **build** : installation complète + éventuel transpile/test
- Étape **run** : copie du code et installation uniquement des dépendances de prod
- Image finale beaucoup plus légère et propre

---

## 📊 Comparaison des tailles d’images

| Étape      | Dockerfile utilisé     | Taille de l’image | Optimisation appliquée |
|------------|-----------------------|------------------|-------------------------|
| Baseline   | initial               | 1,21 GB           | `node:latest`, copie `node_modules`, installation complète |
| Étape 1    | version Node fixée    | 1,1 GB           | Version LTS stable, port unique |
| Étape 2    | cache npm             | 1,11 GB           | Séparation `COPY` pour le cache npm |
| Étape 3    | alpine + prod only    | 152,76 MB           | `node:18-alpine`, dépendances prod uniquement, USER node |
| Étape 4    | multi-stage build     | 153,44 MB           | Build séparé, image finale minimale |

👉 Remplir les tailles réelles avec `docker images`.

---

## ⚙️ Commandes utiles

### Construire chaque étape
```bash
docker build -t app:baseline  .
docker build -t app:step1  .
docker build -t app:step2  .
docker build -t app:step3  .
docker build -t app:final    .
