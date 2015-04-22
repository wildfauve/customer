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
    ref = event["ref"].find {|h| h["ref"] == "party"}
    return if !ref
    party = self.find(ref["link"].split("/").last)
    party.add_references(refs: event["ref"])
  end
  
  
  def create_me(party: nil)
    self.name = party[:name]
    self.age = party[:age]
    self.save
    publish(:successful_save_event, self)
  end

  def update_me(party: nil)
    self.name = party[:name]
    self.age = party[:age]
    self.save
    publish(:successful_update_event, self)
  end
  
  
  def add_references(refs: nil)
    refs.each do |r|
      if r["ref"] != "party"
        id = self.id_references.where(ref: r["ref"]).first
        if id
          id.update_it(ref: r["ref"], link: r["link"], identifier: r["id"])
        else
          self.id_references << IdReference.create_it(ref: r["ref"], link: r["link"], identifier: r["id"])
        end
      end
    end
    self.save
  end
  
  def party_change_event
    {
      kind: "party_change",
      party: {
        name: self.name,
        age: self.age,
        _links: {
          self: {
            href: url_helpers.api_v1_party(self, host: Setting.services(:self, :host))
          }
        }
      }
    }
  end
  
  
  
end
