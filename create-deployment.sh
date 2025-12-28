#!/bin/bash

# Automatic deployment zip creator - reads version from README.md
# Usage: ./create-deployment.sh

# Extract version from README.md
VERSION=$(grep -E "^## Version|Latest:" README.md | grep -oE "v[0-9]+\.[0-9]+\([0-9]+\)" | head -1)

if [ -z "$VERSION" ]; then
    echo "❌ Could not find version in README.md"
    echo "Looking for pattern like: Latest: v1.0(10) - December 2024"
    exit 1
fi

# Convert v1.0(10) to v1.0.10 for filename
VERSION_CLEAN=$(echo $VERSION | sed 's/v\([0-9]*\)\.\([0-9]*\)(\([0-9]*\))/v\1.\2.\3/')

echo "📦 Creating deployment zips for version: $VERSION_CLEAN"
echo ""

# Create versioned zips
zip -q -r "CIP-deployment-${VERSION_CLEAN}.zip" CIP/ -x "*.DS_Store" "*.git*"
zip -q -r "CPIA-deployment-${VERSION_CLEAN}.zip" CPIA/ -x "*.DS_Store" "*.git*"

# Also create non-versioned copies for easy access
cp "CIP-deployment-${VERSION_CLEAN}.zip" "CIP-deployment.zip"
cp "CPIA-deployment-${VERSION_CLEAN}.zip" "CPIA-deployment.zip"

echo "✅ Created versioned deployments:"
ls -lh *-deployment-${VERSION_CLEAN}.zip

echo ""
echo "✅ Created quick-access copies:"
ls -lh CIP-deployment.zip CPIA-deployment.zip

echo ""
echo "📤 To commit and push to GitHub:"
echo "  git add -f *-deployment*.zip"
echo "  git commit -m 'Add deployment zips ($VERSION_CLEAN)'"
echo "  git push"

echo ""
echo "💡 Version is automatically read from README.md"
echo "   Current version: $VERSION_CLEAN"
