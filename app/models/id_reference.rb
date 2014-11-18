class IdReference
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :ref, :type => String 
  field :link, :type => String
  field :identifier, :type => String
  
  embedded_in :party
  
  def self.create_it(ref: nil, link: nil, identifier: nil)
    id = self.new
    id.update_it(ref: ref, link: link, identifier: identifier)
    id
  end
  
  def update_it(ref: nil, link: nil, identifier: identifier)
    self.ref = ref
    self.link = link
    self.identifier = identifier
    self 
  end
    
end
