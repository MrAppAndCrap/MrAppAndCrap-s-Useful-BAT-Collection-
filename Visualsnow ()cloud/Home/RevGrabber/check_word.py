import requests
from bs4 import BeautifulSoup, Comment
from flask import Flask
from pushbullet import Pushbullet
import time

app = Flask(__name__)

# Target website
TARGET_URL = "https://www.revcomps.com/"
THRESHOLD = 3  # Number of occurrences to trigger an alert

# Your Pushbullet API Key
PUSHBULLET_API_KEY = "o.Wx1Ft1GNlXZycaQ2hSIvky4BVHbJjhKW"
pb = Pushbullet(PUSHBULLET_API_KEY)

# Global variable to track previous links
previous_links = set()

REFRESH_INTERVAL = 600  # Refresh interval in seconds (10 minutes)


def fetch_and_check():
    try:
        global previous_links

        # Fetch the target website
        response = requests.get(TARGET_URL)
        response.raise_for_status()  # Raise an error if the request fails

        # Parse the HTML content
        soup = BeautifulSoup(response.text, "html.parser")

        # Remove non-visible elements: <script>, <style>, etc.
        for tag in soup(["script", "style", "noscript"]):
            tag.decompose()

        # Remove HTML comments
        comments = soup.find_all(string=lambda text: isinstance(text, Comment))
        for comment in comments:
            comment.extract()

        # Get the cleaned text from the webpage
        text = soup.get_text(separator=" ")  # Extract visible text

        # Count occurrences of the word "Free"
        word_to_check = "Free"
        count = text.lower().count(word_to_check.lower())

        # Find URLs where the word "Free" appears
        current_links = set()
        for link in soup.find_all("a", href=True):  # Extract all <a> tags with href
            if word_to_check.lower() in link.text.lower():
                full_url = link["href"]
                if not full_url.startswith("http"):
                    full_url = TARGET_URL + full_url  # Handle relative URLs
                current_links.add(full_url)

        # Check for changes in links
        new_links = current_links - previous_links  # New links detected
        previous_links = current_links  # Update the global variable

        # Prepare the response
        response_message = f"The word '{word_to_check}' was found {count} times on {TARGET_URL}.\n"
        if count > THRESHOLD and new_links:
            response_message += "ALERT TRIGGERED! New Links Found!<br><br>"

            # Send Pushbullet notification
            pb.push_note(
                "RevComp Alert",
                f"The word 'Free' was found {count} times on {TARGET_URL}! New links: {', '.join(new_links)}",
            )

        # Append matching URLs to the response
        if current_links:
            response_message += "URLs where 'Free' was found:<br>"
            for url in current_links:
                response_message += f"<a href='{url}' target='_blank'>{url}</a><br>"
        else:
            response_message += "No URLs found with the word 'Free'."

        return response_message

    except Exception as e:
        return f"An error occurred: {str(e)}"


@app.route("/")
def check_word():
    return fetch_and_check()


if __name__ == "__main__":
    print("Starting the periodic re-check...")
    while True:
        print(fetch_and_check())
        
        # Countdown timer
        for remaining in range(REFRESH_INTERVAL, 0, -1):
            minutes, seconds = divmod(remaining, 60)
            print(f"Next check in: {minutes} minutes, {seconds} seconds", end="\r")
            time.sleep(1)  # Sleep for 1 second
