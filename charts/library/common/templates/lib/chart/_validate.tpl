{{/*
Validate global chart values
*/}}
{{- define "bjw-s.common.lib.chart.validate" -}}
  {{- $rootContext := . -}}

  {{- /* Validate persistence values */ -}}
  {{- range $persistenceKey, $persistenceValues := .Values.persistence }}
    {{- $persistenceEnabled := true -}}
    {{- if hasKey $persistenceValues "enabled" -}}
      {{- $persistenceEnabled = $persistenceValues.enabled -}}
    {{- end -}}

    {{- if $persistenceEnabled -}}
      {{- /* Make sure that any advancedMounts component references actually resolve */ -}}
      {{- range $key, $advancedMount := $persistenceValues.advancedMounts -}}
        {{- if not (empty $advancedMount) -}}
          {{- $mountComponent := include "bjw-s.common.lib.component.getByIdentifier" (dict "rootContext" $rootContext "id" $key) -}}
          {{- if empty $mountComponent -}}
            {{- fail (printf "No enabled component found with this identifier. (persistence item: '%s', component: '%s')" $persistenceKey $key) -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
