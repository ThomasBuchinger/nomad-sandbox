job "nginx" {
  // Service = Deployment
  type = "service"

  // Groups are placed together
  group "webserver" {
    count = 3

    network {
      mode = "host"           // Brgide Mode should work, but does not
      port "http" {
        to = 80
        static = 8080         // Static-Port = HostPort
      }
      port "https" {
        to = 443
        static = 8443
      }
    }

    task "nginx" {
      driver = "docker"
      config {
        image = "nginx"
        ports = ["http", "https"]
        mounts =[{
          type = "bind"
          source = "local/html"
          target = "/usr/share/nginx/html"
        }]
      }
      env { }
      resources {
        cpu    = 100 # MHz
        memory = 128 # MB
      }
      artifact {
        source      = "https://gist.githubusercontent.com/ThomasBuchinger/a98c4f5bd2ca7e5542176d0f5c106724/raw/866c51f698d1d446f487c359ba1ed6e2faa536dd/settings.json"
        destination = "local/html/"
      }
    }
  }

  datacenters = ["dc1"]
  update {
    stagger      = "30s"
    max_parallel = 2
  }
}