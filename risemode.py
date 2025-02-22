import time
import hid
import psutil

VENDOR_ID = 0xAA88  # Rise Mode Aura Ice
PRODUCT_ID = 0x8666
SENSOR = "asus_wmi_sensors"
INTERVAL = 2
TEMP = [0]

def get_cpu_temperature(label="CPU"):
    sensors = psutil.sensors_temperatures()
    for sensor_label, sensor_list in sensors.items():
        for sensor in sensor_list:
            if sensor.label == label:
                return sensor.current

    return 0

def get_temperature():
    try:
        temp = round(psutil.sensors_temperatures()[SENSOR][0].current)
    except KeyError:
        print("Sensor does not exist in the system.")
        temp = get_temperature()
    return temp

try:
    h = hid.device()
    h.open(VENDOR_ID, PRODUCT_ID)
    h.set_nonblocking(1)
    h.write(TEMP)
    while True:
        h.set_nonblocking(1)
        TEMP[0] = get_temperature()
        h.write(TEMP)
        time.sleep(INTERVAL)

except IOError as error:
    print(error)
    print(
        "Ensure that the AK Series CPU cooler is connected and the script has the correct Vendor ID and Product ID."
    )
except KeyboardInterrupt:
    print("Script terminated by user.")
finally:
    if "h" in locals():
        h.close()
