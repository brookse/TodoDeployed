(function() {
	RebelChat.Views.LayoutView = Falcon.View.extend({
		url: 'layout.html',
		observables: {
			'currentView': null
		},
		initialize: function() {
			var _this = this;
	
			this.showChatroomView = function(chatroom) {
				var chatroomView = new RebelChat.Views.ChatroomView(chatroom);
				chatroomView.on('goBack', this.showChatroomsListView, this)
				this.currentView(chatroomView);
			};

			this.showChatroomsListView = function() {
				var chatroomsListView = new RebelChat.Views.ChatroomsListView();
				chatroomsListView.on('joinChatroom', function(chatroom) {
					_this.showChatroomView(chatroom);
				});
				this.currentView(chatroomsListView);
			};

			this.showCallsignView = function() {
				var callsignView = new RebelChat.Views.CallsignView();
				callsignView.on('callsignChosen', this.showChatroomsListView, this);
				this.currentView(callsignView);
			};

			this.showHomeView = function() {
				var homeView = new RebelChat.Views.HomeView();
				homeView.on('getStarted', this.showCallsignView, this);
				this.currentView(homeView);
			};

			if (RebelChat.User.callsign) {
				this.showChatroomsListView();
			}
			else {
				this.showHomeView();
			}
		}
	});
})();