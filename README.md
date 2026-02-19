# 🐺 LXR Tattoos - Advanced Tattoo Shop System

```
    ██╗     ██╗  ██╗██████╗       ████████╗ █████╗ ████████╗████████╗ ██████╗  ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ╚══██╔══╝██╔══██╗╚══██╔══╝╚══██╔══╝██╔═══██╗██╔═══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗   ██║   ███████║   ██║      ██║   ██║   ██║██║   ██║███████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝   ██║   ██╔══██║   ██║      ██║   ██║   ██║██║   ██║╚════██║
    ███████╗██╔╝ ██╗██║  ██║         ██║   ██║  ██║   ██║      ██║   ╚██████╔╝╚██████╔╝███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝         ╚═╝   ╚═╝  ╚═╝   ╚═╝      ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝
```

**Professional tattoo shop system for RedM with multi-framework support**

---

## 📋 Overview

LXR Tattoos is a comprehensive tattoo shop system for RedM that allows players to purchase and apply custom tattoos to their characters. The system features multiple tattoo designs, color customization, and full framework compatibility.

### ✨ Features

- 🎨 **16 Male & 16 Female Tattoo Designs** - Extensive variety of tattoos
- 🌈 **6 Color Options** - Customizable tattoo colors (Black, Red, Blue, Blood, Purple, Yellow)
- 🏪 **Tattoo Shop Locations** - NPC-based tattoo shops with blips
- 💰 **Configurable Pricing** - Adjust prices for tattoos and color changes
- 🔄 **Tattoo Management** - Option to remove individual or all tattoos
- 🎭 **Character Customization** - Gender-specific tattoo options
- 💾 **Database Persistence** - Tattoos saved to database
- 🔧 **Multi-Framework Support** - Compatible with multiple frameworks

---

## 🎯 Framework Support

### Primary Frameworks (Full Support)
- ✅ **LXR Core** (Primary)
- ✅ **RSG Core** (Primary)  
- ✅ **VORP Core** (Supported)

### Optional Frameworks
- ⚙️ **RedEM:RP** (Compatible)
- ⚙️ **QBR Core** (Compatible)
- ⚙️ **QR Core** (Compatible)
- ⚙️ **Standalone** (Basic functionality)

The system automatically detects your framework, or you can manually configure it in `shared/config.lua`.

---

## 📦 Installation

### 1. Download & Extract
```bash
# Extract to your resources folder
resources/[lxr]/lxr-tattoos/
```

### 2. Database Setup
Import the SQL file into your database:
```bash
mysql -u username -p database_name < tattoo.sql
```

### 3. Configure Server
Add to your `server.cfg`:
```cfg
ensure lxr-tattoos
```

### 4. Configuration
Edit `shared/config.lua` to customize:
- Tattoo shop locations
- Pricing structure
- NPC models and blips
- Framework settings
- Language preferences

---

## ⚙️ Configuration

### Basic Settings
```lua
Config.DEBUG = false                    -- Debug mode (all tattoos $1)
Config.ShowBlips = true                 -- Show shop blips on map
Config.ColorPrice = 50                  -- Price to change colors
Config.DeleteAllTattooOption = true    -- Allow removing all tattoos
Config.OnlyOneTattoo = false           -- Limit to one tattoo per character
```

### Shop Locations
```lua
Config.Shops = {
    {
        NPC = { x = 2720.2, y = -1290.25, z = 59.29, h = 20.1 },
        STOOL = { x = 2719.0, y = -1288.2, z = 59.34 }
    }
}
```

---

## 🎮 Usage

### For Players
1. Visit a tattoo shop (marked on the map)
2. Interact with the tattoo artist NPC
3. Browse available tattoo designs
4. Select a tattoo and choose your color
5. Confirm purchase

### For Server Owners
- Add/modify shop locations in `shared/config.lua`
- Adjust pricing in configuration
- Customize tattoo designs and colors
- Configure framework integration

---

## 🔧 Dependencies

- **RedM** (Latest version recommended)
- **mysql-async** (Database operations)
- **Framework** (LXR-Core, RSG-Core, VORP Core, or compatible)

---

## 📝 Resource Name

⚠️ **IMPORTANT**: This resource **MUST** be named `lxr-tattoos`. The resource includes runtime protection to ensure branding integrity.

---

## 🐺 About wolves.land

**The Land of Wolves** is a serious hardcore roleplay server for RedM, featuring Georgian culture and immersive gameplay.

- **Server**: Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
- **Type**: Serious Hardcore Roleplay
- **Access**: Discord & Whitelisted

---

## 📞 Support & Links

- 🌐 **Website**: [wolves.land](https://www.wolves.land)
- 💬 **Discord**: [Join our Discord](https://discord.gg/CrKcWdfd3A)
- 🐙 **GitHub**: [@iBoss21](https://github.com/iBoss21)
- 🛒 **Store**: [The Lux Empire Tebex](https://theluxempire.tebex.io)
- 🎮 **Server**: [RedM Server Listing](https://servers.redm.net/servers/detail/8gj7eb)

---

## 👨‍💻 Developer

**iBoss21 / The Lux Empire**

Specialized in RedM resource development with a focus on:
- Multi-framework compatibility
- Performance optimization
- Production-grade code quality
- Immersive roleplay features

---

## 📜 License

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved

This resource is branded for **The Land of Wolves** server. Respect the developer's work and maintain proper attribution.

---

## 🏷️ Tags

`RedM` `Georgian` `SeriousRP` `Whitelist` `Tattoos` `Customization` `Roleplay` `LXR-Core` `RSG-Core` `VORP` `Multi-Framework`

---

**🐺 History Lives Here! | ისტორია ცოცხლდება აქ!**
