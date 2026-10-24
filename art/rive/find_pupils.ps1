Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile('c:\projects\crumbo\art\rive\owl_sleep_base_open_alpha.png')
$hits = New-Object System.Collections.Generic.List[string]
for ($y = 150; $y -lt 260; $y += 2) {
  for ($x = 160; $x -lt 320; $x += 2) {
    $c = $bmp.GetPixel($x, $y)
    # dark brown iris
    if ($c.A -gt 200 -and $c.R -gt 50 -and $c.R -lt 140 -and $c.G -gt 30 -and $c.G -lt 100 -and $c.B -lt 80 -and ($c.R - $c.B) -gt 20) {
      $hits.Add("$x,$y")
    }
  }
}
$bmp.Dispose()
$xs = $hits | ForEach-Object { [int]($_ -split ',')[0] }
$ys = $hits | ForEach-Object { [int]($_ -split ',')[1] }
$mid = ($xs | Measure-Object -Average).Average
$leftX = @(); $leftY = @(); $rightX = @(); $rightY = @()
for ($i = 0; $i -lt $xs.Count; $i++) {
  if ($xs[$i] -lt $mid) { $leftX += $xs[$i]; $leftY += $ys[$i] } else { $rightX += $xs[$i]; $rightY += $ys[$i] }
}
function Avg($a) { if ($a.Count -eq 0) { return 0 }; ($a | Measure-Object -Average).Average }
Write-Output ("left pupil ~ {0:N1},{1:N1} n={2}" -f (Avg $leftX), (Avg $leftY), $leftX.Count)
Write-Output ("right pupil ~ {0:N1},{1:N1} n={2}" -f (Avg $rightX), (Avg $rightY), $rightX.Count)
Write-Output ("owl_body local L: {0:N1},{1:N1}" -f ((Avg $leftX) - 250), ((Avg $leftY) - 255))
Write-Output ("owl_body local R: {0:N1},{1:N1}" -f ((Avg $rightX) - 250), ((Avg $rightY) - 255))
