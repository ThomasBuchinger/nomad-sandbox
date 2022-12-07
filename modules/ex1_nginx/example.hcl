job "example" {
  type = "service"
  meta = { }                      // Metadata

  update {                        // Built-in Canary Deployment
    health_check      = "checks"
    auto_revert       = true
    auto_promote      = true
    canary            = 1
  }
  service {
    provider = "consul"           // or "nomad"
    check {
      ...                         // Liveness Probe
    }
  }
  constraint {
    ...                           // Taints, Tolerations and (Anti-) Affinity
  }
  ephemeral_disk {
    migrate = true                // Automatically migrate data between Nomad Nodes
  }
  parameterized { }               // Jobs can Take Parameter, that are available in Templates
  group "webserver" {
    network { }
    scaling { }                   // Built-in HPA

    task "nginx" {
      driver = "docker"
      config { }
      env { }                     // Environment Variables
      resources {
        ...                       // Configure resources for Allocation
      }
      artifact {
        ...                       // Download Stuff into Allocation Directory
      }

      template {
        template {                // Dynamic Data with Consul Templating Engine
          data = "echo My IP is ${node.attr.ip}"
          destination = "local/my_change_script.sh"
        }
        change_script {
          command = ""            // Run a Script when the data in template changes
        }
      }
    }
  }
}