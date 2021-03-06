class EquipsController < ApplicationController

  # before do
  #   login_required
  # end

  post '/characters/:character_id/equips' do
    login_required
    equip = current_user.equips.new(params[:equip])
    equip.character_id = params[:character_id]
    equip.save

    redirect "characters/#{params[:character_id]}"
  end

  get '/equips' do
    login_required
    @equips = current_user.equips.search(params[:query]).sort_by_name
    erb :"/equips/index"
  end

  get '/equips/new' do
    login_required
    @equips = current_user.equips
    @characters = current_user.characters
    erb :"equips/new"
  end

  post '/equips' do
    login_required
    sanitize_input(params[:equip])
    if !params[:equip][:name].blank?
      equip = current_user.equips.create(params[:equip])
      flash[:message] = "Successfully created equip."
    else
      redirect to "/equips/new"
    end
  
    redirect to "/equips/#{equip.id}"
  end

  get '/equips/:id' do
    login_required
    permission_required
    @character = current_user.characters
    @equip = current_user.equips.find_by_id(params[:id])
    erb :"/equips/show"
  end

  get '/equips/:id/edit' do
    login_required
    permission_required
    @equip = current_user.equips.find_by_id(params[:id])
    @characters = current_user.characters
    @teams = current_user.teams
    erb :"/equips/edit"
  end 

  patch '/equips/:id' do 
    login_required
    permission_required
    sanitize_input(params[:equip])
    @characters = current_user.characters.find_or_create_by(params[:character])
    equip = current_user.equips.find_by_id(params[:id])
    if !params[:equip][:name].blank?
      equip.update(params[:equip])
      flash[:message] = "Successfully updated equip."
    end

    redirect to "/equips/#{equip.id}"
  end

  delete '/equips/:id' do
    login_required
    permission_required
    @equip = current_user.equips.find_by_id(params[:id])
    @equip.destroy
    redirect "equips"
  end 


  private

  def permission_required
    unless @equip = current_user.equips.find_by_id(params[:id])
      flash[:alerts] = ["You don't have permission"]
      redirect to "/equips"
    end 
  end


end