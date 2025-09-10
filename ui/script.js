const RESOURCE = GetParentResourceName ? GetParentResourceName() : 'puffin-jobcenter'

const root = document.getElementById('jobcenter')
const jobListEl = document.getElementById('job-list')
const uiTitleEl = document.getElementById('ui-title')
const playerNameEl = document.getElementById('player-name')
const playerJobEl = document.getElementById('player-job')
const btnClose = document.getElementById('btn-close')

const normalizeColor = (hex) => {
  if (!hex) return '#FFB900'
  const c = hex.trim().replace(/^#/,'')
  return `#${c}`
}

const clampIfOverflow = (el) => {
  if (el.scrollHeight > el.clientHeight + 1) {
    el.classList.add('clamped')
  }
}

const createJobCard = (jobName, def) => {
  const color = normalizeColor(def.color || '#FFB900')
  const card = document.createElement('div')
  card.className = 'job'
  const img = document.createElement('img')
  img.className = 'job-img'
  img.alt = def.title || jobName
  img.src = def.image || 'images/placeholder.png'
  const box = document.createElement('div')
  box.className = 'job-box'
  const title = document.createElement('p')
  title.className = 'job-title'
  title.textContent = def.title || jobName
  title.style.color = color
  const desc = document.createElement('p')
  desc.className = 'job-description'
  desc.textContent = def.description || ''
  const btn = document.createElement('button')
  btn.className = 'job-button'
  btn.textContent = def.setJob ? 'Start Job' : 'Mark Location'
  btn.style.setProperty('--btn-color', color)
  btn.style.setProperty('--btn-text', '#121214')
  btn.addEventListener('click', () => {
    fetch(`https://${RESOURCE}/puffin:jobcenter:selectJob`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify({
        action: 'puffin:jobcenter:selectJob',
        job: jobName,
        title: def.title || jobName,
        setJob: !!def.setJob
      })
    }).catch(() => {})
  })
  box.appendChild(title)
  box.appendChild(desc)
  box.appendChild(btn)
  card.appendChild(img)
  card.appendChild(box)
  requestAnimationFrame(() => clampIfOverflow(desc))
  return card
}

const renderJobs = (config) => {
  jobListEl.innerHTML = ''
  const jobs = (config && config.Jobs) || {}
  for (const [name, def] of Object.entries(jobs)) {
    jobListEl.appendChild(createJobCard(name, def))
  }
}

const openUI = () => {
  root.style.display = 'block'
  document.body.style.overflow = 'hidden'
}

const closeUI = () => {
  root.style.display = 'none';
  document.body.style.overflow = '';
  fetch(`https://${RESOURCE}/puffin:jobcenter:close`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify({})
  }).catch(() => {});
};

document.addEventListener('keyup', (e) => {
  if (e.key === 'Escape') {
    closeUI();
  }
});

btnClose.addEventListener('click', closeUI)

window.addEventListener('message', (event) => {
  const data = event.data || {}
  if (data.action === 'open') {
    const payload = data.payload || {}
    const config = payload.config || {}
    const player = payload.player || {}
    if (config.Title) uiTitleEl.textContent = config.Title
    if (player.name) playerNameEl.textContent = player.name
    if (player.currentJob) playerJobEl.textContent = player.currentJob
    renderJobs(config)
    openUI()
  } else if (data.action === 'close') {
    closeUI()
  }
})
