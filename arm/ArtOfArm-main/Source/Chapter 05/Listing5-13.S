// Listing 5-13
//
// Recursive quicksort

#include "aoaa.inc"

numElements =       10


            .data
ttlStr:     .asciz  "Listing 5-13"
fmtStr1:    .asciz  "Data before sorting: \n"
fmtStr2:    .ascii  "%d "   //Use nl and 0 from fmtStr3
fmtStr3:    .asciz  "\n"
fmtStr4:    .asciz  "Data after sorting: \n"
fmtStr5:    .asciz  "ary=%p, low=%d, high=%d\n"

theArray:   .word   1,10,2,9,3,8,4,7,5,6
        
            .code
            .extern printf
            
// Return program title to C++ program:

            proc    getTitle, public
            lea     x0, ttlStr
            ret
            endp    getTitle


// quicksort-
//
//  Sorts an array using the quicksort algorithm.
//
// Here's the algorithm in C, so you can follow along:
//
// void quicksort(int a[], int low, int high)
// {
//     int i,j,Middle;
//     if( low < high)
//     {
//         Middle = a[(low+high)/2];
//         i = low;
//         j = high;
//         do
//         {
//             while(a[i] <= Middle) i++;
//             while(a[j] > Middle) j--;
//             if( i <= j)
//             {
//                 swap(a[i],a[j]);
//                 i++;
//                 j--;
//             }
//         } while( i <= j );
//  
//         // recursively sort the two subarrays
//
//         if( low < j ) quicksort(a,low,j);
//         if( i < high) quicksort(a,i,high);
//     }
// }
//
// Args:
//    X19 (_a):      Pointer to array to sort
//    X20 (_lowBnd): Index to low bound of array to sort
//    X21 (_highBnd): Index to high bound of array to sort    

// Within the procedure body, these registers
// have the following meaning:
//
// X19: Pointer to base address of array to sort
// X20: Lower bound of array (32-bit index).
// X21: Higher bound of array (32-bit index).
//
// X22: index (i) into array.
// X23: index (j) into array.
// X24: Middle element to compare against

// Create definitions for variable names as registers
// to make the code more readable.

#define array x19
#define lowBnd x20
#define highBnd x21
#define i x22
#define j x23
#define middle w24

            proc    quicksort
            
            
            locals  qsl
            dword   qsl.saveX19
            dword   qsl.saveX20
            dword   qsl.saveX21
            dword   qsl.saveX22
            dword   qsl.saveX23
            dword   qsl.saveX24
            dword   qsl.saveX0
            byte    qsl.stackSpace, 32
            endl    qsl
            
            enter   qsl.size
            
// Preserve the registers we use:

            str     x0, [fp, #qsl.saveX0]
            str     x19, [fp, #qsl.saveX19]
            str     x22, [fp, #qsl.saveX22]
            str     x23, [fp, #qsl.saveX23]
            str     x24, [fp, #qsl.saveX24]
            
    
            cmp     lowBnd, highBnd
            bge     endif3

            mov     i, lowBnd        //i=low
            mov     j, highBnd       //j=high

// Compute a pivotal element by selecting the
// physical middle element of the array.
//
// Element address = ((i+j)/2) * 4 (4 is element size)//                 = ((i+j) * 2)
        
            add     x0, i, j
            lsr     x0, x0, #1
            ldr     middle, [array, x0, lsl #2]  //Middle = ary[(i+j)/2]
                    

// Repeat until the i and j indexes cross one
// another (i works from the start toward the end
// of the array, j works from the end toward the
// start of the array).

rptUntil:
        
// Scan from the start of the array forward
// looking for the first element greater or equal
// to the middle element).
            
            sub     i, i, #1        //to counteract add, below
while1:     add     i, i, #1        //i = i + 1
            ldr     w1, [array, i, lsl #2]
            cmp     middle, w1      //While middle <= ary[i]
            bgt     while1

// Scan from the end of the array backward looking
// for the first element that is less than or equal
// to the middle element.

            add     j, j, #1     //To counteract sub, below
while2:     sub     j, j, #1     //j = j - 1
            ldr     w1, [array, j, lsl #2]
            cmp     middle, w1   //while Middle >= a[j]
            blt     while2 
            
            
// If we've stopped before the two pointers have
// passed over one another, then we've got two
// elements that are out of order with respect
// to the middle element, so swap these two elements.
            
            cmp     i, j        //If i <= j
            bgt     endif1
            
            ldr     w0, [array, i, lsl #2]
            ldr     w1, [array, j, lsl #2]
            str     w0, [array, j, lsl #2]
            str     w1, [array, i, lsl #2]
            
            add     i, i, #1
            sub     j, j, #1            
                
endif1:     cmp     i, j        //Until i > j
            ble     rptUntil
        
// We have just placed all elements in the array in
// their correct positions with respect to the middle
// element of the array. So all elements at indexes
// greater than the middle element are also numerically
// greater than this element. Likewise, elements at
// indexes less than the middle (pivotal) element are
// now less than that element. Unfortunately, the
// two halves of the array on either side of the pivotal
// element are not yet sorted. Call quicksort recursively
// to sort these two halves if they have more than one
// element in them (if they have zero or one elements, then
// they are already sorted).
        
            cmp     lowBnd, j   //if lowBnd < j
            bge     endif2

            // Note: a is still in X19,
            // Low is still in X20
                
            str     highBnd, [fp, #qsl.saveX21]
            mov     highBnd, j   
            bl      quicksort   //( a, Low, j )
            ldr     highBnd, [fp, #qsl.saveX21]
            
endif2:     cmp     i, highBnd  //if i < High
            bge     endif3

            // Note: a is still in X19,
            // High is still in X21d
              
            str     lowBnd, [fp, #qsl.saveX20]
            mov     lowBnd, i  
            bl      quicksort   //( a, i+1, High )
            ldr     lowBnd, [fp, #qsl.saveX20]

// Restore registers and leave:
            
endif3:
            ldr     x0,  [fp, #qsl.saveX0]
            ldr     x19, [fp, #qsl.saveX19]
            ldr     x22, [fp, #qsl.saveX22]
            ldr     x23, [fp, #qsl.saveX23]
            ldr     x24, [fp, #qsl.saveX24]
            leave
            endp    quicksort
    


// Little utility to print the array elements:

            proc    printArray
            
            locals  pa
            dword   pa.savex19
            dword   pa.savex20
            endl    pa
            
            enter   pa.size
            str     x19, [fp, #pa.savex19]
            str     x20, [fp, #pa.savex20] 
            
            
            lea     x19, theArray
            mov     x20, xzr
whileLT10:  cmp     x20, #numElements
            bge     endwhile1
            
            lea     x0, fmtStr2
            ldr     w1, [x19, x20, lsl #2]
            mstr    w1, [sp]
            bl      printf
            
            add     x20, x20, #1
            b.al    whileLT10

endwhile1:  lea     x0, fmtStr3
            bl      printf

            ldr     x19, [fp, #pa.savex19]
            ldr     x20, [fp, #pa.savex20]
            leave
            endp    printArray



// Here is the "asmMain" function.
        
            proc    asmMain, public
            
            locals  am
            dword   am.savex19
            dword   am.savex20
            dword   am.savex21
            byte    am.stackSpace, 64
            endl    am
            
            enter   am.size
            
            str     array, [fp, #am.savex19]
            str     lowBnd, [fp, #am.savex20]
            str     highBnd, [fp, #am.savex21]
        
// Display unsorted array:

            lea     x0, fmtStr1
            bl      printf
            bl      printArray
            

// Sort the array

            lea     array, theArray
            mov     lowBnd, xzr             //low = 0
            mov     highBnd, #numElements-1 //high= 9
            bl      quicksort               //(theArray, 0, 9)
            
// Display sorted results:

            lea     x0, fmtStr4
            bl      printf
            bl      printArray   
            
            ldr     array, [fp, #am.savex19]
            ldr     lowBnd, [fp, #am.savex20]
            ldr     highBnd, [fp, #am.savex21]
            leave
            endp    asmMain
