
echo "convert image to singularity image"
docker run \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v `pwd`:/output \
	--privileged -t --rm \
	singularityware/docker2singularity soichih/tensorflow-bigred2
