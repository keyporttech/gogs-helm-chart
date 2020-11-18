# Gogs Helm Chart

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: 0.12.3](https://img.shields.io/badge/AppVersion-0.12.3-informational?style=flat-square)

Gogs is a painless self-hosted Git service

**Homepage:** <https://github.com/keyporttech/gogs-helm-chart>

## Introduction

This is a kubernetes helm chart for [Gogs](https://gogs.io/).

Looking for the [gitea](https://gitea.io/en-us/) version of this chart? See: [here](https://github.com/jfelten/gitea-helm-chart)

* A kubernetes cluster ( most recent release recommended)
* Helm 3 client
* Please ensure that nodepools have enough resources to run both a web application and database
* An external database if not using the in pod database

## Installing the Chart

This chart is published in [keyporttech/charts](https://github.com/keyporttech/helm-charts). To install the chart, first add the keyporttech helm repo:
```bash
helm repo add keyporttech https://keyporttech.github.io/helm-charts/
```
Then to install with the release name `gogs` in the namespace `gogs` with the customized values in custom_values.yaml run:

```bash
$ helm install -- values custom_values.yaml --name gogs --namespace gogs keyporttech/gogs
```
or locally:

```bash
$ helm install --name gogs --namespace gogs .
```
> **Tip**: You can use the default [values.yaml](values.yaml)

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm uninstall my-release -n my-namespace
```

All resources associated with the last release of the chart as well as its release history will be deleted.

### Database config in pod vs external db

By default the chart will spin up a postgres container inside the pod. It can also work with external databases. To disable the in pod database and use and external one use the following values:

```yaml
dbType: "postgres"
useInPodPostgres: false

#Connect to an external database
externalDB:
  dbUser: "gogs"
  dbPassword: "<MY_PASSWORD>"
  dbHost: "db-service-name.namespace.svc.cluster.local" # or some external host
  dbPort: 5432
  dbDatabase: "gogs"
```

This chart has only been tested using a postgres database, but others should be possible.

## Data Management

This chart will use and create optional persistent volume claims for both postgres (if using in pod db) and gogs data. By default the data will be deleted upon uninstalling the chart. This is not ideal but can be managed in a couple ways:

* prevent helm from deleting the pvcs it creates. Do this by enabling annotation: helm.sh/resource-policy": keep in the pvc optional annotations

```yaml
persistence:
  annotations:
    "helm.sh/resource-policy": keep
```
* create a pvc outside the chart and configure the chart to use it. Do this by setting the persistence existingGogsClaim and existingPostgresClaim properties.

```yaml
 existingGogsClaim: gogs-gogs
 existingPostgresClaim: gogs-postgres
```
a trick that can be is used to first set the helm.sh/resource-policy annotation so that the chart generates the pvcs, but doesn't delete them. Upon next deplyment set the exsiting claim names to the generated values.

## Ingress And External Host/Ports

Gogs requires ports to be exposed for both web and ssh traffic. The chart is flexible and allow a combination of either ingresses, loadblancer, or nodeport services.

To expose the web application this chart will generate an ingress using the ingress controller of choice if specified. If an ingress is enabled services.http.externalHost must be specified. To expose SSH services it relies on either a LoadBalancer or NodePort.

# Configuration

Refer to [values.yaml](values.yaml) for the full run-down on defaults.

The following table lists the configurable parameters of this chart and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| config.disableInstaller | bool | `false` |  |
| config.disableRegistration | bool | `false` |  |
| config.mailer.enabled | bool | `false` |  |
| config.mailer.from | string | `""` |  |
| config.mailer.host | string | `"smtp.gmail.com"` |  |
| config.mailer.passwd | string | `""` |  |
| config.mailer.port | int | `587` |  |
| config.mailer.tls | bool | `false` |  |
| config.mailer.user | string | `""` |  |
| config.metrics.enabled | bool | `false` |  |
| config.metrics.token | string | `""` |  |
| config.notifyMail | bool | `false` |  |
| config.offlineMode | bool | `false` |  |
| config.openidSignin | bool | `true` |  |
| config.requireSignin | bool | `false` |  |
| dbType | string | `"postgres"` |  |
| deploymentAnnotations | object | `{}` |  |
| images.gogs | string | `"gogs/gogs:0.12.3"` |  |
| images.imagePullPolicy | string | `"IfNotPresent"` |  |
| images.memcached | string | `"memcached:1.5.19-alpine"` |  |
| images.postgres | string | `"postgres:11"` |  |
| inPodPostgres.dataMountPath | string | `"/var/lib/postgresql/data/pgdata"` |  |
| inPodPostgres.postgresDatabase | string | `"gogs"` | Create a database if unset default: the postgres user |
| inPodPostgres.secret | string | `"postgresecrets"` | secret with generated credentials |
| inPodPostgres.subPath | string | `"postgresql-db"` | subPath |
| inPodPostgres.usePasswordFile | bool | `false` |  |
| ingress.enabled | bool | `false` | Enable/Disable ingress |
| memcached.extendedOptions | string | `"modern"` | Extended options |
| memcached.maxItemMemory | int | `64` |  |
| memcached.verbosity | string | `"v"` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessMode | string | `"ReadWriteMany"` |  |
| persistence.enabled | bool | `false` |  |
| persistence.gogsSize | string | `"10Gi"` |  |
| persistence.postgresSize | string | `"5Gi"` |  |
| podAnnotations | object | `{}` |  |
| resources.gogs.limits.cpu | int | `1` | requests memory cpu for gogs containers |
| resources.gogs.limits.memory | string | `"2Gi"` | requests memory limits for gogs containers |
| resources.gogs.requests.cpu | string | `"1000m"` | requests cpuresources for gogs containers |
| resources.gogs.requests.memory | string | `"500Mi"` | requests memory resources for gogs containers |
| resources.memcached.requests.cpu | string | `"50m"` | requests memory limits for memcached containers |
| resources.memcached.requests.memory | string | `"64Mi"` | requests memory resources for memcached containers |
| resources.postgres.limits.cpu | int | `1` | requests memory limits for postgres containers |
| resources.postgres.limits.memory | string | `"2Gi"` | requests memory limits for postgres containers |
| resources.postgres.requests.cpu | string | `"200m"` | requests cpu resources for postgres containers |
| resources.postgres.requests.memory | string | `"200Mi"` | requests memory resources for postgres containers |
| service.http.externalHost | string | `"git.example.com"` | gogs external host name |
| service.http.externalPort | int | `8280` |  |
| service.http.port | int | `3000` | kubernetes service port for gogs |
| service.http.serviceType | string | `"ClusterIP"` | kubernetes service type for gogs |
| service.ssh.port | int | `22` | ssh service port |
| service.ssh.serviceType | string | `"ClusterIP"` | ssh service type |
| tolerations | list | `[]` |  |
| useInPodPostgres | bool | `true` | use the chart built in db |

## Source Code

* <https://github.com/gogs/gogs>
* <https://hub.docker.com/r/gogs/gogs/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Keyporttech | info@keyporttech.com |  |

## Contributing

Please see [keyporttech charts contribution guidelines](https://github.com/keyporttech/helm-charts/blob/master/CONTRIBUTING.md)
 helm Chart

