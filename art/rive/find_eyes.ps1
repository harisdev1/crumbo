Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile('c:\projects\crumbo\art\rive\owl_sleep_base.png')
# Sample for dark iris-ish brown pixels (not too dark bg)
$hits = New-Object System.Collections.Generic.List[string]
for ($y = 100; $y -lt 230; $y += 2) {
  for ($x = 150; $x -lt 360; $x += 2) {
    $c = $bmp.GetPixel($x, $y)
    if ($c.R -gt 40 -and $c.R -lt 120 -and $c.G -gt 25 -and $c.G -lt 90 -and $c.B -lt 70 -and ($c.R - $c.B) -gt 15) {
      $hits.Add("$x,$y")
    }
  }
}
$bmp.Dispose()
Write-Output "count=$($hits.Count)"
# cluster roughly into left/right by x mean of first/last quartiles
$xs = $hits | ForEach-Object { [int]($_ -split ',')[0] }
$ys = $hits | ForEach-Object { [int]($_ -split ',')[1] }
if ($xs.Count -gt 0) {
  $left = @(); $right = @()
  $mid = ($xs | Measure-Object -Average).Average
  for ($i = 0; $i -lt $xs.Count; $i++) {
    if ($xs[$i] -lt $mid) { $left += ,@($xs[$i], $ys[$i]) } else { $right += ,@($xs[$i], $ys[$i]) }
  }
  function Avg($pts, $idx) {
    if ($pts.Count -eq 0) { return 0 }
    ($pts | ForEach-Object { $_[$idx] } | Measure-Object -Average).Average
  }
  Write-Output ("leftEye ~ {0:N0},{1:N0} n={2}" -f (Avg $left 0), (Avg $left 1), $left.Count)
  Write-Output ("rightEye ~ {0:N0},{1:N0} n={2}" -f (Avg $right 0), (Avg $right 1), $right.Count)
}
