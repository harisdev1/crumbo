Add-Type -AssemblyName System.Drawing
$src = 'c:\projects\crumbo\art\rive\owl_sleep_base_open_alpha.png'
$dst = 'c:\projects\crumbo\art\rive\owl_sleep_closed_clean.png'
$bmp = [System.Drawing.Bitmap]::FromFile($src)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

# Exact disc cream from pack face
$face = [System.Drawing.Color]::FromArgb(255, 241, 225, 190)
$brush = New-Object System.Drawing.SolidBrush $face
$pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 74, 47, 28)), 4.0
$pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round

# Fully repaint each eye disc interior (measured boxes), then crescent
# Left disc ~188-254 x 187-247
$g.FillEllipse($brush, 192, 192, 58, 52)
# Right disc ~255-309 x 189-249
$g.FillEllipse($brush, 258, 194, 52, 50)

# Matching crescents centered in discs
$g.DrawArc($pen, 200, 208, 42, 22, 20, 140)
$g.DrawArc($pen, 264, 208, 40, 22, 20, 140)

$g.Dispose()
$bmp.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$brush.Dispose()
$pen.Dispose()
Write-Output "saved $dst"
