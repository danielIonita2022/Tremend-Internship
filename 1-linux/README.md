# Linux essentials

## • Lookup the Public IP of tremend.com

```bash
apt-get update
apt-get install dnsutils
nslookup tremend.com
```

The public IP addresses are:
176.34.175.11, 52.18.209.114, 34.248.35.216

## • Map IP address 8.8.8.8 to hostname google-dns

```bash
apt-get install nano
nano /etc/hosts
```

- Write "8.8.8.8 google-dns" at the end of the file
- Exit nano (CTRL-X) and save changes

## • Check if the DNS Port is Open for google-dns

```bash
apt-get install netcat-openbsd
nc -zv google-dns 53 && nc -uzv google-dns 53
```

Output:

```
Connection to google-dns (8.8.8.8) 53 port [tcp/*] succeeded!
Connection to google-dns (8.8.8.8) 53 port [udp/*] succeeded!
```
The DNS port (53) is open for both TCP and UDP connections.

## • Modify the System to Use Google’s Public DNS

### o Change the nameserver to 8.8.8.8 instead of the default local configuration.

```bash
nano /etc/resolv.conf
```

### o Perform another public IP lookup for tremend.com and compare the results.

```bash
nslookup tremend.com
```

Differences in output from the previous time the command was ran:

- The address of the DNS server is the one we set in resolv.conf
- The public IP addresses appear in a different order: 52.18.209.114, 34.248.35.216, 176.34.175.11 (but I don't believe this was caused by any changes I made, the addresses are rotated to evenly distribute the traffic)

## • Install and verify that Nginx service is running 

```bash
apt-get install nginx
service nginx start
service nginx status
```

Output:
```
 * nginx is running
```

## • Find the Listening Port for Nginx

```bash
ss -tulnp | grep nginx
```

Based on the output, the listening port is 80.


## • Change the Nginx Listening port to 8080 

```bash
nano /etc/nginx/sites-enabled/default
```

Inside the file change from:

```bash
listen 80 default_server;
listen [::]:80 default_server;
```

to:

```bash
listen 8080 default_server;
listen [::]:8080 default_server;
```

Save and close the file then run:

```bash
service nginx restart
```

If we run the first command again, the screenshot below shows the port has been changed:

![Nginx changed port](/nginx_port_change.png)

## • Modify the default HTML page title

```bash
nano /usr/share/nginx/html/index.html
```

Replace the text within the \<title> tag with "I have completed the Linux part of the Tremend DevOps internship project"

Screenshot of the modified index.html:

![Nginx start page](/nginx_start_page.png)