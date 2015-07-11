module Pin
  class Transfer < Base
    def self.create(options)
      build_response(make_request(:post, { url: 'transfers', options: options }))
    end

    def self.all(page = nil, pagination = false)
      build_collection_response(make_request(:get, {url: "transfers?page=#{page}" } ), pagination)
    end

    def self.find(token)
      build_response(make_request(:get, {url: "transfers/#{token}" } ))
    end

    def self.line_items(token, page = nil, pagination = false)
      build_collection_response(make_request(:get, {url: "transfers/#{token}/line_items?page=#{page}" } ), pagination)
    end
  end
end
