import pymongo

connection_string = "mongodb://qi-docker01.sqroot.local"
connection = pymongo.MongoClient(connection_string)
database = connection.test


def solution():
    pipeline = [{"$project": {
        "first_char": {"$substr": ["$city", 0, 1]},
        "pop": 1
    }},
        {"$match": {"first_char": {"$in": ["B", "D", "O", "G", "N", "M"]}}},
        {"$group": {
            "_id": "total population",
            "value": {"$sum": "$pop"}
        }}]

    res = database.zips.aggregate(pipeline)

    for doc in res:
        print doc


if __name__ == "__main__":
    solution()