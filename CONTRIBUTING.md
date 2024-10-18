# Contributing to OperanceDataTable

We love your input! We want to make contributing to this project as easy and transparent as
possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## We Develop with GitHub
We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

## All Code Changes Happen Through Pull Requests
Pull requests are the best way to propose changes to the codebase. We actively welcome your pull
requests:

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

## Setting Up Lefthook
We use `lefthook` to manage Git hooks. To set it up, follow these steps:

1. Install `lefthook` globally:
    ```shell
    brew install lefthook
    ```

2. Run the `lefthook` install command in the project directory:
    ```shell
    lefthook install
    ```

This will ensure that the necessary Git hooks are in place and will run automatically when you
commit changes.

## Setting Up FVM
We use `fvm` (Flutter Version Management) to manage Flutter SDK versions. To set it up, follow these
steps:

1. Install `fvm` globally:
    ```shell
    dart pub global activate fvm
    ```

2. Run the `fvm` install command in the project directory:
    ```shell
    fvm install
    ```

3. Use the configured Flutter version:
    ```shell
    fvm use
    ```

This will ensure that you are using the correct Flutter SDK version specified for the project.

## Using the create-branch.sh Script
To create a branch using the `create-branch.sh` script, follow these steps:

1. Run the script:
    ```shell
    ./scripts/create-branch.sh
    ```

2. Follow the prompts:
    - Select the branch type by entering the corresponding number (e.g., `1` for feature).
    - Enter the branch name (use lowercase and hyphens).

3. The script will create the branch and check it out.

Note: To rename an existing branch, just run the rename-branch.sh script and follow the prompts.

```shell
./scripts/rename-branch.sh
```

## Any contributions you make will be under the MIT Software License
In short, when you submit code changes, your submissions are understood to be under the same
[MIT License](http://choosealicense.com/licenses/mit/) that covers the project. Feel free to contact
the maintainers if that's a concern.

## Report bugs using GitHub's [issues](https://github.com/zxcvbnmmohd/OperanceDataTable/issues)
We use GitHub issues to track public bugs. Report a bug by
[opening a new issue](https://github.com/zxcvbnmmohd/OperanceDataTable/issues/new); it's that easy!

## Write bug reports with detail, background, and sample code

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can.
- What you expected would happen
- What actually happens
- Notes (like including why you think this might be happening, or stuff you tried that didn't work)

People \*love\* thorough bug reports. I'm not even kidding.

## License
By contributing, you agree that your contributions will be licensed under its MIT License.