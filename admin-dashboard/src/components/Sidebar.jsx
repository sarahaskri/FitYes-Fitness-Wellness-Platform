import React from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import { FiHome, FiUser, FiSettings, FiLogOut } from 'react-icons/fi';
import './Sidebar.css';

export default function Sidebar() {
 const navigate = useNavigate();

 const logout = () => {
  navigate('/');
 };

 return (
  <div className="sidebar">
   <div className="sidebar-top">
    <h2 className="sidebar-title">Dashboard</h2>
    <nav className="nav-links">
     <NavLink
      to="/dashboard/dashboard-stats"
      end
      className={({ isActive }) => isActive ? 'nav-link active' : 'nav-link'}
     >
      <FiHome className="icon" />
      Statistics
     </NavLink>

     <NavLink
      to="/dashboard/users"
      end
      className={({ isActive }) => isActive ? 'nav-link active' : 'nav-link'}
     >
      <FiUser className="icon" />
      Users List
     </NavLink>

     <NavLink
      to="/dashboard/advices"
      end
      className={({ isActive }) => isActive ? 'nav-link active' : 'nav-link'}
     >
      <FiSettings className="icon" />
      Advices
     </NavLink>
    </nav>
   </div>

   <div className="logout-wrapper">
    <button onClick={logout} className="logout-btn">
     <FiLogOut className="icon" />
     Logout
    </button>
   </div>
  </div>
 );
}
