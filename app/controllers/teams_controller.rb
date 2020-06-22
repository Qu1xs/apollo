class TeamsController < ApplicationController
 #7 restful routes 
 #Create, Read, Update, Delete

    get '/teams' do
        @teams = current_user.teams
         erb :"teams/index"
    end

    get '/teams/new' do
        @teams = Team.all
        erb :"teams/new"
    end

    post '/teams' do
        sanitize_input(params[:team])
        team = current_user.teams.create(params[:team])
        redirect "/teams/#{team.id}"
    end  

    get '/teams/:id' do
        @team = Team.find(params[:id])
        erb :"teams/show"
    end 

    get '/teams/:id/edit' do
        @team = Team.find(params[:id])
        erb :"teams/edit"
    end 
    
    patch '/teams/:id' do
        sanitize_input(params[:team])
        team = Team.find(params[:id])
        team.update(params[:team])
        redirect "teams/#{team.id}"
    end 
    
    delete '/teams/:id' do
        @team = Team.find(params[:id])
        @team.destroy
        redirect "teams"
    end 
        

    private

    # def permission_required
    #   unless @team = current_user.teams.find_by_id(params[:id])
    #     flash[:alerts] = ["You don't have permission"]
    #     redirect to "/teams"
    #   end 
    # end

end