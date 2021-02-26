# compile-apache-os-x-webdav
This is a shell script to compile apache https with a patched mod_dav to enable freequota.

The script will install the new apache in /usr/local


```
$ sudo ./make_httpd.sh
```


NOTE : make sure there are no space in the path leading to the shell script... Build will fail.


## Testing custom build / patched Apache verrsion : 

```
$ /usr/local/bin/apachectl -V
```



```
$ /usr/local/bin/apachectl -t -D DUMP_MODULES
```


## Stopping default apache httpd :


```
$ sudo launchctl unload /System/Library/LaunchDaemons/org.apache.httpd.plist
```


## Starting custom build / patched Apache :


```
$ sudo crontab -u root -l
@reboot /bin/sh /usr/local/bin/apachectl start > /dev/null 2>&1
```


## Testing apache dav with non patched version :
  
```
$ curl 'http://192.168.1.xxx/share/' \
  -u user:password \
  --basic \
  -X PROPFIND \
  --data '<?xml version="1.0" ?><D:propfind xmlns:D="DAV:"><D:prop><D:quota-available-bytes/><D:quota-used-bytes/></D:prop></D:propfind>' \
  -H "Depth: 0"

<?xml version="1.0" encoding="utf-8"?>
<D:multistatus xmlns:D="DAV:" xmlns:ns0="DAV:">
<D:response xmlns:g0="DAV:">
<D:href>/share/</D:href>
<D:propstat>
<D:prop>
<g0:quota-available-bytes/>
<g0:quota-used-bytes/>
</D:prop>
<D:status>HTTP/1.1 404 Not Found</D:status>
</D:propstat>
</D:response>
</D:multistatus>
```

## Testing apache dav with patched version :

```

$ curl 'http://192.168.1.xxx/share/' \
  -u user:password \
  --basic \
  -X PROPFIND \
  --data '<?xml version="1.0" ?><D:propfind xmlns:D="DAV:"><D:prop><D:quota-available-bytes/><D:quota-used-bytes/></D:prop></D:propfind>' \
  -H "Depth: 0"

<?xml version="1.0" encoding="utf-8"?>
<D:multistatus xmlns:D="DAV:" xmlns:ns0="DAV:">
<D:response xmlns:lp1="DAV:" xmlns:lp2="http://apache.org/dav/props/">
<D:href>/share/</D:href>
<D:propstat>
<D:prop>
<lp1:quota-available-bytes>129705369600</lp1:quota-available-bytes>
<lp1:quota-used-bytes>370362667008</lp1:quota-used-bytes>
</D:prop>
<D:status>HTTP/1.1 200 OK</D:status>
</D:propstat>
</D:response>
</D:multistatus>
```



