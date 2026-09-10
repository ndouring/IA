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

## Restant — décision du propriétaire

| Point | Gravité | Remarque |
|---|---|---|
| Énumération des comptes | moyen | `/wp-json/wp/v2/users` et `/?author=1` révèlent l'identifiant `deprice` |
| Aucune protection anti-force brute | moyen | `wp-login.php` accepte un nombre illimité de tentatives |
| Édition de fichiers depuis l'admin | moyen | `DISALLOW_FILE_EDIT` non défini : un compte admin compromis peut écrire du PHP |
| Extensions et thèmes inutilisés | faible | Akismet et Hello Dolly inactifs, 4 thèmes par défaut |
| HSTS absent | faible | Volontairement non activé : difficilement réversible (mis en cache par les navigateurs) |
| Préfixe de table `wp_` | faible | Valeur par défaut |
| `uploads/` en 0775 | faible | Inscriptible par le groupe |

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
