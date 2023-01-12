const aws = require('aws-sdk')
const Handler = require('./handler')


const rekoSvc = new aws.Rekognition()
const translatorSvc = new aws.Translate()

const handler = new Handler({
    rekoSvc,
    translatorSvc
})


// bind - secure to handler that "this" is Handler
module.exports = handler.main.bind(handler)