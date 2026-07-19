$repo = "C:\Users\ADMIN\portfolio"
Set-Location $repo

if (-not (Test-Path .git)) {
    Write-Error "Repository folder is not initialized as a Git repository."
    exit 1
}

if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
    Write-Error "Git repository not found in $repo"
    exit 1
}

git checkout -B main

Copy-Item "C:\Users\ADMIN\Downloads\portfolio.html" ".\index.html" -Force

$content = Get-Content ".\index.html" -Raw
$content = $content -replace '/favicon\.svg', './favicon.svg'
$content = $content -replace '/favicon\.ico', './favicon.ico'
$content = $content -replace '/resume\.pdf', './resume.pdf'
$content = $content -replace '/imran\.jpg', './imran.jpg'
$content = $content -replace '/og-image\.jpg', './og-image.jpg'
Set-Content -Path ".\index.html" -Value $content -Encoding utf8

@'
<!DOCTYPE html>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">
  <rect width="64" height="64" rx="12" fill="#0d0d0e"/>
  <path d="M18 20h28v8H30v16h-12z" fill="#c3fffc"/>
</svg>
'@ | Set-Content -Path ".\favicon.svg" -Encoding utf8

@'
<!DOCTYPE html>
<html lang="en">
  <head><meta charset="utf-8"/><title>Favicon</title></head>
  <body></body>
</html>
'@ | Set-Content -Path ".\favicon.ico" -Encoding utf8

Set-Content -Path ".\resume.pdf" -Value "Resume coming soon" -Encoding ascii
Set-Content -Path ".\.nojekyll" -Value "" -Encoding utf8

if (-not (Test-Path .github)) { New-Item -ItemType Directory -Path .github -Force | Out-Null }
if (-not (Test-Path .github\workflows)) { New-Item -ItemType Directory -Path .github\workflows -Force | Out-Null }

@'
name: Deploy static site
on:
  push:
    branches: [ main ]
permissions:
  contents: read
  pages: write
  id-token: write
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/configure-pages@v5
      - uses: actions/upload-pages-artifact@v3
        with:
          path: ./
      - uses: actions/deploy-pages@v4
'@ | Set-Content -Path ".github\workflows\pages.yml" -Encoding utf8

Copy-Item "C:\Users\ADMIN\Downloads\portfolio.html" ".\index.html" -Force

git config user.name "Pathan Imran Khan"
git config user.email "p.imrankhan67890@gmail.com"
git add .
git commit -m "Initial portfolio deployment"
git push -u origin main
