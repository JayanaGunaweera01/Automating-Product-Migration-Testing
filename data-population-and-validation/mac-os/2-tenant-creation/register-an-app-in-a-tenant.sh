#!/bin/bash

#curl -k --location --request POST "$APPLICATION_EP" \
#--header 'Access-Control-Allow-Origin: '$TENANT_URL'' \
#--header 'Accept: application/json' \
#--header 'Referer;' \
#--header 'Authorization: Basic aWl0QGlpdC5jb206aWl0MTIz' \
#--header 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36' \
#--header 'Content-Type: application/json' \
#--data-raw '{"name":"'$APP_NAME'","description":"Manually configure the inbound authentication protocol, authentication flow, etc.","templateId":"custom-application"}'



# set the server url
server_url=https://localhost:9443

# set the tenant domain
tenant_domain=iit@iit.com

# set the application name
application_name=MigrationApp

# Get the tenant Id 
tenant_id=$(curl -k -X GET -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46YWRtaW4=" ${server_url}/api/identity/user/v0.9/tenants?tenantDomain=${tenant_domain} | jq -r '.tenantId')

# create the service provider
curl -k -X POST -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46YWRtaW4=" -d "{
    \"applicationName\":\"${application_name}\",
    \"description\":\"Application for ${application_name}\",
    \"saasApp\":true,
    \"inboundProvisioningConfig\": {
    \"provisioningEnabled\": true,
    \"deprovisioningEnabled\": true,
    \"userstore\": \"PRIMARY\"
    },
    \"owner\": \"admin\",
    \"appOwner\":\"admin\",
    \"tenantId\":\"${tenant_id}\",
    \"permissionAndRoleConfig\":{
    \"roleMappings\":[]
    }
}" ${server_url}/api/identity/application/v1.0/service-providers

curl -X POST "https://localhost:9443/t/carbon.super/api/server/v1/applications" -H "accept: */*" -H "Authorization: Basic YWRtaW46YWRtaW4=" -H "Content-Type: application/json" -d "{\"name\":\"pickup\",\"description\":\"This is the configuration for Pickup application.\",\"imageUrl\":\"https://example.com/logo/my-logo.png\",\"accessUrl\":\"https://example.com/login\",\"templateId\":\"980b8tester24c64a8a09a0d80abf8c337bd2555\",\"isManagementApp\":false,\"claimConfiguration\":{\"dialect\":\"LOCAL\",\"claimMappings\":[{\"applicationClaim\":\"firstname\",\"localClaim\":{\"uri\":\"http://wso2.org/claims/username\"}}],\"requestedClaims\":[{\"claim\":{\"uri\":\"http://wso2.org/claims/username\"},\"mandatory\":false}],\"subject\":{\"claim\":{\"uri\":\"http://wso2.org/claims/username\"},\"includeUserDomain\":false,\"includeTenantDomain\":false,\"useMappedLocalSubject\":false},\"role\":{\"mappings\":[{\"localRole\":\"admin\",\"applicationRole\":\"Administrator\"}],\"includeUserDomain\":true,\"claim\":{\"uri\":\"http://wso2.org/claims/username\"}}},\"inboundProtocolConfiguration\":{\"saml\":{\"metadataFile\":\"Base64 encoded metadata file content\",\"metadataURL\":\"https://example.com/samlsso/meta\",\"manualConfiguration\":{\"issuer\":\"string\",\"serviceProviderQualifier\":\"string\",\"assertionConsumerUrls\":[\"string\"],\"defaultAssertionConsumerUrl\":\"string\",\"idpEntityIdAlias\":\"string\",\"singleSignOnProfile\":{\"bindings\":[\"HTTP_POST\"],\"enableSignatureValidationForArtifactBinding\":false,\"enableIdpInitiatedSingleSignOn\":false,\"assertion\":{\"nameIdFormat\":\"urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress\",\"audiences\":[\"https://app.example.com/saml\"],\"recipients\":[\"https://app.example.com/saml\"],\"digestAlgorithm\":\"http://www.w3.org/2000/09/xmldsig#sha1\",\"encryption\":{\"enabled\":false,\"assertionEncryptionAlgorithm\":\"string\",\"keyEncryptionAlgorithm\":\"string\"}}},\"attributeProfile\":{\"enabled\":false,\"alwaysIncludeAttributesInResponse\":false},\"singleLogoutProfile\":{\"enabled\":true,\"logoutRequestUrl\":\"string\",\"logoutResponseUrl\":\"string\",\"logoutMethod\":\"BACKCHANNEL\",\"idpInitiatedSingleLogout\":{\"enabled\":false,\"returnToUrls\":[\"string\"]}},\"requestValidation\":{\"enableSignatureValidation\":true,\"signatureValidationCertAlias\":\"string\"},\"responseSigning\":{\"enabled\":true,\"signingAlgorithm\":\"string\"},\"enableAssertionQueryProfile\":false}},\"oidc\":{\"clientId\":\"string\",\"clientSecret\":\"string\",\"grantTypes\":[\"authorization_code\",\"password\"],\"callbackURLs\":[\"regexp=(https://app.example.com/callback1|https://app.example.com/callback2)\"],\"allowedOrigins\":[\"https://app.example.com\"],\"publicClient\":false,\"pkce\":{\"mandatory\":false,\"supportPlainTransformAlgorithm\":true},\"accessToken\":{\"type\":\"JWT\",\"userAccessTokenExpiryInSeconds\":3600,\"applicationAccessTokenExpiryInSeconds\":3600,\"bindingType\":\"cookie\",\"revokeTokensWhenIDPSessionTerminated\":true,\"validateTokenBinding\":true},\"refreshToken\":{\"expiryInSeconds\":86400,\"renewRefreshToken\":true},\"idToken\":{\"expiryInSeconds\":3600,\"audience\":[\"http://idp.xyz.com\",\"http://idp.abc.com\"],\"encryption\":{\"enabled\":false,\"algorithm\":\"RSA-OAEP\",\"method\":\"A128CBC+HS256\"}},\"logout\":{\"backChannelLogoutUrl\":\"https://app.example.com/backchannel/callback\",\"frontChannelLogoutUrl\":\"https://app.example.com/frontchannel/callback\"},\"validateRequestObjectSignature\":false,\"scopeValidators\":[\"Role based scope validator\",\"XACML Scope Validator\"]},\"passiveSts\":{\"realm\":\"string\",\"replyTo\":\"string\"},\"wsTrust\":{\"audience\":\"https://wstrust.endpoint.com\",\"certificateAlias\":\"wso2carbon\"},\"custom\":[{\"name\":\"cas\",\"configName\":\"cas\",\"properties\":[{\"key\":\"app-identifier\",\"value\":\"http://app.wso2.com/employeeApp\",\"friendlyName\":\"Application Identifier\"}]}]},\"authenticationSequence\":{\"type\":\"DEFAULT\",\"steps\":[{\"id\":1,\"options\":[{\"idp\":\"LOCAL\",\"authenticator\":\"basic\"}]}],\"requestPathAuthenticators\":[\"string\"],\"script\":\"string\",\"subjectStepId\":1,\"attributeStepId\":1},\"advancedConfigurations\":{\"saas\":false,\"discoverableByEndUsers\":false,\"certificate\":{\"type\":\"string\",\"value\":\"string\"},\"skipLoginConsent\":false,\"skipLogoutConsent\":false,\"returnAuthenticatedIdpList\":false,\"enableAuthorization\":true,\"additionalSpProperties\":[{\"name\":\"isInternalApp\",\"value\":\"true\",\"displayName\":\"Internal Application\"}]},\"provisioningConfigurations\":{\"inboundProvisioning\":{\"proxyMode\":false,\"provisioningUserstoreDomain\":\"PRIMARY\"},\"outboundProvisioningIdps\":[{\"idp\":\"Google\",\"connector\":\"googleapps\",\"blocking\":false,\"rules\":false,\"jit\":false}]}}"

echo "Registered a service provider successfully"