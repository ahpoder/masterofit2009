psql -U postgres -d postgres -a  -v ON_ERROR_STOP=1 -f %1 > dumpfile.txt