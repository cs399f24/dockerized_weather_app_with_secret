## Overview

This is the second version of the weather app.  It retains the same three components:

1. A Python program using [`requests`](https://docs.python-requests.org/en/master/) to collect data.
2. The [redis](https://redis.io/) database to store data
3. A [Flask](https://flask.palletsprojects.com/en/2.0.x/) server launched via [gunicorn](https://gunicorn.org/) to server up the data.

The data used in this example is the current temperature in Bethlehem using data from the [WeatherAPI](https://www.weatherapi.com/).

The "application" modeled is intentionally minimal: Every 15 minutes, the collector obtains the current count and stores it in the redis database.  The Flask server has a single end point that allows a user to fetch this data.


![architecture](architecture.png)

The main difference in this version is that the API key is stored in SecretsManager.  As a result, we can fully automate the deployment of the system using the [userdata](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) option when we launch our EC2 instance.

## Changes

* The `collector.py` now reads the API key from SecretsManager instead of the `.env` file.
* Now the data in both `.env` files (collector and server) is simply the *configuration* of redis (host name and port).  Since this data is not sensitive, we can safely add it to the hardcoded launch process.
* Everything is automated via a `deploy.sh` script that can be used as the UserData section in the AWS EC2 launch.



## Deploy

Create an EC2 Instance with the same settings as before:

  * Key pair name: vockey
  * Network settings: "Allow HTTP traffic from the internet"
  * Advanced / IAM instance profile: LabInstanceProfile

In addition, for the userdata, copy the contents of [`deploy.sh`](deploy.sh)


This script will run in the background with all log output posted to `/var/log/cloud-init-output.log`. You can "watch" the script using:

```
tail -f  /var/log/cloud-init-output.log
```

When you see a line that starts `Cloud-init v. 22.2.2 finished`, the script is done, and you can press `ctrl-c` to exit `tail`.


## Validation

If everything worked, you will be able to get the current temperature in Bethlehem by accessing the system.

  ```
  curl localhost
  ```
  
If this works, you can verify that your EC2 instance is configured correctly by connecting to the system using a web browser

  ```
  http://<EC2 IP address>
  ```
  
