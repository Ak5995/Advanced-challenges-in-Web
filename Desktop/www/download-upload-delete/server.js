const mongoose = require('mongoose');

require('dotenv').config();

const app = require('./app');

const DB = process.env.DATABASE.replace(
  '<password>',
  process.env.DATABASE_PASSWORD,
);

mongoose
  .connect(DB, {
    useNewUrlParser: true,
    useCreateIndex: true,
    useFindAndModify: false,
    useUnifiedTopology: true,
  })
  .then(() => console.log('Connected to MongoDB Atlas.'));

const port = process.env.PORT || 4000;
app.listen(port, () => {
  console.log(`App running on port ${port}...`);
});
