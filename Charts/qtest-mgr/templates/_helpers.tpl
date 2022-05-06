{{/*
Expand the name of the chart.
*/}}
{{- define "qtest-mgr.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "imagePullSecret" }}
{{- with .Values.imageCredentials }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "qtest-mgr.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "qtest-mgr.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create unified labels for qtest-mgr components
*/}}
{{- define "qtest-mgr.common.matchLabels" -}}
app: {{ template "qtest-mgr.name" . }}
release: {{ .Release.Name }}
{{- end -}}

{{- define "qtest-mgr.common.metaLabels" -}}
chart: {{ template "qtest-mgr.chart" . }}
heritage: {{ .Release.Service }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "qtest-mgr.labels" -}}
helm.sh/chart: {{ include "qtest-mgr.chart" . }}
{{ include "qtest-mgr.selectorLabels" . }}
{{ include "qtest-mgr.common.metaLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "qtest-mgr.selectorLabels" -}}
app.kubernetes.io/name: {{ include "qtest-mgr.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "qtest-mgr.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "qtest-mgr.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
