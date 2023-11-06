from json import dumps
from httplib2 import Http
from dotenv import load_dotenv
from os import getenv

load_dotenv()

def main():
    url = getenv("WEBHOOK_URL")
    message = {
        'text': 'This is a test from the script!'
    }
    headers = {'Content-Type': 'application/json; charset=UTF-8'}
    objects = Http()
    res = objects.request(
        uri=url,
        method='POST',
        headers=headers,
        body=dumps(message)
    )
    print(res)


if __name__=='__main__':
    main()