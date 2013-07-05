module Pin
  class Card < Base

    def self.create(options)
      build_response(auth_post('cards', options))
    end
  end
end