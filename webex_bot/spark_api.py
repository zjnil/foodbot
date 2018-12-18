import config
import json
import requests
from requests_toolbelt import MultipartEncoder


data = requests.post(
    "http://10.131.138.248:4000"
)

content = json.loads(data.content)["text"]

parts = content.split("\n\n")
data = ""

for i in parts:
    key = i.split("*")[1]
    values = ["{}\n".format(x.strip()) for x in i.split("•")[1:]]

    value = "\t".join(values).strip()
    data = "{}{}\n\t{}\n".format(data, key, value)

my_fields = {
    'roomId': config.RoomId,
    'text': data
}

m = MultipartEncoder(fields=my_fields)

data = requests.post(
    config.ApiUrl, data=m,
    headers={
        'Content-Type': m.content_type,
        'Authorization': config.BearerToken
    }
)
