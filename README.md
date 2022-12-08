# Nomad

Unstructured Notes

## Notes
* Requires Consul (and Vault) --> Hashi-Stack Lock-In
* Actiuve WAR with docs (Docs link to Tutorial --> different siebar)
* Not compatible with CentOS 7 (podman too old, qmeu not recognized)
* Nomad keeps a history. Nice in theory. Mostly confusing in practice --> system-wide GC
* There is no indication (in the UI) if (consul?) healthchecks fail. 2 New replicas are online (and working) one old hangs around for seemingly no reason
* if Nomad is started with the wrong config, it will keep to old wrong config
* Jobs can have their own directory independent of the container (for scripts, images, ...) that can be mounted into the container
* Some system level tasks, require the whole docker driver to allow priviledged containers
* Nomad does not manage the firewall
* https://github.com/jippi/awesome-nomad
* https://github.com/jonasvinther/nomad-gitops-operator
* did not manage to run fabio on port 80
* terraform destroy, only deletes 1 version. Nomad might try to deploy a older? version instead
* limited resources are a problem (1c/2G)
* Soehow managed to have nomad with no leader
* Allocation replae init-container
* Nomad tries to migrate local Data between Nodes
* UI can do Clicky stuffs
* CSI:
  * no OpenEBS
  * Ceph possible (not rook) https://docs.ceph.com/en/latest/rbd/rbd-nomad/
* Port Config
  * mode = host && port.to => WORKS
  * Does not make ANY sense, and breaks consul Healthchecks

## Stuff that did not work

* Qemu on CentOS 7 (no qemu-system-x83_64 binary)
* Network Mode "bridge" does not work (failed to setup loopback interface)
* IPv6 Only on clients. Must have a default route


## Comare to current k8s setup

|        | Nomad | K3s |
|--------|-------|-----|
| Install     | 2 Packages + Config + Qemu/docker | Shell script |
| HA          | Built-in / Consul                 | etcd |
| Config      | One Task file                     | Many discrete Manifests |
| Storage     | External / (maybe CSI?)           | CSI |
| ServiceMesh | Builtin Consul                    | must be installed |
| ConfigMaps  | Y (+ConsulFeatures?               | Simple ConfigMaps |
| Grouping    | Namepsace and Job                 | only Namespaces |
| VM Support  | YES                               | Kubevirt? |
| Raw Process | YES                               | very ugly |


Nomad:
* ArgoCD: No Use Terraform
* Ingress: Use Consul. But Consul is much better
* Sealed Secrets: No. Use Vault
* OpenEBS: Does not work
* Operators don't work: different MongoDB, Cert-Manager
* Workpress: works