Scripts I use to backup container volumes/local folders on my server (using restic)

# Usage
- Copy `compose.override.example.yaml` into `compose.override.yaml` and edit values
- `docker compose up -d`

# .resticignore files

Folders backed up manually (through additions in /raw-backups/) will read any `.resticignore` files it finds and treat it like a .gitignore, not backuping up any paths in it

Example content of a `.resticignore` file:
```
*
!backend/.env
```
