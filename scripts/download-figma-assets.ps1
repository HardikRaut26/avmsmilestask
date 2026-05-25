$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$downloadDir = Join-Path $root "assets\figma"
New-Item -ItemType Directory -Force -Path $downloadDir | Out-Null

$files = @("index.html", "styles.css")
$urlPattern = '(http://localhost:3845/assets/[^"''()\s]+|https://www\.figma\.com/api/mcp/asset/[^"''()\s]+)'

$allUrls = New-Object System.Collections.Generic.HashSet[string]
foreach ($file in $files) {
  $path = Join-Path $root $file
  if (Test-Path $path) {
    $content = Get-Content -Raw -Path $path
    foreach ($m in [regex]::Matches($content, $urlPattern)) {
      [void]$allUrls.Add($m.Value)
    }
  }
}

Write-Host "Found URLs:" $allUrls.Count

$urlToLocal = @{}
foreach ($url in $allUrls) {
  $extension = $null
  $fileName = $null
  $assetId = $null

  if ($url -match "http://localhost:3845/assets/(?<name>[^/]+)$") {
    $fileName = $Matches["name"]
    if ($fileName -match "\.(?<ext>[^\.]+)$") {
      $extension = $Matches["ext"]
    }
  } elseif ($url -match "https://www\.figma\.com/api/mcp/asset/(?<id>[a-f0-9\-]+)$") {
    $assetId = $Matches["id"]
  }

  $tempPath = Join-Path $downloadDir "_tmp_download"

  try {
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $tempPath -PassThru
    $contentType = $response.Headers["Content-Type"]

    if (-not $extension) {
      switch -Regex ($contentType) {
        "image/svg\+xml" { $extension = "svg" }
        "image/png" { $extension = "png" }
        "image/jpeg" { $extension = "jpg" }
        "image/webp" { $extension = "webp" }
        default { $extension = "bin" }
      }
    }

    if (-not $fileName) {
      $fileName = "$assetId.$extension"
    } elseif (-not ($fileName -match "\.[^\.]+$")) {
      $fileName = "$fileName.$extension"
    }

    $finalPath = Join-Path $downloadDir $fileName
    Move-Item -Force -Path $tempPath -Destination $finalPath
    $urlToLocal[$url] = ("assets/figma/" + $fileName)
    Write-Host "Saved" $url "->" $fileName
  } catch {
    if (Test-Path $tempPath) {
      Remove-Item -Force $tempPath
    }
    Write-Host "Failed" $url
    Write-Host $_.Exception.Message
  }
}

Write-Host "Downloaded:" $urlToLocal.Count

foreach ($file in $files) {
  $path = Join-Path $root $file
  if (Test-Path $path) {
    $content = Get-Content -Raw -Path $path
    foreach ($kvp in $urlToLocal.GetEnumerator()) {
      $content = $content.Replace($kvp.Key, $kvp.Value)
    }
    Set-Content -Path $path -Value $content
  }
}
