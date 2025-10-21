param githubRepository string
param tags object

module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: 'userAssignedIdentityDeployment'
  params: {
    name: 'id-php-hello-hello-gh-deployment'
    federatedIdentityCredentials: [
      {
        audiences: [
          'api://AzureADTokenExchange'
        ]
        issuer: 'https://token.actions.githubusercontent.com'
        name: 'fcred-php-hello-world-gh-branch-main'
        subject: 'repo:${githubRepository}:ref:refs/heads/main'
      }, {
        audiences: [
          'api://AzureADTokenExchange'
        ]
        issuer: 'https://token.actions.githubusercontent.com'
        name: 'fcred-php-hello-world-gh-pr'
        subject: 'repo:${githubRepository}:pull_request'
      }
    ]

    location: resourceGroup().location
    tags: tags
  }
}

output principalId string = userAssignedIdentity.outputs.principalId
output clientId string = userAssignedIdentity.outputs.clientId
