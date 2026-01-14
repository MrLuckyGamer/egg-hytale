# Hytale Server Egg

![GitHub License](https://img.shields.io/github/license/NATroutter/egg-hytale?style=for-the-badge) ![GitHub Issues](https://img.shields.io/github/issues/NATroutter/egg-hytale?style=for-the-badge)
![GitHub Stars](https://img.shields.io/github/stars/NATroutter/egg-hytale?style=for-the-badge) ![GitHub Forks](https://img.shields.io/github/forks/NATroutter/egg-hytale?style=for-the-badge)

Panel eggs for hosting Hytale game servers on both Pelican and Pterodactyl panels.

## Overview

This egg provides an automated installation and startup configuration for Hytale servers. It handles downloading the Hytale server files, setting up the environment, and starting the server with customizable parameters.

Both Pelican Panel and Pterodactyl Panel are fully supported with dedicated egg files for each platform.

## Features

- Automated Hytale server installation
- Automatic download of server files from official sources
- Configurable server parameters
- Easy setup and deployment
- Support for custom asset packs
- Backup management
- Multiple authentication modes

## Installation

### Pelican Panel

1. Download the [egg-hytale.pelican.json](egg-hytale.pelican.json) file from this repository
2. In your Pelican Panel, navigate to **Admin Panel** > **Eggs**
3. Click **Import**
4. Select the downloaded JSON file and click **Submit**

### Pterodactyl Panel

1. Download the [egg-hytale.pterodactyl.json](egg-hytale.pterodactyl.json) file from this repository
2. In your Pterodactyl Panel, navigate to **Admin Panel** > **Nests**
3. Select or create a nest for the egg
4. Click **Import Egg**
5. Select the downloaded JSON file and click **import**

## Updating the Egg

When a new version of the egg is released, follow these steps to update:

### Pelican Panel

1. Download the latest [egg-hytale.pelican.json](egg-hytale.pelican.json) file from this repository
2. In your Pelican Panel, navigate to **Admin Panel** > **Eggs**
3. Click the "Hytale" egg from the list
4. Click **Import** on top right and select the downloaded JSON file

### Pterodactyl Panel

1. Download the latest [egg-hytale.pterodactyl.json](egg-hytale.pterodactyl.json) file from this repository
2. In your Pterodactyl Panel, navigate to **Admin Panel** > **Nests**
3. Click on the nest where hytale egg is imported
4. Click on the hytale egg to open it
5. On top of the page there update egg section where you can select the new egg Click **Update Egg**

## Server Configuration

The following options can be configured:

| Option | Description | Default |
| ---------- | ------------- | --------- |
| `Game Profile (username)` | Hytale profile username for server authentication. Visit [accounts.hytale.com](https://accounts.hytale.com/) → Game Profiles to find your username. Leave empty to use first profile. | (empty) |
| `Asset Pack` | Assets pack (.zip) that are being send to player | `Assets.zip` |
| `Accept Early Plugins` | Acknowledge that loading early plugins is unsupported and may cause stability issues | `false` |
| `Allow Operators` | Do you wish to allow operators or not | `true` |
| `Auth Mode` | Authentication mode (authenticated or offline) | `authenticated` |
| `Automatic Update` | Update the hytale server automatically | `true` |
| `JVM Arguments` | Additional Java Virtual Machine arguments for advanced configuration. | See egg config |
| `Leverage Ahead-Of-Time Cache` | The server ships with a pre-trained AOT cache (HytaleServer.aot) that improves boot times by skipping JIT warmup | `true` |
| `Disable Sentry Crash Reporting` | Disable Sentry during active plugin development. Hytale uses Sentry to track crashes. Disable it to avoid submitting your development errors | `true` |
| `Enable Backups` | Enable automatic backups | `false` |
| `Backup Frequency` | Backup interval in minutes | `30` |
| `Patchline` | What release channel you want to use | `release` |
| `Memory overhead` | The amount of RAM (in MB) kept aside for the system so the server doesn’t use everything. Java will get the rest. | `0` |

### First-Time Authentication

During the first start, the Hytale downloader will require authentication with your Hytale account. You'll see output similar to this in the console:

```txt
Please visit the following URL to authenticate:
https://oauth.accounts.hytale.com/oauth2/device/verify?user_code=XXXXXXXX
Or visit the following URL and enter the code:
https://oauth.accounts.hytale.com/oauth2/device/verify
Authorization code: XXXXXXXX
```

**To complete authentication:**

1. Open the provided URL in your web browser
2. Enter the authorization code shown in the console
3. Sign in with your Hytale account credentials
4. Authorize the server to download game files
5. Return to the console - the download will continue automatically

This authentication step is only required during initial setup. Subsequent server starts will not require re-authentication.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Hytale team for the game and server software
- Pelican Panel and Pterodactyl Panel for the hosting platforms
- Community contributors

## Links

- [Hytale Official Website](https://hytale.com/)
- [Pelican Panel](https://pelican.dev/)
- [Pterodactyl Panel](https://pterodactyl.io/)
- [Report Issues](https://github.com/NATroutter/egg-hytale/issues)

## Support

If you encounter any issues or have questions:

- Check existing issues for solutions
- Open an issue on GitHub

---

**Note**: This is an unofficial community-created egg and is not officially supported by Hypixel Studios or the Hytale team.
