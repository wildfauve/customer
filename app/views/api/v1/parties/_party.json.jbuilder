json.kind "party"
json.party do
  json.name party.name
  json.age party.age
end
json.timestamps do
  json.createtime party.created_at
  json.updatetime party.updated_at
end
json.id_references party.id_references do |ref|
  json.ref ref.ref
  json.identifier ref.identifier if ref.identifier
  json.link ref.link if ref.link  
end
json._links do
  json.self do
    json.href api_v1_party_url(party)
  end
end
