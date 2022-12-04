
resource "nomad_job" "ex3-vm" {
  jobspec = file("${path.module}/vm.hcl")
}