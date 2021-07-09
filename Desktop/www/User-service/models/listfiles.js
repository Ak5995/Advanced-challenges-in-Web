const mongoose = require("mongoose");

//database model design
const listFilesSchema = new mongoose.Schema(
  {
    fileName: {
      type: String,
      required: [true, " A file must have a name"],
      trim: true
    },

    userId: {
      type: String,
      required: [true, "A user must have a user Id"],
      trim: true
    },

    fileId: {
      type: String,
      required: [true, "A file must have an Id"],
      unique: true,
      trim: true
    },

    uploadedDate: {
      type: String,
      unique: false
    }
  },
);


// creating a model
module.exports = mongoose.model("ListFiles", listFilesSchema);

// schema testing
//const testfiles = new Listfiles({
// filename: 'Test 1 development',
// userId: 'aj893756ncdhsjs',
// fileId: 'cnsdiaufhusu87623612'
//});

// saving the newly created document to check
//testfiles.save().then( doc =>{
// console.log(doc);
//}).catch( err => {
// console.log('ERROR:', err);
//});
