require 'watir'

class GameResultsManager
  def initialize
    @results, @results_percentage, @results_odds = {}, {}, {}
    open_and_prepare_window
    get_results_from_table
  end

  private
  def open_and_prepare_window
    @browser = Watir::Browser.new
    @browser.window.resize_to 1920, 1080
    @browser.window.move_to 0, 0
    @browser.goto('https://oddslot.com/tips/')
    @browser.element(:css => '.team-schedule--full').wait_until_present
  end

  def get_results_from_table
    if ARGV[0].to_i != 0 then pages = ARGV[0].to_i else pages = 80 end
    read_row_data(pages)
    print_results
  end

  def read_row_data(to)
    1.upto(to) do |i|
      print 'Strona' + i.to_s + ': '
      @browser.elements(:css => '.team-schedule--full tbody tr').each do |row|
        league_name = row.elements(:css => 'td')[3].text_content
        odds = row.elements(:css => 'td')[5].text_content
        percentage = row.elements(:css => 'td')[4].text_content
        print '.'
        if row.elements(:css => 'td')[7].element(:css => 'a font').exists?
          if row.elements(:css => 'td')[7].element(:css => 'a font').attribute_value('color') == 'green' then won = true else won = false end
          add_result(league_name, won)
          add_result_odds(odds, won)
          add_result_percentage(percentage, won)
        end
      end
      puts ''
      go_to_next_page
    end
  end

  def go_to_next_page
    @browser.elements(:css => '.pagination--lg li').each_with_index do |page, i|
      if page.class_name == 'active'
        @browser.elements(:css => '.pagination--lg li')[i+1].element(:css => 'a').click
        break
      end
    end
  end

  def add_result(league_name, won)
    add_result_helper(@results, league_name, won)
  end

  def add_result_odds(odds, won)
    add_result_helper(@results_odds, odds, won)
  end

  def add_result_percentage(percentage, won)
    add_result_helper(@results_percentage, percentage, won)
  end

  def add_result_helper(hash, key, value)
    if value then won = 1 else won = 0 end
    if hash.include?(key)
      hash[key][0] += won
      hash[key][1] += 1
    else
      hash[key] = [won, 1]
    end
  end

  def print_results
    @results.sort.each do |league_name, results|
      percentage = (results[0].to_f / results[1].to_f * 100.0).to_i
      puts percentage.to_s + "%\t" + results[0].to_s + '/' + results[1].to_s + "\t" + league_name if percentage > 70 && results[1] > 1
    end
    puts ''
    @results_odds.sort.each do |odd, results|
      percentage = (results[0].to_f / results[1].to_f * 100.0).to_i
      puts percentage.to_s + "%\t" + results[0].to_s + '/' + results[1].to_s + "\t" + odd
    end
    puts ''
    @results_percentage.sort.each do |percent, results|
      percentage = (results[0].to_f / results[1].to_f * 100.0).to_i
      puts percentage.to_s + "%\t" + results[0].to_s + '/' + results[1].to_s + "\t" + percent
    end
  end
end

GameResultsManager.new
