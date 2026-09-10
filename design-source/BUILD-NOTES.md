# DEPRICE — reconstruction Elementor v4 (atomic)

Site : https://deprice.sn — Elementor 4.2.4 (atomic elements, global classes,
variables actifs), Astra 4.13.11, WordPress 7.1. Pas d'Elementor Pro.

## Variables globales (27)

Rendues par Elementor en `--<label>` dans `:root` (kit CSS).

**Couleurs (25)** — `brand-green` `ink` `ink-strong` `ink-deep` `ink-soft`
`ink-line` `white` `surface-muted` `border-light` `border-soft` `border-faint`
`border-mid` `border-pale` `border-hairline` `text-muted` `text-subtle`
`text-meta` `text-body` `text-body-strong` `text-faint` `text-pale` `on-dark`
`on-dark-soft` `on-dark-faint` `hero-sub`

**Polices (2)** — `font-display` = Space Grotesk, `font-body` = Inter.
Elementor enfile automatiquement les Google Fonts correspondantes.

> Les variables de **taille** sont réservées à Elementor Pro (le loader les
> retire quand Pro est absent). Les tokens de taille vivent donc dans les
> classes globales.

## Classes globales (57)

Mise en page : `page-root` `section` `section-tight` `section-muted`
`section-dark` `container` `container-narrow` `divider-bottom`

Typographie : `eyebrow` `eyebrow-muted` `h1-hero` `h2-section` `h2-on-dark`
`card-title` `feature-title` `body-text` `body-sm` `hero-lead` `hero-note`
`cta-sub` `stat-value` `stat-label`

Boutons / liens : `btn` `btn-primary` `btn-outline-light` `btn-lg`
`link-arrow` `link-arrow-sm`

Cartes / grilles : `card` `card-icon` `grid-cards` `grid-stats`
`grid-features` `grid-split`

Hero : `hero` `hero-media` `hero-veil` `hero-content` `hero-actions`

Divers : `stat` `stat-bordered` `logo-row` `logo-tile` `logo-img` `center-col`
`row-between` `feature-item` `feature-num` `feature-body` `stack-16`
`stack-20` `stack-40` `mb-16` `mb-20` `mb-24` `mb-40` `mt-24`

Variantes responsives via les breakpoints Elementor : tablette `max-width:1024px`,
mobile `max-width:767px`.

### Deux pièges rencontrés

1. Le style de base `.e-div-block-base` impose `padding:10px` à **tout**
   `e-div-block`. Chaque classe de mise en page déclare donc son padding
   explicitement (0 le cas échéant), sinon le hero et les grilles se retrouvent
   encadrés de 10px.
2. Astra applique `h1..h6{color:...}` (spécificité 0,0,1). Les classes de titre
   déclarent leur couleur explicitement — `.elementor .h2-section` (0,2,0)
   l'emporte.

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

Photos converties en WebP (bord le plus long ≤ 1600 px, < 400 Ko). Logos et
icônes conservés en PNG pour la transparence, redimensionnés et réencodés.
Conversion faite sur le serveur via Imagick à partir des originaux de
`design-source/assets/`.

## Pages

| Page | Slug | ID | État |
|------|------|----|------|
| Accueil | `accueil` | 81 | fait |
| À propos | `a-propos` | — | à faire |
| Expertise & Services | `expertise-services` | — | à faire |
| Formations & Certifications | `formations-certifications` | — | à faire |
| Références | `references` | — | à faire |
| Contact | `contact` | — | à faire |

Réglages appliqués à chaque page : template `elementor_header_footer`
(Elementor pleine largeur), `ast-site-content-layout=full-width-container`,
`site-content-style=unboxed`, `site-sidebar-layout=no-sidebar`,
`site-post-title=disabled`. En-tête et pied de page restent gérés par le thème.
