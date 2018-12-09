Creating a Delivery Pipeline
============================
Up to this point, you have manually launched builds and deployments. It's time to set PFC to trigger deployments into a pipeline any time there are source code changes.
  
  * In the very top menu, click **Projects**.
  * Click the **hello-world-java** project.
  * Select the **Pipelines** tab.
  * On the right hand side, click **+ Create Pipeline**.
  * Click the `Enter Pipelines Name`field and enter `hello-world-java`.
  * Click **Create Pipeline**.
  * In the next UI, click **Add Containers**.
  * Click the **Select Container** field, then select **hello-world-java**.
  * In the **Select Branch** field, click on **master**, and click **Save Source** and then **Close**
  * You've now `registered` the master branch for auto-build. Any time new code is pushed to `master`, you'll build a new container.
  > NOTE: Since this lab is local and Gitlab will likely not resolve your laptop over the internet, webhooks won't work. Gitlab wouldn't have an easy way to resolve http://pfcfrontend:32007. Just keep in mind the functionality is there to deploy on PR and/or commit to the code repo.
  
  * Next, you will be adding deployment stages to your pipeline.
    * At the bottom of the UI, click **Add Deployment Stage**.
      * Click on **Select Cluster** and select **minikube**.
      * Click on **Select Namespace** and select **default**.
      * Click on **Deployment** and select **dev-hello-world-java**.

      <img src="../img/pfc_adddevdeploypipeline.png" height="200">

      * Click **Add Stage** and **Close**.
      * Next, you will see a yellow "pipe" connecting the build stage window to your dev deployment. Check the **Auto promote on Image Event**... checkbox

      <img src="../img/pfc_autopromoteimage.png" height="200">

      * Now anytime the source for **master** is built, it will create a new image and auto-deploy to **dev-hello-world-java**.
  * To set the pipeline to automatically build and deploy on PR and/or a commit, click the **Auto Build** link under source.
  * Ensure `Commit` is checked. Optionally, you can check `Pullrequest`.
  * Click the red **X**.

#### Adding QA and production environments  
Before you can add these deployments, you must first create them.
  
* Follow the [Time to Deploy](sample_app.md#timetodeploy) section and repeat all steps from above, but use  **qa-hello-world-java** and **prod-hello-world-java** for the deployment names.  

After successfully deploying the two new environments, you should see them in the `Clusters` menu.

Or, you can query the deployments and pods on the command line:
```
# Get deployments
kubectl get deploy | grep java

dev-hello-world-java    1         1         1            1           3h
prod-hello-world-java   1         1         1            1           18s
qa-hello-world-java     1         1         1            1           1m

# Get Pods
kubectl get pod -o wide | grep java

dev-hello-world-java-c8bd49b74-x6wlt     1/1     Running     0          3h     172.17.0.9    minikube
prod-hello-world-java-576948df5b-nhmk8   1/1     Running     0          2m     172.17.0.11   minikube
qa-hello-world-java-548fcd6575-dbhqf     1/1     Running     0          3m     172.17.0.10   minikube

# Get Services
kubectl get services | grep java

dev-hello-world-java   NodePort       10.101.138.1     <none>        9999:32100/TCP   193d

#OH NO, the services are missing for QA and PROD
 ```
 > IMPORTANT, ensure you do not use port 32100 in the next step when you create the service, as this port is already in use. Pick 32200 and 32300 for QA and PROD respectively. Update the selector and metadata in the copy/paste YAML config.

 ex:
 ```YAML
 apiVersion: v1
 kind: Service
 metadata:
   name: qa-hello-world-java  # Replace dev with qa or prod
   labels:
     app: hello-world-java
     stage: dev  # Replace dev with qa or prod
 spec:
   ports:
     - port: 9999
       nodePort: 32100 # Replace 32100 with 32200 or 32300
       name: nodeport
   selector:
     deployment: qa-hello-world-java # Replace dev with qa or prod
   type: LoadBalancer
 ```
* Follow the [Creating a Service](sample_app.md#createservice) steps to create service definitions for each new deployment. 
  
In the command line, you should now see all three services:
```
kubectl get services | grep java

dev-hello-world-java    NodePort       10.101.138.1     <none>        9999:32100/TCP   193d
prod-hello-world-java   NodePort       10.108.107.130   <none>        9999:32300/TCP   8s
qa-hello-world-java     NodePort       10.101.153.240   <none>        9999:32200/TCP   5m
```

#### Final deployments

It's time to add those additional deployments into your pipeline. 

  * In the very top menu, click **Projects**.
  * Click your **hello-world-java** project.
  * Click the **Pipelines** tab.
  * Scroll down and click **Add Deployment Stage**.
    * Click on **Select Cluster** and select **minikube**.
    * Click on **Select Namespace** and select **default**.
    * Click on **Deployment** and select **qa-hello-world-java**.
    * Click **Add Stage**.
    * Click **Close**.
  * Repeat the last steps except select **prod-hello-world-java**.
  * Check the checkbox for `Auto Promote` for the qa-hello-world-java deployment but leave `Auto Promote` unchecked for prod-hello-world-java.

  <img src="../img/pfc_autopromoteqa.png" height="350">

* In the top-right corner of the UI; start a build by clicking on the `Build` hammer <img src="../img/pfc_buildhammer.png" height="19">
  * Select **hello-world-java**.
  * Select **master**.
  * Click **Build**.
  * Click **View Build**.
  * Wait for the build to complete.
* Once the build has finished you will see `dev` and `qa` were automatically deployed. The **status** will change to **running** and then **success**.
* On the very top menu, click **Projects**.
* In the log window, you should see that the dev and qa deployments were successful.

<img src="../img/pfc_deploytodevqa.png" height="250">

Now push to Prod.
  * Click the **Pipelines** tab.
  * Scroll down to the `prod-hello-world-java` section.
  * On the right, click the **Promote** button <img src="../img/pfc_promote.png" height="17">
  * In the middle of the page, check the checkbox next to the `Deployment: prod-hello-world-java` section.
  * Click in **Image** field and ensure the most recent image is picked. *There should be two images if you've followed the guide*

  <img src ="../img/pfc_promoteprod.png" height="200">

  * Click **Promote**.

* In the very top menu, click **Projects**.
* Click your **hello-world-java** project.
You should now see the deployment success for prod. 

In the command line, you can verify all three environments are running the v2 of your build.
```
kubectl get deploy -o json | jq '.items[]| .metadata.labels.deployment + "  =   " + .spec.template.spec.containers[].image'  | grep java

"dev-hello-world-java  =   pcr-internal.puppet.net/john.fahl/hello_world_java:2"
"prod-hello-world-java  =   pcr-internal.puppet.net/john.fahl/hello_world_java:2"
"qa-hello-world-java  =   pcr-internal.puppet.net/john.fahl/hello_world_java:2"
```

Verify your applications are online:
* Browse to [qa-hello-world-java](http://qa-app:32300)
* Browse to [prod-hello-world-java](http://qa-app:32300)

Nice job completing this section of the lab. If you'd like a bit more practice, you can fix the [Ingress](ingress.md) to change how to access your applications. Also, you can try the GCP version of this lab.
