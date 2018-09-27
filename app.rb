require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader' if development?

# connect to DB
set :database, 'sqlite3:board.db'

# Post model
class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :content, presence: true

  has_many :comments
  
  def comments_count
    Comment.where(posts_id: self.id).count
  end
end

# Comment model
class Comment < ActiveRecord::Base
  validates :content, presence: true
  validates :posts_id, presence: true

  belongs_to :post

  def get_post_title
    post_id = self.posts_id
    if post_id
      post = Post.find post_id
      return post.title
    end
    'no post'
  end
end


# Latest posts
# title
# date author
# content
get '/' do
  @posts = Post.all.order created_at: :desc
  erb :index
end


# Add new post route
# form with title and content
get '/posts/new' do
  erb :'posts/new'
end

post '/posts' do
  @post = Post.create params[:post]
  redirect "/posts/#{@post.id}"
end

# post/:id route
# title
# date
# content
# add comment form
# comments list
# date
# content

get '/posts/:id' do
  @post = Post.find params[:id]
  @comments = Comment.where(posts_id: params[:id]).order(created_at: :asc)
  erb :'/posts/details'
end


# post new comment route
post '/posts/:id/comments' do
  comment = Comment.new params[:comment]
  comment.posts_id = params[:id]
  if comment.save
    redirect back
  end
end

# /comments route
get "/comments" do
  @comments = Comment.limit(10).order(created_at: :desc)
  erb :'comments/index'
end