# africamedicalink.com — optimisation SEO, images et performance

Connecteur MCP : `AfricaMedicalink`.
Astra 4.13.10 · Elementor 4.2.4 · WordPress 7.1.2 · PHP 8.4.

Le site n'avait **aucune extension SEO** et **aucune compression serveur**.

## Résultat mesuré

| | Avant | Après |
|---|---|---|
| HTML de la page d'accueil | 206 Ko | **96 Ko** |
| Compression gzip | absente | **active** |
| Cache navigateur sur les images | aucun | **1 an** |
| Requêtes Google Fonts | 6 (≈110 variantes) | **1** (12 variantes) |
| Feuilles de style | 14 | **10** |
| CSS Astra en ligne dans chaque page | 92 Ko | **0** (fichier mis en cache) |
| Balise `description` | aucune | **12 / 12 pages** |
| Open Graph / Twitter Card | aucun | **12 / 12 pages** |
| JSON-LD | aucun | **1 bloc par page** |
| Plan de site XML | aucun | **3 sections, 19 URL** |
| Dossier `uploads/` | 3,8 Mo | **2,7 Mo** |

Les 12 pages publiques répondent 200, avec un seul `<h1>` chacune, sans
avertissement PHP et sans image cassée.

## Images

Treize photographies JPEG converties en WebP sur le serveur (Imagick,
qualité 82, arête la plus longue ramenée à 1600 px) : 1 768 Ko au total
avant, 905 Ko après. Les plus lourdes :

| Fichier | Avant | Après |
|---|---|---|
| `image_optimisee.jpg` (1600 px) | 201 Ko | 95 Ko |
| `Maintenance-des-Equipements.jpg` | 176 Ko | 100 Ko |
| `salon.jpg` | 166 Ko | 90 Ko |
| `audit-2.jpg` | 162 Ko | 77 Ko |
| `formation-3-ok.jpeg` | 154 Ko | 84 Ko |
| `Materiels-et-logiciels.jpg` | 150 Ko | 78 Ko |
| `Formation.jpeg` | 149 Ko | 78 Ko |

Chaque attachment a été basculé sur son nouveau fichier, ses miniatures
régénérées, les anciens noms remplacés partout en base (46 contenus mis à
jour, aucune référence orpheline), et 52 anciens fichiers supprimés. Les
logos, déjà en WebP, n'ont pas été touchés. 23 images ont reçu un texte
alternatif en français ; il n'y en avait aucun.

Les six articles n'avaient **pas d'image à la une** : chacun a reçu celle de
son domaine, ce qui lui donne aussi son image de partage.

## Performance

`wp-content/mu-plugins/aml-performance.php` :

- **Une seule requête de polices.** Le site n'utilise que Archivo (titres),
  Source Sans 3 (texte) et IBM Plex Mono, en graisses 400 à 700. Elementor
  demandait en plus Roboto et Roboto Slab — simples valeurs par défaut de son
  kit : vérifié, aucune règle CSS du site ni aucune page rendue ne se réfère à
  `--e-global-typography-*-font-family`. Chaque famille était demandée en
  dix-huit variantes. Les autres requêtes vers `fonts.googleapis.com` sont
  supprimées via `style_loader_tag`, avec un `preconnect` vers
  `fonts.gstatic.com`.
- **CSS dynamique d'Astra sorti en fichier.** 92 Ko réimprimés dans chaque
  page, identiques d'une page à l'autre. Ils sont écrits dans
  `uploads/aml-css/astra-<empreinte>.css` et servis avec un cache d'un mois.
  Le nom porte l'empreinte du contenu : un changement dans le Customizer
  produit un nouveau fichier de lui-même.
- CSS des blocs Gutenberg (`wp-block-library`, `global-styles`, 15 Ko) retiré
  sur les pages Elementor, après vérification que la page ne contient aucun
  bloc.
- `jquery-migrate`, emoji, RSD, wlwmanifest, generator, oEmbed, shortlink.

`.htaccess` racine, bloc `# BEGIN AML PERFORMANCE` ajouté après le bloc
WordPress. **La compression n'était pas activée du tout** : `mod_deflate` la
met en place, et `mod_expires` plus un `Cache-Control` explicite donnent un an
sur les images et les polices, un mois sur CSS et JS, zéro sur le HTML.
Vérifié après coup : `content-encoding: gzip` sur le HTML et sur le CSS,
`cache-control: public, max-age=31536000, immutable` sur les images. Le bloc
de sécurité existant n'a pas été touché. Sauvegarde : `.htaccess.bak-perf`.

## SEO

SEOPress 10.2 installé et configuré.

- **Titre et méta-description sur les 12 pages et articles**, écrits à partir
  du contenu réel : titres de 40 à 60 caractères, descriptions de 139 à 157.
  Il n'y avait aucune balise `description` auparavant, et le titre de la page
  d'accueil était le gabarit par défaut de WordPress.
- **Open Graph et Twitter Card** sur toutes les pages, en
  `summary_large_image`, avec une image choisie page par page et article par
  article.
- **Données structurées** : `wp-content/mu-plugins/aml-schema.php` émet un
  bloc JSON-LD unique — `Organization` + `LocalBusiness` (adresse Cité Fayçal
  à Dakar, deux téléphones, courriel, zones desservies, domaines
  d'intervention, logo) et `WebSite`. Vérifié : un seul bloc par page, pas de
  second bloc concurrent de SEOPress.
- **Plan de site XML** à `/sitemaps.xml`, déclaré dans `robots.txt` : 6
  articles, 6 pages, 6 catégories.
- Archives par auteur et par date en `noindex` (un seul auteur, contenu
  dupliqué), pièces jointes en `noindex`.

### Permaliens

La structure était `/%year%/%monthnum%/%day%/%postname%/`. Une adresse datée
vieillit mal : elle laisse croire qu'un article de fond est périmé, et elle
allonge l'URL sans rien apporter. Elle est passée à `/%postname%/`.

Rien ne tombe en 404 : `wp-content/mu-plugins/aml-redirects.php` renvoie en
**301** toute ancienne adresse `/AAAA/MM/JJ/slug/` vers l'adresse actuelle, et
les quatre liens internes qui pointaient vers les anciennes adresses ont été
réécrits. Vérifié sur une adresse réelle : `301` vers la nouvelle URL.

## Reste à décider par le client

- Les six catégories du blog n'ont qu'un article chacune. Elles sont pour
  l'instant indexées ; si le blog ne s'étoffe pas, il vaudra mieux les passer
  en `noindex` pour éviter des pages trop minces.
- Aucun compte social n'est renseigné dans SEOPress : si la société a une page
  LinkedIn ou Facebook, l'ajouter renforce le graphe de connaissances.
- La page « Nos Références » indique elle-même que les emplacements d'images
  attendent des photos réelles de missions.
