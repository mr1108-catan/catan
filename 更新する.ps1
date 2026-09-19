# カタンのゲームを更新して公開サイトに反映するスクリプト
# 使い方: このファイルを右クリック →「PowerShell で実行」
#   または PowerShell で  & "C:\Users\mrs11\catan-web\更新する.ps1"

$ErrorActionPreference = 'Stop'
$src  = 'C:\Users\mrs11\catan6-online.html'
$dir  = 'C:\Users\mrs11\catan-web'
$gh   = "$env:ProgramFiles\GitHub CLI\gh.exe"
$url  = 'https://mr1108-catan.github.io/catan/'

Write-Host '■ ゲームファイルをコピーしています...' -ForegroundColor Cyan
Copy-Item $src (Join-Path $dir 'index.html') -Force

Set-Location $dir
git add -A

if (-not (git status --porcelain)) {
  Write-Host '変更はありませんでした。サイトは最新です。' -ForegroundColor Yellow
  Read-Host 'Enterキーで閉じます'
  exit
}

Write-Host '■ 変更をアップロードしています...' -ForegroundColor Cyan
git commit -q -m ("ゲームを更新 " + (Get-Date -Format 'yyyy-MM-dd HH:mm'))
git push -q origin main

Write-Host '■ 公開の反映を待っています（1〜2分かかります）...' -ForegroundColor Cyan
for ($i = 0; $i -lt 30; $i++) {
  Start-Sleep -Seconds 10
  $status = & $gh api 'repos/mr1108-catan/catan/pages' --jq '.status' 2>$null
  if ($status -eq 'built') {
    Write-Host ''
    Write-Host '✅ 反映が完了しました！' -ForegroundColor Green
    Write-Host "   $url" -ForegroundColor Green
    Write-Host '   ※ 友達には、ページの再読み込み（Ctrl+F5）をお願いしてください。'
    Read-Host 'Enterキーで閉じます'
    exit
  }
  Write-Host '  待機中...'
}

Write-Host '反映に時間がかかっています。数分後にサイトを確認してください。' -ForegroundColor Yellow
Read-Host 'Enterキーで閉じます'
