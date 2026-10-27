import React, { useState, useEffect } from 'react';
import './UsersList.css';
import axios from 'axios';

const API_URL = (import.meta.env.VITE_API_URL || 'http://localhost:5003').replace(/\/$/, '');

export default function UsersList() {
 const [users, setUsers] = useState([]);
 const [showModal, setShowModal] = useState(false);
 const [form, setForm] = useState({
  firstname: '',
  lastname: '',
  email: '',
  password: '',
  age: '',
  gender: 'Other',
 });

 useEffect(() => {
  const fetchUsers = async () => {
   try {
    const res = await axios.get(`${API_URL}/api/users/all-users`);
    setUsers(res.data.users);
   } catch (err) {
    console.error('Erreur lors du chargement des utilisateurs', err);
   }
  };

  fetchUsers();
 }, []);

 const deleteUser = async (id) => {
  if (!window.confirm("Are you sure you want to delete this user?")) return;

  try {
   await axios.delete(`${API_URL}/api/users/deleteAdherent/${id}`);
   setUsers(users.filter((user) => user._id !== id));
  } catch (err) {
   console.error('Erreur lors de la suppression:', err.message);
   alert("Échec de la suppression de l'utilisateur");
  }
 };

 const handleChange = (e) => {
  setForm({ ...form, [e.target.name]: e.target.value });
 };

 const handleSubmit = async (e) => {
  e.preventDefault();
  try {
   const res = await axios.post(`${API_URL}/api/users/register`, {
    firstname: form.firstname,
    lastname: form.lastname,
    email: form.email,
    password: form.password,
    age: parseInt(form.age),
    gender: form.gender
   });

   setUsers([...users, res.data]);
   setShowModal(false);
   setForm({
    firstname: '',
    lastname: '',
    email: '',
    password: '',
    age: '',
    gender: 'Other'
   });
  } catch (err) {
   console.error("Erreur lors de l'ajout:", err.response?.data || err.message);
   alert(err.response?.data || "Erreur lors de la création");
  }
 };

 return (
  <div className="users-page">
   <div className="users-header">
    <h1>👥 Users List</h1>
    <button onClick={() => setShowModal(true)} className="create-btn">+ Create New User</button>
   </div>

   <table className="users-table">
    <thead>
     <tr>
      <th>User ID</th>
      <th>First Name</th>
      <th>Last Name</th>
      <th>Email</th>
      <th>Role</th>
      <th>Actions</th>
     </tr>
    </thead>
    <tbody>
     {users.map((user) => (
      <tr key={user._id}>
       <td>{user._id}</td>
       <td>{user.firstname}</td>
       <td>{user.lastname}</td>
       <td>{user.email}</td>
       <td>{user.role}</td>
       <td>
        <button onClick={() => deleteUser(user._id)} className="delete-btn">Delete</button>
       </td>
      </tr>
     ))}
    </tbody>
   </table>

   {showModal && (
    <div className="floating-modal">
     <div className="modal">
      <h2>Create New User</h2>
      <form onSubmit={handleSubmit} className="user-form">
       <input
        type="text"
        name="firstname"
        placeholder="First Name"
        value={form.firstname}
        onChange={handleChange}
        required
       />
       <input
        type="text"
        name="lastname"
        placeholder="Last Name"
        value={form.lastname}
        onChange={handleChange}
        required
       />
       <input
        type="email"
        name="email"
        placeholder="Email"
        value={form.email}
        onChange={handleChange}
        required
       />
       <input
        type="password"
        name="password"
        placeholder="Password"
        value={form.password}
        onChange={handleChange}
        required
       />
       <input
        type="number"
        name="age"
        placeholder="Age"
        value={form.age}
        onChange={handleChange}
        required
       />
       <select name="gender" value={form.gender} onChange={handleChange}>
        <option value="Female">Female</option>
        <option value="Male">Male</option>
        <option value="Other">Other</option>
       </select>
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


