{{- define "ruby-dev-test-1.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "ruby-dev-test-1.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name }}
{{- end }}