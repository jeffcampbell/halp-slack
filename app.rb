# encoding: utf-8
require "rubygems"
require "bundler/setup"
Bundler.require(:default)

configure do
  # Load .env vars
  Dotenv.load
  # Disable output buffering
  $stdout.sync = true
end

get "/" do
  ""
end

post "/" do
  response = ""
begin
  puts "[LOG] #{params}"
  unless params[:token] != ENV["OUTGOING_WEBHOOK_TOKEN"]
    response = { text: "I'm here to help!" }
    response[:attachments] = [ generate_attachment ]
    response[:username] = ENV["BOT_USERNAME"] unless ENV["BOT_USERNAME"].nil?
    response[:icon_emoji] = ENV["BOT_ICON"] unless ENV["BOT_ICON"].nil?
    response = response.to_json
  end
end
  status 200
  body response
end

def previous_message
  @channel = ENV["SLACK_CHANNEL"]
  @token = ENV["SLACK_API_TOKEN"]
  uri = "https://slack.com/api/channels.history?token=#{@token}&channel=#{@channel}&count=2&pretty=1"
  request = HTTParty.get(uri)
  puts "[LOG] #{request.body}"

  @slackresults = JSON.parse(request.body)

  message = @slackresults["messages"][1]["text"]
end

def generate_attachment
  @site = ENV["STACK_EXCHANGE_SITE"]

  searchquery = previous_message.downcase.gsub(/\W/,'%3B')
  puts "[LOG] #{searchquery}"

  uri = "https://api.stackexchange.com/2.2/search?order=desc&sort=votes&tagged=#{searchquery}&site=#{@site}"
  request = HTTParty.get(uri)
  puts "[LOG] #{request.body}"

  @firstresult = JSON.parse(request.body)["items"][0]
  @secondresult = JSON.parse(request.body)["items"][1]
  @nilcheck = JSON.parse(request.body)["items"]

  # Check for results
  if @nilcheck.empty?
    response = { title: "Sorry I couldn't help :cry:" }
  else
    @firsttitle = @firstresult["title"]
    @firstlink = @firstresult["link"]
    @firstscore = @firstresult["score"]
    @firstanswercount = @firstresult["answer_count"]
    @secondtitle = @secondresult["title"]
    @secondlink = @secondresult["link"]
    @secondscore = @secondresult["score"]
    @secondanswercount = @secondresult["answer_count"]
    response = { title: "#{@firsttitle}", title_link: "#{@firstlink}", text: "", fields: [ { title: "Score:", value: "#{@firstscore}", short: true }, { title: "Answers:", value: "#{@firstanswercount}", short: true }, { title: "Or maybe this?", value: "<#{@secondlink}|#{@secondtitle}> - Score: #{@secondscore}", short: false } ] }
  end
end
