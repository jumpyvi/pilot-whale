using GLib;

/**
* Colorize the output of tests (ran by Just)
*/
void colorize_output(string line) {
    // Color codes
    string GREEN = "\x1b[32m"; // Succes text
    string RED = "\x1b[31m"; // Error text
    string NC = "\x1b[0m"; // Normal text

    // Check if the line starts with "ok"
    if (line.has_prefix("ok")) {
        // Prepend "✅" and set text to green
        stdout.printf("✅ %s%s%s\n", GREEN, line, NC);
    }
    // Check if the line contains "ERROR" or "not ok"
    else if (line.contains("ERROR") || line.has_prefix("not ok")) {
        // Prepend "❌" and set text to red
        stdout.printf("❌ %s%s%s\n", RED, line, NC);
    }
    else {
        // Print other lines normally
        stdout.printf("%s\n", line);
    }
}

int main(string[] args) {
    // Read from input
    string line;
    while ((line = stdin.read_line()) != null) {
        colorize_output(line);
    }
    return 0;
}