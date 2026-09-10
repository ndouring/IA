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

### Les pièges rencontrés

1. Le style de base `.e-div-block-base` impose `padding:10px` à **tout**
   `e-div-block`. Chaque classe de mise en page déclare donc son padding
   explicitement (0 le cas échéant), sinon le hero et les grilles se retrouvent
   encadrés de 10px. Même piège sur `.e-button-base`, qui impose un fond bleu
   `#375EFB` : `btn` déclare `background: transparent`, et chaque variante de
   bouton déclare le sien. Un bouton sans fond explicite sort en bleu Elementor.
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

## En-tête et pied de page (Astra Customizer)

Le Theme Builder d'Elementor est réservé à Elementor Pro, absent du site.
L'en-tête et le pied de page sont donc construits avec les constructeurs
natifs d'Astra, pilotés par l'option `astra-settings` et quelques `theme_mod`.

**Page d'accueil du site** : `show_on_front = page`, `page_on_front = 81`.

### En-tête

| Réglage | Valeur |
|---|---|
| `header-desktop-items` | logo à gauche ; `menu-1` + `button-1` à droite |
| `custom_logo` (theme_mod) | 197 — `logo-deprice.png`, 400×301, converti CMYK → sRGB |
| `ast-header-responsive-logo-width` | 61 / 56 / 50 px |
| `display-site-title-responsive`, `display-site-tagline-responsive` | `false` sur les 3 appareils — ce sont **ces** clés qu'Astra lit (`astra_logo()`), pas `display-site-title` ni les `theme_mod` du même nom |
| `hb-header-main-sep` / `-color` | 1 px `#E8E8E4` |
| `header-menu1-*` | Inter 500, 14 px, `#000000`, survol et page active `#7ED321` |
| `header-button1-*` | « Demander un devis » → `/contact/`, fond `#121212`, survol `#7ED321`, Space Grotesk 600 / 14 px |
| `header-button1-border-radius-fields` | 2 px — **pas** `header-button1-border-radius`, qui existe mais n'est pas lue ; le défaut d'Astra est 40 px (pilule) |
| `section-hb-button-1-padding` | 11 / 22 px — **pas** `header-button1-padding`, qui existe mais n'est pas lue ; sans elle, le bouton hérite du 15 / 30 global |
| `site-content-width` | 1240 |
| `header-html-1` | `[gtranslate]` — sélecteur FR / EN, placé entre le menu et le bouton |
| `header-html-1color` / `1link-color` / `1link-h-color` | `#121212` / `#B5B5B0` / `#121212` — noter l'absence de tiret avant `color` dans ces clés Astra |

### Pied de page

| Réglage | Valeur |
|---|---|
| `footer-desktop-items` | rangée haute : `widget-1..4` ; rangée basse : `copyright` |
| `hba-footer-column` / `-layout` | 4 — `4-equal` / `2-equal` / `full` |
| Fonds (`hba-`, `hbb-`, `hb-footer-bg-obj-responsive`) | `#111113` |
| `hbb-footer-top-border-color` | `#2A2A2C` |
| `footer-widget-N-title-color` | `#7C7C78`, Space Grotesk 600, 13 px |
| `footer-widget-N-color` | `#A5A5A1` (colonne 1) / `#D5D5D1` (2 à 4) |
| `footer-widget-N-link-color` / `-link-h-color` | `#D5D5D1` / `#7ED321` |
| `footer-copyright-*` | aligné à droite, `#7C7C78`, 12 px |

Contenu des colonnes (widgets classiques, pour obtenir le `<h2 class="widget-title">`
qu'Astra sait colorer) :

1. `media_image-2` — logo blanc (media 198) en 56×42, lien vers l'accueil — puis
   `text-2`, la baseline. Pas de titre.
2. `nav_menu-2` — titre « NAVIGATION », menu 2.
3. `text-3` — titre « CONTACT », e-mail et téléphones en liens `mailto:` / `tel:`.
4. `text-4` — titre « BUREAU DE DAKAR », adresse.

### La seule feuille de CSS du projet

Deux éléments de la maquette n'ont aucun réglage équivalent dans Astra gratuit.
À la demande explicite du client, ils sont traités dans
**Apparence → Personnaliser → CSS additionnel** (post `custom_css`, id 205) —
c'est le seul CSS écrit à la main du projet, tout le reste passe par les
réglages Astra et par les classes / variables globales Elementor.

1. **Trait vert sous l'onglet actif** — un `::after` de 2 px sur
   `.current-menu-item > .menu-link`, encadré à 14 px pour suivre le padding
   du lien.
2. **En-tête collant** — `position: sticky` sur `#masthead`, avec le décalage
   de 32 px quand la barre d'admin est affichée.

Pour revenir à un site sans CSS écrit à la main, il suffit de vider ce champ :
le menu perd son trait et l'en-tête cesse d'être collant, rien d'autre ne bouge.

### Écarts restants par rapport au design

- **Titres de colonnes en majuscules** : Astra gratuit ne génère pas le
  `text-transform` du titre de widget. Les libellés sont donc saisis en
  majuscules dans les widgets. Le `letter-spacing: 0.06em` du design n'est pas
  reproductible sans CSS.
- **Sélecteur FR / EN** : fourni par GTranslate (`widget_look = lang_codes`,
  `incl_langs = ['fr','en']`, `floating_language_selector = no`), inséré dans
  l'en-tête via le composant HTML 1 d'Astra. La langue courante sort en texte
  simple (`#121212`) et l'autre en lien (`#B5B5B0`, survol `#121212`), ce qui
  reproduit le design. En revanche le composant HTML d'Astra n'expose aucun
  réglage de typographie : les codes s'affichent à 15 px dans la police du
  thème, au lieu de Space Grotesk 12 px 600.

## Formulaire de contact (WPForms Lite)

L'élément `e-form` d'Elementor 4 n'est qu'une promotion Pro (`is_pro_promotion`),
pas un formulaire fonctionnel. Le formulaire est donc bâti avec WPForms Lite et
posé dans l'emplacement réservé via le **widget Elementor `wpforms`** fourni par
le plugin — pas un shortcode collé à la main.

**Formulaire** : post `wpforms` id **210**, « Contact DEPRICE ».

| Champ | Type | Obligatoire | Placeholder |
|---|---|---|---|
| Nom complet | `name` (format simple) | oui | Votre nom |
| Email | `email` | oui | vous@exemple.com |
| Sujet | `text` | non | Ex : Étude actuarielle, formation, devis… |
| Message | `textarea` | oui | Décrivez votre besoin |

Nom et Email sont côte à côte via les classes `wpforms-one-half wpforms-first`.

**Destinataire** : `{admin_email}`, soit le compte admin du site. L'adresse n'est
pas écrite en dur — si le compte admin change, la notification suit.
Expéditeur `contact@deprice.sn` (domaine du site, pour ne pas casser SPF),
`Reply-To` sur l'e-mail du visiteur.

**Anti-spam** : deux couches. D'abord `antispam_v3`, le pot de miel moderne de WPForms. Il injecte un
champ supplémentaire (id 5) à position et libellé aléatoires, imitant les vrais
champs, masqué au visiteur. Aucun service tiers, aucune clé d'API, aucun captcha
à résoudre pour l'utilisateur.

Ensuite **Cloudflare Turnstile**, actif sur le formulaire
(`settings.recaptcha = 1`, `captcha-provider = turnstile`), thème clair et
message d'échec en français. Widget rendu en mode `explicit` :
`<div class="wpforms-turnstile" data-sitekey="…" data-action="FormID-210">`.

Les clés vivent dans l'option `wpforms_settings`
(`turnstile-site-key` / `turnstile-secret-key`) et **ne sont pas versionnées
ici**. La clé de site est publique (visible dans le HTML de la page Contact) ;
la clé secrète ne sort jamais côté navigateur — vérifié.

À noter pour la suite : `class-process.php` sort avant toute validation si
`site_key` ou `secret_key` est vide. Vider une clé désactive donc proprement le
captcha sans casser le formulaire, et le pot de miel continue de le protéger.

**Style** : entièrement réglé sur le widget Elementor, qui émet des variables CSS
scopées à l'élément (`--wpforms-*`). Aucun CSS écrit. Attention : les
préréglages `fieldSize` / `labelSize` / `buttonSize` doivent rester **vides**,
sinon `get_size_css_vars()` écrase les valeurs explicites de taille.

Le conteneur WPForms reste transparent et sans bordure : le cadre gris vient de
la classe globale Elementor `form-slot`.

### Acheminement des e-mails

**WP Mail SMTP 4.9.0** est installé et actif. Expéditeur forcé sur
`contact@deprice.sn` avec `DEPRICE Consulting` comme nom, et `Return-Path`
aligné dessus.

Le SPF du domaine autorise déjà ce serveur :
`v=spf1 +mx +a +ip4:104.247.74.88 +include:relay.mailchannels.net +ip4:192.249.112.17 ~all`
— le `+a` couvre l'IP du site (205.134.255.124), donc un envoi depuis
`contact@deprice.sn` passe l'authentification SPF.

Le serveur SMTP du domaine (Exim, cPanel `res354.servconfig.com`) répond sur les
ports 465, 587 et 25. La configuration est pré-remplie :

| Réglage | Valeur |
|---|---|
| Hôte | `mail.deprice.sn` |
| Port | 465 |
| Chiffrement | SSL |
| Authentification | oui |
| Identifiant | `contact@deprice.sn` |
| Mot de passe | **à saisir par le propriétaire du site** |

Tant que le mot de passe n'est pas renseigné, le mailer reste sur **PHP mail**
(`mailer = mail`), qui fonctionne, plutôt que sur SMTP qui échouerait sans
identifiants. Une fois le mot de passe saisi dans
Réglages → WP Mail SMTP, basculer le mailer sur « Other SMTP » active l'envoi
authentifié.
