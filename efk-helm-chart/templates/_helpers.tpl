{{/*
Expand the name of the chart.
*/}}
{{- define "efk-fluentd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "efk-fluentd.fullname" -}}
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
{{- define "efk-fluentd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "efk-fluentd.labels" -}}
helm.sh/chart: {{ include "efk-fluentd.chart" . }}
{{ include "efk-fluentd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "efk-fluentd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "efk-fluentd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
k8s-app: fluentd-logging
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "efk-fluentd.serviceAccountName" -}}
{{- default (include "efk-fluentd.fullname" .) "fluentd-service-account" }}
{{- end }}

{{/*
Generate namespace path pattern for log collection
*/}}
{{- define "efk-fluentd.namespacePaths" -}}
{{- $paths := list -}}
{{- range .Values.logging.namespaces -}}
{{- $paths = append $paths (printf "/var/log/containers/*_%s_*.log" .) -}}
{{- end -}}
{{- join "," $paths -}}
{{- end }}

{{/*
Generate namespace regex pattern for filtering
*/}}
{{- define "efk-fluentd.namespaceRegex" -}}
^({{ join "|" .Values.logging.namespaces }})$
{{- end }}

{{/*
Create the name of the secret to use for Elasticsearch credentials
*/}}
{{- define "efk-fluentd.secretName" -}}
{{- if .Values.elasticsearch.auth.existingSecret }}
{{- .Values.elasticsearch.auth.existingSecret }}
{{- else }}
{{- include "efk-fluentd.fullname" . }}-secret
{{- end }}
{{- end }}

{{/*
Generate Fluentd image based on Elasticsearch version
*/}}
{{- define "efk-fluentd.fluentdImage" -}}
{{- $repository := "fluent/fluentd-kubernetes-daemonset" -}}
{{- $version := "v1.19.0-debian" -}}
{{- if eq .Values.fluentd.elasticsearchVersion "7" -}}
{{- printf "%s:%s-elasticsearch7-1.0" $repository $version -}}
{{- else -}}
{{- printf "%s:%s-elasticsearch8-1.0" $repository $version -}}
{{- end -}}
{{- end }}