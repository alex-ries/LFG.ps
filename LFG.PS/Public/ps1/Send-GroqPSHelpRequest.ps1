Function Send-GroqPSHelpRequest {
    <#
    .SYNOPSIS
        This script is meant to allow for a quick way to get assistance in solving specific "how to in PowerShell" questions.

        Current supported models are llama38b, llama370b, mixtral8x7b and gemma7B

        Supported models depend on model support from GroqCloud
     
     
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
    [Alias('lfg')]
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

    $defaultModel = "mixtral8x7b"
    $availableModels = [ordered]@{ llama38b = "llama3-8b-8192"; llama370b =  "llama3-70b-8192"; mixtral8x7b = "mixtral-8x7b-32768"; gemma7B = "gemma-7b-it"}
    $targetModel = $availableModels[$defaultModel]

    if ($Model) {
        $targetModel = $availableModels[$Model.ToLower()]
    }

    if (!$ApiKey) {
        $ApiKey = Get-GroqApiKey
        if (!$ApiKey) {
            Write-Error "No API Key Found, please set it using Set-GroqApiKey"
        }
    }


    $systemPrompt = "Your answers must be correct and true, you are not allowed to guess estimate or enhance responses. You must adhere to common decency and casual humility when providing an answer. You are an intelligent AI powered robotic PowerShell assitant you have a large database of PowerShell commands and snippets. You will be asked questions of how to do certain things using PowerShell commands by the user. The user knows and understands PowerShell and wants to use the AI to access the database quickly and combine commands as needed to fulfill the user's prompt. Your responses will be a single, or set of valid PowerShell commands that perform the user's desired actions. Your responses will be concise and consist only of PowerShell commands with absolutely no mark up, comments or other annotations. You will not repeat back part of the user's question in the answer, or use human like responses or flourishes to present the answer or provide any additional instructions, comments, examples or other context. You will provide only a single answer that closest matches the user's request."

    $url = "https://api.groq.com/openai/v1/chat/completions"
    
    $jsonRequest = '
    {    
        "messages" : [
            {
                "role" : "system",
                "content" : "'+$systemPrompt+'"
            },
            {
                "role" : "user",
                "content" : "'+ $Prompt +'"
            }
        ],
        "model": "'+ $targetModel +'",
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