<h1 align="center">VS Code Extension Manager for Sui Developers</h1>

A simple yet powerful Bash script to streamline the management of your Visual-Studio-Code extensions. This tool is designed to help you quickly set up a clean development environment, especially for Sui Move developers, by protecting your essential Sui-related extensions while allowing you to manage others efficiently.

![demo](https://user-images.githubusercontent.com/13322818/129482713-f6a6f1e0-8d1e-11eb-8d24-5d5d8c4c7c6e.gif)

## ✨ Features

-   **Selective Uninstall:** Uninstall all extensions except for a predefined list of essential Sui Move development tools.
-   **Bulk Install:** Install a curated list of extensions for different development profiles (Python, Flutter, AI, etc.).
-   **Extension Profiles:** Install predefined sets of extensions based on development needs (e.g., Python, Flutter, AI).
-   **Customizable Lists:** Easily add or remove extensions from the "keep" and "install" lists.
-   **Export & Sync:** Export your current extension setup to a file or sync extensions from a remote URL.
-   **Stats & Suggestions:** Get statistics on your installed extensions and receive smart suggestions for missing tools.
-   **Dry Run Mode:** Test the script's actions without making any actual changes to your VS Code setup.
-   **Plugin System:** Extend the script's functionality by adding your own plugins.

## 🚀 Getting Started

### Prerequisites

-   [Visual Studio Code](https://code.visualstudio.com/) installed on your system.
-   The `code` command-line tool must be available in your PATH. You can add it by opening the Command Palette in VS Code (`Ctrl+Shift+P` or `Cmd+Shift+P`) and typing `Shell Command: Install 'code' command in PATH`.

### Installation

1.  Clone this repository or download the `vscode-ext-manager.sh` script to your local machine.

    ```bash
    git clone https://github.com/CYBWithFlourish/VSCode-Ext-Manager.git
    cd your-repo-name
    ```

2.  Make the script executable:

    ```bash
    chmod +x vscode-ext-manager.sh
    ```

### Usage

Run the script from your terminal:

```bash
./vscode-ext-manager.sh
```

You will be presented with a menu of options to choose from.

#### Dry Run Mode

To see what the script *would* do without actually uninstalling or installing any extensions, use the `--dry-run` flag:

```bash
./vscode-ext-manager.sh --dry-run
```

## 🛠️ Configuration

You can customize the lists of extensions directly within the script:

-   `KEEP_EXTENSIONS`: This array contains the extension IDs that will be protected from uninstallation. This is ideal for your essential Sui Move development extensions.
-   `INSTALL_LIST`: This array contains a list of extensions that you can choose to install.
-   `*_PROFILE`: These arrays define the extensions for different development profiles (e.g., `PYTHON_PROFILE`, `FLUTTER_PROFILE`).

To find the ID of an extension, navigate to its page in the VS Code Marketplace. The ID is typically in the format `publisher.extension-name`.

## ⚙️ Menu Options

1.  **Install extensions from list:** Choose from the `INSTALL_LIST` to install extensions individually or all at once.
2.  **Uninstall all except Sui Move dev extensions:** Cleans your VS Code setup by removing all extensions not in the `KEEP_EXTENSIONS` list.
3.  **Add extension to install or keep list:** Add new extension IDs to the `INSTALL_LIST` or `KEEP_EXTENSIONS` list.
4.  **Export current extensions to file:** Saves a list of all your currently installed extensions to a `vscode-extensions.txt` file.
5.  **Reset all extensions:** A dangerous option that will uninstall *all* of your extensions.
6.  **Show extension stats:** Displays a summary of your installed, kept, and to-be-removed extensions.
7.  **Smart suggestions:** Checks if any of the essential `KEEP_EXTENSIONS` are missing from your setup.
8.  **Install by profile:** Quickly install a group of extensions defined in a profile (e.g., Python, AI).
9.  **Search extensions:** Search for an extension within the `INSTALL_LIST`.
10. **Sync from remote URL:** Install extensions from a list hosted at a given URL.

## 🤝 Contributing

Contributions are welcome! If you have ideas for new features or improvements, feel free to open an issue or submit a pull request.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
