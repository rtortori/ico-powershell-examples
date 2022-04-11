$intersightCred = @{
    BasePath = "https://intersight.com"
    ApiKeyId = "xxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxx"
    ApiKeyFilePath = "/Path/To/secret.txt" 
    HttpSigningHeader =  @("(request-target)", "Host", "Date", "Digest")
}

Set-IntersightConfiguration @intersightCred