#Requires -Modules Microsoft.Graph.Users

function Get-UserMissingJobTitle {
    <#
    .SYNOPSIS
    Inventorie en lecture seule les comptes Entra dont l'attribut de poste (jobTitle) est vide.

    .DESCRIPTION
    Le composant Personnes de SharePoint affiche le courriel d'une personne
    uniquement lorsque son titre reste vide dans l'annuaire, parce que la carte
    ne montre que deux lignes : le nom puis le titre. Quand le titre manque, le
    courriel prend sa place. Côté Entra, ce champ correspond à l'attribut de
    poste (jobTitle).

    Cette fonction lit les profils du locataire avec Get-MgUser puis retourne
    les comptes dont l'attribut de poste est vide, soit ceux qui feront
    apparaitre leur courriel sur une carte. Elle ne modifie aucun profil ni
    aucun paramètre du locataire. Elle demande la permission déléguée
    User.Read.All avec consentement administrateur.

    .PARAMETER Connect
    Ouvre une session Microsoft Graph avec Connect-MgGraph et la portée
    User.Read.All avant la lecture. Sans ce commutateur, la fonction utilise une
    session Microsoft Graph déjà ouverte.

    .PARAMETER HtmlReportPath
    Chemin d'un fichier HTML à produire en complément des objets retournés. Le
    rapport reprend les colonnes affichées à l'écran.

    .INPUTS
    Aucun. Cette fonction n'accepte pas d'entrée de pipeline.

    .OUTPUTS
    System.Management.Automation.PSCustomObject

    .EXAMPLE
    Get-UserMissingJobTitle -Connect

    Ouvre une session Microsoft Graph puis retourne les comptes sans attribut de poste.

    .EXAMPLE
    Get-UserMissingJobTitle | Export-Csv -Path '.\profils-sans-titre.csv' -NoTypeInformation -Encoding UTF8

    Exporte la liste vers un fichier CSV à des fins de revue.

    .EXAMPLE
    Get-UserMissingJobTitle -Connect -HtmlReportPath '.\profils-sans-titre.html'

    Produit en plus un rapport HTML simple.

    .NOTES
    Permission déléguée requise : User.Read.All avec consentement administrateur.
    Module requis : Microsoft.Graph.Users.

    .LINK
    https://trivium365.com/blog/composant-personnes-sharepoint-courriel-entra/
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param(
        [Parameter()]
        [switch]$Connect,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$HtmlReportPath
    )

    if ($Connect.IsPresent) {
        Write-Verbose 'Ouverture d''une session Microsoft Graph avec la portée User.Read.All.'
        Connect-MgGraph -Scopes 'User.Read.All' -NoWelcome
    }

    $proprietes = 'DisplayName', 'UserPrincipalName', 'JobTitle', 'Mail'

    Write-Verbose 'Lecture des profils du locataire avec Get-MgUser.'
    $resultat = Get-MgUser -All -Property $proprietes |
        Where-Object { [string]::IsNullOrWhiteSpace($_.JobTitle) } |
        Select-Object -Property DisplayName, UserPrincipalName, Mail |
        Sort-Object -Property DisplayName

    if ($PSBoundParameters.ContainsKey('HtmlReportPath')) {
        $titre = 'Profils Entra sans attribut de poste'
        Write-Verbose "Écriture du rapport HTML dans $HtmlReportPath."
        $resultat |
            ConvertTo-Html -Property DisplayName, UserPrincipalName, Mail -Title $titre -PreContent "<h1>$titre</h1>" |
            Out-File -FilePath $HtmlReportPath -Encoding UTF8
        Write-Information "Rapport HTML écrit dans $HtmlReportPath." -InformationAction Continue
    }

    Write-Output $resultat
}
