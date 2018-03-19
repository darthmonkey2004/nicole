from SimpleCV import *
import sys


try:
	cam=int(sys.argv[1])
except:
	print "Usage : 'python viewcam.py <device>'"
	exit()

cam = Camera(cam)
d = Display(resolution=(1920,1080))
#d = Display(resolution=(1440,900))
while 1:
	img = cam.getImage()
	img.save(d)
