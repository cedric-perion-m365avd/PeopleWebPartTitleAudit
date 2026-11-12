@{
    RootModule        = 'PeopleWebPartTitleAudit.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'a7c4e9f2-3b61-4d58-9e07-2f1a6c8b5d34'
    Author            = 'Cédric Périon'
    CompanyName       = 'Cédric Périon'
    Copyright         = '(c) 2026 Cédric Périon. Licence MIT.'
    Description       = 'Inventorie en lecture seule les comptes Entra dont l''attribut de poste (jobTitle) est vide, afin de prévoir l''affichage du courriel dans le composant Personnes de SharePoint.'
    RequiredModules   = @('Microsoft.Graph.Users')
    FunctionsToExport = @('Get-UserMissingJobTitle')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('Entra', 'SharePoint', 'MicrosoftGraph', 'jobTitle', 'PeopleWebPart', 'ReadOnly')
            LicenseUri = 'https://opensource.org/licenses/MIT'
            ProjectUri = 'https://trivium365.com/blog/composant-personnes-sharepoint-courriel-entra/'
        }
    }
}
