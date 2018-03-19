from SimpleCV import *
import time
import subprocess
import simplejson as json

try:
	url = int(sys.argv[1])
	cam = JpegStreamCamera(url)
	msg = "Using camera " + str(sys.argv[1]) + "..."
	print msg
except:
	print "No arguments given. Defaulting to camera 0.."
	cam = JpegStreamCamera("http://192.168.2.5/zm/cgi-bin/nph-zms?mode=jpeg&scale=100&maxfps=5&buffer=1000&monitor=1")

d = Display()
red = (255, 0, 0)
matches = 0

haar = 'face.xml'

while 1:
	img = cam.getImage().scale(320, 240) # get image, scale to speed things up
	img.save(d)
	faces = img.findHaarFeatures(haar)
	if faces:
		faces.draw()
		img.save(d)
		matches += 1
		for f in faces:
			coords = str(f.coordinates())
			strmatches = str(matches)
			face = faces[-1]
			#path = "/home/monkey/nicole/cv/facedetect/saved/"
			#filename = (path + strmatches + ".jpg")
			#face.crop().save(filename)
			printinfo = ("Face found at " + coords)
			print printinfo
			facesjson = json.dumps(coords)
			f = open("/var/www/html/faces_1.json", 'w')
			f.write(facesjson)
			f.close()
