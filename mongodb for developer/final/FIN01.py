import pymongo

connection_string = "mongodb://qi-docker01.sqroot.local"
connection = pymongo.MongoClient(connection_string)
database = connection.enron


def solution():
    sender = "andrew.fastow@enron.com"
    receiver = "jeff.skilling@enron.com"
    # receiver = "john.lavorato@enron.com"

    query = {"headers.From": sender,
             "headers.To": {"$in": [receiver]}}

    res = database.messages.find(query)

    return res.count()


if __name__ == "__main__":
    print solution()



