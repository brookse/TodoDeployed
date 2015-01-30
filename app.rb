require 'sinatra'
require 'sinatra/reloader' if development?
require 'sequel'
require 'sinatra/assetpack'
require 'sass'

register Sinatra::AssetPack

class App < Sinatra::Application
end
	assets do 

		css :application, [
			'/css/reset.css',
			'/css/style.css'
		]
	end

	configure do
		# works
		#DB = Sequel.connect('postgres://postgres:password@localhost:5432/tasks')
		DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://database.db')
		
		# works
		DB.create_table! :tasks do
			primary_key :id
			String :task
			Boolean :completed
			DateTime :created
		end
	end

	# works
	get '/' do
		@tasks = DB[:tasks].reverse_order(:created) # get all tasks in database]
		erb :home
	#	File.read(File.join('public', 'todo.html'))
	end

	# works
	post '/' do
		DB[:tasks].insert(:task => params[:content], :completed => false, :created => Time.now)
		redirect '/'
	end

	# works
	get '/:id/delete' do
		DB[:tasks].where('id = ?', params[:id].to_i).delete
		redirect '/'
	end

	# works
	get '/:id/complete' do
		DB[:tasks].where('id = ?', params[:id].to_i).update(:completed => true)
		redirect '/'
	end


# http://stoodder.github.io/falconjs/tutorial/basic_todo_list.html
# http://stoodder.github.io/falconjs/docs/view/#extend
# http://stoodder.github.io/falconjs/docs/object/
# http://stoodder.github.io/falconjs/docs/model/
# http://stoodder.github.io/falconjs/docs/collection/