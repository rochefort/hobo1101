require "mechanize"
require "retryable"

class Crawler
  def initialize
    @agent = Mechanize.new
    @agent.user_agent_alias = "Windows Mozilla"
  end

  def get(url, tries = 3, sleep = 3)
    page = nil
    Retryable.retryable(tries: tries, sleep: sleep) do |retries, exception|
      page = @agent.get(url)
      Rails.logger.error "try #{retries}, code: #{page&.code} failed with exception: #{exception}" unless page&.code == "200"
    end
    page
  end
end
