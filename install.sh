#!/bin/bash
#
# ofxOpenCvContrib 
# install opencv with its contrib libraries as an openFrameworks addon.
# https://github.com/opencv/opencv.git

# some colors to make the cheer up the terminal :)
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'
BOLD='\033[1;39m'
# echo -e "${CYAN}color${RED}citos!${NC}"

ADDON_PATH="`dirname \"$0\"`"              # relative
ADDON_PATH="`( cd \"$ADDON_PATH\" && pwd )`"  # absolutized and normalized
if [ -z "$ADDON_PATH" ] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
echo "script path not accessible. Check file permissions. Exiting..."
  exit 1  # fail
fi
# echo "$ADDON_PATH"


command -v brew >/dev/null 2>&1

if [ $? -eq 1 ]; then
echo -e "${RED}Homebrew is required but it's not installed.${NC}"
echo -e "press the ${BOLD}Y${NC} key to install Homebrew, or any other key to quit"
while true; do
read -rsn1 input
if [ "$input" = "y" ] || [ "$input" = "Y" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    break
else
  echo -e "${YELLOW}Nothing was installed. Exiting.${NC}"
  exit 0;
fi
done
fi

brew list opencv >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo -e "${YELLOW}install opencv${NC}"
  brew install opencv
  if [ $? -ne 0 ]; then
    echo -e "${RED}Something went wrong while trying to install opencv using homebrew. exiting${NC}"
  fi
fi



OPENCV_DIR="`brew --prefix opencv`"

OPENCV_DIR="`( cd -P \"$OPENCV_DIR\" && pwd )`" 

ADDON_LIBS_PATH=libs/opencv/lib/osx/
ADDON_INCLUDE_PATH=libs/opencv/include/
echo -e "${YELLOW}Copying opencv libs to addon.${NC}"
cd "$ADDON_PATH"
#find "$OPENCV_DIR/lib/" -name \*.a -exec cp {} libs/opencv/lib/osx/ \;
find "$OPENCV_DIR/lib" -name "*.a" -exec cp -f {} "$ADDON_LIBS_PATH" \;
echo -e "${YELLOW}Copying opencv includes to addon.${NC}"
cp -r "$OPENCV_DIR/include" "$ADDON_INCLUDE_PATH"
echo -e "${YELLOW}DONE!${NC}"