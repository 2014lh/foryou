mongoose = require 'mongoose'
Schema = mongoose.Schema

commentSchema=new Schema
  time:Date
  content:String
  user:String
  userid:String
  subComments:[
    time:Date
    content:String
    user:String
    userid:String
    toUser:String
  ]

blogSchema = new Schema
  content: String
  blogHtml:String
  markdownText: String
  contentBegin: String
  tags: [{tag: String, id: Number}]
  title: String
  user: String
  userid:String
  date: Date
  time:
    year: String,
    month: String,
    day: String,
    minute: String
  imgs: [String]
  isTop: {type: Boolean, default: false}
  pv: {type: Number, default: 0}
  editDate: [{date: Date, ip: String}]
  comments:[commentSchema]


blogSchema.statics =

  returnSelfBlog: (userid,cb)->
    @find(userid:userid).sort(date:-1).exec((err,blogs)->
      if err
        cb err, null
      else
        cb null, blogs
    )

  returnAllBlog: (cb)->
    @find().sort({isTop: -1, date: -1}).exec((err, blogs)->
      if err
        cb err, null
      else
        cb null, blogs
    )
  
  returnTopBlog: (cb)->
    @find({isTop: true}).sort({isTop: -1, date: -1}).limit(5).exec((err, blogs)->
      if err
        cb err, null
      else
        cb null, blogs
    )

  returnPerpageBlogIndex: (perpage, cb)->
    blogThis = @
    @count().exec((err, count)->
      if err
        cb err, null, 0
      else
        blogThis.find({}).sort({date: -1}).limit(perpage).exec((err, blogs)->
          if err
            cb err, null, 0
          else
            cb null, blogs, count
        )
    )

  returnPerpageBlog: (perpage, page, cb)->
    blogThis = @
    @count().exec((err, count)->
      if err
        cb err, null, 0
      else
        blogThis.find({}, null,
          {skip: (page - 1) * perpage, limit: perpage}).sort({date: -1}).select('title contentBegin time').exec((err, blogs)->
          if err
            cb err, null, 0
          else
            cb null, blogs, count
        )
    )

  returnBlogById: (id, cb)->
    @findById(id).exec((err, blog)->
      if err
        cb err, null
      else
        cb null, blog
    )

  updateBlogPv: (id)->
    @update({_id: id}, {$inc: {"pv": 1}}).exec()
  returnView: (year, month, cb)->
    keys =
      'time.month': true
    condition = null
    initial =
      count: 0
      blogs: []
    reduce = (doc, aggregator)->
      aggregator.count += 1
      aggregator.blogs.push doc
    @collection.group keys, condition, initial, reduce, null, null, null, (err, results)->
      compare = (value1, value2)->
        new Date(value2['time.month']) - new Date(value1['time.month'])
      compare2 = (value1, value2)->
        value1.date - value2.date
      results.sort compare
      .forEach (item, index, arr)->
        item.blogs.sort compare2
      cb err, results

    readTopAndCount:(cb)->
        coverThis=@
        @count().exec((err,count)->
            if err or count==0
              cb "err",null,0
            else
              coverThis.find({},null).sort({isTop:-1,date:-1}).limit(1).exec((err,covers)->
                    if(err)
                        cb "err",null,0
                    else
                        cb null,covers[0],count
              )
        )


Blog = mongoose.model 'Blog', blogSchema
module.exports = Blog