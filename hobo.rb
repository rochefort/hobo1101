require 'mechanize'
require 'mysql2'

DEBUG = false

class Hobo
  BASE_URL = 'http://www.1101.com/home.html'
  INSERT_SQL = "INSERT INTO darlings(date, text, created_at, update_at) VALUES('%s', '%s', now(), now())"

  def initialize
    @agent = Mechanize.new
    @env = 'production'
  end

  def save_darling
    page = @agent.get(BASE_URL)
    date = page.search('#head img.date').attribute('title').value
    darling = page.search('#todays_darling').text
    save(date, darling)
  end

  private

  def save(date, text)
    db_settings = YAML.load_file('database.yml')[@env]
    client = Mysql2::Client.new(db_settings)
    sql = INSERT_SQL % [date, client.escape(text)]
    client.query(sql)
  rescue Mysql2::Error => e
    puts "errno: #{e.errno} message: #{e.message}"
    puts e.backtrace if DEBUG
  end
end

if __FILE__ == $0
  Hobo.new.save_darling
end
