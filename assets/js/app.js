import 'phoenix_html'
import {DateTime} from 'luxon'

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

function init(_config) {
  updateTimeTags()
}

export default {
  init,
}
