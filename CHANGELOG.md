# Journal des modifications

Toutes les modifications notables de ce projet sont consignées dans ce fichier.

Le format s'inspire de Keep a Changelog et le projet suit le versionnage sémantique.

## [1.0.0] - 2026-11-03

### Ajouté
- Fonction `Get-UserMissingJobTitle` qui inventorie en lecture seule les comptes Entra dont l'attribut de poste (jobTitle) est vide, via `Get-MgUser`.
- Commutateur `-Connect` qui ouvre une session Microsoft Graph avec la portée User.Read.All.
- Paramètre `-HtmlReportPath` qui produit un rapport HTML simple en complément des objets retournés.
- Aide basée sur les commentaires : synopsis, description, chaque paramètre et exemples.
- Manifeste de module, README en français, licence MIT et fichier .gitignore.
