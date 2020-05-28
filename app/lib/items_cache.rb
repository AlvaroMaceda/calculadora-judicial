class ItemsCache

    class << self
        def create(&search_method)
            return Hash.new do |cache, key|
                cache[key] = search_method.call(key)
            end
        end
    end

end