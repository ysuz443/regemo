# Description:
#   register emoji to slack
#
# Notes:
#
fs = require('fs')

readJSON = (path) ->
  json = JSON.parse(fs.readFileSync(path, 'utf8'))
  return json
createDict = (json) ->
  dict = {}
  for key,val of json
    for word in val.keywords
      if dict[word]?
        dict[word].push(val.url)
      else
        dict[word] = [val.url]
  return dict

dict = createDict(readJSON('config/usamaru.json'))

module.exports = (robot) ->
  # error handler
  robot.error (err, res) ->
    console.log(err)
    if res?
      res.send "[error] #{err}"

  # regemo usamaru method
  robot.respond /usa \s*(.+)$/i , (res) ->
    word = res.match[1]
    if dict[word]?
      ran = Math.floor(Math.random() *  dict[word].length);
      img = dict[word][ran]
      res.send(img)
  robot.respond /usalist$/i , (res) ->
    keywords = (word for word,urls of dict)
    res.send(keywords)
