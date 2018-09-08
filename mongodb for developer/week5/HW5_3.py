import pymongo

connection_string = "mongodb://qi-docker01.sqroot.local"
connection = pymongo.MongoClient(connection_string)
database = connection.test


def solution():
    pipeline = [{"$unwind": "$scores"},
                {"$match": {"scores.type": {"$ne": "quiz"}}},
                {"$group": {
                    "_id": {"class": "$class_id",
                            "student": "$student_id"},
                    "student_avg": {"$avg": "$scores.score"}
                }},
                {"$group": {
                    "_id": "$_id.class",
                    "class_avg": {"$avg": "$student_avg"}
                }},
                {"$sort": {"class_avg": -1}},
                {"$limit": 1}]

    res = database.grades.aggregate(pipeline)

    for doc in res:
        print doc


if __name__ == "__main__":
    solution()
