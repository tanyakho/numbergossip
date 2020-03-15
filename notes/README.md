
Locations of files:
- `uniqueWorking.txt` is located at: `db/properties`
- `*.html.erb` files are in `app/views/number_gossip`
   do not need to push buttons, just check
- To update credits, I have to go to
  app/controllers/number_gossip_controller and add there.

----------------------------------------
When I make changes, then first I can test it locally:

Starting local web server in the terminal in NG directory print:
rails server

Then in Firefox type
`localhost:(port number)`


after that I should run unit tests:
in terminal window in ng directory, type rails test


----------------------------------------
To redeploy to the cloud

Once everything has been set up (see below), deployment:

- Upload new version of code to Google Cloud
  `git push gcloud master`

- If the Kubernetes configuration changed, rebuild the pod and/or the service
  `kubectl apply -f deploy/web.yml`,
  `kubectl apply -f deploy/web-svc.yml`,
  `kubectl apply -f deploy/ssl-cert.yml`, or
  `kubectl apply -f deploy/ingress.yml` as needed

  kubectl replace may work, too

  Otherwise it should update automatically?  If not, can force it with
  `kubectl apply -f deploy/web.yml`

- go to numbergossip/status and push buttons if needed. Right now it
  tells that everything is out of date after the deploy because the
  time stamp changes. I do need to update the unique properties if I
  changed them.

---------------------------------------
Moving Unique working to number_gossip directory on April 1, 2008

Sanity check - each line that is not empty should contain a colon:

```
grep " " uniqueWorking.txt|grep -v ";"
```

Each line that contains * corresponds to an approved property.
this can be checked with 
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
this can be checked with
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

To set up Google Cloud control tooling

Install Cloud SDK
- From https://cloud.google.com/sdk/docs/downloads-apt-get
- Install prereqs
  - sudo apt-get install apt-transport-https ca-certificates gnupg
  - They were already there
- Get the Google key
  - curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
- Add the repo
  - echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
- Actually install it, with Kubernetes
  - sudo apt-get update && sudo apt-get install google-cloud-sdk kubectl
- Initialize (machine local, apparently?)
  - gcloud init

----------------------------------------

Is there a separate step to create a project?

Start a cluster named `numbergossip-web`

```
gcloud container clusters create numbergossip-web \
    --enable-cloud-logging \
    --enable-cloud-monitoring \
    --machine-type=n1-standard-1 \
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
kubectl get services
kubectl get ingress
kubectl describe managedcertificate
```

DNS may take time to propagate.

The SSL certificate may take time to provision, and that can only
happen after DNS has propagated.
