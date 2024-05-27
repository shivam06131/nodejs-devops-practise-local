const express = require('express');
const app = express();

console.log("process.env.testENV => ", process.env.TESTENV);

// Set the port the server will listen on
let PORT = process.env.PORT || 3000;
PORT = Number(PORT);

// Define a simple GET route
app.get('/env', (req, res) => {
  console.log(process.env);
  let resData = {
    port: PORT,
    testENV: process.env.TESTENV,
    message : "THIS IS THE UPDATED REPSOSNE !!!"
  }

  console.log("resData => ", resData);
  res.send(resData)
});



// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
