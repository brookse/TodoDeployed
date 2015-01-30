require 'sinatra'
require 'sinatra/reloader' if development?
require 'sequel'
require 'json'

# works
DB = Sequel.connect('postgres://postgres:password@localhost:5432/tasks')

# works
#DB.create_table :tasks do
#	primary_key :id
#	String :task
#	Boolean :completed
#	DateTime :created
#end

# works
get '/' do
	@tasks = DB[:tasks].reverse_order(:created) # get all tasks in database]
#	erb :home
	File.read(File.join('public', 'todo.html'))
end

# works
post '/task' do
	json = JSON.parse(request.body.read)
	task = DB[:tasks].returning(:id).insert(:task => json['task'], :completed => false, :created => Time.now)
	DB[:tasks].where('id = ?', task.first[:id]).first.to_json
end

get '/task/:id' do
	task = DB[:tasks].where('id = ?', params[:id].to_i) # get task with matching id
	task.first.to_json
end

get '/task' do
	tasks = DB[:tasks].reverse_order(:created).all # get all tasks in database]
	tasks.to_json
end

put '/task/:id' do
	json = JSON.parse(request.body.read)
	task = DB[:tasks].where('id = ?', params[:id].to_i).update(:task => json['task'], :completed =>json['completed'])
	task = DB[:tasks].where('id = ?', params[:id].to_i).first
	task.to_json

end

# works
delete '/task/:id' do
	task = DB[:tasks].where('id = ?', params[:id].to_i).first
	puts task.inspect
#	task.delete
	DB[:tasks].where('id = ?', params[:id].to_i).delete
	task.to_json
end




# http://stoodder.github.io/falconjs/tutorial/basic_todo_list.html
# http://stoodder.github.io/falconjs/docs/view/#extend
# http://stoodder.github.io/falconjs/docs/object/
# http://stoodder.github.io/falconjs/docs/model/
# http://stoodder.github.io/falconjs/docs/collection/