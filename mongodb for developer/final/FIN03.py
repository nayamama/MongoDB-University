import pymongo

connection_string = "mongodb://qi-docker01.sqroot.local"
connection = pymongo.MongoClient(connection_string)
database = connection.enron


def solution():
    match = {"headers.Message-ID": "<8147308.1075851042335.JavaMail.evans@thyme>"}
    update = {"$push": {"headers.To": "mrpotatohead@mongodb.com"}}

    doc_before = database.messages.find(match)
    for doc in doc_before:
        to_before = doc["headers"]["To"]
        print to_before

    to_after = None
    database.messages.update(match, update)
    doc_after_update = database.messages.find(match)
    for doc in doc_after_update:
        to_after = doc["headers"]["To"]
        print to_after

    assert "mrpotatohead@mongodb.com" in to_after


if __name__ == "__main__":
    solution()
