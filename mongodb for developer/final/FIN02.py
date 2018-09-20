import pymongo

connection_string = "mongodb://qi-docker01.sqroot.local"
connection = pymongo.MongoClient(connection_string)
database = connection.enron


def solution():
    pipeline = [{"$unwind": "$headers.To"},
                {"$group": {  # output of group only contains the fields mentioned in group, and must implement aggregation function against each field execpt for _id
                    "_id": "$_id",
                    "To": {"$addToSet": "$headers.To"},
                    "From": {"$first": "$headers.From"}
                }},
                {"$unwind": "$To"},
                {"$group": {
                    "_id": {"sender": "$From", "recipient": "$To"},
                    "count": {"$sum": 1}
                }},
                {"$sort": {"count": -1}},
                {"$limit": 1}
                ]

    res = database.messages.aggregate(pipeline)

    for doc in res:
        print doc


if __name__ == "__main__":
    solution()
