import pymongo
from pymongo import IndexModel, ASCENDING, DESCENDING

connection_string = "mongodb://qi-docker01.sqroot.local"
connection = pymongo.MongoClient(connection_string)
database = connection.examples


def solution():
    database.numbers1000.drop_indexes()

    if len(database.numbers1000.index_information()) == 1:
        print "There is no user added index against numbers1000 collection."

    # print len(database.numbers1000.index_information())  # <- 1

    index1 = IndexModel([("a", ASCENDING),
                         ("b", ASCENDING)], name="a_1, b_1")
    index2 = IndexModel([("a", ASCENDING),
                         ("c", ASCENDING)], name="a_1, c_1")
    index3 = IndexModel([("c", ASCENDING)], name="c_1")
    index4 = IndexModel([("a", ASCENDING),
                         ("b", ASCENDING),
                         ("c", DESCENDING)], name="a_1, b_1, c_-1")

    database.numbers1000.create_indexes([index1, index2, index3, index4])

    # print len(database.numbers1000.index_information())  # <- 5
    for index in database.numbers1000.list_indexes():
        print index["name"]


if __name__ == "__main__":
    solution()
