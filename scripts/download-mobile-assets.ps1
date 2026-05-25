$baseUrl = "http://localhost:3845/assets"
$outDir = Join-Path $PSScriptRoot "..\assets\figma"

$files = @(
  "c23ac0d2708e53c95e690ef9e873ee40b9b8c661.png",
  "7c2c5821cd1371845782ea53efeb4ade7a7d7cba.png",
  "e7b7292fa7f8201c8c7ed1e3b0e7579a72efa1dc.png",
  "adf59319add5c533f94462ff9633e5dc0cbbbc47.png",
  "a072cb1188ddd7c1f1ab87479375bf1ec5f3acbb.png",
  "df7f5b720adeee6cef35e3dcc3d96eb8975ff407.png",
  "a717f68603bdfcbf47ab660825cfc6e725c0aff3.png",
  "90572afe41f44e4021e2ff513bbd6d8543bd92fe.png",
  "c41925e9d4da0101bb06eb5a179795a4d1546a8b.png",
  "85eca10b4aabc80db579fbfa39c6332e79f48d0a.png",
  "7cf60d5f5a4fdbecc82f9accae2c5264f0d81959.png",
  "25eda52697b0771bf9107ca97468c64ca78610b6.png",
  "b211de8ce0c8d35552824c7e3742a56df3f1cf3b.svg",
  "37e476f40b68a0b5173ee97642b3c5b6d787bd14.svg",
  "cbf243c133d472d376443019f7e8e12d4cb86a4a.svg",
  "47b233cb797e987ecd8568b77fdc74569177fd10.svg",
  "e9811aa8292ed04a5b16db7943ca90cb0f91a6d3.svg",
  "c6e44e688c747d1833c27a02d4df2c8d9e5c76c3.svg",
  "3cd73e337c12ad5811a5040de66c810b3e1fabf9.svg",
  "2bd4b784e0121f0ee948b86862c476ac642f83c7.svg",
  "7eb14bf3acdcf59f9735c846c23aff69e79e3e0b.svg",
  "efc71344f200b2330e9d3398552e6b8d9d0698cf.svg",
  "c6101dff76c3615c363e0d7a71526698c73de2f5.svg",
  "261e2095c9c276d5af43b554c6634a54a9f96366.svg",
  "3cc1e7f14aab9af0bfa7cc03b749d68124f07715.svg",
  "b8c72bb8400b78fd403c5b511e8d65411ccfd9f3.svg",
  "c42703ffeaee5359f349879b4354382be7179813.svg",
  "27f50cffd68f79d81ba855ac319c2ddb2f544f74.svg",
  "30b48c989e8084f59d6d651a7046efeb155b26ff.svg",
  "078f5a42e6fe247af8723c7a76bd394ca64489f5.svg",
  "9d26faf9932f47a9b3f998faab820f715c764478.svg",
  "e8f0456a5049006c62731236888e935f6782a92b.svg"
)

foreach ($f in $files) {
  $outPath = Join-Path $outDir $f
  if (!(Test-Path $outPath)) {
    try {
      Invoke-WebRequest -Uri "$baseUrl/$f" -OutFile $outPath -ErrorAction Stop
      Write-Host "Downloaded: $f"
    } catch {
      Write-Host "FAILED: $f - $($_.Exception.Message)"
    }
  } else {
    Write-Host "EXISTS: $f"
  }
}
