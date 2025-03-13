#ifndef SYSINFO_H
#define SYSINFO_H

#include "types.h"

struct sysinfo {
    uint64 freemem;         // number of bytes of free memory
    uint64 nproc;           // number of process whose state is not unused
    uint64 nopenfiles;      // number of opening files
};

#endif