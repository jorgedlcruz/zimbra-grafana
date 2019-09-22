How to monitor a Zimbra Collaboration Environment using pflogsumm, Telegraf, InfluxDB and Grafana
===================

![alt tag](https://www.jorgedelacruz.es/wp-content/uploads/2019/09/zimbra-monitoring-grafana-001.png)

*Note: This project is a Community contribution, not tested neither supported officialy by Zimbra. Use it at your own risk. 

----------

### Getting started
This dashboard contains multiples sections with the goal to monitor a full Zimbra Collaboration Server or Servers, we have some sections to monitor the Linux and machine overall performance, and one dedicated section just to monitor Zimbra Collaboration. Special thanks to [Lex Rivera for his Linux System dashboard](https://grafana.com/orgs/lex)

Download the checkzimbraversion.sh scripts from the [GitHub repository](https://github.com/jorgedlcruz/zimbra-grafana) and save it on the next path: 
```
/opt/zimbra/common/bin/checkzimbraversion.sh
chmod +x /opt/zimbra/common/bin/checkzimbraversion.sh
```
More information available in: [https://github.com/jorgedlcruz/zimbra-grafana](https://github.com/jorgedlcruz/zimbra-grafana)

Zimbra Collaboration Performance
* ZCS Version (Only 8.7 and above)
* Received Megabytes
* Total Emails/received
* Deferred
* Held
* Incoming
* Maildrop

Linux and machine performance:
* CPUs (defaults to all)
* Disks (per-disk IOPS)
* Network interfaces (packets, bandwidth, errors/drops)
* Mountpoints (space / inodes)

### Coming next
This is just a v0.3 of this Dashboard, the next step will be to use the Zimbra SOAP API to obtain some extra information from the Zimbra Collaboration Environment, like:
* Number of Active Users
* Number of Inactive Users
* Number of Domains
* Number of Users with ActiveSync
* etc.

### Collector Config
Sample /etc/telegraf.d/zimbra.conf with inputs for Zimbra Processes, Zimbra Scripts, and Linux System Monitoring:

```
# Read metrics about cpu usage
[[inputs.cpu]]
  percpu = true
  totalcpu = true
  fielddrop = ["time_*"]

# Read metrics about disk usage by mount point
[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs"]

[[inputs.diskio]]

[[inputs.kernel]]

[[inputs.mem]]

[[inputs.processes]]

[[inputs.swap]]

[[inputs.system]]

[[inputs.procstat]]
  exe = "memcached"
  prefix = "memcached"

[[inputs.procstat]]
  exe = "java"
  prefix = "java"

[[inputs.procstat]]
  exe = "mysqld"
  prefix = "mysqld"

[[inputs.procstat]]
  exe = "slapd"
  prefix = "slapd"

[[inputs.procstat]]
  exe = "nginx"
  prefix = "nginx"

[[inputs.net]]

[[inputs.exec]]
  commands = ["/opt/zimbra/common/bin/checkzimbraversion.sh"]
  name_override = "zimbra_stats"
  data_format = "value"
  data_type = "string"

# # OpenLDAP cn=Monitor plugin
# # As zimbra user run the next to obatin the password zmlocalconfig -s zimbra_ldap_password ldap_master_url
 [[inputs.openldap]]
   host = "YOURZIMBRASERVERHOSTNAME"
   port = 389
   insecure_skip_verify = true
   bind_dn = "uid=zimbra,cn=admins,cn=zimbra"
   bind_password = "YOURZIMBRALDAPPASSWORD"
   reverse_metric_names = true

 [[inputs.postfix]]
    queue_directory = "/opt/zimbra/data/postfix/spool"
    interval = "1s"
```

* Download the grafana-zimbra-collaboration-dashboard.json JSON file and import it into your Grafana
* Change your data inside the Grafana if needed and enjoy :)

----------

### Coming next
This is just a v0.3 of this Dashboard, the next step will be to use the Zimbra SOAP API to obtain some extra information from the Zimbra Collaboration Environment, like:
* Number of Active Users
* Number of Inactive Users
* Number of Domains
* Number of Users with ActiveSync
* etc.

In next versions we will parse directly the logs and put the attempts of logins, and successful logins on a map.