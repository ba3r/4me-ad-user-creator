function Get-SanitizedString {
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [String]$InputString,
        [Parameter(Mandatory=$false,Position=1)]
        [String]$AllowedSpecialChars = "\-_/"
    )
    $replaceTable = @{'ß'='ss';'à'='a';'á'='a';'â'='a';'ã'='a';'ä'='ae';'å'='aa';'æ'='ae';'ç'='c';'è'='e';'é'='e';'ê'='e';'ë'='e';'ì'='i';'í'='i';'î'='i';'ï'='i';'ð'='d';'ñ'='n';'ò'='o';'ó'='o';'ô'='o';'õ'='o';'ö'='oe';'ø'='o';'ù'='u';'ú'='u';'û'='u';'ü'='ue';'ý'='y';'þ'='p';'ÿ'='y'}


    foreach ($pattern in $replaceTable.Keys) {
        ## Replace special characters with ASCII equivalent, ignoreCase = $true
        #$InputString = $InputString.Replace($pattern, $replaceTable.$pattern, $true, $null)
        $InputString = [Regex]::Replace($InputString, $pattern, $replaceTable.$pattern, 1)
    } 
    ## Trim whitespace
    $InputString = $InputString.Trim() -Replace('\s\s+', ' ')
    ## Remove characters which are not letters, space, dash, underscore, slash (default)
    $InputString = $InputString -Replace("[^a-zA-Z\s$AllowedSpecialChars]", '')   
    ## Title Case FTW
    $InputString = (Get-Culture).TextInfo.ToTitleCase($InputString) 
    return $InputString
}

Measure-Command {
Get-SanitizedString -InputString ("ßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ".ToUpper().ToCharArray() -join " ")
Get-SanitizedString -InputString "   Max Müßig! van øresund, Ährenförde     / DD_PUK-AD"
Get-SanitizedString -InputString "ann-louise o'reilly (2)" -AllowedSpecialChars "\'\-"
}