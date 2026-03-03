param(
  [string]$BaseUrl = "https://kind-mud-063fee810.4.azurestaticapps.net"
)

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$mdDir = Join-Path $projectRoot "posts-md"
$outDir = Join-Path $projectRoot "posts"

New-Item -ItemType Directory -Path $outDir -Force | Out-Null

function Escape-Html {
  param([string]$Text)
  if ($null -eq $Text) { return "" }
  return ($Text.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;"))
}

function Close-Paragraph {
  param([ref]$Html, [ref]$Paragraph)
  if ($Paragraph.Value.Count -gt 0) {
    $joined = ($Paragraph.Value -join " ").Trim()
    if ($joined.Length -gt 0) {
      $Html.Value.Add("        <p>$joined</p>")
    }
    $Paragraph.Value.Clear()
  }
}

function Convert-MarkdownToHtml {
  param([string]$Body)

  $lines = $Body -split "`r?`n"
  $html = New-Object System.Collections.Generic.List[string]
  $paragraph = New-Object System.Collections.Generic.List[string]
  $inList = $false
  $inCode = $false
  $codeBuffer = New-Object System.Collections.Generic.List[string]

  foreach ($line in $lines) {
    if ($line -match '^```') {
      if ($inCode) {
        $codeText = [string]::Join("`n", $codeBuffer)
        $html.Add("        <pre><code>$(Escape-Html $codeText)</code></pre>")
        $codeBuffer.Clear()
        $inCode = $false
      }
      else {
        Close-Paragraph ([ref]$html) ([ref]$paragraph)
        if ($inList) {
          $html.Add("        </ul>")
          $inList = $false
        }
        $inCode = $true
      }
      continue
    }

    if ($inCode) {
      $codeBuffer.Add($line)
      continue
    }

    if ([string]::IsNullOrWhiteSpace($line)) {
      Close-Paragraph ([ref]$html) ([ref]$paragraph)
      if ($inList) {
        $html.Add("        </ul>")
        $inList = $false
      }
      continue
    }

    if ($line -match '^###\s+(.+)$') {
      Close-Paragraph ([ref]$html) ([ref]$paragraph)
      if ($inList) {
        $html.Add("        </ul>")
        $inList = $false
      }
      $html.Add("        <h3>$(Escape-Html $Matches[1])</h3>")
      continue
    }

    if ($line -match '^##\s+(.+)$') {
      Close-Paragraph ([ref]$html) ([ref]$paragraph)
      if ($inList) {
        $html.Add("        </ul>")
        $inList = $false
      }
      $html.Add("        <h2>$(Escape-Html $Matches[1])</h2>")
      continue
    }

    if ($line -match '^#\s+(.+)$') {
      Close-Paragraph ([ref]$html) ([ref]$paragraph)
      if ($inList) {
        $html.Add("        </ul>")
        $inList = $false
      }
      $html.Add("        <h1>$(Escape-Html $Matches[1])</h1>")
      continue
    }

    if ($line -match '^-\s+(.+)$') {
      Close-Paragraph ([ref]$html) ([ref]$paragraph)
      if (-not $inList) {
        $html.Add("        <ul>")
        $inList = $true
      }
      $html.Add("          <li>$(Escape-Html $Matches[1])</li>")
      continue
    }

    $paragraph.Add((Escape-Html $line.Trim()))
  }

  Close-Paragraph ([ref]$html) ([ref]$paragraph)
  if ($inList) {
    $html.Add("        </ul>")
  }

  return ($html -join "`n")
}

$mdFiles = Get-ChildItem -Path $mdDir -Filter *.md -File

foreach ($file in $mdFiles) {
  $raw = Get-Content -Raw -Encoding UTF8 $file.FullName

  $meta = @{}
  $body = $raw

  if ($raw.TrimStart().StartsWith("---")) {
    $parts = $raw -split "`r?`n"
    if ($parts.Length -gt 2 -and $parts[0].Trim() -eq "---") {
      $i = 1
      while ($i -lt $parts.Length -and $parts[$i].Trim() -ne "---") {
        if ($parts[$i] -match '^([A-Za-z0-9_-]+):\s*(.+)$') {
          $meta[$Matches[1].ToLower()] = $Matches[2].Trim()
        }
        $i++
      }
      if ($i -lt $parts.Length -and $parts[$i].Trim() -eq "---") {
        $body = [string]::Join("`n", $parts[($i + 1)..($parts.Length - 1)])
      }
    }
  }

  $slug = if ($meta.ContainsKey("slug")) { $meta["slug"] } else { [IO.Path]::GetFileNameWithoutExtension($file.Name) }
  $title = if ($meta.ContainsKey("title")) { $meta["title"] } else { $slug }
  $date = if ($meta.ContainsKey("date")) { $meta["date"] } else { (Get-Date -Format "yyyy-MM-dd") }
  $category = if ($meta.ContainsKey("category")) { $meta["category"] } else { "Tech" }
  $description = if ($meta.ContainsKey("description")) { $meta["description"] } else { "$title の記事" }

  $articleContent = Convert-MarkdownToHtml -Body $body
  $htmlPath = Join-Path $outDir ("$slug.html")
  $url = "$BaseUrl/posts/$slug.html"

  $doc = @"
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$title</title>
  <meta name="description" content="$description">
  <meta property="og:type" content="article">
  <meta property="og:title" content="$title">
  <meta property="og:description" content="$description">
  <meta property="og:url" content="$url">
  <link rel="icon" href="../favicon.svg" type="image/svg+xml">
  <link rel="stylesheet" href="../style.css">
</head>
<body>
  <header class="site-header">
    <div class="container header-inner">
      <a class="logo" href="../index.html">Ryu Sakamaki Tech Blog</a>
      <nav class="nav">
        <a href="../index.html#featured">特集記事</a>
        <a href="../index.html#latest">最新記事</a>
      </nav>
    </div>
  </header>

  <main class="article">
    <div class="container">
      <article class="content">
        <h1>$title</h1>
        <p class="meta">$date | $category</p>
$articleContent
      </article>
    </div>
  </main>
</body>
</html>
"@

  Set-Content -Path $htmlPath -Value $doc -Encoding UTF8
}

Write-Host "Generated $($mdFiles.Count) post(s)."

