require 'mechanize'
require 'pry'

def file_exist?(user_name, file_name)
  File.file?("images/#{user_name}/#{file_name}.png")
end

puts 'Insert the mosaic url of your victim'
url = gets.chomp

agent = Mechanize.new

agent.get(url) do |page|
  next_page_link = page.link_with(text: '>')
  next_page = page

  user_name = url.split('/')[3]
  index = 1

  while next_page_link
    photo_links = next_page.links_with(class: 'wall_img_container')

    photo_links.each do |link|
      child_page = link.click

      title = child_page.title
      title ||= 'no-title'

      if file_exist?(user_name, title)
        child_page.images[3].fetch.save("images/#{user_name}/#{title.gsub('/','-')}(#{index}).png")
        index += 1
      else
        child_page.images[3].fetch.save("images/#{user_name}/#{title.gsub('/','-')}.png")
      end
    end
    next_page = next_page_link.click
    next_page_link = next_page.link_with(text: '>')
  end
end
