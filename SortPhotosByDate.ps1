# Ensure we can use System.Drawing to read EXIF data
Add-Type -AssemblyName System.Drawing

function Sort-Photos {
    param (
        [string]$sourceFolder
    )

    # Get all JPG, JPEG, and PNG files in the folder
    $files = Get-ChildItem -Path $sourceFolder -File | Where-Object { $_.Extension -match "^(?i)\.(jpg|jpeg|png)$" }

    if ($files.Count -eq 0) {
        Write-Host "No image files found in $sourceFolder. Skipping..."
        return
    }

    # Iterate through each file
    foreach ($file in $files) {
        $dateTaken = $null  # Reset for each file

        try {
            # Open the file in a way that does NOT lock it
            $fs = [System.IO.File]::OpenRead($file.FullName)
            $image = [System.Drawing.Image]::FromStream($fs, $true, $true)

            # Get the "Date Taken" property (EXIF tag 36867)
            $propId = 36867  # PropertyTagExifDTOrig
            if ($image.PropertyIdList -contains $propId) {
                $dateTakenProp = $image.GetPropertyItem($propId)
                $dateTakenString = [System.Text.Encoding]::ASCII.GetString($dateTakenProp.Value).Trim()

                # Remove null terminators if present
                $dateTakenString = $dateTakenString -replace '\0', ''

                # Parse EXIF date format: "yyyy:MM:dd HH:mm:ss"
                $dateTaken = [datetime]::ParseExact($dateTakenString, "yyyy:MM:dd HH:mm:ss", $null)
            }
        } catch {
            Write-Host "Error reading EXIF data for: $($file.Name) - Using LastWriteTime instead"
        } finally {
            # Ensure the file stream is closed to release the lock
            if ($fs) { $fs.Close(); $fs.Dispose() }
            if ($image) { $image.Dispose() }
        }

        # If Date Taken is still null, fall back to LastWriteTime
        if ($null -eq $dateTaken) {
            $dateTaken = $file.LastWriteTime
        }

        # Format the folder name as "Month Year" (e.g., "March 2017")
        $folderName = $dateTaken.ToString("MMMM yyyy")

        # Create the destination folder if it doesn't exist
        $destinationFolder = Join-Path -Path $sourceFolder -ChildPath $folderName
        if (!(Test-Path -Path $destinationFolder)) {
            New-Item -ItemType Directory -Path $destinationFolder | Out-Null
        }

        # Move the file to the appropriate folder
        Move-Item -Path $file.FullName -Destination $destinationFolder -Force
    }

    Write-Host "Sorting photos into month-year folders complete!"

    # Now move "Month Year" folders into their respective "Year" folders
    $monthYearFolders = Get-ChildItem -Path $sourceFolder -Directory | Where-Object { $_.Name -match '^(January|February|March|April|May|June|July|August|September|October|November|December) \d{4}$' }

    foreach ($folder in $monthYearFolders) {
        # Extract the year from "Month Year"
        $year = $folder.Name -replace '^\D+ ', ''

        # Define the year folder path
        $yearFolder = Join-Path -Path $sourceFolder -ChildPath $year

        # Create the year folder if it doesn't exist
        if (!(Test-Path -Path $yearFolder)) {
            New-Item -ItemType Directory -Path $yearFolder | Out-Null
        }

        # Move the month-year folder into the year folder
        Move-Item -Path $folder.FullName -Destination $yearFolder -Force
    }

    Write-Host "Sorting complete! All month-year folders are now inside their respective year folders."
}

# Main Loop
do {
    Clear-Host
    $sourceFolder = Read-Host "Enter the path to the folder containing photos"

    if (!(Test-Path -Path $sourceFolder)) {
        Write-Host "Invalid path! Please enter a valid folder path."
        continue
    }

    Sort-Photos -sourceFolder $sourceFolder

    $choice = Read-Host "Do you want to sort another folder? (yes/no)"
} while ($choice -match "^(yes|y)$")

Write-Host "Exiting... Have a great day!"
