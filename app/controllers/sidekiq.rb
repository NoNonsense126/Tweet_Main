get '/status/:job_id' do
  job_is_complete(params[:job_id]).to_s
end