# Counter-Strike 2 Configuration

## One-line install

With default steam path
```powershell
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/alex-bue/cs2-config/main/Get.ps1")))
```

With argument for custom steam / cs2 config path
```powershell
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/alex-bue/cs2-config/main/Get.ps1"))) -Cs2ConfigPath "C:\Games\Steam\steamapps\common\Counter-Strike Global Offensive\game\csgo\cfg"
```
