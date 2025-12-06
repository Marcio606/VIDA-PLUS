const API_BASE = 'http://127.0.0.1:5000/api';

document.getElementById('nav-login').onclick = () => show('view-login');
document.getElementById('nav-cad').onclick = () => show('view-cad');
document.getElementById('nav-agend').onclick = () => show('view-agend');
document.getElementById('nav-list').onclick = () => { show('view-list'); fetchPacientes(); };

function show(id){
  document.querySelectorAll('.view').forEach(v => v.classList.add('hidden'));
  document.getElementById(id).classList.remove('hidden');
}

document.getElementById('form-paciente').onsubmit = async (e) => {
  e.preventDefault();
  const data = Object.fromEntries(new FormData(e.target).entries());
  const res = await fetch(API_BASE + '/pacientes/', {
    method: 'POST', headers: {'Content-Type':'application/json'}, body: JSON.stringify(data)
  });
  const json = await res.json();
  document.getElementById('cad-result').innerText = JSON.stringify(json, null, 2);
};

document.getElementById('form-agendamento').onsubmit = async (e) => {
  e.preventDefault();
  const data = Object.fromEntries(new FormData(e.target).entries());
  const res = await fetch(API_BASE + '/consultas/', {
    method: 'POST', headers: {'Content-Type':'application/json'}, body: JSON.stringify(data)
  });
  const json = await res.json();
  document.getElementById('agend-result').innerText = JSON.stringify(json, null, 2);
};

async function fetchPacientes(){
  const res = await fetch(API_BASE + '/pacientes/');
  const list = await res.json();
  const ul = document.getElementById('pacientes-list');
  ul.innerHTML = '';
  list.forEach(p => {
    const li = document.createElement('li');
    li.innerText = `${p.id} — ${p.nome} — ${p.cpf} — ${p.email || '-'} `;
    ul.appendChild(li);
  });
}

// inicial
show('view-login');
