# DEPRICE — reconstruction Elementor v4 (atomic)

Site : https://deprice.sn — Elementor 4.2.4 (atomic elements, global classes,
variables actifs), Astra 4.13.11, WordPress 7.1. Pas d'Elementor Pro.

## Variables globales (28)

Rendues par Elementor en `--<label>` dans `:root` (kit CSS).

**Couleurs (26)** — `brand-green` `ink` `ink-strong` `ink-deep` `ink-soft`
`ink-line` `white` `surface-muted` `border-light` `border-soft` `border-faint`
`border-mid` `border-pale` `border-hairline` `text-muted` `text-subtle`
`text-meta` `text-body` `text-body-strong` `text-faint` `text-pale` `on-dark`
`on-dark-soft` `on-dark-faint` `hero-sub` `border-on-dark`

**Polices (2)** — `font-display` = Space Grotesk, `font-body` = Inter.
Elementor enfile automatiquement les Google Fonts correspondantes.

> Les variables de **taille** sont réservées à Elementor Pro (le loader les
> retire quand Pro est absent). Les tokens de taille vivent donc dans les
> classes globales.

## Classes globales (128)

Organisées en trois couches (voir le piège n°3 plus bas).

**Primitives de mise en page (39)** — `page-root` `container` `container-900`
`container-1180` `section` `section-72` `section-b72` `section-64` `col`
`center-col` `stack-16` `stack-20` `stack-28` `stack-40` `row-between`
`grid-cards` `grid-stats` `grid-stats-sm` `grid-features` `grid-split`
`grid-tiles` `grid-cards-220` `grid-levels` `grid-refs` `grid-2-48` `grid-2-56`
`pill-row` `pill-row-start` `logo-row` `value-row` `feature-item` `feature-body`
`hero` `hero-veil` `hero-content` `hero-actions` `ref-logo-box` `panel`
`form-slot`

**Composants (57)** — titres `h1-hero` `h1-page` `h2-section` `h2-24` `h2-26`
`h2-28` ; textes `body-text` `body-sm` `body-15` `body-17` `body-13-meta`
`lead-sm` `lead-center` `hero-lead` `hero-note` `cta-sub` `page-hero`
`page-hero-sub` `eyebrow` ; titres de blocs `card-title` `card-title-16`
`feature-title` `tile-title` `ref-title` ; chiffres `stat` `stat-value`
`stat-value-32` `stat-label` `stat-label-13` `markets-line` `feature-num` ;
surfaces `card` `card-plain` `tile` `tile-text` `level-card` `level-eyebrow`
`level-hours` `level-desc` `level-note` `ref-card` `logo-tile` `pill`
`pill-dark` ; médias `card-icon` `card-icon-28` `service-icon` `logo-img`
`ref-logo-img` `hero-media` `value-dot` ; interactif `btn` `link-arrow` ;
contact `field-label` `contact-value` `legal-note` `value-label`

**Modificateurs (32)** — `h2-on-dark` `eyebrow-muted` `section-tight`
`section-muted` `section-dark` `container-narrow` `divider-bottom`
`stat-bordered` `btn-primary` `btn-outline-light` `btn-lg` `btn-dark` `btn-28`
`link-arrow-sm` `h1-page-lg` `page-hero-sub-sm` `lead-center-sm`
`level-card-dark` `level-eyebrow-green` `level-hours-light` `level-desc-light`
`level-note-light` `text-center` `mb-0` `mb-14` `mb-16` `mb-20` `mb-24` `mb-28`
`mb-36` `mb-40` `mt-24`

Variantes responsives via les breakpoints Elementor : tablette `max-width:1024px`,
mobile `max-width:767px`.

### Trois pièges rencontrés

1. Le style de base `.e-div-block-base` impose `padding:10px` à **tout**
   `e-div-block`. Chaque classe de mise en page déclare donc son padding
   explicitement (0 le cas échéant), sinon le hero et les grilles se retrouvent
   encadrés de 10px.
2. Astra applique `h1..h6{color:...}` (spécificité 0,0,1). Les classes de titre
   déclarent leur couleur explicitement — `.elementor .h2-section` (0,2,0)
   l'emporte.
3. **Ordre de la cascade.** Elementor écrit le CSS des classes globales dans
   l'ordre **inverse** du tableau d'ordre passé à `Global_Classes_Repository::put()`.
   Toutes les classes ont la même spécificité (`.elementor .x`), donc seule
   l'ordre de sortie départage. Le tableau d'ordre est structuré en trois
   couches, de la première à la dernière :

   | Position dans le tableau | Rôle | Sortie CSS |
   |---|---|---|
   | 1 — 32 | modificateurs (`h2-on-dark`, `section-tight`, `btn-lg`, `*-light`…) | en dernier — **gagnent** |
   | 33 — 89 | composants (`btn`, `card`, `h2-section`, `level-card`…) | au milieu |
   | 90 — 128 | primitives de mise en page (`container`, `section`, `grid-*`…) | en premier |

   Si tu ajoutes une classe, place-la dans la bonne couche, sinon un
   modificateur peut perdre silencieusement contre sa classe de base (un titre
   sombre sur fond sombre, par exemple).

## Médias (optimisés côté serveur)

| ID | Fichier | Format | Dim. | Poids |
|----|---------|--------|------|-------|
| 14 | deprice-hero-bureau.webp | WebP q82 | 1024×559 | 90 Ko |
| 15 | icone-actuariat-assurance.png | PNG alpha | 256×256 | 3 Ko |
| 16 | icone-finance.png | PNG alpha | 256×256 | 3 Ko |
| 17 | icone-formation-certification.png | PNG alpha | 256×256 | 7 Ko |
| 18 | logo-css.png | PNG alpha | 480×217 | 128 Ko |
| 19 | logo-sunu.png | PNG alpha | 480×203 | 82 Ko |
| 20 | logo-bit.png | PNG alpha | 348×236 | 64 Ko |
| 21 | logo-asecna.png | PNG alpha | 480×480 | 246 Ko |
| 22 | logo-dgpsn.png | PNG alpha | 368×268 | 68 Ko |
| 79 | icone-ia-data.svg | SVG | 34×34 | <1 Ko |
| 91 | icone-protection-sociale.png | PNG alpha | 256×256 | 8 Ko |
| 92 | icone-actuariat-sombre.png | PNG alpha | 256×256 | 2 Ko |
| 93 | icone-finance-sombre.png | PNG alpha | 256×256 | 3 Ko |
| 94 | icone-assurance.svg | SVG | 24×24 | <1 Ko |
| 95 | puce-verte.svg | SVG | 8×8 | <1 Ko |

Photos converties en WebP (bord le plus long ≤ 1600 px, < 400 Ko). Logos et
icônes conservés en PNG pour la transparence, redimensionnés et réencodés.
Conversion faite sur le serveur via Imagick à partir des originaux de
`design-source/assets/`.

## Pages

| Page | Slug | ID | URL |
|------|------|----|-----|
| Accueil | `accueil` | 81 | /accueil/ |
| À propos | `a-propos` | 166 | /a-propos/ |
| Expertise & Services | `expertise-services` | 173 | /expertise-services/ |
| Formations & Certifications | `formations-certifications` | 179 | /formations-certifications/ |
| Références | `references` | 183 | /references/ |
| Contact | `contact` | 187 | /contact/ |

Les cartes de la page d'accueil pointent vers les ancres
`/expertise-services/#actuariat`, `#finance` et `#ia-data`, posées via le champ
`_cssid` des sections correspondantes.

L'emplacement réservé au formulaire de contact est le conteneur vide
`id="emplacement-formulaire"` (classe `form-slot`), colonne de droite de la
section « coordonnées » de la page Contact.

Trois références n'ont aucun fichier de logo dans l'export (FOUNDEVER,
Ministère de la Culture, FNR) : leurs cartes sont rendues sans bloc logo plutôt
qu'avec un conteneur vide.

Réglages appliqués à chaque page : template `elementor_header_footer`
(Elementor pleine largeur), `ast-site-content-layout=full-width-container`,
`site-content-style=unboxed`, `site-sidebar-layout=no-sidebar`,
`site-post-title=disabled`. En-tête et pied de page restent gérés par le thème.
