Add-Type -AssemblyName System.Drawing
$src = 'c:\projects\crumbo\art\rive\owl_sleep_base.png'
$dst = 'c:\projects\crumbo\art\rive\owl_sleep_closed.png'

# Prefer freshly rendered frame if present under assets
$alt = 'c:\projects\crumbo\assets\rive\owl.frame.png'
if (Test-Path $alt) {
  # keep using $src if we copied; else copy alt
  if (-not (Test-Path $src) -or ((Get-Item $alt).LastWriteTime -gt (Get-Item $src).LastWriteTime)) {
    Copy-Item -Force $alt $src
  }
}

$bmp = [System.Drawing.Bitmap]::FromFile($src)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Measured iris centers from pack think pose
$eyes = @(
  @{ X = 211; Y = 222 },
  @{ X = 268; Y = 214 }
)

$face = [System.Drawing.Color]::FromArgb(255, 232, 208, 174)
$lash = [System.Drawing.Color]::FromArgb(255, 74, 47, 28)
$cheek = [System.Drawing.Color]::FromArgb(110, 255, 171, 145)
$faceBrush = New-Object System.Drawing.SolidBrush $face
$lashPen = New-Object System.Drawing.Pen $lash, 3.6
$lashPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$lashPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$cheekBrush = New-Object System.Drawing.SolidBrush $cheek

foreach ($e in $eyes) {
  # Soft lid covering pupil (ellipse)
  $g.FillEllipse($faceBrush, $e.X - 18, $e.Y - 14, 36, 26)
  # Curved closed-eye crease (smile arc)
  $rect = New-Object System.Drawing.Rectangle ($e.X - 15), ($e.Y - 4), 30, 16
  $g.DrawArc($lashPen, $rect, 20, 140)
  # Cheek blush
  $g.FillEllipse($cheekBrush, $e.X - 34, $e.Y + 18, 20, 12)
}

$g.Dispose()
$bmp.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$lashPen.Dispose()
$faceBrush.Dispose()
$cheekBrush.Dispose()
Write-Output "saved $dst"
