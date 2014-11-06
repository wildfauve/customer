class Party
  
  include Wisper::Publisher

  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, type: String
  field :age, type: Integer
  
  embeds_many :id_references
  
  #{"event":"kiwi_identity",
  #  "ref":[{"link":"http://localhost:3021/api/v1/parties/545964134d6174bb8d050000","ref":"party"},
  # {"ref":"sub","id":"545963db4d61745aead30000"}],
  # "id_token":{"sub":"545963db4d61745aead30000"}}
  def self.id_reference(event)
    link = event["ref"].find {|h| h["ref"] == "party"}
    return if !link
    party = self.find(link.split("/").last)
    party.add_references(ref: event["ref"])
  end
  
  
  def create_me(party: nil)
    self.name = party[:name]
    self.age = party[:age]
    self.save
    publish(:successful_create_event, self)
  end
  
  
  
  def add_references(ref: nil)
    ref.each do |r|
      if r["ref"] != "party"
        id = self.id_references.where(ref: r["ref"]).first
        if id
          id.update_it(ref: r[href], link: r["link"], id: r["id"])
        else
          self.id_references << IdReference.create_it(ref: r["ref"], link: r["link"], id: r["id"])
        end
      end
    end
    self.save
  end
  
  
  
end
