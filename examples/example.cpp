#include <algorithm> // Include this for std::remove
#include <chrono>
#include <iostream>
#include <string>

#include <min2phase/min2phase.h>
#include <min2phase/tools.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <scramble_string>" << std::endl;
        return 1;
    }

    std::string scramble = argv[1];
    uint8_t movesUsed;
    min2phase::tools::setRandomSeed(time(nullptr));

    // Initialization and loading files as before
    auto start = std::chrono::high_resolution_clock::now();
    min2phase::init(); // Uncomment if needed
    min2phase::loadFile("coords.m2pc");
    auto end = std::chrono::high_resolution_clock::now();
    std::cout << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count() << "ms for loading\n";

    // Solving the provided scramble
    start = std::chrono::high_resolution_clock::now();
    std::string solution = min2phase::solve(scramble, 19, 2000000, 60000, 0, &movesUsed); // Removed flags for separator and inverse solution for simplicity
    solution.erase(std::remove(solution.begin(), solution.end(), ' '), solution.end()); // Correctly remove spaces
    std::cout << solution << std::endl; // Print solution without spaces
    end = std::chrono::high_resolution_clock::now();
    std::cout << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count() << "ms for solving\n";
    std::cout << "Moves used: " << static_cast<int>(movesUsed) << std::endl; // Print moves used on a new line

    return 0;
}
