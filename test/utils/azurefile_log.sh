# Copyright 2020 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash

# set -e

NS=kube-system
CONTAINER=azurefile

echo "print out all nodes status ..."
kubectl get nodes -o wide
echo "======================================================================================"

echo "print out all default namespace pods status ..."
kubectl get pods -n default -o wide
echo "======================================================================================"

echo "print out all $NS namespace pods status ..."
kubectl get pods -n${NS} -o wide
echo "======================================================================================"

echo "print out csi-azurefile-controller pods ..."
echo "======================================================================================"
LABEL='app=csi-azurefile-controller'
kubectl get pods -n${NS} -l${LABEL} \
    | awk 'NR>1 {print $1}' \
    | xargs -I {} bash -c "echo 'dumping logs for ${NS}/{}/${CONTAINER}' && kubectl logs {} -c${CONTAINER} -n${NS}"

echo "print out csi-azurefile-node logs ..."
echo "======================================================================================"
LABEL='app=csi-azurefile-node'
kubectl get pods -n${NS} -l${LABEL} \
    | awk 'NR>1 {print $1}' \
    | xargs -I {} bash -c "echo 'dumping logs for ${NS}/{}/${CONTAINER}' && kubectl logs {} -c${CONTAINER} -n${NS}"

echo "print out csi-azurefile-node-win logs ..."
echo "======================================================================================"
LABEL='app=csi-azurefile-node-win'
kubectl get pods -n${NS} -l${LABEL} \
    | awk 'NR>1 {print $1}' \
    | xargs -I {} bash -c "echo 'dumping logs for ${NS}/{}/${CONTAINER}' && kubectl logs {} -c${CONTAINER} -n${NS}"

echo "print out cloudprovider_azure metrics ..."
echo "======================================================================================"
ip=`kubectl get svc csi-azurefile-controller -n kube-system | grep azurefile | awk '{print $4}'`
curl http://$ip:29614/metrics
