Add-Type -AssemblyName System.Drawing
$src = 'c:\projects\crumbo\art\rive\owl_sleep_closed.png'
$dst = 'c:\projects\crumbo\art\rive\owl_sleep_closed_alpha.png'
$bmp = New-Object System.Drawing.Bitmap $src
$out = New-Object System.Drawing.Bitmap $bmp.Width, $bmp.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$knocked = 0
for ($y = 0; $y -lt $bmp.Height; $y++) {
  for ($x = 0; $x -lt $bmp.Width; $x++) {
    $c = $bmp.GetPixel($x, $y)
    # Near-black backdrop (pack renders on black)
    if ($c.R -lt 40 -and $c.G -lt 40 -and $c.B -lt 40) {
      $out.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
      $knocked++
    } else {
      $out.SetPixel($x, $y, $c)
    }
  }
}
$out.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$out.Dispose()
Write-Output "saved $dst knocked=$knocked"
