import 'phoenix_html'
import {DateTime} from 'luxon'
import feather from 'feather-icons'
import Harmonium from './harmonium'
import LiveSocket from 'phoenix_live_view'
import {Socket} from 'phoenix'

/**
 * Updates <time> tags with a datetime attribute in ISO 8601 format to
 * display in the user's local time
 * @returns {void}
 */
function updateTimeTags() {
  const timeTags = document.querySelectorAll('time[datetime]')

  for (let i = 0; i < timeTags.length; i++) {
    const timeTag = timeTags[i]

    const timestamp = DateTime.fromISO(timeTag.getAttribute('datetime'), {
      zone: 'utc',
    })

    const localTimestamp = timestamp.toLocal()

    timeTag.textContent = localTimestamp.toLocaleString(DateTime.DATETIME_FULL)
  }
}

function setupLiveView() {
  const csrfTokenHeader = document.querySelector("meta[name='csrf-token']")
  if (csrfTokenHeader) {
    const csrfToken = csrfTokenHeader.getAttribute('content')
    const liveSocket = new LiveSocket('/live', Socket, {
      params: {_csrf_token: csrfToken},
    })

    // connect if there are any LiveViews on the page
    liveSocket.connect()

    // expose liveSocket on window for web console debug logs and latency simulation:
    // >> liveSocket.enableDebug()
    // >> liveSocket.enableLatencySim(1000)
    window.liveSocket = liveSocket
  }
}

function init(_config) {
  updateTimeTags()
  feather.replace()
  Harmonium.setup()
  setupLiveView()
}

document.addEventListener('DOMContentLoaded', () => {
  init()
})

export default {
  init,
}
