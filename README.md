# Futur-Tech Paperless2Dolibarr

The `paperless2dolibarr` script automates the synchronization and integration of documents between Paperless and Dolibarr, ensuring efficient document management and accurate linking based on document types.

## Features

The script performs the following tasks:

1. **Rsync Synchronization**:
    - Establishes an `rsync` connection to synchronize files from a Paperless **archive** and **originals** folder.
    - Files from the **originals** folder are synced *only if an archived version doesn't exist* (e.g., encrypted PDFs).
    - Documents tagged with "Inbox" are skipped.

2. **Change Detection**: checks for changes detected during `rsync` and processes the newly added files.

3. **Symbolic Link Management**: creates or updates symbolic links for the added files in the appropriate destination directories in Dolibarr based on Document Types from Paperless.

4. **Link Removal**: removes symbolic links for files that no longer exist.

## Usage

```bash
/usr/local/bin/futur-tech-paperless2dolibarr/sync               # Runs only if there are rsync changes and adds links for new files.
/usr/local/bin/futur-tech-paperless2dolibarr/sync remove-all    # Removes all symbolic links, useful for changing the link prefix.
/usr/local/bin/futur-tech-paperless2dolibarr/sync process-all   # Processes all PDF files and checks if links are present.

LOG_DEBUG=true /usr/local/bin/futur-tech-paperless2dolibarr/sync process-all   # Show debug log.

```

## Deploy Commands

Everything is executed by only a few basic deploy scripts. 

```bash
cd /usr/local/src
git clone git@github.com:Futur-Tech/futur-tech-paperless2dolibarr.git
cd futur-tech-paperless2dolibarr

./deploy.sh 
# Main deploy script

./deploy-update.sh -b main
# This script will automatically pull the latest version of the branch ("main" in the example) and relaunch itself if a new version is found. Then it will run deploy.sh. Also note that any additional arguments given to this script will be passed to the deploy.sh script.
```


## Setup Paperless

1. Edit and translate all `ppl_type_` variables in `/usr/local/etc/futur-tech-paperless2dolibarr.conf`.
2. Create corresponding **Paperless Document Types** in Paperless.
3. Create a new **Storage Path** in Paperless:
    - **Name:** `Paperless2Dolibarr`
    - **Path:** `Paperless2Dolibarr/{document_type}/{title} [{tag_list}]`

4. Configure the Paperless server details in `/usr/local/etc/futur-tech-paperless2dolibarr.conf`.

## Setup Dolibarr

1. Edit the following variables in `/usr/local/etc/futur-tech-paperless2dolibarr.conf`:
    - `local_rsync_dir`: Directory to store rsync files.
    - `dol_documents_dir`: Path to the documents folder in Dolibarr.

## Setup Zabbix

A Zabbix template is available to monitor errors and files that do not match the expected patterns.
