#!/usr/bin/python

##############################################################
#  Script     : downloader
#  Author     : Soumitra Kar
#  Description: Downloads from URLs
##############################################################

import sys
import os
import platform
from concurrent.futures import ThreadPoolExecutor
from urllib2 import Request, urlopen, URLError
import boto3
import botocore
from time import time


URL_LIST = sys.argv[1:]

print "Using python version: ", platform.python_version()

def http_endpt(url):
	req = Request(url)
	try:
    		response = urlopen(req)
		with open(os.path.basename(url), "wb") as local_file:
			local_file.write(response.read())
	except URLError as e:
    		if hasattr(e, 'reason'):
        		print 'We failed to reach a server.'
        		print 'Reason: ', e.reason
    		elif hasattr(e, 'code'):
        		print 'The server couldn\'t fulfill the request.'
        		print 'Error code: ', e.code


def s3_endpt(url):
	bucket = url.split('/')[2]
	file = os.path.basename(url)
	s3 = boto3.resource('s3')
	try:
    		s3.Bucket(bucket).download_file(file, file)
	except botocore.exceptions.ClientError as e:
    		if e.response['Error']['Code'] == "404":
        		print("The object does not exist.")

VALID_PROTOCOLS = {"http": http_endpt, "s3": s3_endpt}

def check_url(url):
	
	proto = url.split(':')[0]
	if proto in VALID_PROTOCOLS:
		print "Starting download... :", url
		VALID_PROTOCOLS[proto](url)
		print "Download complete for ", url
	else:
		print "The Protocol :", proto, " : is NOT supported"


#Synchronous
def sync_exec():
	print "Executing sequentially..."
	then = time()
	for url in URL_LIST:
		check_url(url)
	print "Synchronous done in %s" % (time()-then)	

#Async
def async_exec():
	print "Executing concurrently..."
	if len(URL_LIST) < 20:
		pool = ThreadPoolExecutor(len(URL_LIST))
	else:
		pool = ThreadPoolExecutor(20)

	then = time()
	[pool.submit(check_url(url)) for url in URL_LIST]
	print "Threadpool done in %s" % (time()-then)


if __name__ == '__main__':
	sync_exec()
	async_exec()

