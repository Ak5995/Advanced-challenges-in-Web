require("dotenv").config();

const mongoose = require("mongoose");
const app = require("./app");
const admin = require("firebase-admin");

// password to connect with mongodb ATLAS refer to config.env
const DB = process.env.DATABASE.replace(
  "<password>",
  process.env.DATABASE_PASSWORD
);

// just in here for good practice
mongoose
  .connect(DB, {
    useNewUrlParser: true,
    useCreateIndex: true,
    useFindAndModify: false,
    useUnifiedTopology: true,
  })
  .then(() => console.log("DB connection successful"));

const buff = Buffer.from(process.env.FIREBASE_CREDENTIALS, "base64");
const serviceAccount = JSON.parse(buff.toString());

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const port = process.env.PORT || 4001;

app.listen(port, () => {
  console.log(`app running on port ${port}...`);
});
