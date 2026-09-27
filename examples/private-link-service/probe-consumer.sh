#!/bin/sh
set -eu
getent ahostsv4 web.networklab.internal
python3 - <<'PY'
import urllib.request
response=urllib.request.urlopen("http://web.networklab.internal/",timeout=10)
body=response.read().decode()
print("HTTP", response.status, "expected_response=", "network-lab-private-http" in body)
if response.status != 200 or "network-lab-private-http" not in body:
    raise SystemExit("Unexpected private service response")
PY
