const express = require('express');
const app = express();

console.log("process.env.testENV => ", process.env.TESTENV);

// Set the port the server will listen on
let PORT = process.env.PORT || 3000;

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

console.log("PORT", PORT);
console.log("PORT TYPE ", typeof PORT);
console.log("PORT TYPE CONVERTED", typeof Number(PORT));

console.log("TESTENV  ", process.env.TESTENV);

let portNumber = Number(PORT);
// Start the server
app.listen(portNumber, () => {
  console.log(`Server is running on http://localhost:${portNumber}`);
});
