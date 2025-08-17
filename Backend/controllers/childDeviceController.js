const Device = require("../models/ChildDevice");

// Registrar un dispositivo
exports.registerDevice = async (req, res) => {
  try {
    const { code, parentId, alias } = req.body;
    const device = new Device({ code, parentId, alias });
    await device.save();
    res.status(201).json(device);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Obtener dispositivos de un usuario
// exports.getDevicesByUser = async (req, res) => {
//   try {
//     const { parentId } = req.params;
//     const devices = await Device.find({ parentId });
//     res.json(devices);
//   } catch (error) {
//     res.status(500).json({ error: error.message });
//   }
// };
