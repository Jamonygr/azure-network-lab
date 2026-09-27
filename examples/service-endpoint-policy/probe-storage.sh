#!/bin/sh
# Run on the owned managed-identity client VM; positional args are public account names.
set -eu
python3 - "$1" "$2" <<'PY'
import json,sys,urllib.request,urllib.error
request=urllib.request.Request("http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fstorage.azure.com%2F",headers={"Metadata":"true"})
try:
    token=json.load(urllib.request.urlopen(request,timeout=10))["access_token"]
except (urllib.error.URLError,TimeoutError,KeyError,ValueError):
    raise SystemExit("INCOMPLETE: managed-identity token acquisition failed; no token was logged.")
results=[]
for account in sys.argv[1:3]:
    request=urllib.request.Request("https://"+account+".blob.core.windows.net/?comp=list",headers={"Authorization":"Bearer "+token,"x-ms-version":"2023-11-03"})
    try:
        response=urllib.request.urlopen(request,timeout=20)
        results.append((response.status,""))
        response.close()
    except urllib.error.HTTPError as error:
        results.append((error.code,error.headers.get("x-ms-error-code","")))
    except (urllib.error.URLError,TimeoutError):
        raise SystemExit("INCOMPLETE: transport failure is not a policy-denial pass.")
token=None
print("allowed: HTTP",results[0][0],"; denied: HTTP",results[1][0],results[1][1])
if results[0][0] != 200 or results[1] != (403,"AuthorizationFailure"):
    raise SystemExit("FAIL/INCOMPLETE: require authorized allowed=200 and denied=403 AuthorizationFailure; check RBAC propagation and endpoint policy.")
print("PASSED: same managed identity, same source subnet, different policy destinations.")
PY
