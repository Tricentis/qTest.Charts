{{/* vim: set filetype=mustache: */}}
{{- define "common.storage.class" -}}

{{- $storageClass := .persistence.storageClass -}}

{{- if $storageClass -}}
  {{- if (eq "-" $storageClass) -}}
      {{- printf "storageClassName: \"\"" -}}
  {{- else }}
      {{- printf "storageClassName: %s" $storageClass -}}
  {{- end -}}
{{- end -}}

{{- end -}}