from SimpleCV import *
import time
import subprocess
import simplejson as json


try:
	video_file=str(sys.argv[1])
	cam =  VirtualCamera(video_file, "video")
except:
	print "Usage : 'python getfaces_movie.py /path/to/file.avi'"
	exit()

d = Display()
red = (255, 0, 0)
matches = 0
haar = '/home/monkey/nicole/cv/haar/face.xml'


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
			#facesjson = json.dumps(coords)
			#f = open("/var/www/html/faces_0.json", 'w')
			#f.write(facesjson)
			#f.close()
