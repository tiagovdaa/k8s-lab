# Installation Guide[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#installation-guide)

There are multiple ways to install the NGINX ingress controller: - with [Helm](https://helm.sh), using the project repository chart; - with `kubectl apply`, using YAML manifests; - with specific addons (e.g. for [minikube](https://kubernetes.github.io/ingress-nginx/deploy/#minikube) or [MicroK8s](https://kubernetes.github.io/ingress-nginx/deploy/#microk8s)).

On most Kubernetes clusters, the ingress controller will work without  requiring any extra configuration. If you want to get started as fast as possible, you can check the [quick start](https://kubernetes.github.io/ingress-nginx/deploy/#quick-start) instructions. However, in many environments, you can improve the  performance or get better logs by enabling extra features. we recommend  that you check the [environment-specific instructions](https://kubernetes.github.io/ingress-nginx/deploy/#environment-specific-instructions) for details about optimizing the ingress controller for your particular environment or cloud provider.

## Contents[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#contents)

- [Quick start](https://kubernetes.github.io/ingress-nginx/deploy/#quick-start)
- [Environment-specific instructions](https://kubernetes.github.io/ingress-nginx/deploy/#environment-specific-instructions)
- [Docker Desktop](https://kubernetes.github.io/ingress-nginx/deploy/#docker-desktop)
- [minikube](https://kubernetes.github.io/ingress-nginx/deploy/#minikube)
- [MicroK8s](https://kubernetes.github.io/ingress-nginx/deploy/#microk8s)
- [AWS](https://kubernetes.github.io/ingress-nginx/deploy/#aws)
- [GCE - GKE](https://kubernetes.github.io/ingress-nginx/deploy/#gce-gke)
- [Azure](https://kubernetes.github.io/ingress-nginx/deploy/#azure)
- [Digital Ocean](https://kubernetes.github.io/ingress-nginx/deploy/#digital-ocean)
- [Scaleway](https://kubernetes.github.io/ingress-nginx/deploy/#scaleway)
- [Exoscale](https://kubernetes.github.io/ingress-nginx/deploy/#exoscale)
- [Oracle Cloud Infrastructure](https://kubernetes.github.io/ingress-nginx/deploy/#oracle-cloud-infrastructure)
- [Bare-metal](https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal)
- [Miscellaneous](https://kubernetes.github.io/ingress-nginx/deploy/#miscellaneous)

## Quick start[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#quick-start)

You can deploy the ingress controller with the following command:

```
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

It will install the controller in the `ingress-nginx` namespace, creating that namespace if it doesn't already exist.

Info

This command is *idempotent*: - if the ingress controller is not installed, it will install it, - if  the ingress controller is already installed, it will upgrade it.

This requires Helm version 3. If you prefer to use a YAML manifest, you can run the following command instead:

Attention

Before running the command at your terminal, make sure Kubernetes is enabled at Docker settings

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/cloud/deploy.yaml
```

Info

The YAML manifest in the command above was generated with `helm template`, so you will end up with almost the same resources as if you had used Helm to install the controller.

If you are running an old version of Kubernetes (1.18 or earlier), please read [this paragraph](https://kubernetes.github.io/ingress-nginx/deploy/#running-on-Kubernetes-versions-older-than-1.19) for specific instructions.

### Pre-flight check[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#pre-flight-check)

A few pods should start in the `ingress-nginx` namespace:

```
kubectl get pods --namespace=ingress-nginx
```

After a while, they should all be running. The  following command will wait for the ingress controller pod to be up,  running, and ready:

```
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

### Local testing[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#local-testing)

Let's create a simple web server and the associated service:

```
kubectl create deployment demo --image=httpd --port=80
kubectl expose deployment demo
```

Then create an ingress resource. The following example uses an host that maps to `localhost`:

```
kubectl create ingress demo-localhost --class=nginx \
  --rule=demo.localdev.me/*=demo:80
```

Now, forward a local port to the ingress controller:

```
kubectl port-forward --namespace=ingress-nginx service/ingress-nginx-controller 8080:80
```

At this point, if you access http://demo.localdev.me:8080/, you should see an HTML page telling you "It works!".

### Online testing[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#online-testing)

If your Kubernetes cluster is a "real" cluster that supports services of type `LoadBalancer`, it will have allocated an external IP address or FQDN to the ingress controller.

You can see that IP address or FQDN with the following command:

```
kubectl get service ingress-nginx-controller --namespace=ingress-nginx
```

Set up a DNS record pointing to that IP address  or FQDN; then create an ingress resource. The following example assumes  that you have set up a DNS record for `www.demo.io`:

```
kubectl create ingress demo --class=nginx \
  --rule=www.demo.io/*=demo:80
```

You should then be able to see the "It works!"  page when you connect to http://www.demo.io/. Congratulations, you are  serving a public web site hosted on a Kubernetes cluster! 🎉

## Environment-specific instructions[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#environment-specific-instructions)

### Local development clusters[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#local-development-clusters)

#### minikube[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#minikube)

The ingress controller can be installed through minikube's addons system:

```
minikube addons enable ingress
```

#### MicroK8s[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#microk8s)

The ingress controller can be installed through MicroK8s's addons system:

```
microk8s enable ingress
```

Please check the MicroK8s [documentation page](https://microk8s.io/docs/addon-ingress) for details.

#### Docker Desktop[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#docker-desktop)

Kubernetes is available in Docker Desktop:

- Mac, from [version 18.06.0-ce](https://docs.docker.com/docker-for-mac/release-notes/#stable-releases-of-2018)
- Windows, from [version 18.06.0-ce](https://docs.docker.com/docker-for-windows/release-notes/#docker-community-edition-18060-ce-win70-2018-07-25)

The ingress controller can be installed on Docker Desktop using the default [quick start](https://kubernetes.github.io/ingress-nginx/deploy/#quick-start) instructions.

On most systems, if you don't have any other service of type `LoadBalancer` bound to port 80, the ingress controller will be assigned the `EXTERNAL-IP` of `localhost`, which means that it will be reachable on localhost:80. If that doesn't work, you might have to fall back to the `kubectl port-forward` method described in the [local testing section](https://kubernetes.github.io/ingress-nginx/deploy/#local-testing).

### Cloud deployments[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#cloud-deployments)

If the load balancers of your cloud provider do active healthchecks on their backends (most do), you can change the `externalTrafficPolicy` of the ingress controller Service to `Local` (instead of the default `Cluster`) to save an extra hop in some cases. If you're installing with Helm, this can be done by adding `--set controller.service.externalTrafficPolicy=Local` to the `helm install` or `helm upgrade` command.

Furthermore, if the load balancers of your cloud provider support the PROXY  protocol, you can enable it, and it will let the ingress controller see  the real IP address of the clients. Otherwise, it will generally see the IP address of the upstream load balancer. This must be done both in the ingress controller (with e.g. `--set controller.config.use-proxy-protocol=true`) and in the cloud provider's load balancer configuration to function correctly.

In the following sections, we provide YAML manifests that enable these  options when possible, using the specific options of various cloud  providers.

#### AWS[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#aws)

In AWS we use a Network load balancer (NLB) to expose the NGINX Ingress controller behind a Service of `Type=LoadBalancer`.

Info

The provided templates illustrate the setup for legacy in-tree service load balancer for AWS NLB. AWS provides the documentation on how to use [Network load balancing on Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/network-load-balancing.html) with [AWS Load Balancer Controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller).

##### Network Load Balancer (NLB)[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#network-load-balancer-nlb)

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/aws/deploy.yaml
```

##### TLS termination in AWS Load Balancer (NLB)[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#tls-termination-in-aws-load-balancer-nlb)

In some scenarios is required to terminate TLS in the Load Balancer and not in the ingress controller.

For this purpose we provide a template:

- Download [deploy-tls-termination.yaml](https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/aws/deploy-tls-termination.yaml)

```
wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/aws/deploy-tls-termination.yaml
```

- Edit the file and change:
- VPC CIDR in use for the Kubernetes cluster:

```
proxy-real-ip-cidr: XXX.XXX.XXX/XX
```

- AWS Certificate Manager (ACM) ID

```
arn:aws:acm:us-west-2:XXXXXXXX:certificate/XXXXXX-XXXXXXX-XXXXXXX-XXXXXXXX
```

- Deploy the manifest:

```
kubectl apply -f deploy-tls-termination.yaml
```

##### NLB Idle Timeouts[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#nlb-idle-timeouts)

Idle timeout value for TCP flows is 350 seconds and [cannot be modified](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/network-load-balancers.html#connection-idle-timeout).

For this reason, you need to ensure the [keepalive_timeout](http://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_timeout) value is configured less than 350 seconds to work as expected.

By default NGINX `keepalive_timeout` is set to `75s`.

More information with regards to timeouts can be found in the [official AWS documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/network-load-balancers.html#connection-idle-timeout)

#### GCE-GKE[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#gce-gke)

Info

Initialize your user as a cluster-admin with the following command: 

```
kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole cluster-admin \
  --user $(gcloud config get-value account)
```



Danger

For private clusters, you will need to either add an additional firewall rule that allows master nodes access to port `8443/tcp` on worker nodes, or change the existing rule that allows access to ports `80/tcp`, `443/tcp` and `10254/tcp` to also allow access to port `8443/tcp`.

See the [GKE documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#add_firewall_rules) on adding rules and the [Kubernetes issue](https://github.com/kubernetes/kubernetes/issues/79739) for more detail.

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/cloud/deploy.yaml
```

Failure

Proxy protocol is not supported in GCE/GKE

#### Azure[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#azure)

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/cloud/deploy.yaml
```

More information with regards to Azure annotations for ingress controller can be found in the [official AKS documentation](https://docs.microsoft.com/en-us/azure/aks/ingress-internal-ip#create-an-ingress-controller).

#### Digital Ocean[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#digital-ocean)

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/do/deploy.yaml
```

#### Scaleway[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#scaleway)

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/scw/deploy.yaml
```

#### Exoscale[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#exoscale)

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/exoscale/deploy.yaml
```

The full list of annotations supported by Exoscale is available in the Exoscale Cloud Controller Manager [documentation](https://github.com/exoscale/exoscale-cloud-controller-manager/blob/master/docs/service-loadbalancer.md).

#### Oracle Cloud Infrastructure[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#oracle-cloud-infrastructure)

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/cloud/deploy.yaml
```

A [complete list of available annotations for Oracle Cloud Infrastructure](https://github.com/oracle/oci-cloud-controller-manager/blob/master/docs/load-balancer-annotations.md) can be found in the [OCI Cloud Controller Manager](https://github.com/oracle/oci-cloud-controller-manager) documentation.

### Bare metal clusters[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters)

Using [NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport):

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/baremetal/deploy.yaml
```

Tip

Applicable on kubernetes clusters deployed on bare-metal with generic Linux distro(Such as CentOs, Ubuntu ...).

Info

For extended notes regarding deployments on bare-metal, see [Bare-metal considerations](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/).

## Miscellaneous[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#miscellaneous)

### Checking ingress controller version[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#checking-ingress-controller-version)

Run `nginx-ingress-controller --version` within the pod, for instance with `kubectl exec`:

```
POD_NAMESPACE=ingress-nginx
POD_NAME=$(kubectl get pods -n $POD_NAMESPACE -l app.kubernetes.io/name=ingress-nginx --field-selector=status.phase=Running -o name)
kubectl exec $POD_NAME -n $POD_NAMESPACE -- /nginx-ingress-controller --version
```

### Scope[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#scope)

By default, the controller watches Ingress objects from all namespaces. If you want to change this behavior, use the flag `--watch-namespace` or check the Helm chart value `controller.scope` to limit the controller to a single namespace.

See also [“How to easily install multiple instances of the Ingress NGINX controller in the same cluster”](https://kubernetes.github.io/ingress-nginx/#how-to-easily-install-multiple-instances-of-the-ingress-nginx-controller-in-the-same-cluster) for more details.

### Webhook network access[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#webhook-network-access)

Warning

The controller uses an [admission webhook](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/) to validate Ingress definitions. Make sure that you don't have [Network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) or additional firewalls preventing connections from the API server to the `ingress-nginx-controller-admission` service.

### Certificate generation[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#certificate-generation)

Attention

The first time the ingress controller starts, two [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/) create the SSL Certificate used by the admission webhook.

THis can cause an initial delay of up to two minutes until it is possible to create and validate Ingress definitions.

You can wait until it is ready to run the next command:

```
 kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

### Running on Kubernetes versions older than 1.19[ ¶](https://kubernetes.github.io/ingress-nginx/deploy/#running-on-kubernetes-versions-older-than-119)

Ingress resources evolved over time. They started with `apiVersion: extensions/v1beta1`, then moved to `apiVersion: networking.k8s.io/v1beta1` and more recently to `apiVersion: networking.k8s.io/v1`.

Here is how these Ingress versions are supported in Kubernetes: - before Kubernetes 1.19, only `v1beta1` Ingress resources are supported - from Kubernetes 1.19 to 1.21, both `v1beta1` and `v1` Ingress resources are supported - in Kubernetes 1.22 and above, only `v1` Ingress resources are supported

And here is how these Ingress versions are supported in NGINX Ingress Controller: - before version 1.0, only `v1beta1` Ingress resources are supported - in version 1.0 and above, only `v1` Ingress resources are

As a result, if you're running Kubernetes 1.19 or later, you should be  able to use the latest version of the NGINX Ingress Controller; but if  you're using an old version of Kubernetes (1.18 or earlier) you will  have to use version 0.X of the NGINX Ingress Controller (e.g. version  0.49).

The Helm chart of the NGINX Ingress Controller switched to version 1 in version 4 of the chart. In other words, if you're running  Kubernetes 1.19 or earlier, you should use version 3.X of the chart  (this can be done by adding `--version='<4'` to the `helm install` command).