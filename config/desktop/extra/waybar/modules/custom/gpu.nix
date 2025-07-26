_: {
  "custom/gpu" = {
    return-type = "";
    exec = "cat /sys/class/hwmon/hwmon2/device/gpu_busy_percent";
    format = " {}%";
    interval = 5;
  };
}
