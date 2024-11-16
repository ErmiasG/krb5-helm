{{/*
Expand the name of the chart.
*/}}
{{- define "krb-client.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "krb-client.fullname" -}}
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
{{- define "krb-client.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "krb-client.labels" -}}
helm.sh/chart: {{ include "krb-client.chart" . }}
{{ include "krb-client.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "krb-client.selectorLabels" -}}
app.kubernetes.io/name: {{ include "krb-client.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "krb-client.image_repository"  -}}
{{- if and .Values.global .Values.global.image.repository -}}
{{- .Values.global.image.repository -}}{{ .Values.image.repository }}
{{- else }}
{{ .Values.image.repository }}
{{- end }}
{{- end }}