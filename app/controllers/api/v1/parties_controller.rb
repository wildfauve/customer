class Api::V1::PartiesController < Api::ApplicationController
  
  def index
    
  end
  
  def show
    @party = Party.find(params[:id])
    render 'party', status: :ok, location: api_v1_party_path(@party)
  end
  
  def create
    party = Party.new
    party.subscribe(self)
    party.create_me(party: params)
  end
  
  def successful_create_event(party)
    @party = party
    render 'party', status: :created, location: api_v1_party_path(@party)
  end
  
  def successful_update_event(party)
  end
  
end