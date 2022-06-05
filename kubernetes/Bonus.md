### Answering for bonus question
How to secure configmap values?

So i would introduce "vault" as a secret manager tool. I will store all configmap values within a vault secret.
All manifests have to be parameterised, it will be better to convert this as a helm chart so that we can read values from vault 
and pass during helm upgrade.

manifest will look something like this

apiVersion: v1
kind: ConfigMap
metadata:
  name: {{.Values.deploy_name}}
  labels:
    run: {{.Values.deploy_name}}
data:
  production.js: |
    database_url: {{.Values.db_uri}}
    database_password: {{.Values.db_password}}
    database_user: {{.Values.db_user}}
    database_port: {{.Values.db_port}}
    
############
While doing a helm upgrade or helm install, i will pass the values stores in vault as "--set"

helm upgrade --install node-test folder/ --set db_password=test123,db_user=test,db_port=5432
