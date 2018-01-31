Squid ssl-bump caching proxy
============================

A caching proxy server to selectively MITM SSL connections to cache the content. Objective is to speed up delivery rather than spy on people. 

Sample config available in the github repo @ https://github.com/jamesyale/squid-sslbump

To build: 

    docker build -t squid-sslbump .

Due to the way squid needs to init it's cache directories and my lack of willingness to use a startup script the squid config / SSL key have to be pushed in at build time, but can be overridden later. 

To run: 

    docker run -d --name squid-sslbump -p 3128:3128 -v `pwd`/logs:/var/log squid-sslbump
