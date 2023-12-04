# PasswordQA 

## Installation

`make install`

You will need current Ruby and Nodejs installed on your system. See [`.tool-versions` (link)](./.tool-versions).

### Environment

`API_TOKEN` must be defined. I'm using [direnv][DIRENV] locally to load the key for use by both the frontend and backend
apps. In production, this would be loaded from a secrets store, e.g. [Kubernetes secrets][K8S_SECRETS].

## Testing

Run the specs with `bin/rails spec`.


[DIRENV]: https://direnv.net
[K8S_SECRETS]: https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data

