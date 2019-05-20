from splinter import Browser
import requests
from bs4 import BeautifulSoup as bs


def init_browser():
    # @NOTE: Replace the path with your actual path to the chromedriver
    executable_path = {'executable_path': 'chromedriver.exe'}
    return Browser('chrome', **executable_path, headless=False)

def scrape_info():
    browser = init_browser()

    # Retrieve Mars news
    url = 'https://mars.nasa.gov/news'
    browser.visit(url)

    html = browser.html
    soup = bs(html, "html.parser")

    news_title = soup.find('li', class_='slide').find(class_='content_title').text
    news_p = soup.find('li', class_='slide').find(class_='article_teaser_body').text

    # Retrieve Mars image
    url = 'https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars'
    browser.visit(url)
    html = browser.html
    soup = bs(html, "html.parser")
    featured_image_url = 'https://www.jpl.nasa.gov' + soup.find('a', id='full_image')['data-fancybox-href']

    # Retrieve Mars weather
    url = 'https://twitter.com/marswxreport?lang=en'
    browser.visit(url)
    html = browser.html
    soup = bs(html, "html.parser")
    mars_weather = soup.find('p', class_='TweetTextSize').text

    # Retrieve Mars facts
    import pandas as pd
    url = 'https://space-facts.com/mars/'
    table = pd.read_html(url)[0]
    html_table = table.to_html(header=False, index=False)

    # Retrieve Mars hemisphere images
    hemisphere_page_urls = []
    hemisphere_image_urls = []
    url = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
    browser.visit(url)
    html = browser.html
    soup = bs(html, "html.parser")

    for n in range(0, 4):
        hemisphere_page_urls.append('https://astrogeology.usgs.gov' + soup.find_all('div', class_='item')[n].find('a')['href'])

    for page_url in hemisphere_page_urls:
        browser.visit(page_url)
        html = browser.html
        soup = bs(html, "html.parser")
        hemisphere_image_urls.append({'title': soup.find('h2', class_='title').text, 'url': soup.find('li').find('a')['href']})
 
    # Compile results
    result_data = {
        'news_title': news_title,
        'news_p': news_p,
        'featured_image_url': featured_image_url,
        'mars_weather': mars_weather,
        'html_table': html_table,
        'hemisphere_image_urls': hemisphere_image_urls
    }

    # Quite the browser after scraping
    browser.quit()

    # Return results
    return result_data
