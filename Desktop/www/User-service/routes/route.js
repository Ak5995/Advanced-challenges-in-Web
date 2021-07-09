const express = require("express");
const controller = require("../controllers/controller");

const router = express.Router();

router
  .route("/get")
  .get(controller.getFile);

router
  .route("/add")
  .post(controller.saveFile);

router
  .route("/delete")
  .post(controller.deleteFile);

router
  .route("/dashboardDelete")
  .post(controller.dashboardDeleteFile)

module.exports = router;
