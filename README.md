# herb_launch
Launch files and scripts for HERB.


## Using start scripts

### HERB0

In order to load all ROS nodes for demo, on `HERB0`, run
```
scripts/start_herb_all.sh
```
This script will start all ROS nodes on herb machines. (Four tmux sessions on `herb0`: `roscore`, `ros_control`, `talker`, and `state_publisher`. Five tmux sessions on `herb2`: `multisense`, `apriltags`, `rcnn_moped`, `schunk_neck`, and `neck_simple`.)

If you want to start `HERB0` only, run
```
scripts/start_herb0_tmux.sh
```
This script will load `roscore`, `ros_control`, and `state_publisher` in tmux sessions.

### HERB2

> If you successfully run `start_herb_all.sh` script, all ROS nodes on `herb2` should be loaded. Check tmux sessions with `tmux ls` before running the start script on `herb2`.

On `HERB2`, run
```
scripts/start_herb2_tmux.sh
```
This script will load `multisense`, `apriltags`, `rcnn_moped`, `schunk_neck`, and `neck_simple` in tmux sessions.


## Load launch files separately

```
source $(catkin locate)/devel/setup.bash
roslaunch herb_launch <file_name.launch>
```


## Initialize WAM controllers

Check [this document on pr_docs/Starting Herb](https://github.com/personalrobotics/pr_docs/wiki/Starting-Herb).


## Etc.

### Using tmux

- list sessions: `tmux ls`

- open a new session: `tmux new -s <session name>`

- attach to a session: `tmux a -t <session name>`

- start scrolling in a session: `<ctrl + b> + [` and move cursor

- stop scrolling: press `q` or `esc` in scrolling mode

- detach from a session: `<ctrl + b> + d`

- kill all sessions: `pkill -f tmux`

### Syncing time on HERB machines

To sync time on Herb machines, run:
```
sudo sntp -s 0.us.pool.ntp.org
sudo ntpd -q
```
on each Herb machine.

