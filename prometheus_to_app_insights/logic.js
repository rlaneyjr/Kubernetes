const axios = require('axios');
const appInsights = require('applicationinsights');

const url = process.env.PROMETHEUS_URL;
// const url = 'http://<ip:port>/metrics';
// const federateUrl = "http://<ip:port>/federate?match%5B%5D=%7Bjob%3D%22prometheus%22%7D";
let aiClient;

class Logic {
  constructor() {
    console.log('Setting up Application Insights client');
    // env var: 'APPINSIGHTS_INSTRUMENTATIONKEY', must be set.
    appInsights.setup().start();
    aiClient = appInsights.defaultClient;
  }

  extractLineValues(txt) {
    const re1 = '((?:[a-z][a-z0-9_]*))'; // Variable Name 1
    const re2 = '(\\{.*?\\})'; // Curly Braces 1
    const re3 = '.*?'; // Non-greedy match on filler
    const re4 = '(\\d+)'; // Integer Number 1
    const re5 = '.*?'; // Non-greedy match on filler
    const re6 = '(\\d+)'; // Integer Number 2
    const p = new RegExp(re1 + re2 + re3 + re4 + re5 + re6, ['i']);
    const m = p.exec(txt);
    if (m != null) {
      const metricName = m[1];
      const properties = m[2];
      const value = m[3];
      const epoch = m[4];

      const customProps = {};
      if (properties.length > 2) {
        try {
          const props = properties.substr(1, properties.length - 2);
          const tokens = props.split(',');
          tokens.forEach((token) => {
            const keyValue = token.split('=');
            customProps[keyValue[0]] = keyValue[1];
          });
        } catch (exc) {
          console.error(`failed parsing properties object: ${properties}`);
        }
      }

      return {
        metricName, customProps, value, epoch,
      };
    }
    return null;
  }

  // write to app insights
  writeToAppInsights(data) {
    aiClient.trackMetric(
      { name: data.metricName, value: parseInt(data.value, 10), properties: data.customProps }
    );
  }

  // federated line example :
  // process_cpu_seconds_total{instance="localhost:9090",job="prometheus"} 9.16 1532351490791
  async getMetrics() {
    return axios.get(url)
      .then(response => response.data)
      .catch((error) => {
        console.log(error);
        throw error;
      });
  }

  // Transforms to app insights format
  async processResults(values) {
    const lines = values.split(/\r?\n/);

    console.log('Writing data to AI');
    lines.forEach((line) => {
      const extractedValues = this.extractLineValues(line);
      if (extractedValues) {
        this.writeToAppInsights(extractedValues);
      }
    });
  }
}

module.exports = Logic;
