import React, { useState } from 'react';
import axios from 'axios';
import './Login.css';
import { FiEye, FiEyeOff } from 'react-icons/fi';
import { useNavigate } from 'react-router-dom';

const API_URL = (import.meta.env.VITE_API_URL || 'http://localhost:5003').replace(/\/$/, '');

export default function Login() {
 const [email, setEmail] = useState('');
 const [password, setPassword] = useState('');
 const [showPassword, setShowPassword] = useState(false);
 const [error, setError] = useState('');
 const [loading, setLoading] = useState(false);
 const navigate = useNavigate();

 const handleSubmit = async (event) => {
  event.preventDefault();
  setError('');
  setLoading(true);

  try {
   const { data } = await axios.post(`${API_URL}/api/users/login`, { email, password });
   if (data.user_role !== 'admin') {
    setError('Ce compte ne possède pas les droits administrateur.');
    return;
   }
   localStorage.setItem('fityes-admin-token', data.token);
   navigate('/dashboard');
  } catch (requestError) {
   setError(requestError.response?.data?.message || 'Connexion impossible. Vérifiez le serveur et vos identifiants.');
  } finally {
   setLoading(false);
  }
 };

 return (
  <div className="login-container">
   <form className="login-card" onSubmit={handleSubmit}>
    <h2 className="login-title">FitYes Administration</h2>
    <input
     type="email"
     placeholder="Email"
     className="login-input"
     value={email}
     onChange={(event) => setEmail(event.target.value)}
     autoComplete="username"
     required
    />
    <div className="password-wrapper">
     <input
      type={showPassword ? 'text' : 'password'}
      placeholder="Mot de passe"
      className="login-input"
      value={password}
      onChange={(event) => setPassword(event.target.value)}
      autoComplete="current-password"
      required
     />
     <button type="button" className="eye-icon" aria-label={showPassword ? 'Masquer le mot de passe' : 'Afficher le mot de passe'} onClick={() => setShowPassword((visible) => !visible)}>
      {showPassword ? <FiEyeOff /> : <FiEye />}
     </button>
    </div>
    {error && <p role="alert" style={{ color: 'red', marginBottom: '1rem' }}>{error}</p>}
    <button type="submit" className="login-button" disabled={loading}>
     {loading ? 'Connexion…' : 'Se connecter'}
    </button>
   </form>
  </div>
 );
}
