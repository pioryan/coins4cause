module BonsaiSearch
  extend ActiveSupport::Concern

  module ClassMethods
    def to_curl(params = {})
      post_arr = []
      params.each { |k, v|
        next if v.nil?
        post_arr << Curl::PostField.content(k.to_s, v)
      }
      post_arr
    end

    def cheap_encode(source_str)
      source_str.to_s.gsub('+','%2B').gsub(' ','+')
    end

    def bonsai_search(query)
      bonsai_url = ENV['BONSAI_URL']
      if bonsai_url
        params = {"query" => {"match" => {"_all" => query}} }
        params = params.to_json
        puts params
        response = `curl -XGET #{bonsai_url}/user/user/_search -d '#{params}'`
        result = JSON.parse(response)

        users = result["hits"]["hits"].inject([]) do |users, item|
          users << item["_id"]
        end
        User.with_role(:cause).where(:nickname => users)
      end
    end
  end
end

