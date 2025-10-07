const { ConfidentialClientApplication } = require('@azure/msal-node');
const { Client } = require('@microsoft/microsoft-graph-client');

const msalConfig = {
  auth: {
    clientId: process.env.AZURE_CLIENT_ID,
    clientSecret: process.env.AZURE_CLIENT_SECRET,
    authority: `https://login.microsoftonline.com/${process.env.AZURE_TENANT_ID}`
  }
};

const msalInstance = new ConfidentialClientApplication(msalConfig);

const getAccessToken = async () => {
  try {
    const clientCredentialRequest = {
      scopes: ['https://graph.microsoft.com/.default'],
    };

    const response = await msalInstance.acquireTokenByClientCredential(clientCredentialRequest);
    return response.accessToken;
  } catch (error) {
    console.error('Error acquiring token:', error);
    throw error;
  }
};

const getGraphClient = async () => {
  try {
    const accessToken = await getAccessToken();
    return Client.init({
      authProvider: (done) => {
        done(null, accessToken);
      }
    });
  } catch (error) {
    console.error('Error creating Graph client:', error);
    throw error;
  }
};

module.exports = {
  msalInstance,
  getAccessToken,
  getGraphClient
};