---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.16.1
  kernelspec:
    display_name: Python 3 (ipykernel)
    language: python
    name: python3
---

# Bokeh Dashboard


### imports

```python
import pandas as pd

from bokeh.plotting import figure, show
from bokeh.io import output_notebook
from bokeh.layouts import column, row
from bokeh.models import DatetimeTickFormatter, CrosshairTool, HoverTool

output_notebook()
```

#### code for making the dashboard

```python
def make_dashboard():
    h = 300
    w = 600
    p = figure(height=h, width=w, x_axis_type='datetime') 
    p.sizing_mode = "scale_width"
    fmt = "%m-%d\n%H:%M:%S"
    formatter = DatetimeTickFormatter(hours=fmt, days=fmt, months=fmt, years=fmt)
    p.xaxis.formatter= formatter
    #p.add_tools(CrosshairTool())

    p.toolbar.active_drag = None
    p.toolbar.active_scroll = "auto"
    
    battery_percent_fn = "/Users/gsteele/logs/battery_percent.dat"
    battery_percent = pd.read_csv(battery_percent_fn, delimiter=" ", header=None, names=["Timestamp", "Battery %"])
    battery_percent['Time'] = pd.to_datetime(battery_percent['Timestamp'], format="mixed")
    
    x = battery_percent["Time"]
    y = battery_percent["Battery %"]
    l = "Battery"
    p.line(x, y, legend_label=l)
    p.scatter(x, y, legend_label=l, size=5)
    p.legend.location = 'bottom_left'

    p2 = figure(height=h, width=w, x_axis_type='datetime', x_range = p.x_range) 
    p2.sizing_mode = "scale_width"
    fmt = "%m-%d\n%H:%M:%S"
    formatter = DatetimeTickFormatter(hours=fmt, days=fmt, months=fmt, years=fmt)
    p.xaxis.formatter= formatter
    #p.add_tools(CrosshairTool())

    cpu_temp_fn = "/Users/gsteele/logs/cpu_temp.dat"
    cpu_temp = pd.read_csv(cpu_temp_fn, delimiter=" ", header=None, names=["Timestamp", "Temp (C)", "units"])
    cpu_temp['Time'] = pd.to_datetime(cpu_temp['Timestamp'], format="mixed")
    
    c = "orange"
    x = cpu_temp["Time"]
    y = cpu_temp["Temp (C)"]
    l = "Temp (C)"
    p2.line(x, y, legend_label=l, color=c)
    p2.scatter(x, y, legend_label=l, size=5, color=c)
    p2.legend.location = 'bottom_left'
    p2.xaxis.formatter= formatter


    c = column(p,p2)
    for w in p, p2, c:
        w.sizing_mode = "stretch_width"
    target = show(c, notebook_handle=True)

def show_resources(n1=-10, n2=-1, debug = False):
    # Code for parsing the resource status logfile and printing something useful out
    with open("/Users/gsteele/logs/resources_status.log") as f:
        c = f.read() # file contents

    all_entries = c.split("=====\n")
    if n1 < 0:
        n1 = len(all_entries) + n1
    if n2 < 0:
        n2 = len(all_entries) + n2
        
    print("Records: %d" % len(c.split("=====\n")))
    for n in range(n1,n2): 
        e = all_entries[n]
        l = e.split("\n")
        print(l[0], "%d" % n) # date, and index for easy referencing later
        ls = l[1].split()
        # The header
        for ind in 2,3,9,10:
            print(f"{ls[ind]:<12}", end="")
        print()
        # The top 5 processes
        for j in 2,3,4,5,6:
            ls = l[j].split() # spiit on whitespace
            for ind in 2,3,9:
                print(f"{ls[ind]:<12}", end="")
            # The process name often contains full path (not useful)
            # And often a huge number of arguments, which may also contain /
            # So start by splitting on - and grab first element, dropping all args
            cmd = l[j].split(" -")[0]
            # Then split on whitespace, grabbing 10 and rest
            cmd = " ".join(cmd.split()[10:])
            # Then spit on / and grab last one
            cmd = cmd.split("/")[-1]
            # This should now be good enough
            print("%s" % cmd)
            if debug:
                print(l[j])
```

### The dashboard

```python
make_dashboard()
```

```python
show_resources()
```

```python
# how to get more invo on a specific log entry
# n = 1020 
# show_resources(n1=n,n2=n+1,debug=True)
```

```python
!tail -n 20 /Users/gsteele/logs/battery_percent.dat
```

```python
!tail -n 20 /Users/gsteele/logs/cpu_temp.dat
```

```python

```
