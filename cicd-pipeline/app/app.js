const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.json({message: 'Hello from CI/CD demo!'});
});

app.get('/health', (req, res) => {
  res.json({status: 'ok'});
});

app.listen(port, () => {
  console.log(`App listening at http://0.0.0.0:${port}`);
});
