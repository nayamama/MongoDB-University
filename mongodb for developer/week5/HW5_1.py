import pymongo

connection_string = "mongodb://qi-docker01.sqroot.local"
connection = pymongo.MongoClient(connection_string)
database = connection.blog


def solution():
    pipeline = [{"$unwind": "$comments"},
                {"$group": {
                    "_id": "$comments.author",
                    "count": {"$sum": 1}}},
                {"$sort": {"count": -1}},
                {"$limit": 1}]

    result = database.posts.aggregate(pipeline)  # <- return a command cursor

    for doc in result:
        print doc


if __name__ == "__main__":
    solution()
