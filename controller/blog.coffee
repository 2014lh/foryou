Blog = require '../model/Blog'
mongoose = require 'mongoose'


settings = require '../routes/settings'
showdown  = require 'showdown'
converter = new showdown.Converter()
expressValidator = require('express-validator');

env=require('node-jsdom').env
sanitizeHtml=require 'sanitize-html'


Perpage = settings.perPageBlogSize
html="<html><body></body></html>"


postPre = (req, res, cb)->
  req.assert('text', 'Content should not be empty！').notEmpty()
  req.assert('title', 'Title should not be empty！').notEmpty()
  errows = req.validationErrors()
  if errows
    res.json
      err: errows
      success: false
  else
    content = req.body.text
    title = req.body.title
    tags=[]
    tags.push({tag:req.body['tag'+i.toString()],id:i}) for i in [1..3]
    console.log tags
    imgs = []
    blogHtml=converter.makeHtml(content)
    #console.log blogHtml
    img = ''
    contentBegin=''
    blogHtml=sanitizeHtml blogHtml,
      allowedTags:[ 'a','p','pre','ul','li','em','b','i']
      allowedAttributes:
        'a':['href']
    date = new Date()
    ip = req.ip
    cb content, blogHtml, title, tags, imgs, contentBegin, img, date, ip
    
  return

exports.blogAll = (req, res)->
  Blog.returnAllBlog( (err,blogs)->
    posts = []
    if err
      console.log blogs[0].contentBegin.toString()
    else
      blogs.forEach((post, i)->
        posts.push
          id: post._id,
          title: post.title,
          text: (post.content.substr 0, 50 )+ '...'
      )
      res.json
        posts:blogs

  )

exports.blogPerpage = (req, res)->
  Blog.returnPerpageBlogIndex(Perpage, (err, blogs, count)->
    if err
      blogs = []
    #console.log blogs[0].contentBegin.toString()
    res.render 'blog/bloglist',
      title: settings.titles.blog_bloglist,
      posts: blogs,
      OnlyOnePage: count <= Perpage,
      user: req.session.user
  )
exports.getBlogPerpage = (req, res)->
  page = parseInt(req.query.page)
  Blog.returnPerpageBlog(Perpage, page, (err, blogs, count)->
    if err
      res.json
        success: false
        info: 'fail to get！'
    else
      isLastPage = ((page - 1) * Perpage + blogs.length) == count;
      res.json
        total: count
        success: true
        blogs: blogs
        isLastPage: isLastPage
  )

exports.perBlog = (req, res)->
  id = req.params.id
  Blog.updateBlogPv(id)
  Blog.returnBlogById(id, (err, blog)->
    if err
      blog = {}
    post={}
    post.title=blog.title
    post.text=blog.content
    blog.content=converter.makeHtml(blog.content)
    post.html=blog.content
    post.blogid=req.params.id
    res.json
      post:post
      
      
  )

exports.postView = (req, res)->
  count = 1
  tags = []
  while count < 4
    tags.push({tag: '', id: count})
    count++
  res.render 'blog/post',
    title: settings.titles.blog_post,
    user: req.session.user
    blog: new Blog({tags: tags,content:''})
    action: "post"


exports.post = (req, res)->
  postPre(req, res, (content, blogHtml, title, tags, imgs, contentBegin, date, ip)->
    blog = new Blog(
      content: content,
      title: title,
      contentBegin: contentBegin,
      blogHtml:blogHtml,
      tags: tags,
      imgs: imgs,
      user: req.session.user,
      date: date,
      time:
        year: date.getFullYear(),
        month: date.getFullYear() + "-" + (date.getMonth() + 1),
        day: date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate(),
        minute: date.getHours() + ':' + date.getMinutes()
      ip: ip
    )
    blog.save((err)->
      if err?
        console.log('emodoou_text:error');
        res.json
          success:false
          err:err
      else
         console.log('emodoou_text:sucess');
        res.redirect '/index'
    )
  )

exports.editBlogView = (req, res)->
  id = mongoose.Types.ObjectId(req.params.id)
  Blog.findById id, null, (err, doc)->
    count = 1
    len = doc.tags.length
    while count < 4 - len
      doc.tags.push({tag: ''})
      count++


    res.render 'blog/post',
      title: settings.titles.blog_edit,
      blog: doc,
      user: req.session.user
      action: "editblog"

exports.editBlog = (req, res)->
  id = req.params.id
  postPre req, res, (content, blogHtml, title, tags, imgs, contentBegin, img, date, ip)->

    blog =
      content: content,
      title: title,
      contentBegin: contentBegin,
      tags: tags,
      blogHtml:blogHtml,
      img:
        px600: img.replace 'px1366','px600'
        px200: img.replace 'px1366','px200'
        original: img.replace 'px1366',''
        px1366: img

      imgs: imgs

    Blog.update {_id: id}, {$set: blog, $push: {"editDate": {date: date, ip: ip}}}, (err, num, row)->
      if err and num == 0
        res.json
          success: false
      else
        res.redirect '/blog'

exports.viewIndex = (req, res)->
  Blog.returnView null, null, (err, monthBlogs)->
    if err
      monthBlogs = []
    res.render "blog/view",
      title: settings.titles.blog_view
      MonthBlogs: monthBlogs
      user: req.session.user
exports.deleteBlog = (req, res)->
  id = req.query.id
  console.log id
  Blog.remove({_id: id}).exec (err)->
    if err
      res.json({success: false})
    else
      res.json({success: true})
exports.setTop = (req, res)->
  istop = false
  id = req.query.id
  if req.query.istop == 'true'
    istop = true
  Blog.update({_id: id}, {$set: {isTop: istop}}).exec (err)->
    if err
      res.json({success: false})
    else
      res.json({success: true})


























