import os
import json
import urllib.request

url = os.getenv("SLACK_WEBHOOK")
headers = {'Content-Type': 'application/json'}

def lambda_handler(event, context):
    for record in event["Records"]:
        print(record)
        data = json.loads(record["Sns"]["Message"])
        for resource in data["resources"]:
            cluster = resource.split("/")[1]
            service = resource.split("/")[2]
            message = json.dumps({'text': f"Cluster: {cluster}\nService: {service}\nStatus: " + data["detail"]["eventName"]}).encode('utf-8')
            print(message)
            req = urllib.request.Request(url, message, headers)
            resp = urllib.request.urlopen(req)
            response = resp.read()
            print(response)

    return json.loads(record["Sns"]["Message"])


