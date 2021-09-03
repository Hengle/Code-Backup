The problem could be, that in Ubuntu 11.x /bin/sh is linked to /bin/dash and not to bin bash.

check the link:

ls -l /bin/sh

If /bin/sh is a link to /bin/dash, change it to /bin/bash.

sudo mv /bin/sh /bin/sh.orig 

sudo ln -s /bin/bash /bin/sh