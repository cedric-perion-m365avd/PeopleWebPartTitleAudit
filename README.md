# PeopleWebPartTitleAudit

## Présentation

Sur une page d'équipe SharePoint, le composant Personnes affiche le courriel d'une personne seulement lorsque son titre reste vide dans l'annuaire. La carte ne montre que deux lignes. La première ligne porte le nom. La seconde ligne porte le titre de la personne. Quand ce titre manque, le courriel prend sa place. Les comptes au titre renseigné n'affichent donc pas leur courriel et les comptes au titre vide le laissent ressortir.

Côté Entra, ce champ de titre correspond à l'attribut de poste (jobTitle) du profil. Cet outil lit les profils du locataire avec `Get-MgUser` puis retourne les comptes dont cet attribut est vide. Ce sont eux qui feront apparaitre le courriel sur une carte. Vous obtenez ainsi la liste des profils à compléter avant de décider de l'affichage de vos pages.

L'outil est en lecture seule. Il ne modifie aucun profil ni aucun paramètre du locataire.

## Pourquoi maintenant

Le comportement a été décrit par Greg Zelfond (SharePoint Maven) dans un billet publié le 14 octobre 2026. Il s'agit d'un billet de blogue tiers qui rapporte un comportement observé. Ce n'est pas une annonce ni une fonctionnalité documentée par Microsoft. Validez le comportement dans votre propre locataire avant de généraliser une règle d'édition à toutes vos pages.

## Prérequis

- Le module Microsoft.Graph.Users (SDK Microsoft Graph PowerShell).
- La permission déléguée User.Read.All avec consentement administrateur. Faites approuver cet accès avant l'exécution.

## Installation

Installez le module Microsoft Graph requis puis importez le module de l'outil.

```powershell
Install-Module Microsoft.Graph.Users -Scope CurrentUser
Import-Module .\PeopleWebPartTitleAudit\PeopleWebPartTitleAudit.psd1
```

## Exemples d'utilisation

Se connecter à Microsoft Graph puis lister les comptes sans attribut de poste.

```powershell
Get-UserMissingJobTitle -Connect
```

Exporter la liste vers un fichier CSV à des fins de revue.

```powershell
Get-UserMissingJobTitle | Export-Csv -Path '.\profils-sans-titre.csv' -NoTypeInformation -Encoding UTF8
```

Produire en plus un rapport HTML simple.

```powershell
Get-UserMissingJobTitle -Connect -HtmlReportPath '.\profils-sans-titre.html'
```

Obtenir le détail de l'aide intégrée.

```powershell
Get-Help Get-UserMissingJobTitle -Full
```

## Exemple de sortie

La sortie suivante est fictive. Ne la prenez pas pour un résultat réel. Le domaine contoso.com sert uniquement d'exemple.

```
DisplayName     UserPrincipalName            Mail
-----------     -----------------            ----
Alex Tremblay   alex.tremblay@contoso.com    alex.tremblay@contoso.com
Sam Gagnon      sam.gagnon@contoso.com       sam.gagnon@contoso.com
```

Ce résultat repère les profils dont le titre est vide. Comparez ces comptes aux personnes affichées sur votre page.

## Limites connues

- L'outil lit l'ensemble des profils du locataire alors qu'une page SharePoint ne liste souvent qu'un sous-ensemble de personnes. Il sert à cibler les profils à compléter. Il ne reproduit pas l'affichage exact d'une page précise.
- Le contournement `mailto:` décrit dans la source reste manuel et carte par carte. L'outil ne l'automatise pas. Il se limite à la lecture de l'annuaire.
- La source documente le comportement sur la Carte moyenne (Medium Card). Elle ne documente pas le comportement sur les autres tailles de carte.
- Le résultat dépend de l'exactitude des profils Entra. Validez la sortie dans votre environnement avant d'agir.

## Liens

- Article de Cédric Périon : https://trivium365.com/blog/composant-personnes-sharepoint-courriel-entra/
- Get-MgUser (Microsoft Learn) : https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.users/get-mguser?view=graph-powershell-1.0
- List users (Microsoft Graph) : https://learn.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0
- Billet d'origine de SharePoint Maven : https://sharepointmaven.com/how-to-add-an-email-address-to-a-people-web-part/
