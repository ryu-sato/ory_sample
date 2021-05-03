# docker run -d -p 4180:4180 quay.io/oauth2-proxy/oauth2-proxy \
docker run -d oauth2-proxy \
  --'http-address=http://0.0.0.0:4180' \
  --'provider=oidc' \
  --'login-url=http://localhost:4444/oauth2/auth?response_type=code&client_id=members_application&scope=openid+members&redirect_uri=http%3A%2F%member%3A4180%2Foauth2%2Fcallback&state=ZGHWfNTjeY' \
  --'oidc-issuer-url=http://localhost:4444/' \
  --'oidc-jwks-url=http://localhost:4455/.well-known/jwks.json' \
  --'client-id=members_application' \
  --'client-secret=secret' \
  --'email-domain=*' \
  --'cookie-secret=hu9XrailLtAYwQCHyQkGUw==' \
  --'cookie-secure=false' \
#   --'upstream=http://localhost:3300/' \

