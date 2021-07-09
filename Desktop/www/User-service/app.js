const express = require("express");
const route = require("./routes/route");
const cors = require('cors');

const app = express();

const whitelist = [
  "https://snapfile.tech",
  "https://staging.snapfile.tech",
  "https://api.snapfile.tech"
];

const corsOptions = {
  origin: function (origin, callback) {
    if (whitelist.includes(origin) || !origin) {
      callback(null, true)
    } else {
      callback(new Error('Not allowed by CORS'))
    }
  }
}

app.use(cors(corsOptions));
app.use(express.json());

// Routes
app.use((process.env.NODE_ENV === "development") ? "/user" : "/", route);

module.exports = app;
