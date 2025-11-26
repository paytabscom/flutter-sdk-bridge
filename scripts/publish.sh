#!/bin/bash

# Exit on error
set -e

# Configuration
PACKAGE_NAME="flutter_paytabs_bridge"

echo "Setting up pub.dev credentials from environment variables..."

# Validate required environment variables
if [ -z "$PUBDEV_ACCESS_TOKEN" ] || [ -z "$PUBDEV_REFRESH_TOKEN" ] || [ -z "$PUBDEV_TOKEN_EXPIRATION" ]; then
  echo "Error: Missing required environment variables:"
  echo "  - PUBDEV_ACCESS_TOKEN"
  echo "  - PUBDEV_REFRESH_TOKEN"
  echo "  - PUBDEV_TOKEN_EXPIRATION"
  exit 1
fi

# Create pub-cache directory
PUB_CACHE_DIR="$HOME/.pub-cache"
mkdir -p "$PUB_CACHE_DIR"

# Create credentials file in the correct format for pub.dev
cat > "$PUB_CACHE_DIR/credentials.json" << EOF
{
  "version": 1,
  "hosted": [{
    "url": "https://pub.dartlang.org",
    "credentialType": "oauth2",
    "accessToken": "$PUBDEV_ACCESS_TOKEN",
    "refreshToken": "$PUBDEV_REFRESH_TOKEN",
    "tokenExpiration": $PUBDEV_TOKEN_EXPIRATION
  }]
}
EOF

# Set correct file permissions
chmod 600 "$PUB_CACHE_DIR/credentials.json"

echo "✓ Credentials file created at: $PUB_CACHE_DIR/credentials.json"
echo "✓ File permissions set to 600"

# Get Flutter dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# Publish the package
echo "Publishing $PACKAGE_NAME to pub.dev..."
flutter pub publish --force

echo "✓ Successfully published $PACKAGE_NAME to pub.dev"
