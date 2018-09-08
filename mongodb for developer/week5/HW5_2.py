import pymongo

connection_string = "mongodb://qi-docker01.sqroot.local"
connection = pymongo.MongoClient(connection_string)
database = connection.test


def solution():
    pipeline = [{"$match": {"state": {"$in": ["CA", "NY"]},
                            "pop": {"$gt": 25000}}},
                {"$group": {
                    "_id": "$city",
                    "city_total": {"$sum": "$pop"}
                }},
                {"$group": {
                    "_id": "average_population",
                    "value": {"$avg": "$city_total"}
                }},
                {"$project": {
                    "_id": 1,
                    "value": {"$trunc": "$value"}
                }}]

    result = database.zips.aggregate(pipeline)

    for doc in result:
        print doc


if __name__ == "__main__":
    solution()
