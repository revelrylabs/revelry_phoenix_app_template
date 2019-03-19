const {JSDOM} = require('jsdom')
const chai = require('chai')

const jsdom = new JSDOM()
const {window} = jsdom
const {document} = window

global.window = window
global.document = document
global.expect = chai.expect
