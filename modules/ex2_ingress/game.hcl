
job "app-2048" {
  datacenters = ["dc1"]
  type = "service"


  group "game-server" {
    count = 1
    service {  // Consul Confiuration
      name = "game-2048"
      tags = [
        "urlprefix-game.10.0.0.111.nip.io:9999",
        "urlprefix-game.168.119.179.42.nip.io:9999",
        "urlprefix-/game strip=/game"
      ]
      port = "http"
      check {
        name     = "alive"
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }

    }
    network {
      port "http" {
        to = 80
      }
    }
    task "2048" {
      driver = "docker"
      config {
        image = "marcincuber/2048-game:latest"
        ports = ["http"]
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }
  }
}