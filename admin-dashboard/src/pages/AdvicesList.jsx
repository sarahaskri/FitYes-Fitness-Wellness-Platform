import React, { useState, useEffect } from 'react';
import './AdvicesList.css';
import axios from 'axios';

const API_URL = (import.meta.env.VITE_API_URL || 'http://localhost:5003').replace(/\/$/, '');

export default function AdvicesList() {
 const [advices, setAdvices] = useState([]);
 const [showModal, setShowModal] = useState(false);
 const [form, setForm] = useState({
  type: 'Lose Weight',
  content: '',
 });
 const [message, setMessage] = useState(null);

 const fetchAdvices = async () => {
  try {
   const res = await axios.get(`${API_URL}/api/advices`);
   const all = [];

   res.data.advices.forEach((item) => {
    item.advice.forEach((text, i) => {
     all.push({ goal: item.goal, content: text, index: i });
    });
   });

   setAdvices(all);
  } catch (err) {
   console.error('Erreur chargement conseils', err);
  }
 };

 useEffect(() => {
  fetchAdvices();
 }, []);

 const deleteAdvice = async (goal, index) => {
  if (!window.confirm("Do you want to delete this advice ?")) return;

  try {
   await axios.delete(`${API_URL}/api/advices/${goal}/${index}`);
   setMessage("Conseil supprimé avec succès");
   fetchAdvices();
  } catch (err) {
   console.error('Erreur suppression conseil', err.message);
   setMessage(" Erreur lors de la suppression");
  }
 };

 const handleChange = (e) => {
  setForm({ ...form, [e.target.name]: e.target.value });
 };

 const handleSubmit = async (e) => {
  e.preventDefault();

  try {
   await axios.post(`${API_URL}/api/advices`, {
    goal: form.type.toLowerCase(),
    content: form.content,
   });

   setMessage(" Conseil ajouté avec succès");
   fetchAdvices();
   setShowModal(false);
   setForm({ type: 'Lose Weight', content: '' });
  } catch (err) {
   console.error('Erreur ajout conseil', err.message);
   setMessage(" Erreur lors de l'ajout");
  }
 };

 const readableGoal = (goal) => {
  switch (goal) {
   case 'lose weight': return 'Lose Weight';
   case 'gain weight': return 'Gain Weight';
   case 'build muscle': return 'Build Muscle';
   default: return goal;
  }
 };

 return (
  <div className="advice-page">
   <div className="advice-header">
    <h1>💡 Advices</h1>
    <button onClick={() => setShowModal(true)} className="create-btn">+ Add Advice</button>
   </div>

   {message && <div className="info-message">{message}</div>}

   <table className="advice-table">
    <thead>
     <tr>
      <th>Type</th>
      <th>Advice</th>
      <th>Actions</th>
     </tr>
    </thead>
    <tbody>
     {advices.map((advice, idx) => (
      <tr key={idx}>
       <td>{readableGoal(advice.goal)}</td>
       <td>{advice.content}</td>
       <td>
        <button
         onClick={() => deleteAdvice(advice.goal, advice.index)}
         className="delete-btn"
        >
         Delete
        </button>
       </td>
      </tr>
     ))}
    </tbody>
   </table>

   {showModal && (
    <div className="floating-modal">
     <div className="modal">
      <h2>Create New Advice</h2>
      <form onSubmit={handleSubmit} className="advice-form">
       <select name="type" value={form.type} onChange={handleChange}>
        <option value="Lose Weight">Lose Weight</option>
        <option value="Gain Weight">Gain Weight</option>
        <option value="Build Muscle">Build Muscle</option>
       </select>
       <textarea
        name="content"
        rows="5"
        placeholder="Write your advice here..."
        value={form.content}
        onChange={handleChange}
        required
       />
       <div className="form-actions">
        <button type="submit" className="create-btn">Create</button>
        <button type="button" onClick={() => setShowModal(false)} className="cancel-btn">Cancel</button>
       </div>
      </form>
     </div>
    </div>
   )}
  </div>
 );
}


