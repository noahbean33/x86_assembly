// main.cpp

#include <iostream>
#include <chrono>

using namespace std;
using namespace std::chrono;

#include "hexstr.h"

int main (int argc, char *argv[]) {
    char                     buffer[32];
    steady_clock::time_point start;
    duration<double>         elapsed;
    uint64_t                 value      = 0xfedcba9876543210;
    uint64_t                 iterations = 100000000;

    cout << u64ToHexStr(buffer, value) << endl;
    cout << u32ToHexStr(buffer, value) << endl;
    cout << u16ToHexStr(buffer, value) << endl;
    cout <<  u8ToHexStr(buffer, value) << endl;
    cout <<  u4ToHexStr(buffer, value) << endl;

    start = steady_clock::now();
    for (uint64_t i = 0; i < iterations; ++i) {
        u64ToHexStr (buffer, value);
    }
    elapsed = steady_clock::now() - start;
    cout << "u64: " << elapsed.count() << " sec" << endl;

    start = steady_clock::now();
    for (uint64_t i = 0; i < iterations; ++i) {
        u32ToHexStr (buffer, value);
    }
    elapsed = steady_clock::now() - start;
    cout << "u32: " << elapsed.count() << " sec" << endl;

    start = steady_clock::now();
    for (uint64_t i = 0; i < iterations; ++i) {
        u16ToHexStr (buffer, value);
    }
    elapsed = steady_clock::now() - start;
    cout << "u16: " << elapsed.count() << " sec" << endl;

    start = steady_clock::now();
    for (uint64_t i = 0; i < iterations; ++i) {
        u8ToHexStr  (buffer, value);
    }
    elapsed = steady_clock::now() - start;
    cout << "u8:  " << elapsed.count() << " sec" << endl;

    start = steady_clock::now();
    for (uint64_t i = 0; i < iterations; ++i) {
        u4ToHexStr  (buffer, value);
    }
    elapsed = steady_clock::now() - start;
    cout << "u4:  " << elapsed.count() << " sec" << endl;

    return 0;
}
