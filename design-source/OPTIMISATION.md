# Optimisation deprice.sn — SEO, images, performance

Réalisée le 30/09/2026.

## Images : 666 Ko → 87 Ko sur les originaux

Les logos partenaires pesaient 588 Ko à eux cinq, pour un affichage à 96×46 px.
Redimensionnés au bord utile (300 px pour les logos, 128 px pour les icônes,
soit environ 3× la taille d'affichage pour les écrans haute densité) puis
réencodés en gardant, pour chaque fichier, la plus légère des deux versions :
couleur pleine (`png32`) ou palette (`png8`).

| Fichier | Avant | Après |
|---|---|---|
| logo-asecna.png | 246 Ko | 30 Ko |
| logo-css.png | 128 Ko | 14 Ko |
| logo-sunu.png | 82 Ko | 7 Ko |
| logo-dgpsn.png | 68 Ko | 13 Ko |
| logo-bit.png | 64 Ko | 13 Ko |
| logo-deprice.png | 31 Ko | 4 Ko |
| logo-deprice-blanc.png | 20 Ko | 1 Ko |
| 6 icônes | 26 Ko | 4 Ko |

Dossier `uploads` complet, miniatures comprises : 1 721 Ko → 1 079 Ko.
Le format PNG est conservé partout, comme demandé initialement. Passer les
logos en WebP (qui gère la transparence) ferait encore gagner environ 60 %,
mais changerait le format.

## Polices : 5 requêtes → 1

Astra et Elementor chargeaient chacun leurs familles **complètes**, soit
4 familles × 18 variantes — **Roboto et Roboto Slab compris, alors qu'aucune
des deux n'est utilisée** (ce sont les valeurs par défaut du kit Elementor,
laissé vide).

`mu-plugins/deprice-performance.php` remplace tout cela par une requête unique
avec les 7 graisses réellement utilisées : Inter 400/500/600 et Space Grotesk
400/500/600/700, en `display=swap`, avec `preconnect` vers `fonts.gstatic.com`.

> Le dequeue classique ne suffit pas : Elementor enfile ses polices trop tard
> (handles `elementor-gf-*`). La suppression se fait donc sur le filtre
> `style_loader_tag`, au moment où la balise est écrite.

Le même fichier retire les scripts d'emojis, oEmbed, RSD et le tag generator.

## Serveur

`.htaccess` : compression `mod_deflate` sur le HTML, CSS, JS, JSON et SVG
(vérifié : `content-encoding: gzip`), et cache navigateur `mod_expires` — un an
sur les images et les polices, un mois sur CSS et JS, zéro sur le HTML.

## SEO

**SEOPress 10.2** installé. Aucune méta description ni balise Open Graph
n'existait auparavant.

- Titre et description rédigés pour chacune des 6 pages : titres de 35 à
  60 caractères, descriptions de 140 à 159.
- Open Graph et Twitter Card (`summary_large_image`) sur toutes les pages,
  image par défaut : le visuel du hero.
- Plan de site XML et `robots.txt` : déjà fournis par le cœur de WordPress,
  vérifiés en 200.
- Archives d'auteur et de date désactivées — sans contenu, elles ne créent que
  du contenu dupliqué.

### Données structurées

Le Knowledge Graph de SEOPress est **désactivé** au profit de
`mu-plugins/deprice-schema.php`, qui émet un bloc unique : un `@graph`
contenant `Organization` + `ProfessionalService` (adresse postale, deux
téléphones, e-mail, date de fondation, zone desservie, domaines d'expertise) et
`WebSite`. Garder les deux aurait produit deux nœuds `Organization`
concurrents.

Vérifié : un seul bloc JSON-LD par page, valide.

## État final

| Page | Titre | Description | H1 | OG | Images sans alt |
|---|---|---|---|---|---|
| Accueil | 60 | 140 | 1 | 11 | 0 |
| À propos | 54 | 159 | 1 | 11 | 0 |
| Expertise | 56 | 154 | 1 | 11 | 0 |
| Formations | 54 | 148 | 1 | 11 | 0 |
| Références | 52 | 143 | 1 | 11 | 0 |
| Contact | 35 | 148 | 1 | 11 | 0 |
