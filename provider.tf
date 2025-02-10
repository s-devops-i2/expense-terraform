provider "vault" {
  address = "https://vault-internal.shujadevops.shop:8200"
  token = var.vault_token
  skip_tls_verify = true
}