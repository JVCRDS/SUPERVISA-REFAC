
import './MenuPrincipal.css'
import { useNavigate } from 'react-router-dom'
import exit from 'exit'


function MenuPrincipal() {
  const navigate = useNavigate();
  return (

    <div className="Menu">
      <h1>Menu Principal</h1>
      <button onClick={() => {
        navigate('/login');
      }}>Entrar</button>
      
      <button onClick={() => {
        navigate('/register');
      }}>Cadastrar</button>
      
      <button onClick={() => { 
        navigate('/passrec');
      }}>Esqueci minha senha</button>

      <button onClick={() => {
        exit();
      }}>Sair</button>
    </div> 
      
  )
}

export default MenuPrincipal
