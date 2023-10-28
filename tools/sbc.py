import sys
import screen_brightness_control as sbc
arg = sys.argv[1] if len(sys.argv) > 1 else "100"
b = sbc.get_brightness()[0]
newb = b + int(arg) if arg.startswith('-') or arg.startswith('+') else int(arg)
newb = max(0, min(100, newb))
sbc.set_brightness(newb)
print(newb)