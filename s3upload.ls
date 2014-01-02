knox = require('knox')
readline = require('readline')
lazy = require("lazy")

# setup s3
s3 = knox.createClient(
    key: process.env.S3ID
    secret: process.env.S3SECRET
    bucket: 'wybcsite')

uploadPath = (file, path)->
    s3.putFile(String(file), String(path), (err, r)->
        console.log(err) if err)

# uploadPath = (file, path)->
#     console.log('uploading ' + file + ' to ' + path)

new lazy(process.stdin).lines.forEach((line)->
    path = line.slice(5)
    uploadPath(line, path) if path is /\/[^.]/)