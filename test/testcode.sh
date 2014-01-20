# test location
path=/home/simmondsdj/scripts/test
export PATH=$PATH:$path
cd $path

# set variables in parent shell
a=i; b=j; c=k; d=x; e=y; f=z

# test scripts
echo -e '#!/bin/sh\necho a=${a}, b=${b}, c=${c}, d=${d}, e=${e}, f=${f}' > echoTest; chmod +x echoTest
echo -e '#!/bin/sh\npath=/home/simmondsdj/scripts/test; export a=i; b=j; sh $path/echoTest; export -n a' > prepTest; chmod +x prepTest
echo -e '#!/bin/sh\npath=/home/simmondsdj/scripts/test; export c=k; f=z; qsub -o $1 -j oe -V $2; export -n a' > qsubTest; chmod +x qsubTest

# tests
echoTest > test_echoTest
prepTest > test_prepTest
qsub -o test_qsub_echo -j oe -V echoTest
qsub -o test_qsub_prep -j oe -V prepTest
qsubTest test_qsubTest_echo echoTest
qsubTest test_qsubTest_prep prepTest

# cron test scripts
echo -e '#!/bin/sh\npath=/home/simmondsdj/scripts/test; export path PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin:/usr/local/packages/torque/2.4.16/bin:/usr/kerberos/bin:${path} d=x; e=y; cd $path' > template_cron
cp template_cron echoTest_cron; echo 'echoTest > test_cron_echoTest' >> echoTest_cron; chmod +x echoTest_cron
cp template_cron prepTest_cron; echo 'prepTest > test_cron_prepTest' >> prepTest_cron; chmod +x prepTest_cron
cp template_cron echoTest_cron_qsub; echo 'qsub -o test_cron_qsub_echo -j oe -V echoTest' >> echoTest_cron_qsub; chmod +x echoTest_cron_qsub
cp template_cron prepTest_cron_qsub; echo 'qsub -o test_cron_qsub_prep -j oe -V prepTest' >> prepTest_cron_qsub; chmod +x prepTest_cron_qsub
cp template_cron echoTest_cron_qsubTest; echo 'qsubTest test_cron_qsubTest_echo echoTest' >> echoTest_cron_qsubTest; chmod +x echoTest_cron_qsubTest
cp template_cron prepTest_cron_qsubTest; echo 'qsubTest test_cron_qsubTest_prep prepTest' >> prepTest_cron_qsubTest; chmod +x prepTest_cron_qsubTest

# inside cron
path=/home/simmondsdj/scripts/test
0 0 * * * $path/echoTest_cron
0 0 * * * $path/prepTest_cron
0 0 * * * $path/echoTest_cron_qsub
0 0 * * * $path/prepTest_cron_qsub
0 0 * * * $path/echoTest_cron_qsubTest
0 0 * * * $path/prepTest_cron_qsubTest

# verdict
  # no local shell variables
  # has all exported variables
  # mistake on my end clearly, but why would it have worked in the first place then?

