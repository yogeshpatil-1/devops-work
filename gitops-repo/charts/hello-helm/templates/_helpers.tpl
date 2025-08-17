{{- define "hello-helm.name" -}}
hello-helm
{{- end -}}

{{- define "hello-helm.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "hello-helm.name" .) -}}
{{- end -}}