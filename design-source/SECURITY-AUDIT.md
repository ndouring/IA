# Audit de sécurité — deprice.sn

Réalisé le 10/09/2026. WordPress 7.1, PHP 8.4.24 (cgi-fcgi, utilisateur
`deprice`), Apache, hébergement cPanel. Cœur, thème et extensions **tous à jour**.

## Corrigé

### Critique — PHP s'exécutait depuis `/wp-content/uploads/`

Vérifié par test réel : un fichier `.php` déposé dans les uploads était exécuté
par le serveur. N'importe quelle faille permettant de téléverser un fichier
devenait donc une exécution de code à distance, c'est-à-dire une prise de
contrôle complète du site.

Corrigé par un `.htaccess` dans `uploads/` refusant `php`, `phtml`, `phar`,
`cgi`, `pl`, `py`, `sh`, et désactivant le listing. Re-testé : **403, plus
d'exécution**.

### Critique — `wp-config.php` en 0666

Le fichier contenant les identifiants de la base était lisible **et
modifiable par tout le monde** sur le serveur — sur un hébergement mutualisé,
n'importe quel autre compte de la machine pouvait le lire.

Passé en **0640**. PHP tourne sous `deprice`, propriétaire du fichier :
vérifié lisible après changement, le site répond normalement.

### Moyen — listing des répertoires activé

`/wp-content/uploads/` renvoyait un index navigable de tous les fichiers
téléversés. `Options -Indexes` ajouté à la racine et dans `uploads/`. → 403.

### Moyen — en-têtes de sécurité absents

Ajoutés à la racine : `X-Content-Type-Options: nosniff`,
`X-Frame-Options: SAMEORIGIN`, `Referrer-Policy: strict-origin-when-cross-origin`.

### Faible — `readme.html` et `license.txt` exposés

Ils divulguaient la version exacte de WordPress. Supprimés, et bloqués en
`.htaccess` pour qu'une future mise à jour ne les réintroduise pas.

## Corrigé — second passage (à la demande du propriétaire)

### Énumération des comptes

`/wp-json/wp/v2/users` listait les comptes et `/?author=1` redirigeait vers
`/author/deprice/`, révélant l'identifiant admin.

Extension *must-use* `mu-plugins/deprice-hardening.php` : endpoint REST retiré
pour les requêtes **non authentifiées** uniquement, redirection des URL
d'auteur vers l'accueil, message de connexion générique.

> Le hook `template_redirect` est enregistré en **priorité 0** : la redirection
> canonique de WordPress s'exécute en priorité 10 et prenait la main avant.
>
> Les requêtes authentifiées sont épargnées, donc MCP Adapter et Novamira
> fonctionnent normalement.

Vérifié : `/wp-json/wp/v2/users` → 404, `/?author=1` et `/author/deprice/` →
301 vers l'accueil.

### Force brute

**Limit Login Attempts Reloaded 3.3.8** : 4 tentatives, blocage 20 min, puis
24 h après 3 blocages. Mode local, sans service tiers.

### Édition de fichiers depuis l'admin

`DISALLOW_FILE_EDIT` ajouté à `wp-config.php`. Un compte admin compromis ne
peut plus écrire de PHP depuis le tableau de bord. Sans effet sur Novamira, qui
écrit côté serveur.

### Code inutilisé supprimé

Extensions Akismet et Hello Dolly, thèmes Twenty Twenty-Two/Three/Four.
Twenty Twenty-Five conservé comme thème de secours.

### HSTS

`Strict-Transport-Security: max-age=31536000; includeSubDomains`.

> À savoir : c'est mis en cache par les navigateurs pour un an. En cas de
> problème de certificat, retirer l'en-tête ne suffira pas à débloquer
> immédiatement les visiteurs déjà venus.

### Reste ouvert, faible gravité

Préfixe de table `wp_` (défaut) et `uploads/` en 0775 (inscriptible par le
groupe). Aucun des deux n'est exploitable seul sur cet hébergement mono-compte.

## Le point à connaître : Novamira

Conservé à la demande du propriétaire, car c'est l'outil de travail du site.

Novamira expose `execute-php`, `write-file`, `run-wp-cli`,
`create-admin-access-link` et `create-upload-link`. Autrement dit : **exécution
de code arbitraire et accès complet au système de fichiers**, via un simple mot
de passe d'application.

Ce mot de passe doit être traité comme un mot de passe root, pas comme un
identifiant de site. Il est à révoquer dès que le chantier est terminé
(Utilisateurs → Profil → Mots de passe d'application). Aucun durcissement
ci-dessus ne protège contre sa fuite.
