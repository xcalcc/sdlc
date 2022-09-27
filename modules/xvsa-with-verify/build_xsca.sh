BRANCH=$1

echo "Building xsca lib..."
mkdir lib
docker run --rm -v $(pwd)/lib:/home/lib -w /home xcal.build.xsca:1.0 bash /home/buildxsca.sh $BRANCH

cat ./lib/VER >> ../xvsa/COMPONENTS.json