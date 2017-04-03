require "rails"
require "rpages/engine"
require "dynamic_router"

require "active_record/add_reset_pk_sequence_to_base"

module Rpages
  def self.get_root
    gem_root = Pathname.new(Gem::Specification.find_by_name("rpages").gem_dir)
  end
end
