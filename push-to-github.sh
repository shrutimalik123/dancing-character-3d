#!/bin/bash
echo "🚀 Uploading to GitHub..."
git remote add origin https://github.com/shrutimalik123/dancing-character-3d.git 2>/dev/null || echo "Remote already exists, continuing..."
git branch -M main
git push -u origin main
echo "✅ Done! Check your repo at: https://github.com/shrutimalik123/dancing-character-3d"
