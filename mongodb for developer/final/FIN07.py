import pymongo
from pymongo import IndexModel, ASCENDING

connection_string = "mongodb://qi-docker01.sqroot.local"
connection = pymongo.MongoClient(connection_string)
database = connection.photos


def get_all_imageid_in_album():
    pipeline = [{"$unwind": "$images"},
                {"$project":
                     {"_id": 0,
                      "image_id": "$images"}}
                ]

    image_id = set()

    res = database.albums.aggregate(pipeline)
    for doc in res:
        image_id.add(doc["image_id"])

    return image_id


def solution():
    idxes = get_all_imageid_in_album()

    index = IndexModel([("tags", ASCENDING)], name="tags_index")
    database.images.create_indexes([index])

    query = {"tags": {"$in": ["kittens"]}}
    count_before = database.images.find(query).count()
    print "The total number of kittens before the removal is %d" % count_before

    cursor = database.images.find({})

    for doc in cursor:
        if doc["_id"] not in idxes:
            database.images.remove({"_id": doc["_id"]})

    count_after = database.images.find(query).count()
    print "The total number of kittens after the removal is %d" % count_after


if __name__ == "__main__":
    solution()