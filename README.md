# Tekton templates

General tekton pipeline template and examples

## Quick start examples

- ***Notice:*** This project demonstrates the CI/CD process and needs to depend on the project: [springboot-istio-charts-template](https://github.com/wl4g/springboot-istio-charts-template), please make sure it has been downloaded locally.

- Run pipeline testing

```bash
kubectl apply -f ./templates/cd
kubectl apply -f ./templates/ci
kubectl apply -f ./test/pipelinerun-test.yaml
tkn pr describe pipelinerun

Name:              pipelinerun
Namespace:         default
Pipeline Ref:      pipeline
Service Account:   tekton-build-sa
Timeout:           1h0m0s
Labels:
 tekton.dev/pipeline=pipeline

π‘οΈ  Status

STARTED         DURATION   STATUS
4 minutes ago   2m30s      Succeeded(Completed)

β Params

 NAME                  VALUE
 β git_url             https://github.com/wl4g/springboot-istio-charts-template.git
 β image               docker.io/wl4g/springboot-demo:1.0.1
 β charts_dir          ./helm
 β release_name        demo
 β release_namespace   kube-ops
 β overwrite_values    image.repository=docker.io/wl4g/springboot-demo,image.tag=1.0.1
 β values_file         my-values.yaml

π Workspaces

 NAME            SUB PATH   WORKSPACE BINDING
 β demo-repo-pvc   ---        PersistentVolumeClaim (claimName=demo-repo-pvc)

π  Taskruns

 NAME                   TASK NAME   STARTED         DURATION   STATUS
 β pipelinerun-deploy   deploy      3 minutes ago   1m14s      Succeeded
 β pipelinerun-docker   docker      4 minutes ago   55s        Succeeded
 β pipelinerun-build    build       4 minutes ago   11s        Succeeded
 β pipelinerun-test     test        4 minutes ago   4s         Succeeded
 β pipelinerun-clone    clone       4 minutes ago   6s         Succeeded

β­οΈ  Skipped Tasks

 NAME
 β rollback

# ι¨η½²ζεδΊ
curl springboot-demo.svc.cluster.local/demo/echo?name=jack01
{"timestamp":1661096722664,"appversion":"1.0.0","method":"POST","path":"/demo/echo","headers":{},"body":"name=jack01"}
```

- Configure Event trigger testing

```bash
kubectl get eventlistener gitlab-listener
NAME              ADDRESS                                                    AVAILABLE   REASON                     READY   REASON
gitlab-listener   http://el-gitlab-listener.default.svc.cluster.local:8080   True        MinimumReplicasAvailable   True
```

```bash
kubectl get pipelinerun
NAME               SUCCEEDED   REASON      STARTTIME   COMPLETIONTIME
gitlab-run-j77rx   True        Completed   4m46s       46s
curl springboot-demo.svc.cluster.local/demo/echo?name=jack01
{"timestamp":1661096722664,"appversion":"1.0.0","method":"POST","path":"/demo/echo","headers":{},"body":"name=jack01"}
```
