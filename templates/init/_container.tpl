{{/*
Create helm partial for gogs server
*/}}
{{- define "init" }}
- name: init
  image: {{ .Values.images.gogs }}
  imagePullPolicy: {{ .Values.images.imagePullPolicy }}
  env:
  - name: POSTGRES_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ template "db.fullname" . }}
        key: dbPassword
  - name: SCRIPT
    value: &script |-
      mkdir -p /datatmp/gogs/conf
      if [ ! -f /datatmp/gogs/conf/app.ini ]; then
        sed "s/POSTGRES_PASSWORD/${POSTGRES_PASSWORD}/g" < /etc/gogs/app.ini > /datatmp/gogs/conf/app.ini
      fi
  command: ["/bin/sh",'-c', *script]
  volumeMounts:
  - name: gogs-data
    mountPath: /datatmp
  - name: gogs-config
    mountPath: /etc/gogs
{{- end }}
