class Api::V1::PartiesController < Api::ApplicationController
  
  def index
    @parties = Party.all
    
  end
  
  def show
    @party = Party.find(params[:id])
    render 'show', location: api_v1_party_path(@party)
  end
  
  def create
    party = Party.new
    party.subscribe(self)
    party.create_me(party: params)
  end
  
  def update
    party = Party.find(params[:id])
    party.subscribe(self)
    party.update_me(party: params)
  end
  
  def successful_save_event(party)
    @party = party
    render 'party', status: :created, location: api_v1_party_path(@party)
  end
  
  def successful_update_event(party)
  end
  
end