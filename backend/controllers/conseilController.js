const Conseil = require('../models/conseilSchema');

exports.getAllAdvices = async (req, res) => {
 try {
  console.log(" Tentative de récupération des conseils...");
  const advices = await Conseil.find(); 
  console.log(" Conseils récupérés:", advices);
  res.status(200).json({ advices });
 } catch (err) {
  console.error(" Erreur getAllAdvices:", err); 
  res.status(500).json({ message: err.message });
 }
};


exports.addAdvice = async (req, res) => {
 const { goal, content } = req.body;
 console.log(" Reçu:", { goal, content });

 if (!goal || typeof content !== 'string' || content.trim() === '') {
  return res.status(400).json({ message: "Champ 'goal' ou 'content' invalide ou vide" });
 }

 try {
  let conseil = await Conseil.findOne({ goal });

  if (conseil) {
   conseil.advice.push(content);
   await conseil.save();
  } else {
   conseil = new Conseil({ goal, advice: [content] });
   await conseil.save();
  }

  res.status(201).json(conseil);
 } catch (err) {
  console.error(" Erreur addAdvice:", err);
  res.status(500).json({ message: err.message });
 }
};

exports.deleteAdvice = async (req, res) => {
 const { goal, index } = req.params;

 try {
  const conseil = await Conseil.findOne({ goal });
  if (!conseil) return res.status(404).json({ message: 'Conseil introuvable' });

  const parsedIndex = parseInt(index, 10);
  if (isNaN(parsedIndex) || parsedIndex < 0 || parsedIndex >= conseil.advice.length) {
   return res.status(400).json({ message: 'Index invalide' });
  }

  conseil.advice.splice(parsedIndex, 1);
  await conseil.save();

  res.status(200).json({ message: 'Conseil supprimé', conseil });
 } catch (err) {
  console.error("Erreur backend deleteAdvice:", err);
  res.status(500).json({ message: err.message });
 }
};
