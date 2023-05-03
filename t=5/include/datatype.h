#ifndef __DATATYPE_1305_H__
#define __DATATYPE_1305_H__

#define NLIMBS 3
#define u_NLIMBS 6
typedef unsigned char uchar8;
typedef unsigned long long uint64;

typedef struct {
  uint64 l[NLIMBS]; 
}
p1305;

typedef struct {
  uint64 l[u_NLIMBS]; 
}
unreduced_p1305;



#endif


