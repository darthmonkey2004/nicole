#!/usr/bin/env python
# -*- coding: utf-8 -*-

import aiml
import os
import sys
import subprocess
import re

brainfile="nicole.brn"
if sys.argv[1]:
	sessionid = sys.argv[1]
else:
	sessionid = 1234567890
if sys.argv[2]:
	userdir = sys.argv[2]
userdatafile = (userdir + "/nicole/nicchat/userdata/" + sessionid + ".txt")
if os.path.isfile(userdatafile):
	execfile(userdatafile)
	print name

kernel = aiml.Kernel()
if os.path.isfile(brainfile):
	kernel.bootstrap(brainFile = brainfile)
else:
	kernel.bootstrap(learnFiles = "std-startup.xml", commands = "load aiml b")
	kernel.saveBrain(brainfile)
sessionData = kernel.getSessionData(sessionid)

data = raw_input()
userin = data.split('\n')
userin = userin[0]
string = str(userin)
results = (re.search('=', string))
results = str(results)
if (results == "None"):
	if string == "quit":
		exit()
	elif string == "save":
		kernel.saveBrain(brainfile)
	else:
		sessionData = kernel.getSessionData(sessionid)
		response = kernel.respond(userin, sessionid)
		print (response)
elif (results != "None"):
	ary = string.split(',')
	pos = -1
	for i in ary:
		pos = (pos + 1)
		string = ary[pos]
		pieces = string.split()
		method = pieces[0]
		if (method == "set"):
			args = pieces[1]
			command = args.split('=')
			var = command[0]
			val = command[1]
			kernel.setPredicate(var, val, sessionid)
			print ("I set " + var + " to " + val + ".")

		elif (method == "com"):
			com = pieces[1]
			path = ("scripts/" + com)
			if os.path.isfile(path):
				response = ("Running" + args)
				print response
				subprocess.call(com)
				response = (com + "Executed.")
				print response
		elif (method == "get"):
			var = pieces[1]
			print var
			val = kernel.getPredicate(var, sessionid)
			response = (var + " is " + val)
			print response
		else:
			print "Sorry, I was unable to locate that command. Please ensure the script file is in my 'scripts' directory in my home folder."
			print ("Command was " + method)

