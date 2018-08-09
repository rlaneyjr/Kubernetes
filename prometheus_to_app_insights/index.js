const express = require('express');
const cron = require('node-cron');
const Logic = require('./logic');

const app = express();

// This is the stub for our node.js based service which query promethus,
// transforms the data and sends its to AppInsights
app.get('/', (req, res) => res.send('Service is running!'));
app.listen(3000, () => console.log('Listening on port 3000!'));

const logic = new Logic();

console.log('Scheduled the task to run every minute');
cron.schedule('* * * * *', async () => {
  console.log('running scheduled task');
  const res = await logic.getMetrics();
  console.debug(`data length is :${res.length}`);
  await logic.processResults(res);
  console.log('done');
});
