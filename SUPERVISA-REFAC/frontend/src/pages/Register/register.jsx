import { useState } from 'react'
import './Register.css'
import { useNavigate } from 'react-router-dom'


() => {
  const [erro, setErro] = useState('');
  const [email,setEmail] = useState('');
  const [senha,setSenha] = useState('');
  const [confirmSenha,setConfirmSenha] = useState('');
  const [nome, setNome] = useState('');
  const [sobrenome, setSobrenome] = useState('');
  const nomeCompleto = nome + sobrenome;
  const [dataNascimento, setDataNascimento] = useState('');

  return (
    <div className="Register">
  <h1>Cadastro</h1>
      <input type="text" placeholder="Nome" value={nome} onChange={(event) => setNome(event.target.value)} />

      <input type="text" placeholder="Sobrenome" value={sobrenome} onChange={(event) => setSobrenome(event.target.value)} />

      <input type="text" placeholder="Email" value={email} onChange={(event) => setEmail(event.target.value)} />
      
      <input type="text" placeholder="Senha" value={senha} onChange={(event) => {
        setSenha(event.target.value)
        if (!validaTamanhoSenha(event.target.value)) {
          setErro('A senha deve ter no mínimo 8 caracteres');
          return erro;
        } else {
          (setErro(''));
          return erro;
        }
      }} />

      <input type="text" placeholder="Confirmar Senha" value={confirmSenha} onChange={(event) => {
        setConfirmSenha(event.target.value)
        if (!validaConfirmaSenha(senha, event.target.value)) {
          setErro('As senhas não coincidem');
          return erro;
        } else {
          (setErro(''));
          return erro;
        }
      }} />

      <input type="date" placeholder="Data de Nascimento" value={dataNascimento} onChange={(event) => {
        setDataNascimento(event.target.value);
        descobreIdade(event.target.value);
        if (descobreIdade(event.target.value) < 18) {
          setErro('É necessário ser maior de 18 anos para se cadastrar');
          return erro;
        } else {
          (setErro(''));
          return erro;
        }
      } } />
</div>
  )
}

function validaTamanhoSenha(senha) {
  return(senha.length >= 8)
}
function validaConfirmaSenha(senha, confirmSenha) {
  return(senha === confirmSenha)
}
function descobreIdade(dataNascimento) {
  const dataAtual = new Date();
  const dataNascimentoObj = new Date(dataNascimento);
  let idade = dataAtual.getFullYear() - dataNascimentoObj.getFullYear();
  const mesNascimento = dataNascimentoObj.getMonth();
  if (dataAtual.getMonth() < mesNascimento || (dataAtual.getMonth() === mesNascimento && dataAtual.getDate() < dataNascimentoObj.getDate())) {
    idade--;
  } return idade;
}