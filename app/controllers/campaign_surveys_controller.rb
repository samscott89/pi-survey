class CampaignSurveysController < ApplicationController
  def destroy
  	@cs = CampaignSurvey.find(params[:id])
  	authorize! :update, @cs.campaign

  	@cs_id = @cs.id
  	@cs.destroy
  end
end
