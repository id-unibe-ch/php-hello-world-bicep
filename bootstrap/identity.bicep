param githubRepository string
param tags object

module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: 'userAssignedIdentityDeployment'
  params: {
    name: 'id-appdeployidentity-prod-switzerlandnorth-001'
    federatedIdentityCredentials: [
  {
    audiences: [
      'api://AzureADTokenExchange'
    ]
    issuer: 'https://token.actions.githubusercontent.com'
    name: 'github-deploy'
    subject: 'repo:${githubRepository}'
  }
]

    location: resourceGroup().location
    tags: tags
  }
}

output principalId string = userAssignedIdentity.outputs.principalId
output clientId string = userAssignedIdentity.outputs.clientId
