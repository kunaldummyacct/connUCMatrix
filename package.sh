#!/bin/bash

echo "Creating distribution package..."

# Create dist directory
mkdir -p dist
cd dist

# Create package directory
PACKAGE_NAME="connUCMatrix-portable"
rm -rf $PACKAGE_NAME
mkdir $PACKAGE_NAME

# Copy necessary files
cp ../app.py $PACKAGE_NAME/
cp ../requirements.txt $PACKAGE_NAME/
cp ../README.md $PACKAGE_NAME/
cp ../QUICKSTART.txt $PACKAGE_NAME/
cp ../setup.bat $PACKAGE_NAME/
cp ../setup.sh $PACKAGE_NAME/
cp ../run.bat $PACKAGE_NAME/
cp ../run.sh $PACKAGE_NAME/

# Copy templates
mkdir -p $PACKAGE_NAME/templates
cp ../templates/*.html $PACKAGE_NAME/templates/

# Make scripts executable
chmod +x $PACKAGE_NAME/setup.sh
chmod +x $PACKAGE_NAME/run.sh

# Create zip file
ZIP_NAME="${PACKAGE_NAME}.zip"
rm -f $ZIP_NAME

if command -v zip &> /dev/null; then
    zip -r $ZIP_NAME $PACKAGE_NAME
    echo "Package created: dist/$ZIP_NAME"
else
    echo "zip command not found, creating tar.gz instead"
    tar -czf "${PACKAGE_NAME}.tar.gz" $PACKAGE_NAME
    echo "Package created: dist/${PACKAGE_NAME}.tar.gz"
fi

echo ""
echo "Distribution package ready!"
echo "Users should:"
echo "1. Extract the package"
echo "2. Place their ConnUCMatrix.xlsx file in the extracted folder"
echo "3. Run setup script (setup.bat for Windows, ./setup.sh for Mac/Linux)"
echo "4. Run the application (run.bat for Windows, ./run.sh for Mac/Linux)"
