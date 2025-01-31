# DevOps with GitHub Template

This repository contains a set of labs and exercises that demonstrates different DevOps practices applied to GitHub. The instructions for these labs can be found in [this url](https://github.partners/devops.github.io/white-belt/labs/index.html). 
This content is only available for GitHub partners under NDA and must not be shared with customers.

## Before you start

Before you start following the instructions, make sure you create a copy of this template into a GitHub organization you own. You can follow [this instructions](https://docs.github.com/en/enterprise-server@3.10/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template) to do that. Feel free to use a repository name of your choice for your environment.

<details>

<summary>Lab coaches instructions</summary>

## 1. Lab coaches instructions

The following instructions should be performed by lab coaches who are setting up these labs for a bigger audience. These steps are meant to be followed once and will configure the environment for trainees to go through the exercises.

### Pre-requisites

This lab requires:

- `GitHub organization`: we recommend you use your NFR environment for it.
- `Azure subscription`: resources will be provisioned in Azure by GitHub Actions to demonstrate Continous Deployment, therefore an active Azure subscription that you permissions to create resources in is required. You can create an Azure account for free.
- `Microsoft Teams`: we will integrate with Microsoft Teams to push messages into channels based on events in GitHub, therefore we recommend that you create a new Microsoft Team for use with this class.

### Generate a GitHub personal access token

To ensure that we can provision resources in GitHub on your behalf, we will need to authenticate, and for that we will need a Personal Access Token (PAT). Personal access tokens are intended to access GitHub resources on behalf of yourself. In GitHub, there are two types of personal access tokens. You can read more about them [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token#types-of-personal-access-tokens). For this exercise, we will generate a **classic** PAT. 

> You can read more about how to keep your personal access tokens secure following [this link](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token#keeping-your-personal-access-tokens-secure).

[Generate a PAT](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) in GitHub, with the following scopes.

| Scope | Permission |
|-------| ---------- |
| repo | Full control of private repositories |
| workflow | Update GitHub Action workflows |
| admin:repo_hook | Full control of repository hooks |
| notifications | Access notifications |

When you're done, make sure to copy the token. For your security, it won't be shown again. You will need to provide this when you make your request in the DevOps Dojo Self Service Power App.


#### Generate an Azure Service Principal

To ensure that we can provision resources in Azure, we will need to authenticate, and for that we will need to generate a service principal and grant it `Contributor` access to your Azure subscription.

First [sign in with Azure CLI](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli) executing the `az login` command, this will start an interactive login session opening your default web browser.

To create the service principal, execute:

```sh
az ad sp create-for-rbac --name "<name>" --role "Contributor" --output "json" --scopes /subscriptions/<subscriptionId>
```

> The service principal will be granted contributor role against the default subscription, use `--scopes="/subscriptions/<SUBSCRIPTION_ID>"` to specify a specific subscription

The below output will be returned when the service principal has been created.

```json
{
  "appId": "<client_id>",
  "displayName": "<name>",
  "password": "<client_secret>",
  "tenant": "<tenant_id>"
}
```

To obtain the Object ID of the service principal, execute: 

```sh
az ad sp list --display-name "<name>" --query "[].id" --output tsv
```

### Configure Incoming Webhook in Microsoft Teams

To receive messages from GitHub into Microsoft Teams, we will need to [create an Incoming Webhook](https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook#create-incoming-webhook-1) in a channel in your team.

Once you have configured the Incoming Webhook, make a note of the webhook URL.

> We recommend creating the webhook in the General channel, however if you want to create another channel to receive messages into, that is also fine.
> In case you are creating environment for the masterclass, then create a webhook in Bookings/ Coupons team channel

### Lab Setup

Before you start going through this lab it is important that you configure a set of organization secrets.[Here](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-an-organization) you have some instructions on how to create secrets at org level :

- `AZURE_CREDENTIALS` that should have the following format, where clientId is the `appId` field of the [Generate an Azure Service Principal](#generate-an-Azure-Service-Principal) output:
    ```json
    {
        "clientId": "<GUID>",
        "clientSecret": "<STRING>",
        "subscriptionId": "<GUID>",
        "tenantId": "<GUID>"
    }
    ```
- `SERVICEPRINCIPAL_PASSWORD`: password generated as part of the service principal creation.
- `SERVICE_PRINCIPAL_OBJECT_ID`: object id generated as part of the service principal creation.
- `SERVICE_PRINCIPAL_CLIENT_ID`: app id generated as part of the service principal creation.
- `MS_TEAMS_WEBHOOK_URI`: webhook URL of the incoming webhook that you just generated.
- `MYSQL_PASSWORD`: keep in mind that for this value the restrictions are:
    - Your password must be at least 8 characters in length and no more than 128 characters in length.
    - Your password must contain characters from three of the following categories – English uppercase letters, English lowercase letters, numbers (0-9), and non-alphanumeric characters (!, $, #, %, etc.).
    - Your password cannot contain all or part of the login name. (Part of a login name is defined as three or more consecutive alphanumeric characters.)
- `DEVOPS_WITH_GITHUB_PAT`: the GitHub PAT token you generated in the previous section.

Now that you have everything ready and the repository created from this template, go ahead and update the values o the `.github/variables/variables.json` file with your environment data:

```json
{
    "name": "prefix",
    "value": "<three-letters-prefix>" --> Note this value will be used to generate the name for the Azure resources
},
{
    "name": "subscriptionid",
    "value": "<azure-subscription-id>"
},
{
    "name": "repoName",
    "value": "<repo-name>"
}
```

With that you are ready to start your masterclass! 🚀

</details>

<details>

<summary>Attendees instructions</summary>

## 2. Attendees

Get ready for the bootcamp! If you are here everything you really need to do is go to the issues section of this repo and open an new issue using the template `Create copy of demo repository - [Template]`.

You can check the **[labs instructions](https://github.partners/devops.github.io/white-belt/labs/index.html)** 🚀

</details>
