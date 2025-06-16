# Nix Development Environment Setup

This document explains the Nix-based development environment configuration for the Python Introduction course. If you're not familiar with Nix, don't worry – this guide will help you understand what the setup does and how to use it.

## What Is Nix?

Nix is a package manager and build system that provides reproducible, declarative, and reliable software environments. Think of it as a way to create isolated development environments that work the same way across different computers and operating systems.

## What Does Our Setup Do?

The `flake.nix` file in this project creates a development environment that includes:

1. **Python 3** with essential development tools
2. **Code editing support** (syntax highlighting, autocompletion, linting)
3. **Version control** (Git)
4. **Automatic dependency management** (installs packages from `requirements.txt`)

## File Structure Overview

```
flake.nix
├── description          # What this environment is for
├── inputs              # External dependencies (like package repositories)
├── outputs             # What this flake provides
    └── devShells       # Development environments
        └── default     # The main environment configuration
```

## Detailed Breakdown

### 1. Project Description
```nix
description = "Python Introduction DevEnv";
```
This simply describes what the flake is for – setting up a development environment for the Python Introduction course.

### 2. External Dependencies (Inputs)
```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  flake-utils.url = "github:numtide/flake-utils";
};
```

- **nixpkgs**: The main Nix package repository containing thousands of software packages
- **flake-utils**: Helper functions that make our flake work across different operating systems (Linux, macOS, etc.)

### 3. Development Environment Configuration

#### System Compatibility
```nix
flake-utils.lib.eachDefaultSystem (system: ...)
```
This ensures the environment works on common systems like Linux x86_64, macOS Intel, and macOS Apple Silicon.

#### Available Tools
The development environment includes:

**Python Environment:**

The Python environment is created using a special Nix function called `python3.withPackages`:

```nix
(python3.withPackages (
  ps: with ps; [
    python-lsp-server
    python-lsp-ruff
    pylsp-rope
    ruff
  ]
))
```

**What does `python3.withPackages` do?**

Instead of just providing a bare Python 3 interpreter, `python3.withPackages` creates a *bundled* Python environment that includes both the interpreter and specific Python packages. Here's how it works:

1. **Takes a function as input**: The `(ps: with ps; [...])` part is a function that receives the Python package set (`ps`) as its argument
2. **Builds a custom Python**: Nix creates a new Python installation that has the specified packages pre-installed and available
3. **Creates proper isolation**: The resulting Python environment is completely self-contained

**Breaking down the syntax:**
- `python3.withPackages`: The Nix function that creates bundled Python environments
- `ps:`: The parameter representing the Python package set (all available Python packages in Nixpkgs)
- `with ps;`: A Nix language feature that brings all attributes of `ps` into scope, so you can write `python-lsp-server` instead of `ps.python-lsp-server`
- `[...]`: The list of Python packages to include

**What packages are included:**
- `python-lsp-server`: The main Language Server Protocol server for Python, providing IDE features like code completion, go-to-definition, and error checking
- `python-lsp-ruff`: Integration plugin that connects Ruff (a fast Python linter/formatter) with the LSP server
- `pylsp-rope`: Plugin that adds code refactoring capabilities through the Rope library
- `ruff`: The standalone Ruff linter and formatter tool

**Why this approach?**

This is different from a traditional Python setup where you might:
1. Install Python
2. Create a virtual environment
3. Install packages with `pip install python-lsp-server ruff ...`

With `python3.withPackages`, Nix:
- Ensures all packages are compatible with each other
- Creates deterministic builds (same versions every time)
- Makes the Python environment immutable (can't be accidentally modified)
- Allows the environment to be shared exactly across different machines

The result is a Python interpreter that already "knows about" these development tools without needing separate installation steps.

**Development Tools:**
- `git`: Version control system
- `nil` and `nixd`: Language servers for editing Nix files

**Python Virtual Environment:**

In addition to the bundled Python environment created by `python3.withPackages`, this setup also integrates a traditional Python virtual environment using Nix's `venvShellHook`:

```nix
python3Packages.venvShellHook
```

**What is `venvShellHook`?**

`venvShellHook` is a Nix package that provides shell hooks (scripts that run automatically) to create and manage Python virtual environments within Nix shells. It bridges the gap between Nix's declarative package management and Python's traditional virtual environment workflow.

**How it works:**

1. **Virtual Environment Location**: The `venvDir = "./.venv";` setting tells the hook where to create the virtual environment directory
2. **Automatic Creation**: When you first enter the Nix shell, if `.venv` doesn't exist, the hook creates it using Python's built-in `venv` module
3. **Automatic Activation**: Every time you enter the Nix shell, the hook automatically runs the equivalent of `source .venv/bin/activate`
4. **Dependency Installation**: The `postVenvCreation` hook runs `pip install -r requirements.txt` after creating a new virtual environment

**Why use both bundled packages AND a virtual environment?**

This might seem redundant, but it serves different purposes:

- **Bundled packages** (from `python3.withPackages`): These are development tools like LSP servers, linters, and formatters. They're available system-wide within the Nix shell and provide IDE functionality.
- **Virtual environment**: This is where your project-specific dependencies (from `requirements.txt`) are installed. It maintains compatibility with standard Python workflows and tools like `pip`.

**The workflow in practice:**

1. You run `nix develop`
2. Nix creates the bundled Python environment with development tools
3. `venvShellHook` creates `.venv/` (if needed) and activates it
4. `postVenvCreation` installs your project dependencies with `pip`
5. You get both development tools (globally available) and project dependencies (in virtual environment)

**Benefits of this hybrid approach:**

- **Standard compatibility**: Works with existing Python projects and workflows
- **Tool isolation**: Development tools don't clutter your project dependencies
- **Reproducible development environment**: LSP tools are always the same version
- **Flexible project dependencies**: You can still use `pip install` for project-specific packages

## How to Use This Setup

### Prerequisites
You need to have Nix installed on your system. Visit [nixos.org](https://nixos.org/download.html) for installation instructions.

### Entering the Development Environment
1. Navigate to the project directory in your terminal
2. Run one of these commands:
   ```bash
   nix develop
   ```
   or
   ```bash
   nix-shell
   ```

### What Happens When You Enter
1. Nix creates (if needed) or activates the Python virtual environment in `.venv/`
2. All the development tools become available in your shell
3. Project dependencies from `requirements.txt` are automatically installed
4. Your code editor will have enhanced Python support if it supports LSP

### Working in the Environment
Once you're in the Nix shell:
- Use `python` to run Python scripts
- Use `pip` to install additional packages (they'll be installed in the virtual environment)
- Use `git` for version control
- Your editor should provide features like:
  - Code completion
  - Error highlighting
  - Code formatting
  - Refactoring suggestions

### Exiting the Environment
Simply type `exit` or press `Ctrl+D` to leave the Nix shell and return to your normal terminal environment.

## Benefits of This Setup

1. **Reproducibility**: Everyone gets exactly the same development environment
2. **Isolation**: Project dependencies don't interfere with your system Python
3. **Consistency**: Works the same way on different operating systems
4. **Automated Setup**: Dependencies are installed automatically
5. **Enhanced Development**: Built-in support for modern Python development tools

## Troubleshooting

### Common Issues

**"Command not found: nix"**
- Nix is not installed on your system. Install it from [nixos.org](https://nixos.org/download.html)

**"Requirements.txt not found"**
- Make sure you're in the project root directory
- The `requirements.txt` file should be in the same directory as `flake.nix`

**Python packages not found**
- Exit and re-enter the Nix shell to refresh the environment
- Check that the package is listed in `requirements.txt`

### Getting Help

If you encounter issues with the Nix setup:
1. Check the [Nix manual](https://nixos.org/manual/nix/stable/)
2. Ask questions in the project's [GitHub issues](https://github.com/jetbrains-academy/introduction_to_python/issues)
3. Consult the [Nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/) for package-specific questions

## Alternative Setup

If you prefer not to use Nix, you can still work with this project using traditional Python tools:

1. Create a virtual environment: `python -m venv .venv`
2. Activate it: `source .venv/bin/activate` (Linux/macOS) or `.venv\Scripts\activate` (Windows)
3. Install dependencies: `pip install -r requirements.txt`

However, the Nix setup provides additional development tools and ensures consistency across different environments.
