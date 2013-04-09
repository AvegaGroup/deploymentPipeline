#!/bin/sh
export VI_PASSWORD=mysecret
export VI_SERVER=esx.hem.sennerholm.net
export VI_USERNAME=root
for i in `seq 1 31`
do 
  cat /tmp/puppetcreate.xml | sed s/%nr/$i/g > /tmp/puppetcreatetmp.xml && /usr/lib/vmware-vcli/apps/vm/vmcreate64.pl --filename /tmp/puppetcreatetmp.xml && /usr/lib/vmware-vcli/apps/vm/vmcontrol.pl --vmname labm_$i --operation poweron && /usr/lib/vmware-vcli/apps/vm/vmcontrol.pl --vmname labs_$i --operation poweron && echo Done with $i
  sleep 600
done
