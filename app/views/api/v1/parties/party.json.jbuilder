json.kind "party"
json.party do
  json.name @party.name
  json.age @party.age
end
json.timestamps do
  json.createtime @party.created_at
  json.updatetime @party.updated_at
end
json._links do
  json.self do
    json.href api_v1_party_url(@party)
  end
end
