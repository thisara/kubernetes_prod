{{- define "file-api.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{- define "file-api.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
