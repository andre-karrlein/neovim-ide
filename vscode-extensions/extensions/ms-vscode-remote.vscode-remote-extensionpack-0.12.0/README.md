# Visual Studio Code Remote Development Extension Pack

> <span style="color:red">**Note:** You need [**Visual Studio Code Insiders**](https://code.visualstudio.com/insiders/) to use this extension pack!</span>

The **Remote Development** extension pack allows you to open any folder in a container, on a remote machine, or in the [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl) and take advantage of VS Code's full feature set. Since this lets you set up a full-time development environment anywhere, you can:

- Develop on the same operating system you deploy to or use larger, faster, or more specialized hardware than your local machine.
- Quickly swap between different, isolated development environments and safely make updates without worrying about impacting your local machine.
- Help new team members / contributors get productive quickly with easily spun up, consistent development containers.
- Take advantage of a Linux based tool-chain right from the comfort of Windows from a full-featured development tool.

No source code needs to be on your local machine to gain these benefits since Remote Development runs commands and extensions directly on the remote machine.

This **Remote Development extension pack** includes three extensions:

- **[Remote - SSH](https://aka.ms/vscode-remote/download/ssh)** - Work with source code in any location by opening folders on a remote machine/VM using SSH.
- **[Remote - Containers](https://aka.ms/vscode-remote/download/containers)** - Work with a sandboxed toolchain or container based application by opening any folder inside (or mounted into) a container.
- **[Remote - WSL](https://aka.ms/vscode-remote/download/wsl)** - Get a Linux-powered development experience from the comfort of Windows by opening any folder in the Windows Subsystem for Linux.

The Remote SSH extension at work:

![Remote SSH](https://microsoft.github.io/vscode-remote-release/images/ssh-readme.gif)


## Installation

1. Install [VS Code - Insiders](https://code.visualstudio.com/insiders) and this extension pack.

2. **Remote - SSH:** **Windows:** Install [an OpenSSH compatible SSH client](https://aka.ms/vscode-remote/ssh/supported-clients) and ensure that the `ssh` command is in your PATH.

3. **Remote - Containers:** Install and configure [Docker](https://www.docker.com/get-started) for your operating system.

    **Windows / macOS Users:**
    1. Install [Docker Desktop for Mac/Windows](https://www.docker.com/products/docker-desktop).
    2. Right-click on the Docker task bar item and update **Settings / Preferences > Shared Drives / File Sharing** with any source code locations you want to open in a container. If you hit trouble, see [here](https://aka.ms/vscode-remote/containers/troubleshooting) for tips on avoiding common problems with sharing.
    3. **Windows**: Disable automatic line ending conversion for Git by using a Windows command prompt to run: `git config --global core.autocrlf false` (If left enabled, this setting can cause files that you have not edited to appear modified due to line ending differences.)

    **Linux Users:**
    1. Follow the [Docker CE/EE install instructions for your distribution](https://docs.docker.com/install/#supported-platforms). *The Ubuntu Snap package is not supported*.
    2. Add your user to the `docker` group by using a terminal to run: `sudo usermod -aG docker $USER` Sign out and back in again so this setting takes effect.

4. **Remote - WSL:** Install the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) along with your preferred Linux distribution and then follows these steps:
     1. VS Code will use your **default distro**, so use `wslconfig.exe` to change your default as needed.
     2. Disable automatic line ending conversion for Git on the **Windows side** by using a command prompt to run: `git config --global core.autocrlf false` (If left enabled, this setting can cause files that you have not edited to appear modified due to line ending differences.)

## Getting started

Check out one of the following quick starts to get going.

- [SSH: Connect to a remote host](https://aka.ms/vscode-remote/ssh/getting-started)
- [Containers: Try a development container](https://aka.ms/vscode-remote/containers/getting-started/try)
- [Containers: Open an existing folder in a container](https://aka.ms/vscode-remote/containers/getting-started/open)
- [Containers: Attach to a container](https://aka.ms/vscode-remote/containers/getting-started/attach)
- [WSL: Open a folder in WSL](https://aka.ms/vscode-remote/wsl/getting-started)

### Available commands

Another way to learn what you can do with the Remote Development extensions is to browse the commands each of them provide. Press `F1` to bring up the Command Palette and type in `Remote-` for a full list of commands.

![Command palette](https://microsoft.github.io/vscode-remote-release/images/remote-command-palette.png)

You can also click on the Remote "Quick Access" status bar item in the lower left corner to get a list of the most common commands.

![Quick actions status bar item](https://microsoft.github.io/vscode-remote-release/images/remote-dev-status-bar.png)

For more information, please see the [extension pack documentation](https://aka.ms/vscode-remote).

## Questions, Feedback, Contributing

Have a question or feedback?

- See the [documentation](https://aka.ms/vscode-remote) or the [troubleshooting guide](https://aka.ms/vscode-remote/troubleshooting).
- [Up-vote a feature or request a new one](https://aka.ms/vscode-remote/feature-requests), search [existing issues](https://aka.ms/vscode-remote/issues), or [report a problem](https://aka.ms/vscode-remote/issues/new).
- Contribute a [development container definition](https://aka.ms/vscode-dev-containers) for others to use
- Contribute to [our documentation](https://github.com/Microsoft/vscode-docs)
- ...and more. See our [CONTRIBUTING](https://aka.ms/vscode-remote/contributing) guide for details.

Or connect with the community...

[![Twitter](https://microsoft.github.io/vscode-remote-release/images/Twitter_Social_Icon_24x24.png)](https://aka.ms/vscode-remote/twitter) [![Stack Overflow](https://microsoft.github.io/vscode-remote-release/images/so-image-24x24.png)](https://stackoverflow.com/questions/tagged/vscode) [![VS Code Dev Community Slack](https://microsoft.github.io/vscode-remote-release/images/Slack_Mark-24x24.png)](https://aka.ms/vscode-dev-community) [![VS CodeGitter](https://microsoft.github.io/vscode-remote-release/images/gitter-icon-24x24.png)](https://gitter.im/Microsoft/vscode)

## Telemetry

The Visual Studio Code Remote Development extension pack and its related extensions collect telemetry data to help us build a better experience working remotely from VS Code. We only collect data on which commands are executed. We do not collect any information about image names, paths, etc. The extension respects the `telemetry.enableTelemetry` setting which you can learn more about in the [Visual Studio Code FAQ](https://aka.ms/vscode-remote/telemetry).

## License

By downloading and using the Visual Studio Remote Development extension pack and its related components, you agree to the product [license terms](https://go.microsoft.com/fwlink/?linkid=2077057) and [privacy statement](https://www.microsoft.com/en-us/privacystatement/EnterpriseDev/default.aspx).
