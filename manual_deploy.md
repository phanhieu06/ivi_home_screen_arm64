# IVI Home Screen ARM64 - Manual Deploy Instructions

## Package Contents:
- ivi_home_screen: ARM64 executable (16KB)
- engine_arm64/: Flutter engine and assets (64MB) 
- deploy.sh: Automatic deploy script (for ADB)
- main.cpp: Source code

## Deploy Steps on ARM64 Device:

1. Extract package:
   tar -xzf ivi_home_screen_arm64.tar.gz
   cd ivi_home_screen/

2. Set permissions:
   chmod +x ivi_home_screen

3. Run application:
   export LD_LIBRARY_PATH=./engine_arm64:$LD_LIBRARY_PATH
   ./ivi_home_screen

## Requirements:
- ARM64 Linux (kernel 3.7.0+)
- libstdc++6, libc6
- Wayland/Weston display server

## Expected Output:
Starting IVI Home Screen Application...
Flutter engine initialized successfully!
IVI Home Screen is running...
Press Enter to exit...

Note: This binary only runs on ARM64 devices.
