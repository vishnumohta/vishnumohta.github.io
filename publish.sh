#!/usr/bin/env bash
# Stamp build-ts (freshness check reloads open tabs when this is newer) and push the homepage.
set -euo pipefail
cd "$(dirname "$0")"
git pull -q --rebase origin main || true
python3 - <<'P'
import re,time
s=open('index.html').read()
s=re.sub(r'<meta name="build-ts" content="[^"]*">','<meta name="build-ts" content="%d">'%int(time.time()*1000),s,1)
open('index.html','w').write(s)
P
git add index.html publish.sh
git -c user.name=vishnumohta -c user.email=vishnumohta@users.noreply.github.com commit -qm "Update $(TZ=Asia/Kolkata date '+%F %H:%M IST')" || true
git push -q origin main
echo "Live: https://vishnumohta.github.io/"
