import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import MenuPrincipal from './pages/Main/menuPrincipal.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <MenuPrincipal />
  </StrictMode>,
)
