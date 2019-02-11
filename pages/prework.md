Pre-work
========

There is both technical and non-technical pre-work for this exercise.  If you already have a solid understanding of Kubernetes (k8s) you can skip right to the technical work.

## Non-technical

If you've never worked with k8s before you'll definitely want to checkout some materials on what Kubernetes is, how it works, and what problems it's trying to solve (yes, its more then just running a container).  This section gives a brief intro (via external content) to what k8s is, how it works, and what problems it solves(<60 minutes).

#### Read some comics

What?  Yes, seriously there is comic about k8s.  However, its actually a really good resource in terms of the value k8s provides.

[Value Prop](https://cloud.google.com/kubernetes-engine/kubernetes-comic/)

#### Get to know one of the co-founders

Brendan Burns talks about the fundamentals of k8s.  However, pay close attention to the first few minutes where he describes the true value of k8s and what they set out to achieve when designing/building it.  Then pay attention to the rest ;).  You need to understand these core concepts for Pipelines for Containers exercises to make sense.

[The talk](https://www.youtube.com/watch?v=WwBdNXt6wO4)

#### Take interactive Kubernetes Tutorials

You don't HAVE to do this next part; however if you've got the time to invest, the online tutorials (found [here](https://kubernetes.io/docs/tutorials/kubernetes-basics/)) are really great!  There will be a tiny bit of repetition between the k8s tutorials and the PFC exercises, but for the most part the k8s tutorials are going to be way, way more in depth on how k8s works.

## Clone this repo to your laptop

* After cloning, the next labs all assume your working from the `pipelines-for-containers` folder

## Technical

You've got some setup to do. Before choosing a path, you will need `Maven` installed locally to first build your java app. Maven's installation [page](https://maven.apache.org/download.cgi) can provide you links to get the application. Alternatively you can use brew, chocolatey, or your linux distro's package manager (i.e. Yum, apt, zypper).

OSX:
```
brew install maven
```

Chocolately:
```
# Powershell launched as an administrator
choco install maven
```

The rest of this HOL can be followed on one of two paths.


[Path 1](#path1): Develop and deploy locally on your laptop using Minikube and leveraging internal Puppet Container Registry.

[Path 2](#path2): Using Google Cloud Platform (GCP) to deploy to Google Kubernetes Environment (GKE) and leveraging Dockerhub.

### <a name="path1">Path 1</a>

#### Minikube setup

Just a quick note; this exercise uses (2) local VMs.  One is running k8s(minikube) and the other will be used as a build server.  In total, the VMs will have (3) CPUs and (4.5)GB memory allotted, so you may need to spin down any other VMs your running.

#### Install your local environment

The script `pre-work.sh` in the base of this repo will try and automate this process, installing, or guiding you to install any missing applications.

* Virtualbox [Install](https://www.virtualbox.org/wiki/Downloads)
* Vagrant [Install](https://www.vagrantup.com/intro/getting-started/install.html)
* Kubectl [Install](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* Minikube [Install](https://kubernetes.io/docs/tasks/tools/install-minikube/)
  > NOTE: You can skip the `What's Next` section
* Docker
  * [bits](https://download.docker.com/mac/stable/Docker.dmg)
  * [guide](https://docs.docker.com/docker-for-mac/install/#install-and-run-docker-for-mac)
* [Homebrew](https://brew.sh/)
* Java: `brew cask install java`
* [Maven](https://maven.apache.org/) `brew install maven`

#### Puppet Container Registry (PCR)

Puppet hosts a docker registry service that can be used to manage your containers. Sign up for an account and use the registry for this hands-on lab: visit [Puppet Container Registry](https://pcr-internal.puppet.net/).

1. Click **Login via SSO**.
2. Enter your Okta credentials.
3. That's it, you're in!

Now you are ready to continue installing PFC on [minikube](install_pfc.md)!

### <a name="path2">Path 2</a>

In this path, you will be setting up a K8s environment in Google Cloud Platform and using Dockerhub.

#### Google Cloud Platform - Google Kubernetes Environment

Sign up for an account on [GCP](https://console.cloud.google.com). This lab will be connecting Puppet Pipelines to a Google Kubernetes Engine (GKE) cluster to build, deploy, and manage a java application.

>This lab should use minimal resources but know that cloud providers do have costs if you should go over free-tier allocations.

#### Dockerhub

If you do not have a Dockerhub account, you will need one, and it's free. Sign up for an account at [Dockerhub](https://hub.docker.com)

### Github

If you do not have a Github account, you can create one, it is also free. You will be forking a repo on Github for this lab. Alternatively, you could clone the repo and push it up to your own repository in Gitlab or Bitbucket, but those instructions are not included. Also, instructions to connect Gitlab and Bitbucket to PFC is not included in this HOL but the steps are very similar to connecting PFC to Github in the next section.

#### Puppet Pipelines

In this lab, you will be using the SaaS version of Pipelines. Sign up for a free account.

* Navivate to the Pipelines [login](https://pipelines.puppet.com/login).
* Click **Create a free account**.
* Enter your information, then click **Sign up**.

Now you are ready to continue integrations [setup](configure_integrations_gke.md).
