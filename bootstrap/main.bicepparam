using './main.bicep'

// Name of the resource group for the identity
param identityResourceGroupName = 'rg-php-hello-world-identities-switzerlandnorth-001'

// Location for the resources
param location = 'switzerlandnorth'

// The role id for the service principal
// Default id for the 'Unibe-Application-Owner (mg-unibe)' role
param roleDefinitionId = '72da8d0e-bcb9-56fc-b117-8919c5c6a40b'

// Name of the GitHub repository
param githubRepository = 'id-unibe-ch/php-hello-world-bicep'
