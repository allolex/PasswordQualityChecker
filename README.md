# PasswordQA 

## Overview 

When launched this application demonstrates real-time validation of a password for strength as defined by the following:

* Must contain an uppercase letter
* Must contain a lowercase letter
* Must contain a number
* Must contain a symbol
* Must be at least twelve (12) characters in length
* Must pass [Zxcvbn][ZXCVBN] checks that include:
  * Sufficient entropy/randomness 
  * Lack of basis in common dictionary words

## Installation

## Environment

There are two variables defined in the environment that will be used by the Rails app.

- `API_TOKEN`, generated via something like `bin/rails secret`
- `SPA_ORIGIN`, which is set to the value `http://localhost:3000`

It is possible to use [direnv][DIRENV] locally to load these variables. 

In production, this would be loaded from a secrets store, e.g. [Kubernetes secrets][K8S_SECRETS].

### Dependencies

`make install`

You will need current Ruby and Nodejs installed on your system. See [`.tool-versions` (link)](./.tool-versions).

### Foreman

You can use [foreman][FOREMAN] to start up the API and launch the development build for the single page application.

There is a `Makefile` action for it:

`make start`

### Architecture

There are two separate applications within this repository.

1. **The backend**. A minimal Rails API app, running on port 3005.
2. **The frontend**. A React frontend that presents a password form to Users, running on port 3000.

## Testing

Run the specs with `bin/rails spec`.

## Features and tradeoffs

### The backend

- Support for requests either from a specific origin, or using the API token.
  - One of the goals was to have the password checker be client-agnostic.
- All typical use cases tested using automated specs.
  - Some edge cases are handled by the models and controllers.
- Use of ActiveModel validations in the password class to make use of the easy-to-read Rails validation style.
- Rails was the technology of choice because that is what is used at Bark and presumably a password checker could be
  added to an existing backend "for free".
    - However this sort of service would be appropriate for implementation as a server function, deployed as an AWS
      Lambda.
- The API endpoint is not versioned, but normally would be namespaced to produce a path like `/api/v1/password_qa`.
- SQLite is installed, but not used, as it is required by the default RSpec testing configuration.

### The frontend

- Manually tested with no automation at all, due to time constraints.
- Validation feedback (errors) need a React component to make them appear in a nicer, clearer way.
- Validation is performed as the user types, at some cost to performance. 
    - It would be advisable to put a delay in during the next iteration in, so that there is some pause between API
      calls.
- Styling was kept very simple as there were no clear requirements for this.
  - Bootstrap was quick, but something like Bulma is nicer.


[DIRENV]: https://direnv.net
[FOREMAN]: https://github.com/ddollar/foreman
[K8S_SECRETS]: https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data
[ZXCVBN]: https://github.com/formigarafa/zxcvbn-rb
