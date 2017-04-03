module CollectionModel
  extend ActiveSupport::Concern

  module ClassMethods
    def get_collection(collection_array)
      collection_array.each_with_object(Hash.new(0)) { |e, a| a[e.upcase] = e }
    end
  end
end