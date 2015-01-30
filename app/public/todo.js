var Task = Falcon.Model.extend({
	url: 'task',
	
	observables: {
		'task': '',
		'completed': '',
		'created': ''
	}
	
});

var Tasks = Falcon.Collection.extend({
	model: Task
});

var TaskListView = Falcon.View.extend({
	url: '#task_list-tmpl',
	
	defaults: {
		'tasks': function() { 
			return new Tasks;
		}
	},
	
	observables: {
		'newTask': '',	// Content for new task
		'editTask': ''
	},
	
	initialize: function(){
		this.tasks.fetch();
	},
	
	add: function(){
		var task = new Task({task: this.newTask(), completed: false, created: new Date().getDate()});	// Create new task with text
		console.log(task);
		this.tasks.append(task);	// Add to collection
		this.newTask('');			// Clear new text
		task.create();
	},
	
	remove: function(task){
		this.tasks.remove(task);	// Remove task from collection
		task.destroy();
	},
	
	complete: function(task){
		task.set('completed', true);
		task.save();
		
	}
	
});

view = new TaskListView;
Falcon.baseApiUrl = "/";
Falcon.apply(view, "#app");