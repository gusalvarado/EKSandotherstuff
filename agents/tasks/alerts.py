import requests

def alert_slack(message, channel):
    payload = {"text": message, "channel": channel}
    requests.post("https://hooks.slack.com/services/...", json=payload)