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

if [ $NVMEOF_QUANTITY -gt 0 ];then
	modprobe nvmet-rdma
	modprobe nvmet
	modprobe nvme-rdma

	while [ $NVMEOF_QUANTITY -gt 0 ];do
		ENDPOINTS=`flux resource list | awk '/free/ {print $5}'`
		NEXT_ENDPOINT=`python3 cla_hostlist.py -e $ENDPOINTS | sed 's/,/\n/g' | head -1`
		ENDPOINT_ADDRESS=`getent hosts $NEXT_ENDPOINT`
		#nvme discover -t rdma -a $ENDPOINT_ADDRESS -s 4420
		nvme connect -t rdma -n $NEXT_ENDPOINT -a $ENDPOINT_ADDRESS -s 4420
		#lsblk
		#nvme list
		$NVMEOF_QUANTITY--		
	done
fi`
