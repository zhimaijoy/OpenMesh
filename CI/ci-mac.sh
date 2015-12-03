#!/bin/bash

#Exit on any error
set -e 

LANGUAGE=$1

PATH=$PATH:/opt/local/bin
export PATH

OPTIONS=""

if [ "$LANGUAGE" == "C++98" ]; then
  echo "Building with C++98";
  BUILDPATH="$BUILDPATH-cpp98"
elif [ "$LANGUAGE" == "C++11" ]; then
  echo "Building with C++11";
  OPTIONS="$OPTIONS -DCMAKE_CXX_FLAGS='-std=c++11' "
  BUILDPATH="$BUILDPATH-cpp11"  
fi  


echo ""
echo ""
echo "======================================================================"
echo "Building Release version with vectorchecks enabled"
echo "====================================================================== \n"


if [ ! -d build-release-$BUILDPATH-Vector-Checks ]; then
  mkdir build-release-$BUILDPATH-Vector-Checks
fi

cd build-release-$BUILDPATH-Vector-Checks

cmake -DCMAKE_BUILD_TYPE=Release -DOPENMESH_BUILD_UNIT_TESTS=TRUE -DSTL_VECTOR_CHECKS=ON -DOPENMESH_BUILD_PYTHON_UNIT_TESTS=OFF $OPTIONS ../

#build it
make

#build the unit tests
make unittests

echo ""
echo ""
echo "======================================================================"
echo "Running unittests Release version with vectorchecks enabled"
echo "====================================================================== \n"


cd Unittests

#execute tests
./unittests --gtest_color=yes --gtest_output=xml

cd ..
cd ..

echo ""
echo ""
echo "======================================================================"
echo "Building Release version with vectorchecks disabled for python tests"
echo "====================================================================== \n"

if [ ! -d build-release-$BUILDPATH ]; then
  mkdir build-release-$BUILDPATH
fi

cd build-release-$BUILDPATH

cmake -DCMAKE_BUILD_TYPE=Release -DOPENMESH_BUILD_PYTHON_UNIT_TESTS=ON -DBUILD_APPS=OFF $OPTIONS ../

#build it
make

echo ""
echo ""
echo "======================================================================"
echo "Running Python unittests Release version "
echo "====================================================================== \n"


# Execute Python unittests
cd Python-Unittests

rm -f openmesh.so
cp ../Build/python/openmesh.so .
python -m unittest discover -v

cd ..
cd ..



echo ""
echo ""
echo "======================================================================"
echo "Building Debug version with vectorchecks enabled"
echo "====================================================================== \n"


if [ ! -d build-debug-$BUILDPATH-Vector-Checks ]; then
  mkdir build-debug-$BUILDPATH-Vector-Checks
fi

cd build-debug-$BUILDPATH-Vector-Checks

cmake -DCMAKE_BUILD_TYPE=Debug -DOPENMESH_BUILD_UNIT_TESTS=TRUE -DSTL_VECTOR_CHECKS=ON -DOPENMESH_BUILD_PYTHON_UNIT_TESTS=OFF $OPTIONS ../

#build it
make

#build the unit tests
make unittests

echo ""
echo ""
echo "======================================================================"
echo "Running unittests Debug version with vectorchecks enabled"
echo "====================================================================== \n"


cd Unittests

#execute tests
./unittests --gtest_color=yes --gtest_output=xml

cd ..
cd ..

echo ""
echo ""
echo "======================================================================"
echo "Building Debug version with vectorchecks disabled for python tests"
echo "====================================================================== \n"

if [ ! -d build-debug-$BUILDPATH ]; then
  mkdir build-debug-$BUILDPATH
fi

cd build-debug-$BUILDPATH

cmake -DCMAKE_BUILD_TYPE=DEBUG -DOPENMESH_BUILD_PYTHON_UNIT_TESTS=ON -DBUILD_APPS=OFF $OPTIONS ../

#build it
make

echo ""
echo ""
echo "======================================================================"
echo "Running Python unittests Debug version "
echo "====================================================================== \n"


# Execute Python unittests
cd Python-Unittests

rm -f openmesh.so
cp ../Build/python/openmesh.so .
python -m unittest discover -v
