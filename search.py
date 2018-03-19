# USAGE
# python search.py --dataset images --shelve db.shelve --query images/84eba74d-38ae-4bf6-b8bd-79ffa1dad23a.jpg

# import the necessary packages
from PIL import Image
import imagehash
import argparse
import shelve

# construct the argument parse and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-d", "--dataset", required = True,
	help = "path to dataset of images")
ap.add_argument("-s", "--shelve", required = True,
	help = "output shelve database")
ap.add_argument("-q", "--query", required = True,
	help = "path to the query image")
args = vars(ap.parse_args())

# open the shelve database
db = shelve.open(args["shelve"])

# load the query image, compute the difference image hash, and
# and grab the images from the database that have the same hash
# value
querystr = args["query"]
query = Image.open(args["query"])
h = str(imagehash.dhash(query))
filenames = db[h]
#print str(len(filenames))
# loop over the images
for filename in filenames:
	filename = "/home/monkey/nicole/images/" + filename
	if filename != querystr:
		print(filename)


# close the shelve database
db.close()
