#include<stdio.h>
#include<stdlib.h>
#include <time.h>
#include "p1305.h"
#include "datatype.h"
#include <string.h>
#include<math.h>
#include "measure.h"

#define change_input(x,y,z)  {x[0] = y[0]^z[0];}


int main(int argc, char*argv[]){
   int i,j;
   
   unsigned char *temp1,*temp3;
   unsigned char*tag;
   
 
   unsigned int no_of_bytes,lg,no_of_bits,rem;
   double x,cpb;
   unsigned char h[16]={0};
   
   if(argc!=2){
   	printf("please enter the length of the message in terms of bits\n");
   	exit(1);
   }
   
   
   
   no_of_bits=(unsigned int)atoi(argv[1]);
   
   if(no_of_bits<0 || no_of_bits>65536){
   		printf("length out of bounds\n");
   		exit(1);
   }
   
   rem=no_of_bits % 8;
   no_of_bytes=no_of_bits/8;
   
   
   
        
   temp1=(unsigned char*)calloc(sizeof(unsigned char),16*sizeof(char));
   
   temp3=(unsigned char*)calloc(sizeof(unsigned char),(no_of_bytes+16)*sizeof(char));
   
   tag=(unsigned char*) calloc(sizeof(unsigned char),16);
   
    srand(time(0));
   
   
   for(i=0;i<no_of_bytes;i++){
   	temp3[i]=rand()%0xff;
   }
   
   
   if(rem!=0){
      no_of_bytes=no_of_bytes+1;
     
        switch(rem){
        
        	case 1: temp3[no_of_bytes-1]= rand()%0x1;
        		
        		break;
        	case 2: temp3[no_of_bytes-1]= rand()%0x3;
        		
        		break;
               case 3: temp3[no_of_bytes-1]= rand()%0x7;
               	
        		break;
               case 4: temp3[no_of_bytes-1]= rand()%0xf;
               	
        		break;
               case 5: temp3[no_of_bytes-1]= rand()%0x1f;
               	
        		break;
               case 6: temp3[no_of_bytes-1]= rand()%0x2f;
               	
        		break;
        	case 7: temp3[no_of_bytes-1]= rand()%0x3f;
        		
        	
        }
    
   }
    
   for(i=0;i<16;i++){
   	temp1[i]=rand()%0xff;
   }
  
   
   
  
  if(no_of_bits>0){
  x=(double)(no_of_bytes/16.0);
  x=ceil(x);
  lg=ceil(log(x)/log(2));
    
  p1305_nrBRW_computation(no_of_bits,temp3,temp1,tag);
  
  printf("\noutput: ");
   for(i=15;i>0;i--){
  		printf("%x",tag[i]); 
   }
   printf("%x", tag[i]);
   
  
  srand(time(0));
  
  
  MEASURE_TIME({p1305_nrBRW_computation(no_of_bits,temp3,temp1,tag); change_input(temp3,h,temp1);});
  
  cpb=((get_median())/(double)(no_of_bytes*N));
  
  printf("\nCPU-cycles per byte: %6.4lf\n\n", cpb);
  } 
  
  else{
        printf("The input was an empty string\n");
        printf("output:\n");
   	for(i=15;i>=0;i--){
  		printf("%x",tag[i]); 
   }	
   
   }  
  printf("\n");
     
  return 0;
}

