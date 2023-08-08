# Abbey Starter Kit Azure Example

This starter kit is an example for how to use Abbey Labs and set up a Grant Kit for an Azure group and member. By the end, you’ll be able 
- Create an Azure group
- Configure an Abbey grant kit and attach it to an Azure resource
- Add an Azure user to a group with time-based expiry
- Approve/Revoke access to an Azure resource


## Setup
### Make a copy of the repo
Clone a copy of this repo into your own account


### Azure setup
[Install & configure the azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli). On Mac:
```
brew update && brew install azure-cli
az login
```

### Configure Github Actions with Azure
This repo uses Azure in the Github Actions job when generating terraform resources. First, we'll need to create a set of credentials for use by Github via:
```
az ad sp create-for-rbac --name "myApp" --role contributor \
                            --scopes /subscriptions/{subscription-id} \
                            --sdk-auth
```

The command should output a JSON object similar to this:
```
  {
    "clientId": "<GUID>",
    "clientSecret": "<GUID>",
    "subscriptionId": "<GUID>",
    "tenantId": "<GUID>",
    (...)
  }
```

Save this output, you'll need it in the next step. 

*See [Configure azure credentials as secrets](https://github.com/marketplace/actions/azure-cli-action#configure-azure-credentials-as-github-secret) for more help*

Next, add repository secrets so GithubActions can access these credentials. You'll add the following:
1. `AZURE_CLIENT_ID`
2. `AZURE_CLIENT_SECRET`
3. `AZURE_SUBSCRIPTION_ID`
4. `AZURE_TENANT_ID`

You can do this via `github repo page -> Settings -> Secrets and Variables -> Actions -> New Repository Secret` and create with the above names. You can take the values from the JSON output of the `az ad sp` command.


### Configure terraform file
Navigate to `main.tf`. 

Let's configure an Abbey identity for our Azure user first. You'll see a resource block
```
resource "abbey_identity" "dev_user" {
  abbey_account = "replace-me@example.com" #CHANGEME
  source = "pagerduty"
  metadata = jsonencode(
    {
      upn = "replace-me-EXT-MICROSOFT_UPN@example.com" #CHANGEME
    }
  )
}
```

1. Replace the `abbey_acount` email with the email address you used to create an Abbey account. 
2. Replace the upn field with the User principal name from the Azure console of the user you want to test with


## Usage
At this point, Azure specific set up is complete and you can continue instructions in our [starter kit docs](https://docs.abbey.io/getting-started/quickstart#step-2-configure-github).

When you create a request for access and approve it, you'll be able to see that the newly created group in the Azure console will now have a new member in it.

Once the access is revoked, the user will be removed from the group.

## :books: Learn More

To learn more about Grant Kits and Grant Workflows, visit the following resources:

-   [Abbey Labs Documentation](https://docs.abbey.io) - learn about automating access management with Abbey Labs.
