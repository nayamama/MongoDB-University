"""
import base64
code="CmltcG9ydCBweW1vbmdvCmltcG9ydCB1cmxsaWIyCmltcG9ydCB1cmxsaWIKaW1wb3J0IGNvb2tpZWxpYgppbXBvcnQgcmFuZG9tCmltcG9ydCByZQppbXBvcnQgc3RyaW5nCmltcG9ydCBzeXMKaW1wb3J0IGdldG9wdAoKIyB0aGlzIGlzIGEgdmFsaWRhdGlvbiBwcm9ncmFtIHRvIG1ha2Ugc3VyZSB0aGF0IHRoZSBibG9nIHdvcmtzIGNvcnJlY3RseS4KIyBJZiB5b3UgYXJlIHJlYWRpbmcgdGhpcyBpbiBjbGVhciB0ZXh0LCB5b3UgYXJlIHByb2JhYmx5IHZpb2xhdGluZyB0aGUgaG9ub3IgY29kZQoKCiMgZGVjbGFyZSB0aGUgdmFyaWFibGVzIHRvIGNvbm5lY3QgdG8gZGIKY29ubmVjdGlvbiA9IE5vbmUKZGIgPSBOb25lCgp3ZWJob3N0ID0gImxvY2FsaG9zdDo4MDgyIgptb25nb3N0ciA9ICJtb25nb2RiOi8vbG9jYWxob3N0OjI3MDE3IgpkYl9uYW1lID0gImJsb2ciCgoKIyBtYWtlcyBhIGxpdHRsZSBzYWx0CmRlZiBtYWtlX3NhbHQobik6CiAgICBzYWx0ID0gIiIKICAgIGZvciBpIGluIHJhbmdlKG4pOgogICAgICAgIHNhbHQgPSBzYWx0ICsgcmFuZG9tLmNob2ljZShzdHJpbmcuYXNjaWlfbGV0dGVycykKICAgIHJldHVybiBzYWx0CgoKZGVmIGNyZWF0ZV91c2VyKHVzZXJuYW1lLCBwYXNzd29yZCk6CiAgICB0cnk6CiAgICAgICAgcHJpbnQgIlRyeWluZyB0byBjcmVhdGUgYSB0ZXN0IHVzZXIgIiwgdXNlcm5hbWUKICAgICAgICBjaiA9IGNvb2tpZWxpYi5Db29raWVKYXIoKQogICAgICAgIHVybCA9ICJodHRwOi8vezB9L3NpZ251cCIuZm9ybWF0KHdlYmhvc3QpCgogICAgICAgIGRhdGEgPSB1cmxsaWIudXJsZW5jb2RlKFsoImVtYWlsIiwiIiksKCJ1c2VybmFtZSIsdXNlcm5hbWUpLCAoInBhc3N3b3JkIixwYXNzd29yZCksICgidmVyaWZ5IixwYXNzd29yZCldKQogICAgICAgIHJlcXVlc3QgPSB1cmxsaWIyLlJlcXVlc3QodXJsPXVybCwgZGF0YT1kYXRhKQogICAgICAgIG9wZW5lciA9IHVybGxpYjIuYnVpbGRfb3BlbmVyKHVybGxpYjIuSFRUUENvb2tpZVByb2Nlc3NvcihjaikpCiAgICAgICAgZiA9IG9wZW5lci5vcGVuKHJlcXVlc3QpCgogICAgICAgIHVzZXJzID0gZGIudXNlcnMKICAgICAgICB1c2VyID0gdXNlcnMuZmluZF9vbmUoeydfaWQnOnVzZXJuYW1lfSkKICAgICAgICBpZiAodXNlciA9PSBOb25lKToKICAgICAgICAgICAgcHJpbnQgIkNvdWxkIG5vdCBmaW5kIHRoZSB0ZXN0IHVzZXIgIiwgdXNlcm5hbWUsICJpbiB0aGUgdXNlcnMgY29sbGVjdGlvbi4iCiAgICAgICAgICAgIHJldHVybiBGYWxzZQogICAgICAgIHByaW50ICJGb3VuZCB0aGUgdGVzdCB1c2VyICIsIHVzZXJuYW1lLCAiIGluIHRoZSB1c2VycyBjb2xsZWN0aW9uIgoKICAgICAgICAjIGNoZWNrIHRoYXQgdGhlIHVzZXIgaGFzIGJlZW4gYnVpbHQKICAgICAgICByZXN1bHQgPSBmLnJlYWQoKQogICAgICAgIGV4cHIgPSByZS5jb21waWxlKCJXZWxjb21lXHMrIisgdXNlcm5hbWUpCiAgICAgICAgaWYgZXhwci5zZWFyY2gocmVzdWx0KToKICAgICAgICAgICAgcmV0dXJuIFRydWUKICAgICAgICAKICAgICAgICBwcmludCAiV2hlbiB3ZSB0cmllZCB0byBjcmVhdGUgYSB1c2VyLCBoZXJlIGlzIHRoZSBvdXRwdXQgd2UgZ290XG4iCiAgICAgICAgcHJpbnQgcmVzdWx0CiAgICAgICAgCiAgICAgICAgcmV0dXJuIEZhbHNlCiAgICBleGNlcHQ6CiAgICAgICAgcHJpbnQgInRoZSByZXF1ZXN0IHRvICIsIHVybCwgIiBmYWlsZWQsIHNvIHlvdXIgYmxvZyBtYXkgbm90IGJlIHJ1bm5pbmcuIgogICAgICAgIHJldHVybiBGYWxzZQoKCmRlZiB0cnlfdG9fbG9naW4odXNlcm5hbWUsIHBhc3N3b3JkKToKCiAgICB0cnk6CiAgICAgICAgcHJpbnQgIlRyeWluZyB0byBsb2dpbiBmb3IgdGVzdCB1c2VyICIsIHVzZXJuYW1lCiAgICAgICAgY2ogPSBjb29raWVsaWIuQ29va2llSmFyKCkKICAgICAgICB1cmwgPSAiaHR0cDovL3swfS9sb2dpbiIuZm9ybWF0KHdlYmhvc3QpCgogICAgICAgIGRhdGEgPSB1cmxsaWIudXJsZW5jb2RlKFsoInVzZXJuYW1lIix1c2VybmFtZSksICgicGFzc3dvcmQiLHBhc3N3b3JkKV0pCiAgICAgICAgcmVxdWVzdCA9IHVybGxpYjIuUmVxdWVzdCh1cmw9dXJsLCBkYXRhPWRhdGEpCiAgICAgICAgb3BlbmVyID0gdXJsbGliMi5idWlsZF9vcGVuZXIodXJsbGliMi5IVFRQQ29va2llUHJvY2Vzc29yKGNqKSkKICAgICAgICBmID0gb3BlbmVyLm9wZW4ocmVxdWVzdCkKCiAgICAgICAgIyBjaGVjayBmb3Igc3VjY2Vzc2Z1bCBsb2dpbgogICAgICAgIHJlc3VsdCA9IGYucmVhZCgpCiAgICAgICAgZXhwciA9IHJlLmNvbXBpbGUoIldlbGNvbWVccysiKyB1c2VybmFtZSkKICAgICAgICBpZiBleHByLnNlYXJjaChyZXN1bHQpOgogICAgICAgICAgICByZXR1cm4gVHJ1ZQoKICAgICAgICBwcmludCAiV2hlbiB3ZSB0cmllZCB0byBsb2dpbiwgaGVyZSBpcyB0aGUgb3V0cHV0IHdlIGdvdFxuIgogICAgICAgIHByaW50IHJlc3VsdAogICAgICAgIHJldHVybiBGYWxzZQogICAgZXhjZXB0OgogICAgICAgIHByaW50ICJ0aGUgcmVxdWVzdCB0byAiLCB1cmwsICIgZmFpbGVkLCBzbyB5b3VyIGJsb2cgbWF5IG5vdCBiZSBydW5uaW5nLiIKICAgICAgICByYWlzZQogICAgICAgIHJldHVybiBGYWxzZQoKCiMgY29tbWFuZCBsaW5lIGFyZyBwYXJzaW5nIHRvIG1ha2UgZm9sa3MgaGFwcHkgd2hvIHdhbnQgdG8gcnVuIGF0IG1vbmdvbGFicyBvciBtb25nb2hxCiMgdGhpcyBmdW5jdGlvbnMgdXNlcyBnbG9iYWwgdmFycyB0byBjb21tdW5pY2F0ZS4gZm9yZ2l2ZSBtZS4KZGVmIGFyZ19wYXJzaW5nKGFyZ3YpOgoKICAgIGdsb2JhbCB3ZWJob3N0CiAgICBnbG9iYWwgbW9uZ29zdHIKICAgIGdsb2JhbCBkYl9uYW1lCgogICAgdHJ5OgogICAgICAgIG9wdHMsIGFyZ3MgPSBnZXRvcHQuZ2V0b3B0KGFyZ3YsICItcDotbTotZDoiKQogICAgZXhjZXB0IGdldG9wdC5HZXRvcHRFcnJvcjoKICAgICAgICBwcmludCAidXNhZ2UgdmFsaWRhdGUucHkgLXAgd2ViaG9zdCAtbSBtb25nb0Nvbm5lY3RTdHJpbmcgLWQgZGF0YWJhc2VOYW1lIgogICAgICAgIHByaW50ICJcdHdlYmhvc3QgZGVmYXVsdHMgdG8gezB9Ii5mb3JtYXQod2ViaG9zdCkKICAgICAgICBwcmludCAiXHRtb25nb0Nvbm5lY3Rpb25TdHJpbmcgZGVmYXVsdCB0byB7MH0iLmZvcm1hdChtb25nb3N0cikKICAgICAgICBwcmludCAiXHRkYXRhYmFzZU5hbWUgZGVmYXVsdHMgdG8gezB9Ii5mb3JtYXQoZGJfbmFtZSkKICAgICAgICBzeXMuZXhpdCgyKQogICAgZm9yIG9wdCwgYXJnIGluIG9wdHM6CiAgICAgICAgaWYgKG9wdCA9PSAnLWgnKToKICAgICAgICAgICAgcHJpbnQgInVzYWdlIHZhbGlkYXRlLnB5IC1wIHdlYmhvc3QgLW0gbW9uZ29Db25uZWN0U3RyaW5nIC1kIGRhdGFiYXNlTmFtZSIKICAgICAgICAgICAgc3lzLmV4aXQoMikKICAgICAgICBlbGlmIG9wdCBpbiAoIi1wIik6CiAgICAgICAgICAgIHdlYmhvc3QgPSBhcmcKICAgICAgICAgICAgcHJpbnQgIk92ZXJyaWRpbmcgSFRUUCBob3N0IHRvIGJlICIsIHdlYmhvc3QKICAgICAgICBlbGlmIG9wdCBpbiAoIi1tIik6CiAgICAgICAgICAgIG1vbmdvc3RyID0gYXJnCiAgICAgICAgICAgIHByaW50ICJPdmVycmlkaW5nIE1vbmdvREIgY29ubmVjdGlvbiBzdHJpbmcgdG8gYmUgIiwgbW9uZ29zdHIKICAgICAgICBlbGlmIG9wdCBpbiAoIi1kIik6CiAgICAgICAgICAgIGRiX25hbWUgPSBhcmcKICAgICAgICAgICAgcHJpbnQgIk92ZXJyaWRpbmcgTW9uZ29EQiBkYXRhYmFzZSB0byBiZSAiLCBkYl9uYW1lCgoKIyBtYWluIHNlY3Rpb24gb2YgdGhlIGNvZGUKZGVmIG1haW4oYXJndik6CiAgICAgICAgICAgIAogICAgYXJnX3BhcnNpbmcoYXJndikKICAgIGdsb2JhbCBjb25uZWN0aW9uCiAgICBnbG9iYWwgZGIKCiAgICBwcmludCAiV2VsY29tZSB0byB0aGUgSFcgMi4zIHZhbGlkYXRpb24gdGVzdGVyIgoKICAgICMgY29ubmVjdCB0byB0aGUgZGIgKG1vbmdvc3RyIHdhcyBzZXQgaW4gYXJnX3BhcnNpbmcpCiAgICBjb25uZWN0aW9uID0gcHltb25nby5Nb25nb0NsaWVudChtb25nb3N0cikKICAgIGRiID0gY29ubmVjdGlvbltkYl9uYW1lXQogICAgICAgICAgICAKCiAgICB1c2VybmFtZSA9IG1ha2Vfc2FsdCg3KQogICAgcGFzc3dvcmQgPSBtYWtlX3NhbHQoOCkKCiAgICAjIHRyeSB0byBjcmVhdGUgdXNlcgoKICAgIGlmIChjcmVhdGVfdXNlcih1c2VybmFtZSwgcGFzc3dvcmQpKToKICAgICAgICBwcmludCAiVXNlciBjcmVhdGlvbiBzdWNjZXNzZnVsLiAiCiAgICAgICAgIyB0cnkgdG8gbG9naW4KICAgICAgICBpZiAodHJ5X3RvX2xvZ2luKHVzZXJuYW1lLCBwYXNzd29yZCkpOgogICAgICAgICAgICBwcmludCAiVXNlciBsb2dpbiBzdWNjZXNzZnVsLiIKICAgICAgICAgICAgcHJpbnQgIlZhbGlkYXRpb24gQ29kZSBpcyAiLCAiamtmZHM1ODM0ajk4Zm5tMzluamYwOTIwZjAyIgogICAgICAgIGVsc2U6CiAgICAgICAgICAgIHByaW50ICJVc2VyIGxvZ2luIGZhaWxlZCIKICAgICAgICAgICAgcHJpbnQgIlNvcnJ5LCB5b3UgaGF2ZSBub3Qgc29sdmVkIGl0IHlldC4iCgogICAgZWxzZToKICAgICAgICBwcmludCAiU29ycnksIHlvdSBoYXZlIG5vdCBzb2x2ZWQgaXQgeWV0LiIKICAgICAgICBzeXMuZXhpdCgxKQoKCmlmIF9fbmFtZV9fID09ICJfX21haW5fXyI6CiAgICBtYWluKHN5cy5hcmd2WzE6XSkKCgoKCgoKCg=="
print base64.b64decode(code).decode('utf-8')
"""

import pymongo
import urllib2
import urllib
import cookielib
import random
import re
import string
import sys
import getopt

# this is a validation program to make sure that the blog works correctly.
# If you are reading this in clear text, you are probably violating the honor code
# declare the variables to connect to db
connection = None
db = None
webhost = "localhost:8082"
mongostr = "mongodb://qi-docker01.sqroot.local"
db_name = "blog"


# makes a little salt
def make_salt(n):
    salt = ""
    for i in range(n):
        salt = salt + random.choice(string.ascii_letters)
    return salt


def create_user(username, password):
    try:
        print "Trying to create a test user ", username
        cj = cookielib.CookieJar()
        url = "http://{0}/signup".format(webhost)
        data = urllib.urlencode([("email", ""), ("username", username), ("password", password), ("verify", password)])
        request = urllib2.Request(url=url, data=data)
        opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
        f = opener.open(request)
        users = db.users
        user = users.find_one({'_id': username})
        if (user == None):
            print "Could not find the test user ", username, "in the users collection."
            return False
        print "Found the test user ", username, " in the users collection"
        # check that the user has been built
        result = f.read()
        expr = re.compile("Welcome\s+" + username)
        if expr.search(result):
            return True

        print "When we tried to create a user, here is the output we got\n"
        print result

        return False
    except:
        print "the request to ", url, " failed, so your blog may not be running."
        return False


def try_to_login(username, password):
    try:
        print "Trying to login for test user ", username
        cj = cookielib.CookieJar()
        url = "http://{0}/login".format(webhost)
        data = urllib.urlencode([("username", username), ("password", password)])
        request = urllib2.Request(url=url, data=data)
        opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
        f = opener.open(request)
        # check for successful login
        result = f.read()
        expr = re.compile("Welcome\s+" + username)
        if expr.search(result):
            return True
        print "When we tried to login, here is the output we got\n"
        print result
        return False
    except:
        print "the request to ", url, " failed, so your blog may not be running."
        raise
        return False


# command line arg parsing to make folks happy who want to run at mongolabs or mongohq
# this functions uses global vars to communicate. forgive me.
def arg_parsing(argv):
    global webhost
    global mongostr
    global db_name
    try:
        opts, args = getopt.getopt(argv, "-p:-m:-d:")
    except getopt.GetoptError:
        print "usage validate.py -p webhost -m mongoConnectString -d databaseName"
        print "\twebhost defaults to {0}".format(webhost)
        print "\tmongoConnectionString default to {0}".format(mongostr)
        print "\tdatabaseName defaults to {0}".format(db_name)
        sys.exit(2)
    for opt, arg in opts:
        if (opt == '-h'):
            print "usage validate.py -p webhost -m mongoConnectString -d databaseName"
            sys.exit(2)
        elif opt in ("-p"):
            webhost = arg
            print "Overriding HTTP host to be ", webhost
        elif opt in ("-m"):
            mongostr = arg
            print "Overriding MongoDB connection string to be ", mongostr
        elif opt in ("-d"):
            db_name = arg
            print "Overriding MongoDB database to be ", db_name


# main section of the code
def main(argv):
    arg_parsing(argv)
    global connection
    global db
    print "Welcome to the HW 2.3 validation tester"
    # connect to the db (mongostr was set in arg_parsing)
    connection = pymongo.MongoClient(mongostr)
    db = connection[db_name]

    username = make_salt(7)
    password = make_salt(8)
    # try to create user
    if (create_user(username, password)):
        print "User creation successful. "
        # try to login
        if (try_to_login(username, password)):
            print "User login successful."
            print "Validation Code is ", "jkfds5834j98fnm39njf0920f02"
        else:
            print "User login failed"
            print "Sorry, you have not solved it yet."
    else:
        print "Sorry, you have not solved it yet."
        sys.exit(1)


if __name__ == "__main__":
    main(sys.argv[1:])

