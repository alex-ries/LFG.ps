Function Send-GroqPSHelpRequest {
    <#
    .SYNOPSIS
        This script is meant to allow for a quick way to get assistance in solving specific "how to in PowerShell" questions.
     
     
    .NOTES
        Name: Send-GroqPSHelpRequest
        Author: Alex Ries
        Version: 1.0
        DateCreated: 2024-May 6
     
     
    .EXAMPLE
        Send-GroqRequest How do i loop through all items in an array?
     
     
    .LINK
        https://midnightsushi.net/
    #>
    
    [CmdletBinding(PositionalBinding=$false)]
    param(
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
            )]
        [string[]]  $ApiKey,
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
            )]
        [string[]]  $Model,
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true
            )]
        [string[]]  $Prompt
    )

    if (!$Model) {
        $Model = "llama3-70b-8192"
    }

    if (!$ApiKey) {
        $ApiKey = "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"
    }


    $url = "https://api.groq.com/openai/v1/chat/completions"
    
    $jsonRequest = '
    {    
        "messages" : [
            {
                "role" : "system",
                "content" : "You are a PowerShell Expert and has deep understanding of PowerShell and all availables commandlets. You will provide a response with up to three PowerShell commands to perform the request of the user. The response MUST be a valid set of prompts and provide the user with a line they could copy and use immediately in their console without error. The response must not include any notes or instructions or comments or other annotations. If you are not sure you MUST give your best guess. If there is no good answer or the answer does not contain a valid set of PowerShell commands you must respond with ''I do not know''"
            },
            {
                "role" : "user",
                "content" : "'+ $Prompt +'"
            }
        ],
        "model": "'+ $Model +'",
        "stream": false
    }'
    
    $headers = @{
        'Authorization' = 'Bearer ' + $ApiKey
    }
    try {
        $response = Invoke-RestMethod -Method 'Post' -Uri $url -Headers $headers -Body $jsonRequest
        Write-Host $response.choices[0].message.content
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $errorObject = (ConvertFrom-Json $_.ErrorDetails.Message).error
        switch ($statusCode) {
            429 { 
                Write-Host "Server returned 429 too many requests, please wait a while before your next prompt..."
            }
            Default {

                Write-Host "Server returned $($errorObject.code) ($statusCode)"
                Write-Host "Message: $($errorObject.message)"
            }
        }
    }
}

Send-GroqPSHelpRequest Write a console message in random colours for each letter