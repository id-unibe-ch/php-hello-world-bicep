targetScope = 'subscription'

@description('The name of the identity resource group')
param identityResourceGroupName string

@description('The name of the location where the resources will be deployed')
param location string

@description('The id of the role definition, which the new identity will be assigned on the subscription level')
param roleDefinitionId string

@description('The name of the GitHub repository')
param githubRepository string

var tags = {
  division: 'id'
  subDivision: 'idci'
  environment: 'prod'
  managedBy: 'bicep'
}

resource identityResourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: identityResourceGroupName
  location: location
  tags: tags
}

module identity 'identity.bicep' = {
  name: 'identityModule'
  params: {
    githubRepository: githubRepository
    tags: tags
  }
  scope: identityResourceGroup
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: subscription()
  name: guid(subscription().id, roleDefinitionId, identityResourceGroup.id)
  properties: {
    principalId: identity.outputs.principalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
  }
}

output clientId string = identity.outputs.clientId
output subscriptionId string = subscription().subscriptionId
output tenantId string = subscription().tenantId
