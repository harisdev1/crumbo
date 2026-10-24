Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile('c:\projects\crumbo\art\rive\owl_sleep_base_open_alpha.png')
# Find cream eye-disc pixels then cluster
$hits = New-Object System.Collections.Generic.List[object]
for ($y = 160; $y -lt 250; $y++) {
  for ($x = 170; $x -lt 310; $x++) {
    $c = $bmp.GetPixel($x, $y)
    if ($c.A -lt 200) { continue }
    # cream eye disc
    if ($c.R -gt 220 -and $c.G -gt 200 -and $c.B -gt 170 -and $c.R -lt 255) {
      $hits.Add([pscustomobject]@{X=$x;Y=$y})
    }
  }
}
$mid = ($hits | Measure-Object -Property X -Average).Average
$left = $hits | Where-Object { $_.X -lt $mid }
$right = $hits | Where-Object { $_.X -ge $mid }
function Center($pts) {
  $cx = ($pts | Measure-Object -Property X -Average).Average
  $cy = ($pts | Measure-Object -Property Y -Average).Average
  # darkest pixel near center = pupil
  $best = $null; $bestScore = 9999
  foreach ($p in $pts) {
    if ([math]::Abs($p.X-$cx) -gt 22 -or [math]::Abs($p.Y-$cy) -gt 22) { continue }
    $c = $bmp.GetPixel([int]$p.X, [int]$p.Y)
    $score = [int]$c.R + [int]$c.G + [int]$c.B
    # prefer darker
    $c2 = $bmp.GetPixel([int]$p.X, [int]$p.Y)
  }
  # scan disc bbox for darkest brown
  $minX = ($pts | Measure-Object -Property X -Minimum).Minimum
  $maxX = ($pts | Measure-Object -Property X -Maximum).Maximum
  $minY = ($pts | Measure-Object -Property Y -Minimum).Minimum
  $maxY = ($pts | Measure-Object -Property Y -Maximum).Maximum
  $px=0;$py=0;$best=99999
  for ($y=[int]$minY; $y -le [int]$maxY; $y++) {
    for ($x=[int]$minX; $x -le [int]$maxX; $x++) {
      $c = $bmp.GetPixel($x,$y)
      if ($c.A -lt 200) { continue }
      if ($c.R -lt 150 -and $c.G -lt 120 -and $c.B -lt 100) {
        $s = [int]$c.R+[int]$c.G+[int]$c.B
        if ($s -lt $best) { $best=$s; $px=$x; $py=$y }
      }
    }
  }
  return @{ Cx=[math]::Round($cx,1); Cy=[math]::Round($cy,1); Px=$px; Py=$py; N=$pts.Count; Box="$minX-$maxX,$minY-$maxY" }
}
$L = Center $left
$R = Center $right
Write-Output ("LEFT disc={0},{1} pupil={2},{3} n={4} box={5}" -f $L.Cx,$L.Cy,$L.Px,$L.Py,$L.N,$L.Box)
Write-Output ("RIGHT disc={0},{1} pupil={2},{3} n={4} box={5}" -f $R.Cx,$R.Cy,$R.Px,$R.Py,$R.N,$R.Box)
$bmp.Dispose()
