# Build the "board game" design (A) version from catan6-online.html.
#   - swaps the dark UI colors for theme variables (see theme-board.css)
#   - removes decorative emoji (resources, VP, dev cards, pieces, dice etc. are kept)
#   - injects fonts + theme-board.css
# Output: catan-web\new\index.html  and  C:\Users\mrs11\catan6-online-board.html (local preview)
$ErrorActionPreference = 'Stop'
$root = 'C:\Users\mrs11'
$web  = Join-Path $root 'catan-web'
$utf8 = New-Object System.Text.UTF8Encoding $false
$src  = [IO.File]::ReadAllText((Join-Path $root 'catan6-online.html'), [Text.Encoding]::UTF8)
$css  = [IO.File]::ReadAllText((Join-Path $web 'theme-board.css'), [Text.Encoding]::UTF8)

# ---- 1) UI colors -> theme variables (board/canvas colors are not in this list) ----
$map = [ordered]@{
  '#8aaac0'='var(--ink-2)'; '#c8dff0'='var(--ink)'; '#e8e8e8'='var(--ink)'; '#eef4fa'='var(--ink)'; '#e8f2ff'='var(--ink)'
  '#90aabf'='var(--ink-2)'; '#aac4d8'='var(--ink-2)'; '#8aaabf'='var(--ink-2)'; '#a8c4dc'='var(--ink-2)'
  '#6a8aa0'='var(--ink-3)'; '#7890a8'='var(--ink-3)'; '#3a5570'='var(--ink-3)'; '#7a9ab0'='var(--ink-3)'; '#6a8aaa'='var(--ink-3)'; '#567090'='var(--ink-3)'
  '#f4a460'='var(--accent)'; '#f4d060'='var(--gold)'; '#ffe880'='var(--gold)'; '#ffe888'='var(--gold)'
  '#7ee0a0'='var(--ok)'; '#20a060'='var(--ok)'; '#88ddaa'='var(--ok)'; '#88ffaa'='var(--ok)'; '#3fae5c'='var(--ok)'
  '#ff8888'='var(--ng)'; '#802020'='var(--ng)'; '#882222'='var(--ng)'; '#ff9a7a'='var(--ng)'; '#cc8888'='var(--ng)'; '#ff7777'='var(--ng)'; '#ffaa88'='var(--ng)'; '#ff9c9c'='var(--ng)'
  '#4a8adc'='var(--info)'; '#4a8ade'='var(--info)'; '#2e6aa0'='var(--info)'
  '#1a3a5c'='var(--line)'; '#2a4a6c'='var(--line)'; '#1e3a58'='var(--line)'; '#16304a'='var(--line)'
  '#2e5a80'='var(--line-2)'; '#2a5a9c'='var(--line-2)'; '#6a9ccc'='var(--line-2)'
  '#0d2035'='var(--line-soft)'; '#12283f'='var(--line-soft)'
  '#071525'='var(--paper-3)'; '#1c3d5a'='var(--paper-3)'; '#1a2a3a'='var(--paper-3)'; '#0a1a2c'='var(--paper-3)'; '#10263d'='var(--paper-3)'
  '#264e72'='var(--paper-4)'
  '#0a1e30'='var(--paper-2)'; '#091a2e'='var(--paper-2)'; '#0d1f36'='var(--paper-2)'; '#0d2137'='var(--paper-2)'
  '#0c1e32'='var(--paper)'; '#0b1d33'='var(--paper)'
  '#26507e'='var(--card-cur)'
  '#040f1c'='var(--bar)'; '#061828'='var(--wood)'; '#1264b0'='var(--wood)'; '#040c18'='var(--paper-3)'
  'rgba(4,18,40,.85)'='var(--paper)'; 'rgba(4,15,28,.92)'='var(--paper)'; 'rgba(4,12,24,.82)'='transparent'
  'rgba(4,15,40,.97)'='var(--paper)'; 'rgba(6,20,40,.97)'='var(--paper)'; 'rgba(4,18,40,.96)'='var(--paper)'
  'rgba(160,0,0,.08)'='var(--ng-soft)'; 'rgba(160,0,0,.1)'='var(--ng-soft)'; 'rgba(100,0,0,.2)'='var(--ng-soft)'
  'rgba(0,180,80,.1)'='var(--ok-soft)'; 'rgba(0,180,80,.13)'='var(--ok-soft)'
  'rgba(244,164,96,.16)'='var(--accent-soft)'; 'rgba(244,164,96,.15)'='var(--accent-soft)'
  'rgba(255,255,255,.1)'='var(--line)'; 'rgba(255,255,255,.06)'='var(--line-soft)'
  'rgba(255,255,255,.03)'='rgba(0,0,0,.03)'; 'rgba(40,80,130,.4)'='var(--paper-3)'
  # notices / popups that had their own dark background and light text
  'rgba(0,80,20,.97)'='var(--paper)'; 'rgba(90,0,0,.97)'='var(--paper)'; '#3a0808'='var(--paper)'; '#3a1010'='var(--paper-3)'; '#2a0808'='var(--ng-soft)'
  '#44ff88'='var(--ok)'; '#ff5555'='var(--ng)'; 'rgba(50,255,100,.5)'='rgba(0,0,0,.2)'; 'rgba(255,50,50,.6)'='rgba(0,0,0,.2)'; 'rgba(154,79,220,.45)'='rgba(0,0,0,.2)'
  '#ffeecc'='var(--ink)'; '#ffccaa'='var(--ng)'; '#ffaaaa'='var(--ng)'; '#ff6666'='var(--ng)'; '#ff8a7a'='var(--ng)'
  '#f4d03f'='var(--gold)'; '#ffcc55'='var(--gold)'; '#c8a060'='var(--gold)'
  '#c890ff'='#6e4a7e'; '#e8b0ff'='#6e4a7e'; '#9aaecc'='var(--ink-2)'; '#aaa'='var(--ink-3)'
  # end screen dice chart
  '#a0c0e0'='var(--ink-2)'; '#e05555'='var(--ng)'; 'rgba(255,255,255,.18)'='rgba(0,0,0,.14)'
  # white text that sat on a dark popup background
  'color:#fff;font-size:14px;margin-top:4px'='color:var(--ink);font-size:14px;margin-top:4px'
  'color:#fff;font-size:14px;margin-top:5px'='color:var(--ink);font-size:14px;margin-top:5px'
  'color:#fff;font-size:15px;margin-top:5px'='color:var(--ink);font-size:15px;margin-top:5px'
  'font-weight:700;color:#fff;padding:14px'='font-weight:700;color:var(--ink);padding:14px'
  'font-size:20px;font-weight:700;color:#fff">'='font-size:20px;font-weight:700;color:var(--ink)">'
}
foreach ($k in $map.Keys) {
  $pat = [regex]::Escape($k)
  if ($k.StartsWith('#')) { $pat += '(?![0-9a-fA-F])' }
  $src = [regex]::Replace($src, $pat, $map[$k], 'IgnoreCase')
}

# ---- 1b) player colors used as TEXT are darkened so they read on paper ----
$src = [regex]::Replace($src, '(const PCOLORS\s*=\s*\[[^\]]*\];)', '$1' + "`n" +
  "const PCOLOR_INK={'#f03525':'#bd2a1c','#1db85e':'#137a3c','#1a90e0':'#1563a3','#ff9500':'#9a5200','#9e30c8':'#7a2299','#ff10a0':'#b80a72'};" +
  "function inkOf(c){return PCOLOR_INK[c]||c;}" +
  "const RES_CHIP={wood:'#2f6a28',brick:'#9a3f26',sheep:'#557f28',wheat:'#96700a',ore:'#55587a'};")
# resource chips drawn with the bright tile color + white text -> darker chip colors
$src = $src.Replace('background:${RES_COLOR[r]};color:#fff', 'background:${RES_CHIP[r]||RES_COLOR[r]};color:#fff')
$src = [regex]::Replace($src, 'color:\$\{([A-Za-z_][\w.]*)\.color\}', { param($m) 'color:${inkOf(' + $m.Groups[1].Value + '.color)}' })
$src = $src.Replace('color:${color};', 'color:${inkOf(color)};')
$src = $src.Replace('color:${PCOLORS[ci]||', 'color:${inkOf(PCOLORS[ci])||')
$src = [regex]::Replace($src, "color:'\+([A-Za-z_][\w.]*)\.color\+", { param($m) "color:'+inkOf(" + $m.Groups[1].Value + ".color)+" })

# ---- 2) emoji ----
# CPU / human markers in lists -> small "CPU" label
$src = [regex]::Replace($src, "\$\{([A-Za-z_][\w.]*)\.isAI\?'\uD83E\uDD16':'\uD83D\uDC64'\}", {
  param($m) '${' + $m.Groups[1].Value + ".isAI?'<span class=""cpu-tag"">CPU</span>':''}"
})
# ranking medals -> plain numbers
$src = [regex]::Replace($src, "const medals=\[[^\]]*\];", "const medals=['1.','2.','3.'];")
# decorative emoji (headings, buttons, labels, log decorations)
$deco = @(
  '\uD83E\uDD1D','\uD83D\uDD04','\uD83C\uDF10','\uD83C\uDFDD','\uD83D\uDCCA','\uD83D\uDD28','\uD83D\uDCE4','\uD83D\uDCE5',
  '\uD83C\uDFE6','\uD83D\uDC65','\uD83D\uDD22','\u26A1','\uD83D\uDE80','\uD83D\uDCE3','\uD83C\uDFA8','\u23F1','\uD83E\uDDE0',
  '\uD83D\uDE14','\u2699','\u2696','\uD83D\uDDFA','\uD83C\uDF89','\uD83D\uDCE8','\uD83D\uDCCB','\uD83D\uDEE0','\uD83D\uDD11',
  '\uD83D\uDFE2','\uD83D\uDFE1','\uD83E\uDD32','\uD83D\uDCE6','\uD83C\uDFC5','\uD83D\uDDD1','\uD83D\uDCB8','\uD83D\uDCD6',
  '\uD83D\uDD12','\uD83D\uDD13','\u23F8','\u23F3','\u2705','\u26A0','\uD83D\uDD0C','\uD83C\uDFC6','\u21A9\uFE0F','\u25B6',
  '\uD83E\uDD16','\uD83D\uDC64'
)
$src = [regex]::Replace($src, '(?:' + ($deco -join '|') + ')\uFE0F?[ \u3000]?', '')
# player card: remaining pieces are written as words instead of icons
$src = [regex]::Replace($src, '(<span title="[^"]*">)🏠️?<b>', '$1<span class="pk">開拓地</span><b>')
$src = [regex]::Replace($src, '(<span title="[^"]*">)🏙️?<b>', '$1<span class="pk">都市</span><b>')
$src = [regex]::Replace($src, '(<span title="[^"]*">)🛤️?<b>', '$1<span class="pk">街道</span><b>')
# settings labels / select options: drop any leading emoji so every row reads the same
$anyEmoji = '(?:[\uD83C-\uD83E][\uDC00-\uDFFF]|[\u2300-\u23FF\u2600-\u27BF\u2B50])\uFE0F?[ \u3000]?'
# action buttons: text only
$src = [regex]::Replace($src, "(add\(')" + $anyEmoji, '$1')
# special awards (right panel, award explanation, end-screen badges): text only
$src = [regex]::Replace($src, "row\('[^']*',('(?:\u6700\u5927\u9A0E\u58EB\u529B|\u6700\u9577\u4EA4\u6613\u8DEF)')", 'row('''',$1')
$src = $src.Replace('<span class="sp-label">${icon} ${p?short:full}', '<span class="sp-label">${icon?icon+'' '':''''}${p?short:full}')
$src = [regex]::Replace($src, $anyEmoji + '(?=(?:\u6700\u5927\u9A0E\u58EB\u529B|\u6700\u9577\u4EA4\u6613\u8DEF))', '')
$src = [regex]::Replace($src, '(<label[^>]*>)' + $anyEmoji, '$1')
$src = [regex]::Replace($src, '(<option[^>]*>)' + $anyEmoji, '$1')

# ---- 3) fonts + theme css ----
$fonts = '<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>' +
         '<link href="https://fonts.googleapis.com/css2?family=Shippori+Mincho+B1:wght@600;800&family=Zen+Kaku+Gothic+New:wght@400;500;700;900&display=swap" rel="stylesheet">'
$i = $src.IndexOf('</title>'); $src = $src.Insert($i + 8, "`n" + $fonts)
$i = $src.IndexOf('</style>'); $src = $src.Insert($i, "`n" + $css + "`n")

New-Item -ItemType Directory -Force (Join-Path $web 'new') | Out-Null
[IO.File]::WriteAllText((Join-Path $web 'new\index.html'), $src, $utf8)
[IO.File]::WriteAllText((Join-Path $root 'catan6-online-board.html'), $src, $utf8)
Write-Host 'built new\index.html'
