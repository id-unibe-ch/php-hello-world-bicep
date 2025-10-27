targetScope = 'subscription'

// The main bicep module to provision Azure resources.
// For a more complete walkthrough to understand how this file works with azd,
// see https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/make-azd-compatible?pivots=azd-create

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@maxLength(64)
@description('Name of the service.')
param serviceName string = 'php-hello-mr'


@minLength(1)
@maxLength(64)
@description('Primary location for all resources, taken for the deployment location by default.')
param location string = deployment().location

@description('Enable telemetry for resources that support it.')
param enableTelemetry bool = false

param resourceGroupName string = 'rg-${serviceName}-${environmentName}'
param appServicePlanName string = 'asp-${serviceName}-${environmentName}'
param appServiceName string = 'app-${serviceName}-${environmentName}'
// param logAnalyticsName string = ''
// param applicationInsightsDashboardName string = ''
// param applicationInsightsName string = ''


// tags that should be applied to all resources.
var tags = {
  // Tag all resources with the environment name.
  Division: 'id'
  SubDivision: 'idci'
  Environment: 'Non-Prod'
  ManagedBy: 'bicep'
}

// Add resources to be provisioned below.
// Organize resources in a resource group
// module resourceGroup 'br/public:avm/res/resources/resource-group:0.4.2' = {
//   name: 'resourceGroupDeployment'
//   params: {
//     // Required parameters
//     name: resourceGroupName
//     // Non-required parameters
//     tags: union(tags, {
//      'hidden-title': 'This is visible in the resource name'
//       Role: 'DeploymentValidation'
//     })
//     enableTelemetry: enableTelemetry
//   }
// }

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags: union(tags, {
    'hidden-title': 'Can be deleted after deployment'
    Role: 'DeploymentValidation'
  })
}

module servicePlan 'br/public:avm/res/web/serverfarm:0.5.0' = {
  scope: resourceGroup
  name: 'serverfarmDeployment'
  params: {
    name: appServicePlanName
    skuName: 'F1'
    skuCapacity: 1
    kind: 'linux'
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module webApp 'br/public:avm/res/web/site:0.19.3' = {
  scope: resourceGroup
  name: 'phpWebApp'
  params: {
    name: appServiceName
    // location: resourceGroup.location
    serverFarmResourceId: servicePlan.outputs.resourceId
    kind: 'app,linux'
    siteConfig: {
      linuxFxVersion: 'php|8.3' // Latest supported PHP version
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
    }
    publicNetworkAccess: 'Disabled'
    httpsOnly: true
    enableTelemetry: enableTelemetry
  }
}
// Add outputs from the deployment here, if needed.
//
// This allows the outputs to be referenced by other bicep deployments in the deployment pipeline,
// or by the local machine as a way to reference created resources in Azure for local development.
// Secrets should not be added here.
//
// Outputs are automatically saved in the local azd environment .env file.
// To see these outputs, run `azd env get-values`,  or `azd env get-values --output json` for json output.

// App outputs
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output AZURE_SUBSCRIPTION_ID string = subscription().subscriptionId
output AZURE_RESOURCE_GROUP string = resourceGroup.name
output AZURE_APP_SERVICE_PLAN string = servicePlan.outputs.name
