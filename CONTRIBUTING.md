# Contributing to Adaptive E-learning System

Thank you for your interest in contributing to the Adaptive E-learning System! This document provides guidelines and instructions for contributing to this project.

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## How to Contribute

### Reporting Bugs

1. **Check existing issues** first to avoid duplicates
2. **Use the bug report template** when creating new issues
3. **Provide detailed information** including steps to reproduce, expected behavior, and actual behavior
4. **Include environment details** (OS, Java version, browser, etc.)

### Suggesting Features

1. **Check existing feature requests** to avoid duplicates
2. **Use the feature request template** when creating new requests
3. **Clearly describe the problem** and proposed solution
4. **Consider backwards compatibility** and implementation complexity

### Pull Request Process

#### Before You Start

1. **Create an issue** to discuss major changes before implementing
2. **Fork the repository** and create a feature branch
3. **Ensure you have the latest changes** from the main branch

#### Development Guidelines

1. **Follow Java coding standards**
   - Use meaningful variable and method names
   - Add JavaDoc comments for public methods
   - Follow consistent indentation (4 spaces)
   - Keep methods focused and concise

2. **Write tests**
   - Add unit tests for new functionality
   - Ensure existing tests still pass
   - Aim for good test coverage

3. **Update documentation**
   - Update README.md if needed
   - Add or update JavaDoc comments
   - Update any relevant configuration files

#### Branch Protection Rules

This repository enforces the following rules to protect the main branch:

- **No direct pushes to main** - All changes must go through pull requests
- **Required reviews** - At least one code owner must approve changes
- **Status checks must pass** - CI pipeline must pass before merging
- **Up-to-date branches** - Branches must be up-to-date with main before merging

#### Pull Request Checklist

Before submitting your pull request, ensure:

- [ ] Your branch is up-to-date with the main branch
- [ ] All tests pass locally
- [ ] Code follows the project's style guidelines
- [ ] You've added tests for new functionality
- [ ] Documentation has been updated
- [ ] Commit messages are clear and descriptive
- [ ] The PR description explains what and why

#### Review Process

1. **Automated checks** will run when you submit your PR
2. **Code owners** will be automatically requested for review
3. **Address feedback** promptly and professionally
4. **Keep your branch updated** with any changes to main
5. **Squash commits** if requested by maintainers

### Development Setup

#### Prerequisites

- Java 11 or higher
- Apache Tomcat 9.0+
- SQL Server
- Maven 3.6+
- Git

#### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/macdogiahuy/PRJ_Adaptive-E-learning-System.git
   cd PRJ_Adaptive-E-learning-System
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the coding guidelines
   - Add tests for new functionality
   - Update documentation as needed

4. **Test your changes**
   ```bash
   # Run tests
   mvn test
   
   # Check code style
   mvn checkstyle:check
   ```

5. **Commit and push**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   git push origin feature/your-feature-name
   ```

6. **Create a pull request**
   - Use the PR template
   - Provide clear description
   - Link related issues

### Commit Message Guidelines

Follow conventional commit format:

- `feat:` new features
- `fix:` bug fixes
- `docs:` documentation changes
- `style:` formatting changes
- `refactor:` code refactoring
- `test:` adding or updating tests
- `chore:` maintenance tasks

Example: `feat: add user authentication module`

### Branch Naming Convention

Use descriptive branch names:

- `feature/feature-name` for new features
- `bugfix/issue-description` for bug fixes
- `hotfix/critical-issue` for urgent fixes
- `docs/documentation-update` for documentation

### Getting Help

If you need help or have questions:

1. Check existing documentation
2. Search through existing issues
3. Create a new issue with the question label
4. Contact the maintainers

## License

By contributing to this project, you agree that your contributions will be licensed under the same license as the project.

## Recognition

Contributors will be recognized in the project documentation and release notes. Thank you for helping make this project better!