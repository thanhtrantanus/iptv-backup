#!/bin/bash
set -e

# Danh sách JSON cần tải: URL -> filename
declare -A FILES=(
  ["https://iptv.rophim.dev"]="rophim.json"
  ["https://op-pvd.moviedb.dev"]="ophim.json"
  ["https://kk-pvd.moviedb.dev"]="kkphim.json"
  ["https://vp-pvd.moviedb.dev"]="vipphim.json"
  ["https://tv-pvd.moviedb.dev"]="tvphim.json"
  ["https://iptv.animehay.dev"]="animehay.json"
  ["https://iptv.anime47.net"]="anime47.json"
  ["https://iptv.nangcucz.link"]="nangcuc.json"
  ["https://iptv.nangcucz.link/provider/vlxx"]="vlxx.json"
  ["https://iptv.nangcucz.link/provider/heovl"]="heovl.json"
  ["https://iptv.nangcucz.link/provider/sextop1"]="sextop1.json"
  ["https://iptv.nangcucz.link/provider/sexlive"]="sexlive.json"
  # ["https://example.com/data.json"]="dummy.json"   # uncomment khi cần
)

# Lặp qua từng file
for URL in "${!FILES[@]}"; do
  FILE="${FILES[$URL]}"
  echo "⬇️ Downloading $FILE from $URL"
  curl -s -L "$URL" -o "$FILE"

  echo "🔍 Validating $FILE"
  if jq . "$FILE" > /dev/null 2>&1; then
    echo "✅ $FILE is valid JSON"
  else
    echo "❌ $FILE is invalid JSON, skipping commit"
    rm "$FILE"
  fi
done

# Commit nếu có thay đổi
git config --global user.name "github-actions[bot]"
git config --global user.email "github-actions[bot]@users.noreply.github.com"
git add *.json || true
if git diff --cached --quiet; then
  echo "✅ No changes in JSON files"
else
  git commit -m "Update JSON files"
  git push
fi
