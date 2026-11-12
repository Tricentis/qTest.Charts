# qtest-insights-i-etl

Helm chart for the qTest Insights ETL job.

Kubernetes `>=1.24.0-0` and Helm 3 are required.

The defaults below come from `values.yaml`. Environment-specific values replace them at install time.

## Values

### Namespace

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `namespace.name` | string | `"qtest"` | Kubernetes namespace for the rendered resources. |

### Secrets

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `secrets.enabled` | bool | `false` | When true, create the application Secret that holds database passwords. |
| `secrets.name` | string | `"qtest-i-etl-secret"` | Secret containing application credentials. Name of the Secret read by `QTEST_READ_DB_PW`, `QTEST_WRITE_DB_PW`, `SESSIONS_WRITE_DB_PW`, `SESSIONS_READ_DB_PW`, `LAUNCHDARKLY_SDKKEY`, `LIQUIBASE_COMMAND_PASSWORD`. |
| `secrets.launchDarklySdkKey` | string | `"launchdarkly-sdkKey"` | Secret key read into `LAUNCHDARKLY_SDKKEY`. |

### Image

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `image.repository` | string | `"242129367204.dkr.ecr.us-east-1.amazonaws.com/i-etl"` | Container image repository. |
| `image.pullPolicy` | string | `"IfNotPresent"` | Image pull policy. |
| `image.tag` | string | `"2026.8.2"` | Image tag. The chart appVersion is used when this is empty. |

### liquibase

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `liquibase.enabled` | bool | `true` | When true, create the Liquibase migration Jobs. |
| `liquibase.image.repository` | string | `"242129367204.dkr.ecr.eu-central-1.amazonaws.com/i-etl-liquibase"` | Container image repository. |
| `liquibase.image.tag` | string | `""` | Liquibase image tag. Defaults to `image.tag` when empty. |
| `liquibase.image.pullPolicy` | string | `"IfNotPresent"` | Image pull policy. |
| `liquibase.securityContext` | object | `{}` | Container security context. |
| `liquibase.annotations.helm.sh/hook` | string | `"pre-install, pre-upgrade"` | Annotation merged onto the workload that uses `liquibase.annotations`. |
| `liquibase.annotations.helm.sh/hook-delete-policy` | string | `"before-hook-creation"` | Annotation merged onto the workload that uses `liquibase.annotations`. |
| `liquibase.dependencyAnnotations.helm.sh/hook` | string | `"pre-install, pre-upgrade"` | Field of `liquibase.dependencyAnnotations`, which the chart renders as a block. |
| `liquibase.dependencyAnnotations.helm.sh/hook-weight` | string | `"-5"` | Field of `liquibase.dependencyAnnotations`, which the chart renders as a block. |

### Image pull credentials

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `imageCredentials.enabled` | bool | `false` | Pull secret for the application image. |

### Service account

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `serviceAccount.create` | bool | `true` | Specifies whether a service account should be created |
| `serviceAccount.annotations` | object | `{}` | Annotations to add to the service account |
| `serviceAccount.name` | string | `"qtest-insights-i-etl-sa"` | ServiceAccount name. Created when `serviceAccount.create` is true; otherwise the name of an existing account. |

### deployment

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `deployment.annotations` | object | `{}` | Annotations on the workload. |
| `deployment.singlePodPerNode` | bool | `false` | Schedule at most one pod per node. An explicit affinity value takes precedence. |
| `deployment.strategy.type` | string | `"Recreate"` | Deployment update strategy. |

### lifecycle

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `lifecycle` | object | `{}` | Lifecycle hooks for the container. |

### podAnnotations

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `podAnnotations` | object | `{}` | Pod annotations, including checksums added by the chart. |

### Rollouts

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `rollouts.enabled` | bool | `false` | Enable the Argo Rollout instead of a normal Deployment. |
| `rollouts.ingressClassName` | string | `"alb"` | Ingress class key on the Rollout canary traffic routing. |
| `rollouts.strategy.canary.maxSurge` | string | `"25%"` | Field of `rollouts.strategy`, which the chart renders as a block. |
| `rollouts.strategy.canary.maxUnavailable` | int | `0` | Field of `rollouts.strategy`, which the chart renders as a block. |
| `rollouts.steps` | list | `[{"setWeight":50}]` | Canary steps on the Rollout strategy. |

### extraInitContainers

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `extraInitContainers` | list | `[]` | Extra init containers. |

### extraContainers

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `extraContainers` | list | `[]` | Extra sidecar containers. |

### extraEnv

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `extraEnv` | list | `[]` | Extra container environment variables appended to the workload. |

### extraVolumeMounts

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `extraVolumeMounts` | list | `[]` | Extra container volume mounts. |

### extraVolumes

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `extraVolumes` | list | `[]` | Extra pod volumes. |

### Service

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `service.type` | string | `"ClusterIP"` | Kubernetes Service type. |
| `service.annotations` | object | `{}` | Annotations on the Service and, when rollouts are enabled, the canary Service. |
| `service.port` | int | `8080` | Service port exposed inside the cluster. |
| `service.targetPort` | int | `8080` | Container port the Service sends traffic to. |
| `service.serviceName` | string | `"insights-i-etl"` | Service name. The Rollout uses it as the stable Service and appends `-canary` for the canary Service. |

### securityContext

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `securityContext.runAsUser` | int | `8877` | Field of `securityContext`, which the chart renders as a block. |
| `securityContext.runAsNonRoot` | bool | `true` | Field of `securityContext`, which the chart renders as a block. |
| `securityContext.fsGroup` | int | `8877` | Field of `securityContext`, which the chart renders as a block. |

### qTestInsightsIEtl

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `qTestInsightsIEtl.readQTestDBHost` | string | `"postgres.local"` | PostgreSQL host for the read connection. Copied to ConfigMap key `QTEST_READ_DB_HOST`. |
| `qTestInsightsIEtl.readQTestDBPort` | int | `5432` | PostgreSQL port. Copied to ConfigMap key `QTEST_READ_DB_PORT`. |
| `qTestInsightsIEtl.readQTestDBName` | string | `"qtest"` | PostgreSQL database name. Copied to ConfigMap key `QTEST_READ_DB_NAME`. |
| `qTestInsightsIEtl.readQTestDBUser` | string | `"postgres"` | PostgreSQL user name. Copied to ConfigMap key `QTEST_READ_DB_USER`. |
| `qTestInsightsIEtl.readQTestDBMaxPoolSize` | int | `25` | Copied to ConfigMap key `QTEST_READ_DB_MAX_POOL_SIZE`. |
| `qTestInsightsIEtl.readQTestDBMinIdle` | int | `5` | Copied to ConfigMap key `QTEST_READ_DB_MIN_IDLE`. |
| `qTestInsightsIEtl.writeQTestDBHost` | string | `"postgres.local"` | PostgreSQL host for the write connection. Copied to ConfigMap key `QTEST_WRITE_DB_HOST` and included in `LIQUIBASE_COMMAND_URL`. |
| `qTestInsightsIEtl.writeQTestDBPort` | int | `5432` | PostgreSQL port. Copied to ConfigMap key `QTEST_WRITE_DB_PORT` and included in `LIQUIBASE_COMMAND_URL`. |
| `qTestInsightsIEtl.writeQTestDBName` | string | `"qtest"` | PostgreSQL database name. Copied to ConfigMap key `QTEST_WRITE_DB_NAME` and included in `LIQUIBASE_COMMAND_URL`. |
| `qTestInsightsIEtl.writeQTestDBUser` | string | `"postgres"` | PostgreSQL user name. Copied to ConfigMap key `QTEST_WRITE_DB_USER` and set as `LIQUIBASE_COMMAND_USERNAME` on the main Liquibase Job. |
| `qTestInsightsIEtl.writeQTestDBMaxPoolSize` | int | `25` | Copied to ConfigMap key `QTEST_WRITE_DB_MAX_POOL_SIZE`. |
| `qTestInsightsIEtl.writeQTestDBMinIdle` | int | `5` | Copied to ConfigMap key `QTEST_WRITE_DB_MIN_IDLE`. |
| `qTestInsightsIEtl.qTestDBSchema` | string | `"public"` | Copied to ConfigMap key `QTEST_DB_SCHEMA`. |
| `qTestInsightsIEtl.insightsDBSchema` | string | `"insights"` | Copied to ConfigMap key `INSIGHTS_DB_SCHEMA` and set as `LIQUIBASE_COMMAND_DEFAULT_SCHEMA_NAME` on the migrate-old Liquibase Job. |
| `qTestInsightsIEtl.insightsDBUser` | string | `"postgres"` | PostgreSQL user name. Copied to ConfigMap key `INSIGHTS_DB_USER` and set as `LIQUIBASE_COMMAND_USERNAME` on the migrate-old Liquibase Job. |
| `qTestInsightsIEtl.sessionsReadDBHost` | string | `"postgres.local"` | PostgreSQL host for the sessions read connection. Copied to ConfigMap key `SESSIONS_READ_DB_HOST`. |
| `qTestInsightsIEtl.sessionsReadDBPort` | int | `5432` | PostgreSQL port. Copied to ConfigMap key `SESSIONS_READ_DB_PORT`. |
| `qTestInsightsIEtl.sessionsReadDBName` | string | `"sessions"` | PostgreSQL database name. Copied to ConfigMap key `SESSIONS_READ_DB_NAME`. |
| `qTestInsightsIEtl.sessionsReadDBUser` | string | `"postgres"` | PostgreSQL user name. Copied to ConfigMap key `SESSIONS_READ_DB_USER`. |
| `qTestInsightsIEtl.sessionsReadDBSchema` | string | `"public"` | Copied to ConfigMap key `SESSIONS_READ_DB_SCHEMA_NAME`. |
| `qTestInsightsIEtl.sessionsWriteDBHost` | string | `"postgres.local"` | PostgreSQL host for the sessions write connection. Copied to ConfigMap key `SESSIONS_WRITE_DB_HOST`. |
| `qTestInsightsIEtl.sessionsWriteDBPort` | int | `5432` | PostgreSQL port. Copied to ConfigMap key `SESSIONS_WRITE_DB_PORT`. |
| `qTestInsightsIEtl.sessionsWriteDBName` | string | `"sessions"` | PostgreSQL database name. Copied to ConfigMap key `SESSIONS_WRITE_DB_NAME`. |
| `qTestInsightsIEtl.sessionsWriteDBUser` | string | `"postgres"` | PostgreSQL user name. Copied to ConfigMap key `SESSIONS_WRITE_DB_USER`. |
| `qTestInsightsIEtl.sessionsWriteDBSchema` | string | `"public"` | Copied to ConfigMap key `SESSIONS_WRITE_DB_SCHEMA_NAME`. |
| `qTestInsightsIEtl.autoRefreshDBLink` | bool | `true` | Copied to ConfigMap key `AUTO_REFRESH_DBLINK`. |
| `qTestInsightsIEtl.logEnvironment` | string | `"opk8s"` | Copied to ConfigMap key `LOG_ENVIRONMENT`. The application includes `logback-${LOG_ENVIRONMENT}.xml`. |
| `qTestInsightsIEtl.deploymentEnv` | string | `"op"` | Copied to ConfigMap key `DEPLOYMENT_ENV`. Feature flags stay offline unless the value is `saas`. |
| `qTestInsightsIEtl.iEtlQuartzThreadCount` | int | `10` | Copied to ConfigMap key `QUARTZ_THREAD_COUNT`. |
| `qTestInsightsIEtl.iEtlBatchInitialSize` | int | `10000` | Copied to ConfigMap key `INSIGHTS_ETL_BATCH_INITIAL_SIZE`. |
| `qTestInsightsIEtl.iEtlBatchMinSize` | int | `1000` | Copied to ConfigMap key `INSIGHTS_ETL_BATCH_MIN_SIZE`. |
| `qTestInsightsIEtl.iEtlBatchMaxSize` | string | `"1000000"` | Copied to ConfigMap key `INSIGHTS_ETL_BATCH_MAX_SIZE`. |
| `qTestInsightsIEtl.iEtlBatchSleepPercentage` | int | `50` | Copied to ConfigMap key `INSIGHTS_ETL_BATCH_SLEEP_PERCENTAGE`. |
| `qTestInsightsIEtl.iEtlBatchOptimalDurationSeconds` | int | `60` | Copied to ConfigMap key `INSIGHTS_ETL_BATCH_OPTIMAL_DURATION_SECONDS`. |
| `qTestInsightsIEtl.iEtlAggregationInterval` | int | `600` | Copied to ConfigMap key `INSIGHTS_ETL_AGGREGATION_INTERVAL`. |
| `qTestInsightsIEtl.iEtlMaterializedViewInterval` | int | `600` | Copied to ConfigMap key `INSIGHTS_ETL_MATERIALIZED_VIEW_INTERVAL`. |
| `qTestInsightsIEtl.iEtlBetaJobsDisabled` | bool | `false` | Copied to ConfigMap key `INSIGHTS_ETL_BETA_JOBS_DISABLED`. |
| `qTestInsightsIEtl.iEtlLongRunningMaterializedViewInterval` | int | `10800` | Copied to ConfigMap key `INSIGHTS_ETL_LONG_RUNNING_MATERIALIZED_VIEW_INTERVAL`. |
| `qTestInsightsIEtl.rapidDashboardsTaskInterval` | int | `60` | Task interval in seconds. Copied to ConfigMap key `RAPID_DASHBOARDS_TASK_INTERVAL`. |
| `qTestInsightsIEtl.rapidDashboardsBatchSize` | int | `100` | Copied to ConfigMap key `RAPID_DASHBOARDS_BATCH_SIZE`. |
| `qTestInsightsIEtl.rapidDashboardsMaxConcurrentTasks` | int | `10` | Copied to ConfigMap key `RAPID_DASHBOARDS_MAX_CONCURRENT_TASKS`. |
| `qTestInsightsIEtl.rapidDashboardsPickerWindow` | int | `61` | Copied to ConfigMap key `RAPID_DASHBOARDS_PICKER_WINDOW`. |
| `qTestInsightsIEtl.rapidDashboardsRequestTimeout` | int | `600` | Copied to ConfigMap key `RAPID_DASHBOARDS_REQUEST_TIMEOUT`. |
| `qTestInsightsIEtl.rapidDashboardsConnectTimeout` | int | `10` | Copied to ConfigMap key `RAPID_DASHBOARDS_CONNECT_TIMEOUT`. |
| `qTestInsightsIEtl.rapidDashboardsSocketTimeout` | int | `600` | Copied to ConfigMap key `RAPID_DASHBOARDS_SOCKET_TIMEOUT`. |
| `qTestInsightsIEtl.rapidDashboardsConnectionRequestTimeout` | int | `10` | Copied to ConfigMap key `RAPID_DASHBOARDS_CONNECTION_REQUEST_TIMEOUT`. |
| `qTestInsightsIEtl.rapidDashboardsEnableMisfireHandling` | bool | `true` | Copied to ConfigMap key `RAPID_DASHBOARDS_ENABLE_MISFIRE_HANDLING`. |
| `qTestInsightsIEtl.scheduledReportsEnableMisfireHandling` | bool | `true` | Copied to ConfigMap key `SCHEDULED_REPORTS_ENABLE_MISFIRE_HANDLING`. |
| `qTestInsightsIEtl.scheduledReportsBatchSize` | int | `100` | Copied to ConfigMap key `SCHEDULED_REPORTS_BATCH_SIZE`. |
| `qTestInsightsIEtl.scheduledReportsRequestTimeout` | int | `600` | Copied to ConfigMap key `SCHEDULED_REPORTS_REQUEST_TIMEOUT`. |
| `qTestInsightsIEtl.scheduledReportsResultLogsPath` | string | `"/tmp/scheduled-reports-logs"` | Copied to ConfigMap key `SCHEDULED_REPORTS_RESULT_LOGS_PATH`. |
| `qTestInsightsIEtl.scheduledReportsConnectTimeout` | int | `10` | Copied to ConfigMap key `SCHEDULED_REPORTS_CONNECT_TIMEOUT`. |
| `qTestInsightsIEtl.scheduledReportsSocketTimeout` | int | `600` | Copied to ConfigMap key `SCHEDULED_REPORTS_SOCKET_TIMEOUT`. |
| `qTestInsightsIEtl.scheduledReportsConnectionRequestTimeout` | int | `10` | Copied to ConfigMap key `SCHEDULED_REPORTS_CONNECTION_REQUEST_TIMEOUT`. |
| `qTestInsightsIEtl.scheduledReportsMaxConcurrentTasks` | int | `10` | Copied to ConfigMap key `SCHEDULED_REPORTS_MAX_CONCURRENT_TASKS`. |
| `qTestInsightsIEtl.scheduledReportsTaskInterval` | int | `60` | Copied to ConfigMap key `SCHEDULED_REPORTS_TASK_INTERVAL`. |

### Ingress class

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `ingressClass.enabled` | bool | `false` | Create a chart-managed IngressClass. |
| `ingressClass.labels` | object | `{}` | Labels added to the IngressClass. |
| `ingressClass.controller` | string | `"ingress.k8s.aws/alb"` | Controller name written to the IngressClass. |
| `ingressClass.isDefaultClass` | bool | `true` | Mark the chart IngressClass as the default class. |
| `ingressClass.fallbackApiVersion` | string | `""` | Use to force a networking.k8s.io API Version for certain CI/CD applications. Ex. "v1" |

### Ingress

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `ingress.enabled` | bool | `false` | Create the Ingress. |
| `ingress.name` | string | `"qtest-insights-i-etl-ingress"` | Ingress name. Rollout traffic routing targets this Ingress. |
| `ingress.labels` | object | `{}` | Labels on the Ingress. |
| `ingress.annotations` | object | `{}` | Annotations copied onto the Ingress. The chart does not add controller-specific annotations. |
| `ingress.canary.annotationPrefix` | string | `""` | Annotation prefix on Rollout canary traffic routing. |
| `ingress.canary.annotations` | object | `{}` | Extra annotations on Rollout canary traffic routing. |
| `ingress.hosts` | list | `[{"host":"insights-i-etl.qtest.local"}]` | Host rules for the Ingress. A host may be a string or an object with a host field. |
| `ingress.paths` | list | `[]` | HTTP paths on each Ingress host. |
| `ingress.extraPaths` | list | `[{"path":"/*","backendServiceName":"insights-i-etl","pathType":"ImplementationSpecific","b...` | Extra HTTP paths appended after `ingress.paths` on each Ingress host. |
| `ingress.tls` | list | `[]` | TLS hosts and secret for the Ingress. |
| `ingress.https` | bool | `false` | Not applied by the chart. Put any HTTP-to-HTTPS redirect in `ingress.annotations` for the controller in use. |

### Autoscaling

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `autoscaling.enabled` | bool | `false` | Create the HorizontalPodAutoscaler. |
| `autoscaling.minReplicas` | int | `1` | Minimum pod replicas. |
| `autoscaling.maxReplicas` | int | `1` | Maximum pod replicas. |
| `autoscaling.livenessProbe.httpGet.path` | string | `"/healthz"` | Field of `autoscaling.livenessProbe`, which the chart renders as a block. |
| `autoscaling.livenessProbe.httpGet.scheme` | string | `"HTTP"` | Field of `autoscaling.livenessProbe`, which the chart renders as a block. |
| `autoscaling.livenessProbe.httpGet.port` | int | `8080` | Field of `autoscaling.livenessProbe`, which the chart renders as a block. |
| `autoscaling.livenessProbe.initialDelaySeconds` | int | `15` | Field of `autoscaling.livenessProbe`, which the chart renders as a block. |
| `autoscaling.livenessProbe.periodSeconds` | int | `15` | Probe period used by probes that read the autoscaling block. Field of `autoscaling.livenessProbe`, which the chart renders as a block. |
| `autoscaling.livenessProbe.failureThreshold` | int | `3` | Field of `autoscaling.livenessProbe`, which the chart renders as a block. |
| `autoscaling.readinessProbe.httpGet.path` | string | `"/healthz"` | Field of `autoscaling.readinessProbe`, which the chart renders as a block. |
| `autoscaling.readinessProbe.httpGet.scheme` | string | `"HTTP"` | Field of `autoscaling.readinessProbe`, which the chart renders as a block. |
| `autoscaling.readinessProbe.httpGet.port` | int | `8080` | Field of `autoscaling.readinessProbe`, which the chart renders as a block. |
| `autoscaling.readinessProbe.initialDelaySeconds` | int | `15` | Field of `autoscaling.readinessProbe`, which the chart renders as a block. |
| `autoscaling.readinessProbe.periodSeconds` | int | `15` | Probe period used by probes that read the autoscaling block. Field of `autoscaling.readinessProbe`, which the chart renders as a block. |
| `autoscaling.readinessProbe.failureThreshold` | int | `3` | Field of `autoscaling.readinessProbe`, which the chart renders as a block. |
| `autoscaling.startupProbe.httpGet.path` | string | `"/healthz"` | Field of `autoscaling.startupProbe`, which the chart renders as a block. |
| `autoscaling.startupProbe.httpGet.scheme` | string | `"HTTP"` | Field of `autoscaling.startupProbe`, which the chart renders as a block. |
| `autoscaling.startupProbe.httpGet.port` | int | `8080` | Field of `autoscaling.startupProbe`, which the chart renders as a block. |
| `autoscaling.startupProbe.initialDelaySeconds` | int | `10` | Field of `autoscaling.startupProbe`, which the chart renders as a block. |
| `autoscaling.startupProbe.periodSeconds` | int | `5` | Probe period used by probes that read the autoscaling block. Field of `autoscaling.startupProbe`, which the chart renders as a block. |
| `autoscaling.startupProbe.failureThreshold` | int | `20` | Field of `autoscaling.startupProbe`, which the chart renders as a block. |
| `autoscaling.targetCPUUtilizationPercentage` | int | `85` | Target CPU utilization for the autoscaler. |
| `autoscaling.targetMemoryUtilizationPercentage` | int | `85` | Target memory utilization for the autoscaler. |

### vpaAutoscaling

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `vpaAutoscaling.enabled` | bool | `false` | Create the VerticalPodAutoscaler. |
| `vpaAutoscaling.updatePolicy.updateMode` | string | `"Off"` | Update mode on the VerticalPodAutoscaler. |
| `vpaAutoscaling.resourcePolicy.containerPolicies` | list | `[{"containerName":"*","controlledValues":"RequestsAndLimits","controlledResources":["cpu",...` | Field of `vpaAutoscaling.resourcePolicy`, which the chart renders as a block. |

### Resources

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `resources.requests.cpu` | int | `1` | CPU requested for the container. Field of `resources`, which the chart renders as a block. |
| `resources.requests.memory` | string | `"2Gi"` | Memory requested for the container. Field of `resources`, which the chart renders as a block. |
| `resources.limits.cpu` | int | `1` | CPU limit for the container. Field of `resources`, which the chart renders as a block. |
| `resources.limits.memory` | string | `"2Gi"` | Memory limit for the container. Field of `resources`, which the chart renders as a block. |

### nodeSelector

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `nodeSelector` | object | `{}` | Pod node selector. |

### tolerations

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `tolerations` | list | `[]` | Pod tolerations. |

### affinity

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `affinity` | object | `{}` | Pod scheduling affinity. |

### topologySpreadConstraints

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `topologySpreadConstraints` | object | `{}` | Spread pods across topology domains. |
