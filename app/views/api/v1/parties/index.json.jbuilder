json.kind "parties"
json.parties @parties do |party|
  json.partial! 'party', party: party
end
json._links do
  json.self do
    json.href api_v1_parties_url
  end
end
