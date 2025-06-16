# Introduction to Python course  (JetBrains Academy version) [![official JetBrains project](http://jb.gg/badges/official.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)
  <p>This is an introductory Python course by JetBrains Academy. Python is a leading language for data analysis, AI, ML, automation, and more. The course is designed for individuals with little to no programming experience who want to start learning Python.</p>


  <p>In this course, you will learn about the basics, such as variables and operations
  with them, strings and other data structures, boolean operators, conditions, control
  flow, and so on. You will try implementing loops, functions, and classes, as well as
  using parts of your code as imported modules, and working with text files.</p>

  <p>Have fun and good luck!</p>

## Development Environment Setup

This project includes a Nix-based development environment that provides a complete, reproducible Python setup with all necessary tools and dependencies.

### Using Nix (Recommended)

If you have Nix installed, you can get a fully configured development environment by running:

```bash
nix develop
```

This will automatically:
- Set up Python 3 with development tools
- Create and activate a virtual environment
- Install all project dependencies
- Provide enhanced IDE support with Language Server Protocol (LSP) tools

For detailed information about the Nix setup, see [NIX_DEVELOPMENT_SETUP.md](./NIX_DEVELOPMENT_SETUP.md).

### Traditional Python Setup

If you prefer not to use Nix, you can set up the project manually:

1. Create a virtual environment:
   ```bash
   python -m venv .venv
   ```

2. Activate the virtual environment:
   - On Linux/macOS: `source .venv/bin/activate`
   - On Windows: `.venv\Scripts\activate`

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Want to know more?
If you have questions about the course or the tasks, or if you find any errors, feel free to ask questions and participate in discussions within the repository [issues](https://github.com/jetbrains-academy/introduction_to_python/issues).

## Contribution
Please be sure to review the [project's contributing guidelines](./contributing.md) to learn how to help the project.
