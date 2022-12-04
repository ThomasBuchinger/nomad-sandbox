
resource "nomad_job" "ex2-ingress" {
  jobspec = file("${path.module}/ingress.hcl")
}

resource "nomad_job" "ex2-game" {
  jobspec = file("${path.module}/game.hcl")
}
