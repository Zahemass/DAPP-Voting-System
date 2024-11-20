const HDWalletProvider = require('@truffle/hdwallet-provider');
const mnemonic = "raise lady blood egg under tackle strategy derive key once huge mimic";
const alchemyApiKey = "iAj8ySyOJVAzx8YTLKD_KKK1_EkTdGOh"; // Replace with your Alchemy API key

module.exports = {
  networks: {
    sepolia: {
      provider: () => new HDWalletProvider({
        mnemonic: mnemonic,
        providerOrUrl: `https://eth-sepolia.g.alchemy.com/v2/${alchemyApiKey}`,
        timeoutSeconds: 1000 // Increase timeout if needed
      }),
      network_id: 11155111, // Sepolia network ID
      gas: 8000000, // Increase the gas limit to 8,000,000 units
      networkCheckTimeout: 600000,
    }
  },

  // Mocha testing framework settings
  mocha: {
    timeout: 100000
  },

  // Compiler settings
  compilers: {
    solc: {
      version: "0.8.0",      // Use a specific solc version
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  }
};
