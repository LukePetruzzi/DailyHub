import json

def getJson():
    return (json.dumps({'file_id': 'this_ass', 'filename': 'is_so_fireflames' , 'links_to' : 'DONKEY!'}))

print(getJson())