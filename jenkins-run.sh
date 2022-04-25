pattern=" |'"
if [[ $SPOTINST_GROUP_NAME =~ $pattern ]]; then
	echo "SPOTINST_GROUP_NAME can't contain spaces"
    exit 1
fi



if [[ -e "${WORKSPACE}/pemfile.pem" ]]; then 
	rm -f ${WORKSPACE}/pemfile.pem
fi

if [[ "${PREPARE_FOR}" == "BACKWARDS" ]]; then
	export HOSTS_FILE="${WORKSPACE}/../Backwards/all_hosts"
elif [[ "${PREPARE_FOR}" == "PERFORMANCE_EMBEDDED" ]]; then
	export HOSTS_FILE="${WORKSPACE}/../Performance-Embedded/all_hosts"
elif [[ "${PREPARE_FOR}" == "PERFORMANCE_REMOTE" ]]; then
	export HOSTS_FILE="${WORKSPACE}/../Performance-Remote/all_hosts"
elif [[ "${PREPARE_FOR}" == "PERFORMANCE_REMOTE_2_1" ]]; then
	export HOSTS_FILE="${WORKSPACE}/../Performance-Remote-2-1/all_hosts"
else 
	export HOSTS_FILE="${WORKSPACE}/all_hosts"
fi

HOSTS_DIR=$(dirname ${HOSTS_FILE})
if [[ ! -e "${HOSTS_DIR}" ]]; then
	mkdir -p ${HOSTS_DIR}
fi




cd ansible
if [[ ! -e "${WORKSPACE}/pemfile" ]]; then
	echo "Pem file was not provided"
    exit 1
fi
cp ${WORKSPACE}/pemfile ${WORKSPACE}/pemfile.pem
export PEM_FILE_LOCATION=${WORKSPACE}/pemfile.pem
    
chmod 400 ${WORKSPACE}/pemfile.pem

./create_varsfile.sh

curl -X GET http://localhost:8080/job/Metric/job/Spotinst/job/Templates/job/Spotinst-Delete-Machines-Template/config.xml -u jenkins:ec11e72141e663c7bc9ade972b2c0ab4 -o myconfig.xml
lineNum=$(awk '/ALL_CONTENT_HERE/{ print NR; exit }' myconfig.xml)
if [[ -z "${lineNum}" ]]; then
	echo "could not find text in file"
    exit 1
fi

head -n $(( ${lineNum} - 1 )) myconfig.xml > newconfig.xml
echo "<defaultValue>" >> newconfig.xml
cat ${WORKSPACE}/ansible/group_vars/all >> newconfig.xml
echo "</defaultValue>" >> newconfig.xml
tail -n +$(( ${lineNum} + 1 )) myconfig.xml >> newconfig.xml


#cat newconfig.xml
curl -s -XPOST "http://localhost:8080/job/Metric/job/Spotinst/createItem?name=Spotinst-Delete-${SPOTINST_GROUP_NAME}" -u jenkins:ec11e72141e663c7bc9ade972b2c0ab4 --data-binary @newconfig.xml -H "Content-Type:text/xml"



./start.sh
