import pymongo

connection = pymongo.MongoClient("mongodb://qi-docker01.sqroot.local")

db = connection.students
collections = db.grades


def find():
    project = {"_id": 0}
    query = {'type': 'homework'}
    try:
        cursor = collections.find(query, project)
        cursor = cursor.sort([('student_id', pymongo.ASCENDING),
                              ('score', pymongo.ASCENDING)])
    except Exception as e:
        print "Error trying to read collection:", type(e), e

    # remove every other document when going through along the iteration
    for doc in cursor:
        collections.remove(doc)
        cursor.next()


if __name__ == '__main__':
    find()
