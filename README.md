# Family Justice C100 Service
 
This is a Rails application to enable citizens to complete the C100 form. It will also produce a C1A form and a C8 form 
under certain circumstances based on the answers the applicant gives (for example if there are safety concerns).

## Getting Started

* Run `brew install shared-mime-info` so MimeMagic works fine if you are on a Mac.

* Copy `.env.example` to `.env` and replace with suitable values. e.g. `cp .env.example .env`
You don't need to configure Notify or Auth0 at this point.

* `yarn install` # will pull [GOV.UK Frontend](https://design-system.service.gov.uk)
* `bundle install`
* `bundle exec rails db:setup`
* `bundle exec rails db:migrate`
* `bundle exec rails server`

### For running the tests:

* Copy `.env.test.example` to `.env.test` e.g. `cp .env.test.example .env.test`
* `RAILS_ENV=test bundle exec rails db:setup`
* `RAILS_ENV=test bundle exec rails db:migrate`

You can then run all the code linters and tests with:

* `RAILS_ENV=test bundle exec rake`
or  
* `RAILS_ENV=test bundle exec rake test`

Or you can run specific tests as follows (refer to *lib/tasks/all_tests.rake* for the complete list):

* `RAILS_ENV=test bundle exec rake spec`
* `RAILS_ENV=test bundle exec rake brakeman`

## Cucumber features

ChromeDriver is needed for the integration tests. It can be installed on Mac using Homebrew: `brew cask install chromedriver`

The features can be run manually (these are not part of the default rake task) in any of these forms:

* `bundle exec cucumber features`
* `bundle exec cucumber features/miam.feature`
* `bundle exec cucumber features/miam.feature -t @happy_path`
* `bundle exec cucumber features/miam.feature -t @unhappy_path`

By default cucumber will start a local server on a random port, run features against that server, and kill the server once the features have finished.

If you want to show the browser (useful to debug issues) prefix the commands like this:

* `SHOW_BROWSER=1 bundle exec cucumber features`

Note: if some assets are not found when running cucumber, try deleting the content of the `/tmp` directory (inside your local checkout of the project).

## Mutation testing

This project uses extensive mutation coverage, which makes the (mutation) tests take a long time to run, and can end up with the CI killing the build due to excessive job work time.

In order to make this a bit faster, by default in CI master branch and in local when run without any flags, the scope of mutant testing will be reduced to a few models, and a randomized small sample of classes in each of these groups: Form objects and Decision trees.

In PRs, the mutation will be `--since master` meaning only files changed will be tested with mutant. This is much faster than running a random sample and also should be more accurate and pick the classes that matter (the changed ones, if any).

However it is still possible to have full flexibility of what mutant runs in your local environment:

##### Run mutation on a specific file:
`RAILS_ENV=test bundle exec rake mutant C100App::RespondentDecisionTree`

##### Run mutation on the whole project (no random samples):
`RAILS_ENV=test bundle exec rake mutant all`

##### Run mutation on the whole project but only on files changed since master:
`RAILS_ENV=test bundle exec rake mutant master`

##### Run mutation on a small sample of classes (default):
`RAILS_ENV=test bundle exec rake mutant`

## Sidekiq for background job processing

The service makes use of [Sidekiq](https://github.com/mperham/sidekiq) to process background jobs including sending 
emails asynchronously. It also requires Redis to be setup and running.

In local machines, to simplify development and minimise dependencies, you can set an ENV variable `QUEUE_ADAPTER=async` 
so the jobs are processed in memory.

If you want to replicate a production environment as much as possible, you can use `docker-compose` or you can install 
the dependencies locally (Redis and Sidekiq) and then start the redis server (`redis-server`) and sidekiq worker (there 
is a [sidekiq.sh](/sidekiq.sh) script to simplify this and other tasks).  
Do not forget to unset the `QUEUE_ADAPTER` variable in your local env.

## Back office (Auth0 integration)

There is a back office / admin side that uses [Auth0](http://auth0.com) as the identity provider.  
Each application environment (localhost, staging and production) has a corresponding `tenant` in an Auth0 account.  

This allow us to have separate configurations for each environment and to test the integration with confidence.  

The different tenants contain each an `application` (the C100 backoffice). And each tenant also has `rules` that need to 
be present in order to ensure we only allow users who have been previously granted access.

You can test and use the backoffice locally without need for Auth0 credentials. Just expose the `AUTH0_BYPASS_LOCALHOST` 
env variable.

Please refer to the [config/auth0](config/auth0) directory for more details.

## Charts

Jenkins will only automatically update the chart repository if you make the change in your chart config file. If you update one of the templates, you must also bump the version number in `/charts/c100-application/Chart.yaml`.

Test your charts using the CLI command `helm template c100 charts/c100-application`

Delete existing charts using `kubectl delete hr [...]`


## Links

[infrastructure-repo]: https://github.com/hmcts/c100-shared-infrastructure
[staging]: https://c100-application.staging.platform.hmcts.net


# C100 Infrastructure

C100 is deployed on the SDS platform. If the PET team cannot support with an infrastructure query, ask #sds-cloud-native on the hmcts-reform.slack.com Slack group. 

## Development process

All pull requests automatically get a unique deployment on the dev cluster. This is also where QA testing happens. DO NOT MERGE before the ticket has been tested and fully signed off.

Merging a PR deploys it to production - as well as staging, ITHC and demo environments.

### Getting the Pull Request unique URL

On the pull request, hmcts-jenkins-cnp bot will automaticaly create a message saying, e.g. "hmcts-jenkins-cnp deployed to preview 5 minutes ago". Besides this is a button, view deployment. Click this to get to the unique URL for that PR.

Alternatively, create the URL by hand. You can see the PR number in the url: "/pull/PR_NUMBER". The PR will be at https://c100-application-pr-PR_NUMBER.dev.platform.hmcts.net/

## Environments

- Dev:- deploys a unique build for each pull request. Unlike the other environments, does not have a permanent database or redis instance. Instead, it builds its own for each new build. Shortname: `dev`. Url: https://c100-application-pr-PR_NUMBER.dev.platform.hmcts.net/.
- Staging:- a replica of the live environment. Not used as part of the development process. Can be used to interact with a replica of the live deployment without having to put test data in the production database. Shortname: `stg`. Url https://c100-application.staging.platform.hmcts.net/.
- Demo:- used for doing demonstrations to external stakeholders. Shortname: `demo`. Url https://c100-application.demo.platform.hmcts.net/.
- Production:- the live environment. Access to the console not available to developers. Shortname: `demo`. Urls https://c100-application.platform.hmcts.net/ or https://apply-to-court-about-child-arrangements.service.justice.gov.uk/.
- ITHC:- IT Health Check - a replica of the live environment, access is given to penetration testers and security consultants to test the security of C100. Shortname: `demo`. Url https://c100-application.demo.platform.hmcts.net/.

## Maintenance Page

To turn ON:
- az keyvault secret set `--vault-name 'c100-ENV_SHORTNAME' --name 'maintenance-enabled' --value 'true'`
- Delete the pods, which will rebuild automatically, using `kubectl -n c100 delete pod $pod`
- Ensure you've deleted pods on all clusters for that environment (staging and production have two clusters).

To turn OFF:
- az keyvault secret set `--vault-name 'c100-ENV_SHORTNAME' --name 'maintenance-enabled' --value 'false'`
- Delete the pods

## Environment Variables

The keyvaults are available in the Azure portal under the name c100-ENV_SHORTNAME.

Keys can be added there, or through the console using:

`az keyvault secret show --vault-name 'c100-ENV_SHORTNAME' --name 'env-name'`
`az keyvault secret set --vault-name 'c100-ENV_SHORTNAME' --name 'env-name' --value ''`

### Non-secret environment variables

If you don't need the environment variable to be a secret, you can hard code it into the list of env vars in `/charts/c100-application/values.yaml` in this repository.

### Changing environment variables

When a key is added or code or config is modified, the corresponding pod will eventually re-deploy. If you update a secret and don’t change the code or config, flux will eventually redeploy. It’s very infrequent, so rather than waiting for flux, it's faster to delete the pod using `kubectl -n c100 delete pod $pod` and allow the pod to rebuild. Ensure you've deleted pods on all clusters for that environment (staging and production have two clusters).


## Useful commands to manage the pods

Connect to the cluster you want to manage using the commands in the next section

```
kubectl get pods -n c100
pod=
kubectl exec -it $pod -n c100 -- /bin/sh
kubectl logs -n c100 -f $pod
kubectl get ingress -n c100
kubectl get deployments --all-namespaces=true
kubectl describe -n c100 pod/$pod
kubectl delete pod $pod -n c100
```

## Connecting to clusters

This can be done using the Azure portal or command line. For the portal, visit e.g. https://portal.azure.com/#@HMCTS.NET/resource/subscriptions/867a878b-cb68-4de5-9741-361ac9e178b6/resourceGroups/ss-dev-01-rg/providers/Microsoft.ContainerService/managedClusters/ss-dev-01-aks/overview

Click on the connect tab and you'll be given the connection strings needed to connect.

Here are the connection strings for the most commonly used clusters.

### Dev

Cluster name: `ss-dev-01-aks`

``az account set --subscription 867a878b-cb68-4de5-9741-361ac9e178b6
az aks get-credentials --resource-group ss-dev-01-rg --name ss-dev-01-aks``

Once you have access once, you can switch to this using `kubectl config use-context ss-dev-01-aks`


### Staging

Cluster name: `ss-stg-00-aks`

``az account set --subscription 74dacd4f-a248-45bb-a2f0-af700dc4cf68
az aks get-credentials --resource-group ss-stg-00-rg --name ss-stg-00-aks``

`kubectl config use-context ss-stg-00-aks`

### Production

SDS are only people who can access.


## Troubleshooting the infrastructure

First check https://hmcts.github.io/ways-of-working/troubleshooting, and the rest of the ways-of-working document. This is generally expected by the SDS team. Check the issue as thoroughly as possible using the command line and Azure Portal. If stuck, ask in #sds-cloud-native.


### Flux issues

https://hmcts.github.io/ways-of-working/troubleshooting/#flux-did-not-commit-latest-image-to-github

A useful command for checking flux issues:
`az aks get-credentials --resource-group ss-ptl-00-rg --name ss-ptl-00-aks --subscription DTS-SHAREDSERVICESPTL`


## Database access

Follow the instructions here: https://github.com/hmcts/cnp-module-postgres

Cheatsheet:

- request access: https://myaccess.microsoft.com/@CJSCommonPlatform.onmicrosoft.com#/access-packages
  - ITHC, Staging and Production requires production bastion access
- az login
- az ssh config --ip \*.platform.hmcts.net --file ~/.ssh/config
- Turn on F5 VPN

- For e.g. Demo, run:
  - ssh bastion-nonprod.platform.hmcts.net
  - POSTGRES_HOST=c100-demo.postgres.database.azure.com
  - DB_USER=c100_postgresql_user@c100-demo
  - DB_NAME=c100
  - psql "sslmode=require host=${POSTGRES_HOST} dbname=${DB_NAME} user=${DB_USER}"


## Infrastructure Key documentation:

- https://github.com/hmcts/cnp-jenkins-library
Shows standard opinionated pipeline stages
Shows the branch → environment relationships for both infra + app code pipelines.
- https://hmcts.github.io/ways-of-working/new-component/secrets-management.html#secrets-management
Environment variables
- https://github.com/hmcts/cnp-module-postgres
Database setup + access
- https://github.com/hmcts/cnp-flux-config/blob/master/docs/app-deployment-v2.md
To add deployment
- https://hmcts.github.io/ways-of-working/troubleshooting/
Learn this set of issues. When getting an issue, check this first.
- https://user-guide.cloud-platform.service.justice.gov.uk/documentation/other-topics/aws-rds-migration.html#step-2-sequences
Downloading data from RDS
- https://hmcts.github.io/ways-of-working/new-component/helm-chart.html#helm-chart
Information about helm
- https://tools.hmcts.net/confluence/display/RSTR/Migration+-+Developer+Notes
AWS to Azure developer migration notes


### Infrastructure repositories used:

- https://github.com/hmcts/c100-shared-infrastructure - to set up database, key vault, redis
- https://github.com/hmcts/c100-application - code + deployment pipeline
./charts/.. - used for deployment pipeline settings
./Jenkinsfile_CNP - used for deployment pipeline settings
- https://github.com/hmcts/sds-flux-config/tree/master/apps/c100
Deployment pipeline configuration
- https://github.com/hmcts/cnp-jenkins-library/ - contains code to allow Jenkins to deploy ruby projects
Import into C100 using Jenkinsfile_CNP file
- https://portal.azure.com/#@HMCTS.NET/resource/subscriptions/8999dec3-0104-4a27-94ee-6588559729d1/resourceGroups/rpe-acr-prod-rg/providers/Microsoft.ContainerRegistry/registries/hmctspublic/repository
Container repository
- https://github.com/hmcts/azure-public-dns
Public DNS for prod
- https://github.com/hmcts/azure-private-dns
Private DNS for all envs
- https://github.com/hmcts/sds-azure-platform/pull/261
Platform config


