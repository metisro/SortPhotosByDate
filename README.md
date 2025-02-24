# Sort Photos by Date Taken

## Overview

This PowerShell script (and its compiled `.exe` version) automatically organizes photos into folders based on the **Date Taken** metadata. It supports `.jpg`, `.jpeg`, and `.png` files.

**Version:** 1.0

### Features

- Reads the **Date Taken** from EXIF metadata (if available) or falls back to the last modified date.
- Sorts images into folders named **"Month Year"** (e.g., `March 2020`).
- Moves all **Month Year** folders into a **Year** folder (e.g., `2020/March 2020`).
- Works with `.jpg`, `.jpeg`, and `.png` files.
- Interactive prompt for selecting a folder.
- Allows processing multiple folders in one session.
- Available as both a **PowerShell script** and a standalone **Windows executable ([SortPhotosByDate](SortPhotosByDate.exe))**.

## Requirements

### For the PowerShell Script

- Windows 10 or later
- PowerShell 5.1 or later
- Execution Policy set to allow script execution:
  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process -Force
  ```

### For the EXE Version

- Windows 10 or later
- No additional dependencies required

## Installation

### Option 1: Using the PowerShell Script

1. Download `` from this repository.
2. Right-click the file, select **Properties**, and check **Unblock** (if blocked).
3. Open PowerShell and run:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   ```
4. Run the script:
   ```powershell
   .\SortPhotosByDate.ps1
   ```

### Option 2: Using the EXE (Standalone)

1. Download ``.
2. Double-click the `.exe` file to start sorting your photos.

## Usage

1. When the script/exe starts, it will prompt you to enter the **path** of the folder containing photos.
2. It will analyze all `.jpg`, `.jpeg`, and `.png` files.
3. Files will be sorted into **Month Year** folders (e.g., `May 2021`).
4. All **Month Year** folders will be moved into a **Year** folder (e.g., `2021/May 2021`).
5. After processing, the script will ask if you want to sort another folder or exit.

## Example

Before Running:

```
C:\Photos
   ├── photo1.jpg (taken on April 5, 2022)
   ├── photo2.png (taken on May 10, 2021)
   ├── photo3.jpeg (taken on May 15, 2021)
```

After Running:

```
C:\Photos
   ├── 2021
   │   ├── May 2021
   │   │   ├── photo2.png
   │   │   ├── photo3.jpeg
   ├── 2022
   │   ├── April 2022
   │   │   ├── photo1.jpg
```

## Compilation (For Developers)

To compile the PowerShell script into an EXE with an icon:

```powershell
Install-Module -Name ps2exe -Scope CurrentUser
Invoke-PS2EXE SortPhotosByDate.ps1 SortPhotosByDate.exe -NoConsole -IconFile "icon.ico"
```

## License

This project is provided "as-is" without any warranties or guarantees. The author is not responsible for any issues or data loss that may occur while using this software. Use at your own risk.

This project is released under the [MIT License](LICENSE).

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to fork this repository and submit pull requests.

## Author

metisro - GitHub: https://github.com/metisro

