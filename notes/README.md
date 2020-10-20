----------------------------------------
Locations of files

- `uniqueWorking.txt` is located at: `db/properties`
- `*.html.erb` files are in `app/views/number_gossip`
   do not need to push buttons, just check
- To update credits, I have to go to
  app/controllers/number_gossip_controller and add there.

---------------------------------------
Sanity checks

Each line of uniqueWorking.txt that is not empty should contain a
colon:

```
grep " " uniqueWorking.txt|grep -v ";"
```

Each line that contains * corresponds to an approved property.
This can be checked with:

```
grep "^*" uniqueWorking.txt|wc
```

This checks lines that start with a `*`

- On May 28 2007 it was 752
- On Aug 28 2007 it was 782
- On Apr 1 2008 it was 839

In unique.txt the number of properties is counted in the following manner:
```
cat unique.txt | tr ";" "\n" | wc
```

`cat onefile` - outputs file; `tr` - replaces ; with a new line, then
we count the number of lines.

- On May 28 2007 it was 750.

Each line that contains ?? corresponds to a property I have to check.
This can be checked with:

```
grep "??" uniqueWorking.txt | wc
```

- On May 15 2007 it was 666
- On Aug 28 2007 it was 740
- On April 1 2008 it was 674

Each line in `unique.txt` corresponds to a number with unique properties.
This can be checked with `wc unique.txt`

- On May 28 it was 463.
- On Aug 28 2007 it was 478.

----------------------------------------
When I make changes, then first I can test it locally:

Setup
- Make sure Docker is installed and set up correctly
- Make sure rbenv is set up properly and has the right version of Ruby
  installed.
- bundle install

Test code
- bundle exec rake test

Set up database
- bundle exec rails db:schema:load
- bundle exec rake rebuild_database

Test Rails app
- bundle exec rails server and browse localhost:<port>

Test full container
- docker build .
  - Prints a new image ID at the end
- docker run -p 127.0.0.1:3000:80 <image id>
- docker ps
  - Lists the running containers
- docker exec <container name> <command>
  - To debug what's going on in the container
- docker stop -t 1 <container name>
  - Stops the container when done

----------------------------------------
To redeploy to the cloud

Once everything has been set up (see below), deployment:

- Upload new version of code to Google Cloud
  `git push gcloud master`

- This triggers an automatic rebuild, taking 4-5 minutes.  You can
  watch the status with
  `gcloud builds list`

- To use the result, edit `deploy/web.yml`, to set
  spec.template.spec.containers[0].image to the built image, which
  should have a name like
  gcr.io/pelagic-force-260622/numbergossip:f9842d1

- Redeploy with
  `kubectl apply -f deploy/web.yml`

- This should trigger a rollout that you watch with
  `kubectl rollout status deployment.apps/numbergossip-web`
  or whose end result can be seen with
  `kubectl get pods`
  - Once it says 'deployment "numbergossip-web" successfully rolled out', the change should be live.

- If the Kubernetes configuration changed, rebuild the pod and/or the service
  `kubectl apply -f deploy/web.yml`,
  `kubectl apply -f deploy/web-svc.yml`,
  `kubectl apply -f deploy/ssl-cert.yml`, or
  `kubectl apply -f deploy/ingress.yml` as needed

  kubectl replace may work, too

- Don't forget to commit and push the updated web.yml to Github so
  that future deployments pick up the change.

----------------------------------------
To set up Google Cloud control tooling

Install Cloud SDK and Kubernetes

- These instructions taken from
  https://cloud.google.com/sdk/docs/downloads-apt-get

- Install prereqs

- sudo apt-get install apt-transport-https ca-certificates gnupg

- Get the Google key

  - curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

- Add the Google repository for Debian packages

  - echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
    | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

- Actually install the SDK, and Kubernetes

- sudo apt-get update && sudo apt-get install google-cloud-sdk kubectl

- Needs to be granted permission to access the project, presumably by
  an existing owner, presumably via cloud.google.com.

- Initialize (machine local, apparently?)

  - gcloud init

----------------------------------------
To start a Cloud numbergossip project

It should not be necessary to repeat this.

Is there a separate step to create a project?

Start a cluster named `numbergossip-web`

```
gcloud container clusters create numbergossip-web \
    --enable-cloud-logging \
    --enable-cloud-monitoring \
    --machine-type=e2-micro \
    --num-nodes=1
```

Fetch credentials for that cluster

```
gcloud container clusters get-credentials numbergossip-web
```

Go to the Google Cloud UI and create a Cloud Source Repository

Upload numbergossip code to that repository

```
git remote add gcloud ssh://<email>@source.developers.google.com:2022/p/<project>/r/numbergossip
git push gcloud master
```

Go to the UI and turn on Cloud Build; add a trigger to build on push
to the Cloud Source repo; also one to tag the latest built image
`latest`.

Create a global ip address named `numbergossip-global-ip` (because
Ingresses don't work with regional IP addresses):

```
gcloud compute addresses create numbergossip-global-ip --global
```

To find out what the IP address is

```
gcloud compute addresses describe numbergossip-global-ip --global
```

Point DNS at that IP address

Start everything

```
kubectl apply -f deploy/web.yml
kubectl apply -f deploy/web-svc.yml
kubectl apply -f deploy/ssl-cert.yml
kubectl apply -f deploy/ingress.yml
```

To check that it worked

```
kubectl get pods
kubectl get deployments
kubectl get services
kubectl get ingress
kubectl describe managedcertificate
```

DNS may take time to propagate.

The SSL certificate may take time to provision, and that can only
happen after DNS has propagated.

----------------------------------------
Changing machine types is surprisingly annoying

List existing node pool
gcloud container node-pools list --cluster numbergossip-web

Create desired new node pool
gcloud container node-pools create small-pool \
  --cluster=numbergossip-web \
  --machine-type=e2-small \
  --num-nodes=1

The tutorial at
https://cloud.google.com/kubernetes-engine/docs/tutorials/migrating-node-pool
has a lot of stuff about cordoning and draining the old node pool, but
it didn't seem to be necessary.

Delete the old node pool
gcloud container node-pools delete default-pool --cluster numbergossip-web

The web site was still up, so it seems to have worked

----------------------------------------
To add a new developer setup to an existing cloud setup

Just add the git remote
```
git remote add gcloud ssh://<email>@source.developers.google.com:2022/p/pelagic-force-260622/numbergossip
```
