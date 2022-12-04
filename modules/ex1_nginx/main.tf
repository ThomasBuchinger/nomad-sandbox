
resource "nomad_job" "ex1-nginx" {
  jobspec = file("${path.module}/nginx.hcl")
}
