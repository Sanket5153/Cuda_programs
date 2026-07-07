#include <stdio.h>
#include <cuda_runtime.h>

// TODO: Write a __global__ kernel named 'helloGPU' that prints:
// "Hello from GPU!" using printf inside the device code.
// Your code here:


int main() {
    printf("Host: Launching GPU Kernel...\n");

    // TODO: Launch the 'helloGPU' kernel with 1 block and 1 thread.
    // Your code here:


    // TODO: Add the synchronization function so the CPU waits for the GPU printf to flush before exiting.
    // Your code here:


    printf("Host: Kernel finished execution.\n");
    return 0;
}
