

function exit() {
  if (window.confirm("Deseja realmente sair?")) {
    window.close();
  }
}

function reload() {
   window.location.reload();
}

function goBack(navigate,previeWindow) {
  navigate(previeWindow);
}
export { exit, reload, goBack }