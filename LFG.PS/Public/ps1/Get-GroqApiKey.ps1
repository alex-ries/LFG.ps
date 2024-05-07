Function Get-GroqApiKey {
    <#
    .SYNOPSIS
        Get the Groq Api Key from a settings file in the user profile
     
     
    .NOTES
        Name: Get-GroqApiKey
        Author: Alex Ries
        Version: 1.0
        DateCreated: 2024-May 6
     
     
    .EXAMPLE
        Get-GroqApiKey
     
     
    .LINK
        https://midnightsushi.net/
    #>
    

    $directorySeparator = [System.IO.Path]::DirectorySeparatorChar
    $appFolderName = ".groqpshelp"
    $apiKeyFilname = ".apikey"
    $appFolderPath = "$($env:USERPROFILE + $directorySeparator + $appFolderName)"
    $appSettingPath = "$($appFolderPath + $directorySeparator + $apiKeyFilname)"
    
    if (!(Test-Path -Path $appSettingPath -PathType Leaf)) {
        return $null
    }
    
    return Get-Content -Path $appSettingPath -Raw

}