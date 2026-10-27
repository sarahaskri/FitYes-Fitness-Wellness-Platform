const express = require('express');
const router = express.Router();
const adviceController = require('../controllers/conseilController');

router.get('/', adviceController.getAllAdvices);
router.post('/', adviceController.addAdvice);
router.delete('/:goal/:index', adviceController.deleteAdvice);

module.exports = router;
