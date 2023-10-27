from firebase_functions import firestore_fn
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import requests

cred = credentials.Certificate('serviceAccount.json')
firebase_admin.initialize_app(cred)

db = firestore.client()


@firestore_fn.on_document_created(document="messages/{messageID}")
def extractUrls(
    event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None],
) -> None:

    if event.data is None:
        return
    try:
        print(event.data)
        if event.data.get("vText") != '':
            original = event.data.get("vText")
        else:
            original = event.data.get("message")
        # extract links from message
        urls = extract_urls(original)

    except KeyError:
        return

    event.data.reference.update({"links": urls})

    if len(urls) > 0:
        # update message with links
        event.data.reference.update({"isScanning": True})


def extract_urls(text):
    # splits text into words
    url = []
    text = text.split()
    # searches for urls in each word
    for word in text:
        if word.startswith("http://") or word.startswith("https://") or word.startswith("www."):
            url.append(word)

    return url


@firestore_fn.on_document_created(document="users/{userID}/chats/{chatID}/messages/{messageID}")
def scanMessage(
    event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None],
) -> None:

    if event.data is None:
        return
    try:
        print(event.data)
        if event.data.get("vText") != '':
            original = event.data.get("vText")
        else:
            original = event.data.get("message")
        urls = extract_urls(original)

    except KeyError:
        return

    event.data.reference.update({"links": urls})

    if len(urls) > 0:
        event.data.reference.update({"isScanning": True})
        scan_url(urls[0], event)


def scan_url(url, event):
    try:
        api_url = 'https://ap101.pythonanywhere.com/predict'
        payload = {
            'url': url
        }
        response = requests.post(api_url, json=payload)

        if response.status_code == 200:
            data = response.json()
            label = data.get('label', '')
            event.data.reference.update({"isScanning": False, "status": label})

        else:
            print(f"Error: {response.status_code}")
            event.data.reference.update(
                {"isScanning": False, "status": "Failed to scan"})

    except Exception as e:
        print(e)
        event.data.reference.update(
            {"isScanning": False, "status": "Failed to scan"})
