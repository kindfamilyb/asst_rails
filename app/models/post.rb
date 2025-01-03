class Post < ApplicationRecord
    after_create_commit { broadcast_post }
    
    private

    def broadcast_post
      ActionCable.server.broadcast "posts_channel", {
        id: self.id,
        name: self.name
      }
    end
end
