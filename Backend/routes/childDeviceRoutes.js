const express = require("express");
const router = express.Router();
const childDeviceController = require("../controllers/childDeviceController");

// POST /api/devices → registrar
router.post("/", childDeviceController.registerDevice);
router.get("/search/:code", childDeviceController.searchDevice);
router.delete("/delete/:code", childDeviceController.deleteDevice);

// GET /api/devices/:parentId → obtener dispositivos por usuario
//router.get("/:parentId", childDeviceController.getDevicesByUser);

module.exports = router;
