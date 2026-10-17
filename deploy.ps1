# Deploy script (run after filling .env)
$envFile = "C:\Users\محمد حسين\Documents\clude\.env"
$envVars = @{}
Get-Content $envFile | ForEach-Object {
    if ($_ -match '^\s*([^#][^=]+)=(.*)$') {
        $envVars[$matches[1].Trim()] = $matches[2].Trim()
    }
}
$user = $envVars['GITHUB_USERNAME']
$token = $envVars['GITHUB_TOKEN']
if (-not $user -or -not $token -or $user -eq 'your_github_username' -or $token -eq 'your_personal_access_token') {
    Write-Host "Please fill .env with real GITHUB_USERNAME and GITHUB_TOKEN"
    exit 1
}
$env:GH_TOKEN = $token
$repo = "Claude"
$dir = "C:\Users\محمد حسين\Documents\clude"
Set-Location $dir
if (-not (Test-Path ".git")) {
    git init
    git branch -M main
}
git add -A
git commit -m "Initial commit: Claude 100 site" 2>&1 | Out-Null
gh repo create "$user/$repo" --public --source=$dir --remote=origin --push 2>&1
gh api -X POST "repos/$user/$repo/pages" -f "source[branch]=main" -f "source[path]=/" 2>&1
Write-Host "Done. URL: https://$user.github.io/$repo/"
