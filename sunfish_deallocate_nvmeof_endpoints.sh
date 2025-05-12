#!/bin/bash
###################################################################################
# Assuming that the Flux/Sunfish adapter has created 'Available' NVMeoF endpoints #
# $> flux run --setattr=sunfish-nvmeof-bb=<quantity> 
###################################################################################

JOB_ID=""
JOB_SPEC=""
NVMEOF_QUANTITY=0

JOB_ID=$FLUX_JOB_ID
JOB_SPEC=`flux job info --original $JOB_ID jobspec | jq .attributes.system.environment`

if [ -n `$JOB_SPEC | jq .r sunfish-nvmeof-bb` ];then 
	NVMEOF_QUANTITY=`JOB_SPEC | jq .r sunfish-nvmeof-bb`
fi

while [ `nvme_list` ];do
	#ENDPOINT=`nvme_list | awk '{print $2' |head -1`
	#nvme disconnect -n $ENDPOINT 
done
