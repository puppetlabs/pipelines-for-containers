Ingress
=======
Your apps are deployed but you have to access them on host:port. There are better ways to access your applications through services.

> Probably start by reading about what `Ingress` is [here](https://kubernetes.io/docs/concepts/services-networking/ingress/)

## Why?  
There's a bunch of ways to access services on a k8s cluster.  Very commonly, companies will run their k8s clusters on AWS or GCE and both of these services have deeply integrated setups for their respective load balancing services. If you're running in one of these clouds, you can simply define your services with type `LoadBalancer` (and some other key settings you can read about [here](https://aws.amazon.com/blogs/opensource/network-load-balancer-support-in-kubernetes-1-9/) and [here](https://cloud.google.com/kubernetes-engine/docs/load-balancer)) and it will automatically create an external facing load balancer so you can access your application.
  
However, even with using a cloud provider many companies are going to use an `Ingress` controller because they want a single entry point to their cluster and applications. Most of the time GCE or AWS load balancers are going to create a new public IP for each application, which isn't always desirable or easily maintained.


## Setup
For this portion of the exercise you'll be using `kubectl` for your commands. Today there is no ability to manage `ingress` within PFC.  You're going to use the [Traefik](https://traefik.io/) ingress controller. You've actually already deployed the controller when you built out PFC, so you'll just be adding a new `ingress resource`.

* In the base of your pipelines-self-paced repo, navigate to pipelines-for-containers/assets/ingress subdirectory.
* Take a look at app-dev.yaml:
  ```
  cat -n dev-app.yaml
  ```
  * Lines 1-5 are just metadata - same as your service definitions.
  * Lines 6-7 are a special annotation so that your Traefik controller knows it has control of this ingress resource (you can have multiple ingress controllers).
  * Lines 8-16 define your actual rules.
    * The host `dev-app` and requests to `/` for this host will get directed to our defined back end. Your back end is a service, `dev-hello-world-java`, and it's using the port `nodePort` (which is a name, not a type!). 
* Let's deploy this ingress resource.
  ```
  kubectl apply -f dev-app.yaml`
  ```
* Now watch the magic. In your browser, go to `http://dev-app'
* As you can see, there is no port required now. This is K8s doing the ingress work for you.
* You can view the details of your deployed ingress resource:
  ```
  kubectl get ingress
  
  #or  
  
  kubectl describe ingress dev-app
  ```
  * You can also view the Traefik console at `http://<minikube-ip>:8080`
  
### Challenge lab  
Can you create two more ingress resources? Create one for QA and one for Prod.

