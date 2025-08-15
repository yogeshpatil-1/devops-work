{{- define "cicd-demo.name" -}}
cicd-demo
{{- end }}

{{- define "cicd-demo.fullname" -}}
{{ .Release.Name }}
{{- end }}
