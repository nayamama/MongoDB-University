"""
{
	"_id" : 0,
	"name" : "aimee Zank",
	"scores" : [
		{
			"type" : "exam",
			"score" : 1.463179736705023
		},
		{
			"type" : "quiz",
			"score" : 11.78273309957772
		},
		{
			"type" : "homework",
			"score" : 6.676176060654615
		},
		{
			"type" : "homework",
			"score" : 35.8740349954354
		}
	]
}

"""
import pymongo

connection = pymongo.MongoClient("mongodb://qi-docker01.sqroot.local")

db = connection.school
collections = db.students


def find():
    """
    remove the lowest homework score for each student
    """
    try:
        cursor = collections.find({})
    except Exception as e:
        print "Error trying to read collection:", type(e), e

    for doc in cursor:
        id = doc["_id"]
        if doc["scores"][2]["score"] <= doc["scores"][3]["score"]:
            lowest = doc["scores"][2]["score"]
        else:
            lowest = doc["scores"][3]["score"]

        collections.update({"_id": id},
                           {"$pull": {"scores": {"score": lowest}}})


if __name__ == '__main__':
    find()
