How to monitor a Zimbra Collaboration Environment using pflogsumm, Telegraf, InfluxDB and Grafana
===================

![alt tag](https://www.jorgedelacruz.es/wp-content/uploads/2017/08/zimbra-grafana-001.png)

This project uses a modified version of the popular pflogsumm script to retrieve the Zimbra collaboration email queues information, and creates an output which we send to InfluxDB using Telegraf, then in Grafana: a Dashboard is created to present all the information.

----------

### Getting started
This dashboard contains multiples sections with the goal to monitor a full Zimbra Collaboration Server or Servers, we have some sections to monitor the Linux and machine overall performance, and one dedicated section just to monitor Zimbra Collaboration. Special thanks to Lex Rivera for his Linux System dashboard - https://grafana.com/orgs/lex

Download the zimbra_pflogsumm.pl and the checkzimbraversion.sh scripts from this repository and save it on the next path: 
```
/opt/zimbra/common/bin/zimbra_pflogsumm.pl
/opt/zimbra/common/bin/checkzimbraversion.sh
chmod +x /opt/zimbra/common/bin/zimbra_pflogsumm.pl
chmod +x /opt/zimbra/common/bin/checkzimbraversion.sh
```
These scripts monitors:
Zimbra Collaboration Performance
* ZCS Version (Only 8.7 and above)
* Received Megabytes
* Delivered Megabytes
* Total Emails/received
* Total Emails/Delivered
* Total Recipients
* Total Senders
* Forwarded
* Deferred
* Bounced
* Rejected
* Held
* Discarded
* Domains Receiving Emails
* Domains Sending Emails

Linux and machine performance:
* CPUs (defaults to all)
* Disks (per-disk IOPS)
* Network interfaces (packets, bandwidth, errors/drops)
* Mountpoints (space / inodes)

### Collector Config

Sample /etc/telegraf/telegraf.conf with inputs for Zimbra Processes, Zimbra Scripts, and Linux System Monitoring:

```
# Read metrics about cpu usage
[[inputs.cpu]]
  ## Whether to report per-cpu stats or not
  percpu = true
  ## Whether to report total system cpu stats or not
  totalcpu = true
  ## Comment this line if you want the raw CPU time metrics
  fielddrop = ["time_*"]

# Read metrics about disk usage by mount point
[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs"]

# Read metrics about disk IO by device
[[inputs.diskio]]

# Get kernel statistics from /proc/stat
[[inputs.kernel]]

# Read metrics about memory usage
[[inputs.mem]]

# Get the number of processes and group them by status
[[inputs.processes]]

# Read metrics about swap memory usage
[[inputs.swap]]

# Read metrics about system load & uptime
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
  commands = ["/opt/zimbra/common/bin/zimbra_pflogsumm.pl -d today /var/log/zimbra.log"]
  name_override = "zimbra_stats"
  data_format = "influx"

[[inputs.exec]]
  commands = ["/opt/zimbra/common/bin/checkzimbraversion.sh"]
  name_override = "zimbra_stats"
  data_format = "value"
  data_type = "string"
```

* Download the grafana-zimbra-collaboration-dashboard.json JSON file and import it into your Grafana
* Change your data inside the Grafana if needed and enjoy :)

----------

### Coming next
This is just a v0.2 of this Dashboard, the next step will be to use the Zimbra SOAP API to obtain some extra information from the Zimbra Collaboration Environment, like:
* Number of Active Users
* Number of Inactive Users
* Number of Domains
* Number of Users with ActiveSync
* etc.

In next versions we will parse directly the logs and put the attempts of logins, and successful logins on a map.