# Enterprise Authentication Patterns

This reference catalogs the enterprise auth patterns that `api-anything` generated CLIs must support. Enterprise API specs are routinely incomplete or inaccurate about auth — the generated CLI must handle what the spec says, what the spec omits, and what the spec gets wrong.

## Table of contents

1. [Auth modes](#auth-modes)
2. [Environment profiles](#environment-profiles)
3. [Policy overlay](#policy-overlay)
4. [Auth configuration file format](#auth-configuration-file-format)
5. [Auth flow implementations](#auth-flow-implementations)
6. [Secret handling](#secret-handling)
7. [Decision criteria](#decision-criteria)

## Auth modes

### API key in header

```yaml
auth:
  method: api-key
  location: header
  header_name: X-API-Key  # or Authorization, x-functions-key, etc.
  env_var: MYCLI_API_KEY   # where to read the key from
```

Implementation: inject the header on every request. Read from config profile or environment variable.

### API key in query parameter

```yaml
auth:
  method: api-key
  location: query
  param_name: api_key
  env_var: MYCLI_API_KEY
```

Implementation: append the query parameter. Warn in stderr if the API uses HTTP (key visible in logs).

### API key in cookie

```yaml
auth:
  method: api-key
  location: cookie
  cookie_name: session_token
  env_var: MYCLI_SESSION_TOKEN
```

Implementation: set the cookie header. Handle expiry if the API returns `Set-Cookie` with new values.

### HTTP Basic auth

```yaml
auth:
  method: basic
  env_var_user: MYCLI_USERNAME
  env_var_pass: MYCLI_PASSWORD
```

Implementation: Base64-encode `user:pass` into `Authorization: Basic ...` header.

### Bearer token

```yaml
auth:
  method: bearer
  env_var: MYCLI_TOKEN
  token_prefix: Bearer  # some APIs use "Token" or custom prefixes
```

Implementation: inject `Authorization: {prefix} {token}` header.

### OAuth 2.0 client credentials

```yaml
auth:
  method: oauth2-client-credentials
  token_url: https://auth.example.com/oauth/token
  client_id_env: MYCLI_CLIENT_ID
  client_secret_env: MYCLI_CLIENT_SECRET
  scopes:
    - read:customers
    - write:customers
  audience: https://api.example.com  # optional, required by some providers
```

Implementation:
1. POST to `token_url` with `grant_type=client_credentials`
2. Cache the access token until expiry
3. Refresh automatically when `expires_in` is reached
4. Inject as Bearer token

### OAuth 2.0 authorization code + PKCE

```yaml
auth:
  method: oauth2-auth-code-pkce
  authorize_url: https://auth.example.com/authorize
  token_url: https://auth.example.com/oauth/token
  client_id_env: MYCLI_CLIENT_ID
  redirect_uri: http://localhost:8085/callback
  scopes:
    - openid
    - profile
    - read:data
```

Implementation:
1. Generate PKCE code_verifier and code_challenge
2. Open browser to authorize_url with PKCE challenge
3. Start local HTTP server on redirect_uri to capture the authorization code
4. Exchange code + code_verifier for tokens at token_url
5. Store tokens in secure local storage (OS keychain preferred, encrypted file fallback)
6. Refresh using refresh_token when access_token expires
7. Provide `mycli auth login --profile <name>` command to initiate the flow
8. Provide `mycli auth logout --profile <name>` to revoke/clear tokens

### OpenID Connect discovery

```yaml
auth:
  method: oidc
  issuer: https://auth.example.com
  # Discovery URL: {issuer}/.well-known/openid-configuration
  client_id_env: MYCLI_CLIENT_ID
  scopes:
    - openid
    - profile
```

Implementation:
1. Fetch `{issuer}/.well-known/openid-configuration`
2. Extract `authorization_endpoint`, `token_endpoint`, `jwks_uri`
3. Use discovered endpoints for the auth code + PKCE flow
4. Validate ID tokens against JWKS if needed

### mTLS (mutual TLS)

```yaml
auth:
  method: mtls
  client_cert_path_env: MYCLI_CLIENT_CERT
  client_key_path_env: MYCLI_CLIENT_KEY
  ca_cert_path_env: MYCLI_CA_CERT  # optional, for custom CA
```

Implementation: configure the HTTP client with client certificate and key. Some enterprise environments combine mTLS with other auth methods (e.g., mTLS for transport + bearer token for application auth).

### Custom enterprise gateway headers

```yaml
auth:
  method: custom-headers
  headers:
    X-Tenant-ID:
      env_var: MYCLI_TENANT_ID
    X-Correlation-ID:
      generate: uuid  # auto-generate per request
    X-Gateway-Auth:
      env_var: MYCLI_GATEWAY_TOKEN
```

Implementation: inject configured headers on every request. This covers API gateways, service meshes, and internal platforms that use non-standard auth patterns.

## Environment profiles

Generated CLIs must support named profiles for different environments:

```yaml
# ~/.mycli/config.yaml
profiles:
  dev:
    base_url: https://api-dev.example.com
    auth:
      method: api-key
      header_name: X-API-Key
    env_vars:
      MYCLI_API_KEY: dev-key-here

  prod:
    base_url: https://api.example.com
    auth:
      method: oauth2-client-credentials
      token_url: https://auth.example.com/oauth/token
      scopes: [read:all, write:all]
    env_vars:
      MYCLI_CLIENT_ID: prod-client-id
      MYCLI_CLIENT_SECRET: # read from OS keychain

default_profile: dev
```

Profile selection:
1. `--profile prod` flag (highest priority)
2. `MYCLI_PROFILE` environment variable
3. `default_profile` from config file
4. Fall back to error if no profile is configured

Commands for profile management:
- `mycli auth setup --profile <name>` — interactive profile configuration
- `mycli auth test --profile <name>` — verify auth works against the API
- `mycli auth refresh --profile <name>` — refresh tokens
- `mycli auth list` — list configured profiles
- `mycli auth whoami --profile <name>` — show current identity

## Policy overlay

Enterprise specs are routinely wrong or incomplete about auth. The generated CLI must provide a **spec-patches.yaml** mechanism:

```yaml
# spec-patches.yaml — operator corrections to the OpenAPI spec
patches:
  - description: "Spec says API key in query but gateway requires header"
    operation: override
    target: securitySchemes.ApiKeyAuth
    value:
      type: apiKey
      in: header
      name: X-Api-Key

  - description: "Missing OAuth scopes for admin endpoints"
    operation: merge
    target: paths./admin/users.get.security
    value:
      - oauth2: [admin:read]

  - description: "Token URL is wrong in spec"
    operation: override
    target: securitySchemes.OAuth2.flows.clientCredentials.tokenUrl
    value: https://correct-auth.example.com/oauth/token
```

The CLI loads and applies patches before processing auth requirements. This keeps the generated code clean while letting operators fix spec inaccuracies without forking.

## Auth configuration file format

The config file lives at `~/.mycli/config.yaml` (or `$MYCLI_CONFIG_DIR/config.yaml`). It contains:

```yaml
version: 1
default_profile: dev
profiles:
  <name>:
    base_url: <string>
    auth: <auth-config>
    timeout_ms: 30000
    retry:
      max_attempts: 3
      backoff_ms: [100, 500, 2000]
    headers:  # additional headers for this profile
      X-Custom: value
```

Sensitive values (secrets, tokens) should be stored in the OS keychain or encrypted file, not in plaintext YAML. The config file references them via environment variable names, not literal values.

## Auth flow implementations

### Auth command tree

```
mycli auth setup    --profile <name>    # Configure a profile
mycli auth test     --profile <name>    # Verify auth works
mycli auth refresh  --profile <name>    # Refresh tokens
mycli auth login    --profile <name>    # Interactive login (OAuth/OIDC)
mycli auth logout   --profile <name>    # Clear tokens
mycli auth list                         # List profiles
mycli auth whoami   --profile <name>    # Show current identity
```

All auth commands return the standard JSON envelope.

### Token caching and refresh

For OAuth/OIDC flows:
1. Store access_token, refresh_token, expires_at in secure storage
2. Before each API call, check if access_token is expired
3. If expired and refresh_token exists, attempt silent refresh
4. If refresh fails, return error with `AUTH_TOKEN_EXPIRED` code and suggestion to re-login
5. Never cache secrets in the JSON output envelope

## Secret handling

- Never print tokens, keys, or passwords to stdout
- Redact secrets in stderr logs (show first 4 chars + `***`)
- Config file stores env var references, not literal secrets
- `mycli auth whoami` shows identity info, not the credential itself
- Debug mode (`--debug`) shows request headers but redacts `Authorization` values

## Decision criteria

Use this table to decide which auth mode to generate:

| Spec declares | Spec is accurate? | Action |
|---|---|---|
| `securitySchemes` with clear types | Yes | Generate matching auth implementation |
| `securitySchemes` with clear types | No / uncertain | Generate matching implementation + policy overlay + warning in ingestion report |
| No `securitySchemes` at all | N/A | Ask the user what auth the API requires. Generate custom-headers mode as a safe default with policy overlay for corrections |
| Multiple schemes | N/A | Support all declared schemes. Let the profile select which to use |

When in doubt, generate the auth implementation but flag it as "derived from spec — may need operator correction via spec-patches.yaml".
