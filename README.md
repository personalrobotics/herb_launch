# herb_launch
Launch files and scripts for HERB.


## Using start scripts

### HERB0
On `HERB0`, run
```
scripts/start_herb0_tmux.sh
```
This script will load `roscore`, `state_publisher`, and `ros_control` in tmux sessions.

### HERB2
On `HERB2`, run
```
scripts/start_herb2_tmux.sh
```
This script will load `multisense`, `apriltags`, and `rcnn_moped` in tmux sessions.


## Load launch files separately

```
source $(catkin locate)/devel/setup.bash
roslaunch herb_launch <file_name.launch>
```


## Initialize WAM controllers

Check [this document on pr_docs/Starting Herb](https://github.com/personalrobotics/pr_docs/wiki/Starting-Herb).


## Etc.

To sync time on Herb machines, run:
```
sudo sntp -s 0.us.pool.ntp.org
sudo ntpd -q
```
on each Herb machine.

