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
from bokeh.layouts import row
from bokeh.models import DatetimeTickFormatter, CrosshairTool, HoverTool

output_notebook()
```

#### code for making the dashboard

```python
def make_dashboard():
    p = figure(height=200, width=600, x_axis_type='datetime') 
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
    show(p)

    p = figure(height=200, width=600, x_axis_type='datetime') 
    p.sizing_mode = "scale_width"
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
    p.line(x, y, legend_label=l, color=c)
    p.scatter(x, y, legend_label=l, size=5, color=c)

    p.legend.location = 'bottom_left'
    show(p)
```

### The dashboard

```python
make_dashboard()
```

### The logfiles

```python
!tail -n 20 /Users/gsteele/logs/battery_percent.dat
```

```python
!tail -n 20 /Users/gsteele/logs/cpu_temp.dat
```

```python
!tail -n 100 /Users/gsteele/logs/battery_status.log
```

```python
# Code for parsing the resource status logfile and printing something useful out

for e in c.split("=====\n")[-10:]:
    l = e.split("\n")
    print(l[0])
    ls = l[1].split()
    for ind in 2,3,9,10:
        print(f"{ls[ind]:<12}", end="")
    print()
    for j in 2,3,4,5,6:
        ls = l[j].split()
        for ind in 2,3,9:
            print(f"{ls[ind]:<12}", end="")
        print("%s" % ls[10].split("/")[-1])
```
