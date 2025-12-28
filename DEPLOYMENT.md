# Deployment Workflow

## Quick Start (No Memory Needed!)

Just run this command anytime you need deployment zips:

```bash
./create-deployment.sh
```

That's it! The script automatically:
- ✅ Reads the version from README.md
- ✅ Creates versioned zips (e.g., `CIP-deployment-v1.0.10.zip`)
- ✅ Creates quick-access copies (`CIP-deployment.zip`, `CPIA-deployment.zip`)

## When Making a New Release

1. **Update version in README.md**
   ```
   ## Version
   Latest: v1.0(11) - December 2024
   ```

2. **Run the deployment script**
   ```bash
   ./create-deployment.sh
   ```

3. **Commit to git (optional, for version history)**
   ```bash
   git add -f *-deployment*.zip
   git commit -m "Add deployment zips (v1.0.11)"
   git push
   ```

4. **Download from GitHub or local files**
   - Quick access: `CIP-deployment.zip` and `CPIA-deployment.zip`
   - Versioned: `CIP-deployment-v1.0.11.zip` and `CPIA-deployment-v1.0.11.zip`

5. **Upload to tiiny.site**
   - CIP → cip.tiiny.site
   - CPIA → cpia.tiiny.site

## Retrieving Old Versions

All versioned zips are saved in git history:

```bash
# List all deployment commits
git log --all --oneline | grep -i deploy

# Get a specific old version
git show COMMIT_HASH:CIP-deployment-v1.0.9.zip > old-version.zip
```

## No AI Memory Required!

The script is self-contained and reads everything from your README.md.
Just run `./create-deployment.sh` whenever you need fresh deployment zips.
