const express = require('express');
const controller = require('./controller');
const router = require('./route');
const path = require('path');
const app = express();
const cors = require('cors');

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
// ---- This Part is NOT needed for upload/download ----
if (process.env.NODE_ENV === "development") {
  //Setting up temporary Frontend using EJS
  app.set('view engine', 'ejs');
  app.set('views', path.resolve(__dirname, 'views'));
  app.use(express.static(path.resolve(__dirname, 'public')));
  app.use(express.urlencoded({ extended: false }));

  app.get('/', controller.pageRendering);
  app.get('/dud/returnurl/:id', controller.buttonReturnUrlFunc);
  app.post('/dud/delete/:id', controller.buttonDeleteFunc);
// -----------------------------------------------------
}

app.use((process.env.NODE_ENV === 'development') ? '/dud' : '/', router);

module.exports = app;
