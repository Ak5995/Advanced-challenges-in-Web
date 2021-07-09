const fileModel = require("./../models/listfiles");
const axios = require("axios");
const admin = require("firebase-admin");

//1. list files uploaded by users
exports.getFile = async (req, res) => {
  const idToken = req.headers.authorization?.split(" ")[1];

  if (!idToken) {
    res.sendStatus(401);
    return;
  }

  try {
    const { uid } = await admin.auth().verifyIdToken(idToken);

    const userFile = await fileModel.find({ userId: uid });

    res.status(200).json({
      status: "success",
      data: {
        userFile,
      },
    });
  } catch (err) {
    res.status(500).json({
      status: "fail",
      message: err,
    });
  }
};

//2. Save a new file uploaded by user(from upload-delete service)
exports.saveFile = async (req, res) => {
  const { userIdToken, ...data } = req.body.data;

  if (!userIdToken) {
    res.sendStatus(401);
    return;
  }

  try {

    const { uid } = await admin.auth().verifyIdToken(userIdToken);

    const newFile = await fileModel.create({
      ...data,
      userId: uid,
    });

    res.status(201).json({
      status: "success",
      data: {
        newFile,
      },
    });
  } catch (err) {
    console.log(err);
    res.status(500).json({
      status: "fail",
      message: err,
    });
  }
};

//3. Internal delete requests
exports.deleteFile = async (req, res) => {
  try {
    const { fileIds } = req.body.data;

    await fileModel.deleteMany({ fileId: { $in: fileIds } });

    res.sendStatus(200);
  } catch (err) {
    res.status(500).json({ err });
  }
};

// 4. Delete requests from dashboard
exports.dashboardDeleteFile = async (req, res) => {
  const idToken = req.headers.authorization?.split(" ")[1];

  if (!idToken) {
    res.sendStatus(401);
    return;
  }

  try {
    const { uid } = await admin.auth().verifyIdToken(idToken);

    const { fileIds: reqFileIds } = req.body.data;

    // User can only delete their own files
    const filesToBeDeleted = await fileModel.find(
      { fileId: { $in: reqFileIds }, userId: uid },
      "fileId"
    );

    const fileIds = filesToBeDeleted.map(({ fileId }) => fileId);

    const metaDelete = axios.post(process.env.URL_META + "delete", { data: { fileIds } });

    const dudDelete = axios.post(process.env.URL_DUD + "delete", { data: { fileIds } });

    const localDelete = fileModel.deleteMany({ fileId: { $in: fileIds } });

    await Promise.all([
      metaDelete, dudDelete, localDelete
    ]);

    res.sendStatus(200);
  } catch (err) {
    console.log(err);
    res.status(500).json({ err });
  }
};
