const expect = require('chai').expect
const {JSDOM} = require('jsdom')

import App from '../js/app'

describe('App', () => {
  describe('init', () => {
    it('updates times', () => {
      const timeTagHTML = `
      <time datetime="2018-12-06T22:56:17Z" title="2018-12-06T22:56:17Z">2018-12-06T22:56:17Z</time>
      `

      const jsdom = new JSDOM(timeTagHTML)

      const {window} = jsdom
      const {document} = window

      global.window = window
      global.document = document

      App.init()

      const timeTagElement = document.querySelector('time[datetime]')

      expect(timeTagElement.textContent).to.have.string('December')
    })
  })
})
