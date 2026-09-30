# daroulistikhama.com — optimisation SEO, images et performance

Connecteur MCP : `ndouring-f7b86036`.
Astra 4.14 · Elementor 4.3.2 · WordPress 7.1.2 · PHP 8.4 · Yoast SEO 28.6.

## Résultat mesuré

| | Avant | Après |
|---|---|---|
| Dossier `uploads/` | 66 Mo | 5,7 Mo |
| HTML de la page d'accueil | 198 Ko | 104 Ko |
| Requêtes Google Fonts | 7 (≈110 variantes) | 1 (16 variantes) |
| Feuilles de style | 31 | 20 |
| Scripts | 9 | 6 |
| CSS Astra en ligne dans chaque page | 69 Ko | 0 (fichier mis en cache) |
| Titres et descriptions SEO renseignés | 0 / 8 pages | 8 / 8 |

Les huit pages répondent 200, sans avertissement PHP et sans image cassée.

## Images

Les photographies passent en WebP, converties sur le serveur avec Imagick,
arête la plus longue ramenée à 1600 px. Les logos, qui ont un canal alpha,
restent en PNG et sont seulement ré-encodés (comparaison png32 / png8, le plus
léger l'emporte).

| Fichier | Avant | Après |
|---|---|---|
| `kit.png` → `kit.webp` | 860 Ko | 368 Ko |
| `conseil.jpg` → `.webp` (2048 → 1600 px) | 367 Ko | 242 Ko |
| `don-tabaski.jpg` → `.webp` | 259 Ko | 160 Ko |
| `don-tabaski-1.jpg` → `.webp` | 259 Ko | 160 Ko |
| `partenaires.jpg` → `.webp` | 183 Ko | 160 Ko |
| `3-conference-annuelle.jpg` → `.webp` | 139 Ko | 121 Ko |
| `605139696_…_n.jpg` → `.webp` | 125 Ko | 122 Ko |
| `pose-vrai.jpg` → `.webp` | 82 Ko | 74 Ko |
| `sante.jpg` → `.webp` | 48 Ko | 35 Ko |
| `cropped-logo-…_small.png` (PNG conservé) | 181 Ko | 54 Ko |
| `kit-small.png` (PNG conservé) | 206 Ko | 57 Ko |
| `logo-daroul-istikhama_small.png` | 35 Ko | 9 Ko |
| `di-logo.png` | 24 Ko | 7 Ko |

Deux images grossissaient en WebP à qualité 82 : `3-conference-annuelle` et
`605139696_…`. Elles ont été ré-encodées à 78, seul réglage qui fasse encore
gagner du poids sur ces deux photos.

Chaque attachment a été basculé sur le nouveau fichier (`_wp_attached_file`,
`post_mime_type`, `guid`), ses miniatures régénérées, puis les anciens noms de
fichiers remplacés partout en base : 44 anciens fichiers supprimés, aucune
référence orpheline. 17 attachments ont reçu un texte alternatif en français.

**58 Mo de cache de greffon** ont aussi été vidés : `ast-block-templates-json`
(53 Mo) et `astra-sites/json` (4,6 Mo), catalogues de modèles que Starter
Templates retélécharge à la demande, et `wpforms/cache` (2,1 Mo).

## Performance

`wp-content/mu-plugins/di-performance.php` :

- **Une seule requête de polices.** Le site n'utilise que Libre Franklin
  (titres), Spectral (texte), IBM Plex Mono et Noto Kufi Arabic, en graisses
  400 à 700. Elementor demandait en plus Roboto et Roboto Slab, jamais
  utilisées, et chaque famille en dix-huit variantes. Les autres requêtes vers
  `fonts.googleapis.com` sont supprimées via `style_loader_tag`, avec un
  `preconnect` vers `fonts.gstatic.com`.
- **Six feuilles d'icônes retirées** : eicons, widget-icon-list,
  widget-social-icons et les trois fichiers Font Awesome (brands, fontawesome,
  solid), ajoutés d'office par Header Footer Elementor. Vérifié auparavant sur
  les huit pages : aucune classe `fa-`, `fab`, `fas`, `far` ni `eicon-`.
- **CSS dynamique d'Astra sorti en fichier.** 69 Ko identiques d'une page à
  l'autre, réimprimés dans chaque page. Ils sont écrits dans
  `uploads/di-css/astra-<empreinte>.css` et servis avec un cache d'un mois.
  Le nom porte l'empreinte du contenu : un changement dans le Customizer
  produit un nouveau fichier de lui-même.
- CSS des blocs Gutenberg (`wp-block-library`, `global-styles`) retiré sur les
  pages Elementor, après vérification que la page ne contient aucun bloc.
- Script de prévisualisation de Starter Templates retiré du site public.
- `jquery-migrate`, emoji, RSD, wlwmanifest, generator, oEmbed, shortlink.

`.htaccess` racine, bloc `# BEGIN Daroul Istikhama - performance` ajouté après
le bloc WordPress : `mod_deflate` et `mod_expires`, plus un `Cache-Control`
explicite — un an sur les images et les polices, un mois sur CSS et JS, zéro
sur le HTML. Vérifié : `cache-control: public, max-age=31536000, immutable`
sur les images. La compression gzip et les en-têtes de sécurité étaient déjà en
place. Sauvegarde : `.htaccess.bak-perf`.

## SEO

- **Nom du site** ramené de 122 caractères à `Daroul Istikhama`. Le titre de la
  page d'accueil faisait 133 caractères, Google en affiche environ 60. Le nom
  et la description contenaient aussi un `&amp;` doublement échappé. Le titre
  et le slogan sont masqués dans l'en-tête (le logo les remplace), donc rien ne
  change à l'écran.
- **Titre et méta-description sur les huit pages**, écrits à partir du contenu
  réel de chaque page : titres de 49 à 56 caractères, descriptions de 141 à
  152.
- **Image Open Graph choisie pour chaque page.** Yoast prenait la première
  image trouvée : la page Contact partageait le `submit-spin.svg` de WPForms.
  Chaque page a maintenant une photo au format paysage, avec la même image en
  `twitter:image` et la carte en `summary_large_image`.
- **Schema.org** : `wp-content/mu-plugins/di-schema.php` complète le graphe de
  Yoast via `wpseo_schema_organization` — type `Organization` + `NGO`, nom
  arabe, adresse postale à Pikine, téléphone, courriel, horaires d'ouverture,
  zone desservie, domaines d'action. Un seul bloc JSON-LD par page, pas de
  second bloc concurrent.
- **Sitemap** : les modèles d'en-tête et de pied de page (`elementor-hf`) et la
  bibliothèque Elementor en sont sortis. Il ne reste que `page-sitemap.xml`.
- Archives par date et par auteur désactivées (un seul auteur, contenu
  dupliqué), archives et pièces jointes en `noindex`.
- L'article d'exemple « Bonjour tout le monde ! » et le commentaire
  d'exemple de WordPress sont à la corbeille. Commentaires fermés partout.

## Reste à décider par le client

- **Starter Templates** (`astra-sites`) reste actif. Le site est construit,
  l'extension ne sert plus qu'à importer des modèles et son cache reprendra
  50 Mo à la première visite de son écran. Elle peut être désactivée.
- Aucun compte social n'est renseigné dans Yoast (`sameAs` vide) : si
  l'association a une page Facebook ou un compte Instagram, les ajouter
  renforce le graphe de connaissances.
- Images non utilisées restant dans la médiathèque : `methode.jpg`,
  `pose-2.jpg`, `pose-2-1.jpg`, `di-hero-accueil.webp`, `kit-small.png`. Elles
  ne pèsent pas sur les pages publiques, seulement sur le disque.
